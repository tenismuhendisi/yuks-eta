import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/theme/app_theme.dart';
import 'package:crm_app/core/theme/coach_colors.dart';
import 'package:crm_app/core/utils/student_notes.dart';
import 'package:crm_app/core/utils/court_locations.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/gestures.dart';

const _weekdays = [
  (1, 'Pzt'),
  (2, 'Sal'),
  (3, 'Çar'),
  (4, 'Per'),
  (5, 'Cum'),
  (6, 'Cmt'),
  (7, 'Paz'),
];

const _hours = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22];

/// Haftalık genel plan ızgarası — antrenör hakları.
class GeneralPlanView extends ConsumerWidget {
  const GeneralPlanView({
    super.key,
    required this.role,
    required this.userId,
  });

  final UserRole role;
  final String userId;

  bool get _isAdmin => role == UserRole.admin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return StreamBuilder<List<WeeklyCourtRight>>(
      stream: db.watchWeeklyCourtRights(),
      builder: (context, rightsSnap) {
        return FutureBuilder<(List<Court>, List<User>, List<PlanChangeRequest>)>(
          future: () async {
            final courts = await db.getAllCourts();
            final coaches = await db.getUsersByRole('coach');
            final pending = _isAdmin
                ? await db.watchPendingPlanChangeRequests().first
                : <PlanChangeRequest>[];
            return (courts, coaches, pending);
          }(),
          builder: (context, metaSnap) {
            if (!metaSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final (courts, coaches, pending) = metaSnap.data!;
            final rights = rightsSnap.data ?? [];
            final byKey = {
              for (final r in rights) '${r.weekday}|${r.courtId}|${r.hour}': r,
            };
            final coachById = {for (final c in coaches) c.id: c};

            return Column(
              children: [
                if (_isAdmin && pending.isNotEmpty)
                  _PendingRequestsBar(
                    pending: pending,
                    coaches: coachById,
                    adminId: userId,
                  ),
                Expanded(
                  child: _GeneralPlanGrid(
                    courts: courts,
                    byKey: byKey,
                    coachById: coachById,
                    isAdmin: _isAdmin,
                    currentUserId: userId,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _PendingRequestsBar extends ConsumerWidget {
  const _PendingRequestsBar({
    required this.pending,
    required this.coaches,
    required this.adminId,
  });

  final List<PlanChangeRequest> pending;
  final Map<String, User> coaches;
  final String adminId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.lime.withValues(alpha: 0.25),
      child: ListTile(
        dense: true,
        leading: const Icon(Icons.pending_actions),
        title: Text('${pending.length} bekleyen değişiklik talebi'),
        trailing: TextButton(
          onPressed: () => _showPendingSheet(context, ref),
          child: const Text('İncele'),
        ),
      ),
    );
  }

  Future<void> _showPendingSheet(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Text(
                'Değişiklik talepleri',
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              for (final req in pending) ...[
                Card(
                  child: ListTile(
                    title: Text(
                      '${_weekdayLabel(req.weekday)} · ${_hourLabel(req.hour)} · ${_courtShort(req.courtId)}',
                    ),
                    subtitle: Text(
                      [
                        if (req.fromCoachId != null)
                          'Şu an: ${coaches[req.fromCoachId]?.name ?? '?'}',
                        if (req.toCoachId != null)
                          'İstenen: ${coaches[req.toCoachId]?.name ?? '?'}'
                        else
                          'İstenen: boşalt',
                        if (req.note != null && req.note!.isNotEmpty) req.note!,
                      ].join('\n'),
                    ),
                    isThreeLine: true,
                    trailing: Wrap(
                      spacing: 4,
                      children: [
                        IconButton(
                          tooltip: 'Onayla',
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () async {
                            await db.resolvePlanChangeRequest(
                              id: req.id,
                              status: 'approved',
                              resolvedById: adminId,
                              applyToPlan: true,
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                        ),
                        IconButton(
                          tooltip: 'Reddet',
                          icon: Icon(Icons.cancel, color: Colors.red.shade700),
                          onPressed: () async {
                            await db.resolvePlanChangeRequest(
                              id: req.id,
                              status: 'rejected',
                              resolvedById: adminId,
                              applyToPlan: false,
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _GeneralPlanGrid extends ConsumerWidget {
  const _GeneralPlanGrid({
    required this.courts,
    required this.byKey,
    required this.coachById,
    required this.isAdmin,
    required this.currentUserId,
  });

  final List<Court> courts;
  final Map<String, WeeklyCourtRight> byKey;
  final Map<String, User> coachById;
  final bool isAdmin;
  final String currentUserId;

  static const _labelW = 72.0;
  static const _cellW = 56.0;
  static const _cellH = 44.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planCourts = [...courts]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
        scrollbars: true,
      ),
      child: SingleChildScrollView(
        primary: false,
        physics: const AlwaysScrollableScrollPhysics(),
        child: SingleChildScrollView(
          primary: false,
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: _labelW),
                  for (final h in _hours)
                    SizedBox(
                      width: _cellW,
                      child: Text(
                        h.toString().padLeft(2, '0'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              for (final day in _weekdays) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: Text(
                    _fullWeekday(day.$1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                for (final court in planCourts)
                  _courtRow(
                    context,
                    ref,
                    day: day.$1,
                    dayShort: day.$2,
                    court: court,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _courtRow(
    BuildContext context,
    WidgetRef ref, {
    required int day,
    required String dayShort,
    required Court court,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _labelW,
            child: Text(
              court.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 1.1,
                color: AppColors.navy,
              ),
            ),
          ),
          for (final hour in _hours)
            SizedBox(
              width: _cellW,
              height: _cellH,
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: _PlanCell(
                  right: byKey['$day|${court.id}|$hour'],
                  coachById: coachById,
                  onTap: () => _onCellTap(
                    context,
                    ref,
                    weekday: day,
                    court: court,
                    hour: hour,
                    right: byKey['$day|${court.id}|$hour'],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onCellTap(
    BuildContext context,
    WidgetRef ref, {
    required int weekday,
    required Court court,
    required int hour,
    required WeeklyCourtRight? right,
  }) async {
    final coaches = coachById.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    if (isAdmin) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => _AdminEditRightDialog(
          weekday: weekday,
          court: court,
          hour: hour,
          current: right,
          coaches: coaches,
        ),
      );
      return;
    }

    // Antrenör: talep
    await showDialog<void>(
      context: context,
      builder: (ctx) => _CoachRequestDialog(
        weekday: weekday,
        court: court,
        hour: hour,
        current: right,
        coaches: coaches,
        requesterId: currentUserId,
      ),
    );
  }
}

class _PlanCell extends StatelessWidget {
  const _PlanCell({
    required this.right,
    required this.coachById,
    required this.onTap,
  });

  final WeeklyCourtRight? right;
  final Map<String, User> coachById;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final coachId = right?.coachId;
    final coach = coachId == null ? null : coachById[coachId];
    final fill = coach == null
        ? const Color(0xFFF3F4F2)
        : CoachColors.fill(coachId);
    final ink = coach == null
        ? Colors.grey.shade500
        : CoachColors.onFill(coachId);
    final short = coach == null
        ? ''
        : truncateLetters(turkishLower(firstNameOf(coach.name)), 5);
    final label = right?.label;

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: coach == null
                  ? Colors.grey.shade300
                  : CoachColors.forCoach(coachId).withValues(alpha: 0.25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (short.isNotEmpty)
                  Text(
                    short,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: ink,
                      height: 1.05,
                    ),
                  ),
                if (label != null && label.isNotEmpty)
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: ink.withValues(alpha: 0.8),
                      height: 1.05,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminEditRightDialog extends ConsumerStatefulWidget {
  const _AdminEditRightDialog({
    required this.weekday,
    required this.court,
    required this.hour,
    required this.current,
    required this.coaches,
  });

  final int weekday;
  final Court court;
  final int hour;
  final WeeklyCourtRight? current;
  final List<User> coaches;

  @override
  ConsumerState<_AdminEditRightDialog> createState() =>
      _AdminEditRightDialogState();
}

class _AdminEditRightDialogState extends ConsumerState<_AdminEditRightDialog> {
  String? _coachId;
  late final TextEditingController _label;

  @override
  void initState() {
    super.initState();
    _coachId = widget.current?.coachId;
    _label = TextEditingController(text: widget.current?.label ?? '');
  }

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '${_weekdayLabel(widget.weekday)} · ${_hourLabel(widget.hour)}\n${widget.court.name}',
      ),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String?>(
              isExpanded: true,
              value: _coachId,
              decoration: const InputDecoration(labelText: 'Antrenör'),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('— Boş —'),
                ),
                for (final c in widget.coaches)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => setState(() => _coachId = v),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _label,
              decoration: const InputDecoration(
                labelText: 'Etiket (opsiyonel)',
                hintText: 'örn. Yet-45',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        FilledButton(
          onPressed: () async {
            await ref.read(databaseProvider).setWeeklyCourtRight(
                  weekday: widget.weekday,
                  courtId: widget.court.id,
                  hour: widget.hour,
                  coachId: _coachId,
                  label: _label.text.trim().isEmpty ? null : _label.text.trim(),
                );
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}

class _CoachRequestDialog extends ConsumerStatefulWidget {
  const _CoachRequestDialog({
    required this.weekday,
    required this.court,
    required this.hour,
    required this.current,
    required this.coaches,
    required this.requesterId,
  });

  final int weekday;
  final Court court;
  final int hour;
  final WeeklyCourtRight? current;
  final List<User> coaches;
  final String requesterId;

  @override
  ConsumerState<_CoachRequestDialog> createState() => _CoachRequestDialogState();
}

class _CoachRequestDialogState extends ConsumerState<_CoachRequestDialog> {
  String? _toCoachId;
  late final TextEditingController _note;

  @override
  void initState() {
    super.initState();
    _toCoachId = widget.requesterId;
    _note = TextEditingController();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Değişiklik talebi'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${_weekdayLabel(widget.weekday)} · ${_hourLabel(widget.hour)} · ${widget.court.name}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              isExpanded: true,
              value: _toCoachId,
              decoration: const InputDecoration(labelText: 'Yeni hak sahibi'),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('— Boşalt —'),
                ),
                for (final c in widget.coaches)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => setState(() => _toCoachId = v),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _note,
              decoration: const InputDecoration(
                labelText: 'Not (opsiyonel)',
                hintText: 'örn. o saat dersim yok',
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        FilledButton(
          onPressed: () async {
            await ref.read(databaseProvider).insertPlanChangeRequest(
                  PlanChangeRequestsCompanion.insert(
                    id: const Uuid().v4(),
                    requesterId: widget.requesterId,
                    weekday: widget.weekday,
                    courtId: widget.court.id,
                    hour: widget.hour,
                    fromCoachId: Value(widget.current?.coachId),
                    toCoachId: Value(_toCoachId),
                    note: Value(
                      _note.text.trim().isEmpty ? null : _note.text.trim(),
                    ),
                    createdAt: DateTime.now(),
                  ),
                );
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Talep yöneticiye iletildi')),
              );
            }
          },
          child: const Text('Talep gönder'),
        ),
      ],
    );
  }
}

String _weekdayLabel(int d) => switch (d) {
      1 => 'Pazartesi',
      2 => 'Salı',
      3 => 'Çarşamba',
      4 => 'Perşembe',
      5 => 'Cuma',
      6 => 'Cumartesi',
      7 => 'Pazar',
      _ => 'Gün $d',
    };

String _fullWeekday(int d) => _weekdayLabel(d).toUpperCase();

String _hourLabel(int h) =>
    '${h.toString().padLeft(2, '0')}:00–${(h + 1).toString().padLeft(2, '0')}:00';

String _courtShort(String id) => CourtLocations.shortLabel(id);
