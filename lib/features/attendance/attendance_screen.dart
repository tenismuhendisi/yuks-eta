import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/attendance_status.dart';
import 'package:crm_app/core/enums/ball_level.dart';
import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/core/utils/student_notes.dart';
import 'package:crm_app/core/widgets/itf_tennis_ball.dart';
import 'package:crm_app/features/attendance/widgets/take_attendance_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Antrenör: ders listesi + yoklama al.
/// Admin / Veli: sporcu bazlı yoklama geçmişi.
class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({
    super.key,
    required this.role,
    required this.userId,
  });

  final UserRole role;
  final String userId;

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    switch (widget.role) {
      case UserRole.coach:
        return _CoachAttendanceTab(coachId: widget.userId);
      case UserRole.admin:
        return const _AdminAttendanceTab();
      case UserRole.parent:
        return _ParentAttendanceTab(parentId: widget.userId);
      case UserRole.athlete:
        return _AthleteAttendanceTab(athleteId: widget.userId);
    }
  }
}

enum _CoachAttendanceScope { today, all }

class _CoachAttendanceTab extends ConsumerStatefulWidget {
  const _CoachAttendanceTab({required this.coachId});

  final String coachId;

  @override
  ConsumerState<_CoachAttendanceTab> createState() => _CoachAttendanceTabState();
}

class _CoachAttendanceTabState extends ConsumerState<_CoachAttendanceTab> {
  _CoachAttendanceScope _scope = _CoachAttendanceScope.today;
  bool _onlyPending = false;
  int _reloadToken = 0;

