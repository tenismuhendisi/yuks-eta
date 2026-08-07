import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/attendance_status.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/theme/app_theme.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TakeAttendanceDialog extends ConsumerStatefulWidget {
  const TakeAttendanceDialog({
    super.key,
    required this.lesson,
    required this.coachId,
  });

  final Lesson lesson;
  final String coachId;

  @override
  ConsumerState<TakeAttendanceDialog> createState() => _TakeAttendanceDialogState();
}

class _TakeAttendanceDialogState extends ConsumerState<TakeAttendanceDialog> {
  final Map<String, AttendanceStatus> _statusByUser = {};
  final Map<String, User> _users = {};
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final parts = await db.getParticipantsForLesson(widget.lesson.id);
    final existing = await db.getAttendancesForLesson(widget.lesson.id);
    final existingMap = {
      for (final a in existing) a.userId: AttendanceStatus.fromString(a.status),
    };

    final users = <String, User>{};
    for (final p in parts) {
      final u = await db.getUserById(p.userId);
      if (u != null) users[u.id] = u;
      _statusByUser[p.userId] = existingMap[p.userId] ?? AttendanceStatus.present;
    }

    if (!mounted) return;
    setState(() {
      _users
        ..clear()
        ..addAll(users);
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(databaseProvider).saveLessonAttendances(
          lessonId: widget.lesson.id,
          markedById: widget.coachId,
          userStatus: {
            for (final e in _statusByUser.entries) e.key: e.value.name,
          },
        );
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.lesson.title ?? 'Grup';
    final when = AppDateFormat.dateTime(widget.lesson.startTime);

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Grup Yoklaması'),
          const SizedBox(height: 4),
          Text(
            '$title · $when',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                ),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: _loading
            ? const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              )
            : _users.isEmpty
                ? const Text('Bu grupta kayıtlı sporcu yok')
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Her sporcu için durum seçin (${_users.length} kişi)',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 12),
                        ..._users.entries.map((e) {
                          final status = _statusByUser[e.key]!;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.lime.withValues(alpha: 0.35),
                                        child: Text(
                                          e.value.name.characters.first,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.navy,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          e.value.name,
                                          style: const TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: AttendanceStatus.values.map((s) {
                                      final selected = status == s;
                                      return ChoiceChip(
                                        label: Text(s.label, style: const TextStyle(fontSize: 12)),
                                        selected: selected,
                                        selectedColor: s == AttendanceStatus.present
                                            ? AppColors.lime.withValues(alpha: 0.55)
                                            : null,
                                        onSelected: (_) =>
                                            setState(() => _statusByUser[e.key] = s),
                                        visualDensity: VisualDensity.compact,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _saving || _users.isEmpty ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Kaydet'),
        ),
      ],
    );
  }
}
