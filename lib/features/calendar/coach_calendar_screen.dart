import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/core/constants/app_constants.dart';
import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/lesson_status.dart';
import 'package:crm_app/core/enums/lesson_type.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/features/calendar/widgets/confirm_lesson_dialog.dart';
import 'package:crm_app/features/calendar/widgets/lesson_form_dialog.dart';
import 'package:crm_app/features/calendar/widgets/slot_action_sheet.dart';
import 'package:crm_app/features/calendar/widgets/tentative_lesson_dialog.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart' hide Table, TableRow;
import 'package:flutter/material.dart' as material show Table, TableRow;
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CalendarDaySpan {
  /// Pzt–Per
  weekdays,
  /// Cum–Paz + sonraki Pzt
  weekend,
  /// Pzt–Paz
  fullWeek,
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
  bool _showTemplates = false;
  late Set<String> _expandedBlocks;

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
            isTemplate: _showTemplates,
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
        await showDialog<bool>(
          context: context,
          builder: (_) => TentativeLessonDialog(
            coachId: widget.coachId,
            start: lesson.startTime,
            end: lesson.endTime,
            existingLesson: lesson,
          ),
        );
      case LessonTapAction.editFull:
        await showDialog<bool>(
          context: context,
          builder: (_) => LessonFormDialog(
            coachId: widget.coachId,
            existingLesson: lesson,
          ),
        );
      case LessonTapAction.delete:
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Dersi sil'),
            content: const Text('Bu dersi silmek istediğinize emin misiniz?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sil')),
            ],
          ),
        );
        if (ok == true) {
          await ref.read(databaseProvider).deleteLesson(lesson.id);
        }
    }
    if (mounted) setState(() {});
  }

  Future<void> _onLessonDrop(Lesson lesson, DateTime newStart) async {
    final duration = lesson.endTime.difference(lesson.startTime);
    final newEnd = newStart.add(duration);

    if (!lesson.isTemplate &&
        lesson.courtId != null &&
        LessonStatus.fromString(lesson.status) == LessonStatus.confirmed) {
      final service = ref.read(courtAvailabilityServiceProvider);
      final available = await service.isCourtAvailable(
        lesson.courtId!,
        newStart,
        newEnd,
        excludeLessonId: lesson.id,
      );
      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kort bu saatte müsait değil')),
          );
        }
        return;
      }
    }

    await ref.read(databaseProvider).updateLesson(
          lesson.id,
          LessonsCompanion(
            startTime: Value(newStart),
            endTime: Value(newEnd),
          ),
        );
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
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Gerçek Dersler'),
                selected: !_showTemplates,
                onSelected: (_) => setState(() => _showTemplates = false),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Şablon Dersler'),
                selected: _showTemplates,
                onSelected: (_) => setState(() => _showTemplates = true),
              ),
              const Spacer(),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.amber.shade200,
                  border: Border.all(color: Colors.amber.shade800),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Text('Olası', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<List<Lesson>>(
            future: db.getLessonsForCoachInRange(
              widget.coachId,
              days.first,
              days.last.add(const Duration(days: 1)),
            ),
            builder: (context, snapshot) {
              final allLessons = snapshot.data ?? [];
              final lessons = allLessons.where((l) => l.isTemplate == _showTemplates).toList();

              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: _CalendarGrid(
                      weekDays: days,
                      lessons: lessons,
                      totalWidth: constraints.maxWidth,
                      expandedBlocks: _expandedBlocks,
                      onToggleBlock: _toggleBlock,
                      onCellTap: _onCellTap,
                      onLessonDrop: _onLessonDrop,
                      onLessonTap: _onLessonTap,                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.weekDays,
    required this.lessons,
    required this.totalWidth,
    required this.expandedBlocks,
    required this.onToggleBlock,
    required this.onCellTap,
    required this.onLessonDrop,
    required this.onLessonTap,
  });

  final List<DateTime> weekDays;
  final List<Lesson> lessons;
  final double totalWidth;
  final Set<String> expandedBlocks;
  final void Function(String blockId) onToggleBlock;
  final void Function(DateTime day, int hour) onCellTap;
  final Future<void> Function(Lesson lesson, DateTime newStart) onLessonDrop;
  final void Function(Lesson lesson) onLessonTap;

  static const _cellHeight = 56.0;
  static const _timeWidth = 40.0;
  static const _headerHeight = 36.0;
  static const _blockHeaderHeight = 32.0;

  double get _dayWidth => (totalWidth - _timeWidth) / weekDays.length;

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
        material.Table(
          columnWidths: _columnWidths,
          border: TableBorder.all(color: Colors.grey.shade300),
          children: [_dayHeaderRow()],
        ),
        ...AppConstants.calendarTimeBlocks.map((block) {
          final expanded = expandedBlocks.contains(block.id);
          final hiddenCount = expanded ? 0 : _lessonCountInBlock(block);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: expanded ? Colors.grey.shade200 : Colors.amber.shade50,
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
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            block.label,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            block.rangeLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (!expanded && hiddenCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$hiddenCount ders',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          Text(
                            expanded ? 'Gizle' : 'Göster',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
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
                    left: BorderSide(color: Colors.grey.shade300),
                    right: BorderSide(color: Colors.grey.shade300),
                    bottom: BorderSide(color: Colors.grey.shade300),
                    horizontalInside: BorderSide(color: Colors.grey.shade300),
                    verticalInside: BorderSide(color: Colors.grey.shade300),
                  ),
                  children: block.hours.map((hour) {
                    return material.TableRow(
                      children: [
                        SizedBox(
                          width: _timeWidth,
                          height: _cellHeight,
                          child: Center(
                            child: Text(
                              '${hour.toString().padLeft(2, '0')}:00',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        ...weekDays.map((day) {
                          final lesson = _lessonAt(day, hour);
                          if (lesson != null && lesson.startTime.hour == hour) {
                            return _LessonCell(
                              lesson: lesson,
                              cellWidth: dayW,
                              onTap: () => onLessonTap(lesson),
                            );
                          }
                          if (lesson != null) {
                            return const SizedBox(height: _cellHeight);
                          }
                          return _EmptyCell(
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
      ],
    );
  }
}

class _EmptyCell extends StatelessWidget {
  const _EmptyCell({required this.onTap, required this.onAccept});

  final VoidCallback onTap;
  final void Function(Object? data) onAccept;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Object>(
      onAcceptWithDetails: (d) => onAccept(d.data),
      builder: (context, candidate, rejected) {
        return InkWell(
          onTap: onTap,
          child: Container(
            height: _CalendarGrid._cellHeight,
            color: candidate.isNotEmpty ? Colors.green.shade50 : null,
            child: candidate.isNotEmpty
                ? const Center(child: Icon(Icons.add, size: 16, color: Colors.green))
                : null,
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
    required this.onTap,
  });

  final Lesson lesson;
  final double cellWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final type = LessonType.fromString(lesson.type);
    final isTentative = LessonStatus.fromString(lesson.status) == LessonStatus.tentative;
    final Color color;
    if (lesson.isTemplate) {
      color = Colors.purple.shade100;
    } else if (isTentative) {
      color = Colors.amber.shade200;
    } else if (type == LessonType.private) {
      color = Colors.blue.shade200;
    } else {
      color = Colors.teal.shade200;
    }

    final subtitle = isTentative
        ? 'Olası${lesson.price != null ? ' · ${lesson.price!.toStringAsFixed(0)}₺' : ''}'
        : '${lesson.maxParticipants} kişi';

    return Draggable<Lesson>(
      data: lesson,
      feedback: Material(
        elevation: 4,
        child: Container(
          width: cellWidth,
          padding: const EdgeInsets.all(4),
          color: color,
          child: Text(
            lesson.title ?? type.label,
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ),
      childWhenDragging: Container(
        height: _CalendarGrid._cellHeight,
        color: Colors.grey.shade200,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: _CalendarGrid._cellHeight,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            border: isTentative
                ? Border.all(color: Colors.amber.shade800, width: 1.5)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lesson.title ?? (isTentative ? 'Olası özel' : type.label),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
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