  Future<void> _openAttendance(Lesson lesson) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => TakeAttendanceDialog(
        lesson: lesson,
        coachId: widget.coachId,
      ),
    );
    if (saved == true && mounted) {
      setState(() => _reloadToken++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final rangeStart = _scope == _CoachAttendanceScope.today
        ? dayStart
        : dayStart.subtract(const Duration(days: 60));
    final rangeEnd = _scope == _CoachAttendanceScope.today
        ? dayEnd
        : dayStart.add(const Duration(days: 14));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SegmentedButton<_CoachAttendanceScope>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: _CoachAttendanceScope.today,
                label: Text('Bugün'),
              ),
              ButtonSegment(
                value: _CoachAttendanceScope.all,
                label: Text('Tüm yoklamalar'),
              ),
            ],
            selected: {_scope},
            onSelectionChanged: (s) {
              setState(() {
                _scope = s.first;
                _reloadToken++;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FilterChip(
              avatar: Icon(
                _onlyPending ? Icons.warning_amber_rounded : Icons.pending_actions,
                size: 18,
              ),
              label: const Text('Alınmayanlar'),
              selected: _onlyPending,
              onSelected: (v) => setState(() => _onlyPending = v),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: FutureBuilder<(List<Lesson>, Set<String>, Map<String, BallLevel>)>(
            key: ValueKey('$_scope-$_reloadToken'),
            future: () async {
              final lessons = await db.getLessonsForCoachInRange(
                widget.coachId,
                rangeStart,
                rangeEnd,
              );
              final group = lessons
                  .where((l) => !l.isTemplate && l.type == 'group')
                  .toList()
                ..sort((a, b) => _scope == _CoachAttendanceScope.today
                    ? a.startTime.compareTo(b.startTime)
                    : b.startTime.compareTo(a.startTime));
              final atts = await db.getAttendancesForLessons(
                group.map((l) => l.id).toList(),
              );
              final taken = {for (final a in atts) a.lessonId};
              final levelByGroup = await _ballLevelByGroupCode(db, widget.coachId);
              return (group, taken, levelByGroup);
            }(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data;
              if (data == null) {
                return const Center(child: Text('Yoklama listesi yüklenemedi'));
              }
              var (lessons, takenIds, levelByGroup) = data;
              if (_onlyPending) {
                lessons = lessons.where((l) => !takenIds.contains(l.id)).toList();
              }

              if (lessons.isEmpty) {
                final msg = _onlyPending
                    ? (_scope == _CoachAttendanceScope.today
                        ? 'Bugün alınmayan yoklama yok'
                        : 'Alınmayan yoklama yok')
                    : (_scope == _CoachAttendanceScope.today
                        ? 'Bugün grup dersi yok'
                        : 'Grup dersi bulunamadı');
                return Center(child: Text(msg));
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  final taken = takenIds.contains(lesson.id);
                  final code = (lesson.title ?? '').trim().toLowerCase();
                  return _CoachLessonAttendanceCard(
                    lesson: lesson,
                    taken: taken,
                    ballLevel: levelByGroup[code],
                    onOpen: () => _openAttendance(lesson),
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

Future<Map<String, BallLevel>> _ballLevelByGroupCode(
  AppDatabase db,
  String coachId,
) async {
  final profiles = await db.getStudentsForCoach(coachId);
  final counts = <String, Map<BallLevel, int>>{};
  for (final p in profiles) {
    final code = StudentNotes.groupCode(p.notes)?.toLowerCase();
    if (code == null || code.isEmpty) continue;
    final level = BallLevel.tryParse(p.level);
    if (level == null) continue;
    final bucket = counts.putIfAbsent(code, () => {});
    bucket[level] = (bucket[level] ?? 0) + 1;
  }
  return {
    for (final e in counts.entries)
      e.key: e.value.entries.reduce((a, b) => a.value >= b.value ? a : b).key,
  };
}

class _CoachLessonAttendanceCard extends StatelessWidget {
  const _CoachLessonAttendanceCard({
    required this.lesson,
    required this.taken,
    required this.onOpen,
    this.ballLevel,
  });

  final Lesson lesson;
  final bool taken;
  final VoidCallback onOpen;
  final BallLevel? ballLevel;

  @override
  Widget build(BuildContext context) {
    final statusBg = taken ? Colors.green.shade50 : Colors.orange.shade50;
    final statusFg = taken ? Colors.green.shade800 : Colors.orange.shade900;
    final statusIcon = taken ? Icons.check_circle : Icons.radio_button_unchecked;
    final statusLabel = taken ? 'Alındı' : 'Alınmadı';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
          child: Row(
            children: [
              ItfTennisBallAvatar(
                level: ballLevel,
                size: 36,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title ?? 'Grup',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${AppDateFormat.dateTime(lesson.startTime)} · ${lesson.maxParticipants} sporcu',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 14, color: statusFg),
                          const SizedBox(width: 4),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusFg,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (!taken)
                FilledButton(
                  onPressed: onOpen,
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Al'),
                )
              else
                IconButton(
                  tooltip: 'Düzenle',
                  onPressed: onOpen,
                  icon: const Icon(Icons.edit_outlined),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminAttendanceTab extends ConsumerWidget {
  const _AdminAttendanceTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: FutureBuilder<List<LessonAttendance>>(
            future: db.getRecentAttendances(limit: 80),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final rows = snapshot.data ?? [];
              if (rows.isEmpty) {
                return const Center(child: Text('Henüz yoklama kaydı yok'));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: rows.length,
                itemBuilder: (context, index) => _AttendanceTile(attendance: rows[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ParentAttendanceTab extends ConsumerWidget {
  const _ParentAttendanceTab({required this.parentId});

  final String parentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Çocuklarımın Yoklaması', style: Theme.of(context).textTheme.titleLarge),
        ),
        Expanded(
          child: FutureBuilder<List<User>>(
            future: db.getAthletesForParent(parentId),
            builder: (context, athleteSnap) {
              if (athleteSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final athletes = athleteSnap.data ?? [];
              if (athletes.isEmpty) {
                return const Center(child: Text('Bağlı sporcu bulunamadı'));
              }

              return FutureBuilder<List<LessonAttendance>>(
                future: db.getAttendancesForUsers(athletes.map((a) => a.id).toList()),
                builder: (context, attSnap) {
                  if (attSnap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final rows = attSnap.data ?? [];
                  if (rows.isEmpty) {
                    return const Center(child: Text('Henüz yoklama kaydı yok'));
                  }
                  final nameById = {for (final a in athletes) a.id: a.name};
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final a = rows[index];
                      return _AttendanceTile(
                        attendance: a,
                        athleteName: nameById[a.userId],
                      );
                    },
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

class _AthleteAttendanceTab extends ConsumerWidget {
  const _AthleteAttendanceTab({required this.athleteId});

  final String athleteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Yoklamalarım', style: Theme.of(context).textTheme.titleLarge),
        ),
        Expanded(
          child: StreamBuilder<List<LessonAttendance>>(
            stream: db.watchAttendancesForUser(athleteId),
            builder: (context, snapshot) {
              final rows = snapshot.data ?? [];
              if (snapshot.connectionState == ConnectionState.waiting && rows.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (rows.isEmpty) {
                return const Center(child: Text('Henüz yoklama kaydı yok'));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: rows.length,
                itemBuilder: (context, index) => _AttendanceTile(attendance: rows[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AttendanceTile extends ConsumerWidget {
  const _AttendanceTile({
    required this.attendance,
    this.athleteName,
  });

  final LessonAttendance attendance;
  final String? athleteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = AttendanceStatus.fromString(attendance.status);
    final (bg, fg, icon) = switch (status) {
      AttendanceStatus.present => (Colors.green.shade100, Colors.green.shade700, Icons.check),
      AttendanceStatus.absent => (Colors.red.shade100, Colors.red.shade700, Icons.close),
      AttendanceStatus.late => (Colors.orange.shade100, Colors.orange.shade700, Icons.schedule),
      AttendanceStatus.excused => (Colors.blueGrey.shade100, Colors.blueGrey.shade700, Icons.event_busy),
    };

    return FutureBuilder<Lesson?>(
      future: ref.read(databaseProvider).getLessonById(attendance.lessonId),
      builder: (context, snap) {
        final lesson = snap.data;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: bg,
              child: Icon(icon, color: fg, size: 20),
            ),
            title: Text(
              [
                if (athleteName != null) athleteName!,
                lesson?.title ?? 'Ders',
              ].join(' · '),
            ),
            subtitle: Text(
              [
                status.label,
                if (lesson != null) AppDateFormat.dateTime(lesson.startTime),
              ].join(' · '),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
