import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/core/constants/app_constants.dart';
import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/lesson_status.dart';
import 'package:crm_app/core/enums/lesson_type.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/utils/court_locations.dart';
import 'package:crm_app/core/widgets/schedule_lesson_slot.dart';
import 'package:crm_app/features/calendar/widgets/confirm_lesson_dialog.dart';
import 'package:crm_app/features/calendar/widgets/lesson_form_dialog.dart';
import 'package:crm_app/features/calendar/widgets/recurring_scope_dialog.dart';
import 'package:crm_app/features/calendar/widgets/select_representative_sheet.dart';
import 'package:crm_app/features/calendar/widgets/slot_action_sheet.dart';
import 'package:crm_app/features/calendar/widgets/tentative_color_picker.dart';
import 'package:crm_app/features/calendar/widgets/tentative_lesson_dialog.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart' hide Table, TableRow;
import 'package:flutter/material.dart' as material show Table, TableRow;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

enum CalendarDaySpan {
  /// Pzt–Per
  weekdays,
  /// Cum–Paz + sonraki Pzt
  weekend,
  /// Pzt–Paz
  fullWeek,
}

enum CalendarOverlayMode {
  none,
  generalPlan,
  currentPlan,
}

class CoachCalendarScreen extends ConsumerStatefulWidget {
  const CoachCalendarScreen({super.key, required this.coachId});

  final String coachId;

  @override
  ConsumerState<CoachCalendarScreen> createState() => _CoachCalendarScreenState();
}

