import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/attendance_status.dart';
import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
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

class _CoachAttendanceTab extends ConsumerWidget {
  const _CoachAttendanceTab({required this.coachId});

  final String coachId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final rangeEnd = dayStart.add(const Duration(days: 7));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Yoklama', style: Theme.of(context).textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Yalnızca grup derslerinde yoklama alınır — her sporcu için ayrı işaretleyin',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<List<Lesson>>(
            future: db.getLessonsForCoachInRange(coachId, dayStart.subtract(const Duration(days: 7)), rangeEnd),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final lessons = (snapshot.data ?? [])
                  .where((l) => !l.isTemplate && l.type == 'group')
                  .toList()
                ..sort((a, b) => b.startTime.compareTo(a.startTime));

              if (lessons.isEmpty) {
                return const Center(child: Text('Yoklama alınacak grup dersi bulunamadı'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: const Icon(Icons.groups, size: 20),
                      ),
                      title: Text(lesson.title ?? 'Grup'),
                      subtitle: Text(
                        '${AppDateFormat.dateTime(lesson.startTime)} · ${lesson.maxParticipants} sporcu',
                      ),
                      trailing: const Icon(Icons.fact_check_outlined),
                      onTap: () async {
                        await showDialog<bool>(
                          context: context,
                          builder: (_) => TakeAttendanceDialog(
                            lesson: lesson,
                            coachId: coachId,
                          ),
                        );
                      },
                    ),
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

class _AdminAttendanceTab extends ConsumerWidget {
  const _AdminAttendanceTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Yoklama Takibi', style: Theme.of(context).textTheme.titleLarge),
        ),
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