class _CoachCalendarScreenState extends ConsumerState<CoachCalendarScreen> {
  late DateTime _weekStart;
  late CalendarDaySpan _daySpan;
  late Set<String> _expandedBlocks;
  CalendarOverlayMode _overlayMode = CalendarOverlayMode.none;
  Set<String> _selectedCourtIds = {...CourtLocations.sogutonuIds};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _weekStart = _startOfWeek(now);
    _daySpan = _defaultSpanFor(now);
    _expandedBlocks = {
      for (final b in AppConstants.calendarTimeBlocks)
        if (b.expandedByDefault) b.id,
    };
  }

  void _toggleBlock(String id) {
    setState(() {
      if (_expandedBlocks.contains(id)) {
        _expandedBlocks.remove(id);
      } else {
        _expandedBlocks.add(id);
      }
    });
  }

  void _toggleLocationGroup(Set<String> groupIds) {
    setState(() {
      final allSelected = groupIds.every(_selectedCourtIds.contains);
      if (allSelected) {
        final next = {..._selectedCourtIds}..removeAll(groupIds);
        if (next.isEmpty) return;
        _selectedCourtIds = next;
      } else {
        _selectedCourtIds = {..._selectedCourtIds, ...groupIds};
      }
    });
  }

  void _toggleCourt(String courtId) {
    setState(() {
      if (_selectedCourtIds.contains(courtId)) {
        if (_selectedCourtIds.length <= 1) return;
        _selectedCourtIds = {..._selectedCourtIds}..remove(courtId);
      } else {
        _selectedCourtIds = {..._selectedCourtIds, courtId};
      }
    });
  }

  static DateTime _startOfWeek(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  static CalendarDaySpan _defaultSpanFor(DateTime date) {
    return date.weekday <= 4 ? CalendarDaySpan.weekdays : CalendarDaySpan.weekend;
  }

  List<DateTime> get _visibleDays {
    switch (_daySpan) {
      case CalendarDaySpan.weekdays:
        return List.generate(4, (i) => _weekStart.add(Duration(days: i)));
      case CalendarDaySpan.weekend:
        return [
          _weekStart.add(const Duration(days: 4)),
          _weekStart.add(const Duration(days: 5)),
          _weekStart.add(const Duration(days: 6)),
          _weekStart.add(const Duration(days: 7)),
        ];
      case CalendarDaySpan.fullWeek:
        return List.generate(7, (i) => _weekStart.add(Duration(days: i)));
    }
  }

  void _prevWeek() => setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));
  void _nextWeek() => setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));

  void _goToday() {
    final now = DateTime.now();
    setState(() {
      _weekStart = _startOfWeek(now);
      _daySpan = _defaultSpanFor(now);
    });
  }

  Future<void> _onCellTap(DateTime day, int hour) async {
    final start = DateTime(day.year, day.month, day.day, hour);
    final end = start.add(const Duration(hours: 1));

    final action = await showSlotActionSheet(context);
    if (!mounted || action == null) return;

    switch (action) {
      case SlotPlanAction.tentativePrivate:
        await showDialog<bool>(
          context: context,
          builder: (_) => TentativeLessonDialog(
            coachId: widget.coachId,
            start: start,
            end: end,
          ),
        );
      case SlotPlanAction.planLesson:
        await showDialog<bool>(
          context: context,
          builder: (_) => LessonFormDialog(
            coachId: widget.coachId,
            initialStart: start,
            initialEnd: end,
          ),
        );
    }
    if (mounted) setState(() {});
  }

  Future<void> _onLessonTap(Lesson lesson) async {
    final action = await showLessonActionSheet(context, lesson: lesson);
    if (!mounted || action == null) return;

    switch (action) {
      case LessonTapAction.confirm:
        await showDialog<bool>(
          context: context,
          builder: (_) => ConfirmLessonDialog(lesson: lesson),
        );
      case LessonTapAction.editTentative:
        await _editTentativeWithScope(lesson);
      case LessonTapAction.repeatWeekly:
        await _repeatTentativeWeekly(lesson);
      case LessonTapAction.changeColor:
        await _changeTentativeColor(lesson);
      case LessonTapAction.selectRepresentative:
        await _selectRepresentative(lesson);
      case LessonTapAction.editFull:
        await showDialog<bool>(
          context: context,
          builder: (_) => LessonFormDialog(
            coachId: widget.coachId,
            existingLesson: lesson,
          ),
        );
      case LessonTapAction.delete:
        await _deleteLessonWithScope(lesson);
    }
    if (mounted) setState(() {});
  }

  Future<void> _selectRepresentative(Lesson lesson) async {
    final selectedId = await showSelectRepresentativeSheet(context, lesson: lesson);
    if (!mounted || selectedId == null) return;
    await ref.read(databaseProvider).updateLesson(
          lesson.id,
          LessonsCompanion(
            representativeUserId: Value(selectedId.isEmpty ? null : selectedId),
          ),
        );
  }

  Future<void> _editTentativeWithScope(Lesson lesson) async {
    final scope = await resolveRecurringScope(
      context,
      lesson: lesson,
      title: 'Olası dersi düzenle',
    );
    if (!mounted || scope == null) return;

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => TentativeLessonDialog(
        coachId: widget.coachId,
        start: lesson.startTime,
        end: lesson.endTime,
        existingLesson: lesson,
      ),
    );
    if (saved != true || scope == RecurringScope.thisOnly) return;

    final db = ref.read(databaseProvider);
    final updated = await db.getLessonById(lesson.id);
    if (updated == null) return;

    final targets = await lessonsForScope(ref, lesson: lesson, scope: scope);
    final participants = await db.getParticipantsForLesson(updated.id);

    for (final target in targets) {
      if (target.id == updated.id) continue;
      await db.updateLesson(
        target.id,
        LessonsCompanion(
          maxParticipants: Value(updated.maxParticipants),
          price: Value(updated.price),
          title: Value(updated.title),
          notes: Value(updated.notes),
          colorHex: Value(updated.colorHex),
        ),
      );
      final existing = await db.getParticipantsForLesson(target.id);
      for (final p in existing) {
        await db.removeParticipant(target.id, p.userId);
      }
      for (final p in participants) {
        await db.insertParticipant(LessonParticipantsCompanion.insert(
          id: const Uuid().v4(),
          lessonId: target.id,
          userId: p.userId,
        ));
      }
    }
  }

  Future<void> _changeTentativeColor(Lesson lesson) async {
    final hex = await showTentativeColorPicker(
      context,
      currentHex: lesson.colorHex,
    );
    if (!mounted || hex == null) return;

    final scope = await resolveRecurringScope(
      context,
      lesson: lesson,
      title: 'Renk değiştir',
    );
    if (!mounted || scope == null) return;

    final targets = await lessonsForScope(ref, lesson: lesson, scope: scope);
    final db = ref.read(databaseProvider);
    final companion = LessonsCompanion(
      colorHex: Value(hex.isEmpty ? null : hex),
    );
    for (final target in targets) {
      await db.updateLesson(target.id, companion);
    }
  }

  Future<void> _deleteLessonWithScope(Lesson lesson) async {
    final scope = await resolveRecurringScope(
      context,
      lesson: lesson,
      title: 'Dersi sil',
    );
    if (!mounted || scope == null) return;

    final targets = await lessonsForScope(ref, lesson: lesson, scope: scope);
    if (!mounted) return;
    final label = switch (scope) {
      RecurringScope.thisOnly => 'Bu dersi silmek istediğinize emin misiniz?',
      RecurringScope.allEvents =>
        'Serideki ${targets.length} dersin tümünü silmek istediğinize emin misiniz?',
      RecurringScope.thisAndFollowing =>
        'Bu ve sonraki ${targets.length} dersi silmek istediğinize emin misiniz?',
    };

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dersi sil'),
        content: Text(label),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sil')),
        ],
      ),
    );
    if (ok != true) return;

    await ref.read(databaseProvider).deleteLessons(targets.map((t) => t.id).toList());
  }

  Future<void> _repeatTentativeWeekly(Lesson lesson) async {
    var weeks = 8;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return AlertDialog(
              title: const Text('Her hafta tekrarla'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Bu olası ders, aynı gün ve saatte sonraki haftalara kopyalanır.',
                    style: Theme.of(ctx).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text('Kaç hafta? (bu ders hariç)', style: Theme.of(ctx).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [4, 8, 12, 16].map((n) {
                      return ChoiceChip(
                        label: Text('$n'),
                        selected: weeks == n,
                        onSelected: (_) => setLocal(() => weeks = n),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
                FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Oluştur')),
              ],
            );
          },
        );
      },
    );
    if (confirmed != true || !mounted) return;

    final db = ref.read(databaseProvider);
    final participants = await db.getParticipantsForLesson(lesson.id);
    final duration = lesson.endTime.difference(lesson.startTime);
    final seriesId = lesson.seriesId?.isNotEmpty == true
        ? lesson.seriesId!
        : const Uuid().v4();

    if (lesson.seriesId == null || lesson.seriesId!.isEmpty) {
      await db.updateLesson(
        lesson.id,
        LessonsCompanion(seriesId: Value(seriesId)),
      );
    }

    var created = 0;
    var skipped = 0;

    for (var w = 1; w <= weeks; w++) {
      final start = lesson.startTime.add(Duration(days: 7 * w));
      final end = start.add(duration);

      final existing = await db.getLessonsForCoachInRange(
        lesson.coachId,
        start,
        end,
      );
      final clash = existing.any(
        (l) =>
            !l.isTemplate &&
            l.startTime.isBefore(end) &&
            l.endTime.isAfter(start),
      );
      if (clash) {
        skipped++;
        continue;
      }

      final id = const Uuid().v4();
      await db.insertLesson(LessonsCompanion.insert(
        id: id,
        coachId: lesson.coachId,
        courtId: const Value(null),
        type: lesson.type,
        startTime: start,
        endTime: end,
        maxParticipants: Value(lesson.maxParticipants),
        isTemplate: const Value(false),
        status: Value(LessonStatus.tentative.name),
        price: Value(lesson.price),
        title: Value(lesson.title),
        notes: Value(lesson.notes ?? 'Haftalık tekrar (olası)'),
        seriesId: Value(seriesId),
        colorHex: Value(lesson.colorHex),
      ));
      for (final p in participants) {
        await db.insertParticipant(LessonParticipantsCompanion.insert(
          id: const Uuid().v4(),
          lessonId: id,
          userId: p.userId,
        ));
      }
      created++;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          skipped == 0
              ? '$created haftalık olası ders oluşturuldu'
              : '$created oluşturuldu, $skipped hafta dolu olduğu için atlandı',
        ),
      ),
    );
  }

  Future<void> _onLessonDrop(Lesson lesson, DateTime newStart) async {
    final delta = newStart.difference(lesson.startTime);
    if (delta.inMinutes == 0) return;

    final duration = lesson.endTime.difference(lesson.startTime);
    final newEnd = newStart.add(duration);
    final lessonLabel = (lesson.title?.trim().isNotEmpty ?? false)
        ? lesson.title!.trim()
        : LessonType.fromString(lesson.type).label;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dersi taşı'),
        content: Text(
          '$lessonLabel\n\n'
          '${AppDateFormat.fullDay(lesson.startTime)}\n'
          '${AppDateFormat.timeRange(lesson.startTime, lesson.endTime)}\n\n'
          '↓\n\n'
          '${AppDateFormat.fullDay(newStart)}\n'
          '${AppDateFormat.timeRange(newStart, newEnd)}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Taşı')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final scope = await resolveRecurringScope(
      context,
      lesson: lesson,
      title: 'Saat / gün değiştir',
    );
    if (!mounted || scope == null) return;

    final targets = await lessonsForScope(ref, lesson: lesson, scope: scope);
    final db = ref.read(databaseProvider);
    final service = ref.read(courtAvailabilityServiceProvider);
    var moved = 0;
    var skipped = 0;

    for (final target in targets) {
      final start = target.startTime.add(delta);
      final end = start.add(target.endTime.difference(target.startTime));

      if (!target.isTemplate &&
          target.courtId != null &&
          LessonStatus.fromString(target.status) == LessonStatus.confirmed) {
        final available = await service.isCourtAvailable(
          target.courtId!,
          start,
          end,
          excludeLessonId: target.id,
        );
        if (!available) {
          skipped++;
          continue;
        }
      }

      final overlapping = await db.getLessonsForCoachInRange(
        target.coachId,
        start,
        end,
      );
      final clash = overlapping.any(
        (l) =>
            l.id != target.id &&
            !l.isTemplate &&
            l.startTime.isBefore(end) &&
            l.endTime.isAfter(start),
      );
      if (clash) {
        skipped++;
        continue;
      }

      await db.updateLesson(
        target.id,
        LessonsCompanion(
          startTime: Value(start),
          endTime: Value(end),
        ),
      );
      moved++;
    }

    if (!mounted) return;
    if (skipped > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$moved taşındı, $skipped çakışma nedeniyle atlandı')),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final days = _visibleDays;
    final rangeLabel = AppDateFormat.weekRange(days.first, days.last);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Row(
            children: [
              IconButton(onPressed: _prevWeek, icon: const Icon(Icons.chevron_left)),
              Expanded(
                child: Text(
                  rangeLabel,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(onPressed: _nextWeek, icon: const Icon(Icons.chevron_right)),
              TextButton(onPressed: _goToday, child: const Text('Bugün')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SegmentedButton<CalendarDaySpan>(
            segments: const [
              ButtonSegment(
                value: CalendarDaySpan.weekdays,
                label: Text('Hafta başı', style: TextStyle(fontSize: 12)),
                tooltip: 'Pzt–Per',
              ),
              ButtonSegment(
                value: CalendarDaySpan.weekend,
                label: Text('Hafta sonu', style: TextStyle(fontSize: 12)),
                tooltip: 'Cum–Paz + Pzt',
              ),
              ButtonSegment(
                value: CalendarDaySpan.fullWeek,
                label: Text('7 gün', style: TextStyle(fontSize: 12)),
                tooltip: 'Tüm hafta',
              ),
            ],
            selected: {_daySpan},
            onSelectionChanged: (s) => setState(() => _daySpan = s.first),
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SegmentedButton<CalendarOverlayMode>(
            segments: const [
              ButtonSegment(
                value: CalendarOverlayMode.none,
                label: Text('Varsayılan', style: TextStyle(fontSize: 11)),
              ),
              ButtonSegment(
                value: CalendarOverlayMode.generalPlan,
                label: Text('Genel plan', style: TextStyle(fontSize: 11)),
              ),
              ButtonSegment(
                value: CalendarOverlayMode.currentPlan,
                label: Text('Güncel plan', style: TextStyle(fontSize: 11)),
              ),
            ],
            selected: {_overlayMode},
            onSelectionChanged: (s) => setState(() => _overlayMode = s.first),
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        if (_overlayMode != CalendarOverlayMode.none) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Wrap(
              spacing: 6,
              runSpacing: 0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: const Text('Söğütönü', style: TextStyle(fontSize: 11)),
                  selected: CourtLocations.sogutonuIds.every(_selectedCourtIds.contains),
                  onSelected: (_) => _toggleLocationGroup(CourtLocations.sogutonuIds),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                FilterChip(
                  label: const Text('Kent Ormanı', style: TextStyle(fontSize: 11)),
                  selected: CourtLocations.kentOrmaniIds.every(_selectedCourtIds.contains),
                  onSelected: (_) => _toggleLocationGroup(CourtLocations.kentOrmaniIds),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                for (final id in CourtLocations.orderedIds)
                  FilterChip(
                    label: Text(
                      CourtLocations.shortLabel(id),
                      style: const TextStyle(fontSize: 11),
                    ),
                    selected: _selectedCourtIds.contains(id),
                    onSelected: (_) => _toggleCourt(id),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<_CalendarLoad>(
            future: _loadCalendar(db, days),
            builder: (context, snapshot) {
              final data = snapshot.data;
              final lessons = data?.lessons ?? const <Lesson>[];
              final names = data?.firstNamesByLessonId ?? const <String, List<String>>{};
              final reps = data?.repFirstNameByLessonId ?? const <String, String>{};
              final fullSlots = data?.allCourtsFullKeys ?? const <String>{};

              return LayoutBuilder(
                builder: (context, constraints) {
                  return _CalendarGrid(
                    weekDays: days,
                    lessons: lessons,
                    firstNamesByLessonId: names,
                    repFirstNameByLessonId: reps,
                    allCourtsFullKeys: fullSlots,
                    totalWidth: constraints.maxWidth,
                    expandedBlocks: _expandedBlocks,
                    onToggleBlock: _toggleBlock,
                    onCellTap: _onCellTap,
                    onLessonDrop: _onLessonDrop,
                    onLessonTap: _onLessonTap,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<_CalendarLoad> _loadCalendar(AppDatabase db, List<DateTime> days) async {
    final allLessons = await db.getLessonsForCoachInRange(
      widget.coachId,
      days.first,
      days.last.add(const Duration(days: 1)),
    );
    final lessons = allLessons.where((l) => !l.isTemplate).toList();
    final parts = await db.getParticipantsForLessons(lessons.map((l) => l.id).toList());
    final userIds = <String>{
      ...parts.map((p) => p.userId),
      for (final l in lessons)
        if (l.representativeUserId != null) l.representativeUserId!,
    };
    final users = await db.getUsersByIds(userIds.toList());
    final nameById = {for (final u in users) u.id: u.name};

    String firstName(String full) {
      final t = full.trim();
      if (t.isEmpty) return '';
      return t.split(RegExp(r'\s+')).first;
    }

    final names = <String, List<String>>{};
    for (final p in parts) {
      final n = nameById[p.userId];
      if (n == null) continue;
      names.putIfAbsent(p.lessonId, () => []).add(firstName(n));
    }

    final reps = <String, String>{};
    for (final l in lessons) {
      final rid = l.representativeUserId;
      if (rid == null) continue;
      final n = nameById[rid];
      if (n != null) reps[l.id] = firstName(n);
    }

    final hours = AppConstants.calendarTimeBlocks.expand((b) => b.hours);
    Set<String> fullKeys = {};
    switch (_overlayMode) {
      case CalendarOverlayMode.none:
        break;
      case CalendarOverlayMode.generalPlan:
        final rights = await db.getWeeklyCourtRights();
        fullKeys = CourtAvailabilityService.slotsWhereAllCourtsClaimedInGeneralPlan(
          days: days,
          hours: hours,
          courtIds: _selectedCourtIds,
          rights: rights,
        );
      case CalendarOverlayMode.currentPlan:
        final svc = ref.read(courtAvailabilityServiceProvider);
        fullKeys = await svc.slotsWhereAllCourtsBusy(
          days: days,
          hours: hours,
          courtIds: _selectedCourtIds,
        );
    }

    return _CalendarLoad(
      lessons: lessons,
      firstNamesByLessonId: names,
      repFirstNameByLessonId: reps,
      allCourtsFullKeys: fullKeys,
    );
  }
}

class _CalendarLoad {
  const _CalendarLoad({
    required this.lessons,
    required this.firstNamesByLessonId,
    required this.repFirstNameByLessonId,
    this.allCourtsFullKeys = const {},
  });

  final List<Lesson> lessons;
  final Map<String, List<String>> firstNamesByLessonId;
  final Map<String, String> repFirstNameByLessonId;
  /// Key: `yyyy-M-d|H`
  final Set<String> allCourtsFullKeys;
}
class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.weekDays,
    required this.lessons,
    required this.firstNamesByLessonId,
    required this.repFirstNameByLessonId,
    required this.allCourtsFullKeys,
    required this.totalWidth,
    required this.expandedBlocks,
    required this.onToggleBlock,
    required this.onCellTap,
    required this.onLessonDrop,
    required this.onLessonTap,
  });

  final List<DateTime> weekDays;
  final List<Lesson> lessons;
  final Map<String, List<String>> firstNamesByLessonId;
  final Map<String, String> repFirstNameByLessonId;
  final Set<String> allCourtsFullKeys;
  final double totalWidth;
  final Set<String> expandedBlocks;
  final void Function(String blockId) onToggleBlock;
  final void Function(DateTime day, int hour) onCellTap;
  final Future<void> Function(Lesson lesson, DateTime newStart) onLessonDrop;
  final void Function(Lesson lesson) onLessonTap;

  static const _cellHeight = 56.0;
  static const _timeWidth = 36.0;
  static const _headerHeight = 32.0;
  static const _blockHeaderHeight = 28.0;

  double get _dayWidth => (totalWidth - _timeWidth) / weekDays.length;

  static String slotKey(DateTime day, int hour) =>
      '${day.year}-${day.month}-${day.day}|$hour';

  bool _courtsFull(DateTime day, int hour) =>
      allCourtsFullKeys.contains(slotKey(day, hour));

  Lesson? _lessonAt(DateTime day, int hour) {
    final slotStart = DateTime(day.year, day.month, day.day, hour);
    final slotEnd = slotStart.add(const Duration(hours: 1));
    return lessons
        .where((l) => l.startTime.isBefore(slotEnd) && l.endTime.isAfter(slotStart))
        .firstOrNull;
  }

  int _lessonCountInBlock(CalendarTimeBlock block) {
    var count = 0;
    for (final day in weekDays) {
      for (final hour in block.hours) {
        final lesson = _lessonAt(day, hour);
        if (lesson != null && lesson.startTime.hour == hour) count++;
      }
    }
    return count;
  }

  Map<int, TableColumnWidth> get _columnWidths => {
        0: const FixedColumnWidth(_timeWidth),
        for (var i = 1; i <= weekDays.length; i++) i: FixedColumnWidth(_dayWidth),
      };

  material.TableRow _dayHeaderRow() {
    return material.TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      children: [
        const SizedBox(width: _timeWidth, height: _headerHeight),
        ...weekDays.map(
          (d) => SizedBox(
            height: _headerHeight,
            child: Center(
              child: Text(
                AppDateFormat.dayHeader(d),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dayW = _dayWidth;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          elevation: 2,
          color: Colors.grey.shade100,
          child: material.Table(
            columnWidths: _columnWidths,
            border: TableBorder.all(color: Colors.grey.shade300),
            children: [_dayHeaderRow()],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...AppConstants.calendarTimeBlocks.map((block) {
                  final expanded = expandedBlocks.contains(block.id);
                  final hiddenCount = expanded ? 0 : _lessonCountInBlock(block);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Material(
                        color: expanded ? Colors.grey.shade200 : const Color(0xFFEEF1EF),
                        child: InkWell(
                          onTap: () => onToggleBlock(block.id),
                          child: SizedBox(
                            height: _blockHeaderHeight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    expanded ? Icons.expand_more : Icons.chevron_right,
                                    size: 16,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    block.label,
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      block.rangeLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  if (!expanded && hiddenCount > 0) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '$hiddenCount ders',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(width: 6),
                                  Text(
                                    expanded ? 'Gizle' : 'Göster',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (expanded)
                        material.Table(
                          columnWidths: _columnWidths,
                          border: TableBorder(
                            horizontalInside: BorderSide(color: Colors.grey.shade100),
                            verticalInside: BorderSide(color: Colors.grey.shade100),
                          ),
                          children: block.hours.map((hour) {
                            return material.TableRow(
                              children: [
                                SizedBox(
                                  width: _timeWidth,
                                  height: _cellHeight,
                                  child: Center(
                                    child: Text(
                                      hour.toString().padLeft(2, '0'),
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                ...weekDays.map((day) {
                                  final lesson = _lessonAt(day, hour);
                                  final courtsFull = _courtsFull(day, hour);
                                  if (lesson != null && lesson.startTime.hour == hour) {
                                    return _LessonCell(
                                      lesson: lesson,
                                      cellWidth: dayW,
                                      courtsFull: courtsFull,
                                      participantFirstNames:
                                          firstNamesByLessonId[lesson.id] ?? const [],
                                      representativeFirstName:
                                          repFirstNameByLessonId[lesson.id],
                                      onTap: () => onLessonTap(lesson),
                                    );
                                  }
                                  if (lesson != null) {
                                    return const SizedBox(height: _cellHeight);
                                  }
                                  return _EmptyCell(
                                    courtsFull: courtsFull,
                                    onTap: () => onCellTap(day, hour),
                                    onAccept: (data) {
                                      if (data is Lesson) {
                                        onLessonDrop(
                                          data,
                                          DateTime(day.year, day.month, day.day, hour),
                                        );
                                      }
                                    },
                                  );
                                }),
                              ],
                            );
                          }).toList(),
                        ),
                    ],
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class _EmptyCell extends StatelessWidget {
  const _EmptyCell({
    required this.onTap,
    required this.onAccept,
    this.courtsFull = false,
  });

  final VoidCallback onTap;
  final void Function(Object? data) onAccept;
  final bool courtsFull;

  static const _gap = EdgeInsets.all(2);
  static final _radius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    return DragTarget<Object>(
      onAcceptWithDetails: (d) => onAccept(d.data),
      builder: (context, candidate, rejected) {
        final hovering = candidate.isNotEmpty;
        final bg = hovering
            ? const Color(0xFFE8F0EA)
            : courtsFull
                ? const Color(0xFFF5E6E4)
                : const Color(0xFFF7F8F7);
        final border = hovering
            ? const Color(0xFF9BB5A4)
            : courtsFull
                ? const Color(0xFFD4A39A)
                : const Color(0xFFE6E8E6);
        return SizedBox(
          height: _CalendarGrid._cellHeight,
          child: Padding(
            padding: _gap,
            child: Material(
              color: bg,
              borderRadius: _radius,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                borderRadius: _radius,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: _radius,
                    border: Border.all(color: border),
                  ),
                  child: hovering
                      ? const Icon(Icons.add, size: 16, color: Color(0xFF5F7A68))
                      : courtsFull
                          ? const Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Icon(
                                  Icons.block,
                                  size: 12,
                                  color: Color(0xFFB55A4A),
                                ),
                              ),
                            )
                          : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LessonCell extends StatelessWidget {
  const _LessonCell({
    required this.lesson,
    required this.cellWidth,
    required this.participantFirstNames,
    required this.representativeFirstName,
    required this.onTap,
    this.courtsFull = false,
  });

  final Lesson lesson;
  final double cellWidth;
  final List<String> participantFirstNames;
  final String? representativeFirstName;
  final VoidCallback onTap;
  final bool courtsFull;

  static const _gap = EdgeInsets.all(2);

  @override
  Widget build(BuildContext context) {
    final type = LessonType.fromString(lesson.type);
    final isTentative = LessonStatus.fromString(lesson.status) == LessonStatus.tentative;
    final isGroup = type == LessonType.group;

    final personCount = participantFirstNames.isNotEmpty
        ? participantFirstNames.length
        : lesson.maxParticipants;

    final List<String> lines;
    if (isGroup) {
      lines = ScheduleLessonSlot.groupLines(
        lesson.title ?? type.label,
        personCount,
      );
    } else if (participantFirstNames.isNotEmpty) {
      lines = ScheduleLessonSlot.privateLines(participantFirstNames);
    } else {
      lines = [lesson.title ?? (isTentative ? 'Olası özel' : type.label)];
    }

    final slot = ScheduleLessonSlot(
      coachId: lesson.coachId,
      colorHex: lesson.colorHex,
      isGroup: isGroup,
      isTentative: isTentative,
      lines: lines,
      onTap: onTap,
    );

    final body = Stack(
      children: [
        Positioned.fill(child: slot),
        if (courtsFull)
          const Positioned(
            top: 2,
            right: 2,
            child: Icon(
              Icons.block,
              size: 12,
              color: Color(0xFFB55A4A),
            ),
          ),
      ],
    );

    return Draggable<Lesson>(
      data: lesson,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: cellWidth - 4,
          height: _CalendarGrid._cellHeight - 4,
          child: slot,
        ),
      ),
      childWhenDragging: SizedBox(
        height: _CalendarGrid._cellHeight,
        child: Padding(
          padding: _gap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
          ),
        ),
      ),
      child: SizedBox(
        height: _CalendarGrid._cellHeight,
        child: Padding(padding: _gap, child: body),
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
