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

  static bool _isOther(AttendanceStatus s) =>
      s == AttendanceStatus.late || s == AttendanceStatus.excused;

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

  Future<void> _pickOther(String userId) async {
    final picked = await showDialog<AttendanceStatus>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Diğer'),
        children: [
          for (final s in const [AttendanceStatus.late, AttendanceStatus.excused])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, s),
              child: Row(
                children: [
                  Icon(
                    s == AttendanceStatus.late ? Icons.schedule : Icons.event_busy,
                    size: 20,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 12),
                  Text(s.label, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _statusByUser[userId] = picked);
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

  Widget _statusRow(String userId, AttendanceStatus status) {
    final other = _isOther(status);
    return Row(
      children: [
        Expanded(
          child: _StatusChip(
            label: AttendanceStatus.present.label,
            selected: status == AttendanceStatus.present,
            selectedColor: AppColors.lime.withValues(alpha: 0.55),
            onTap: () => setState(() => _statusByUser[userId] = AttendanceStatus.present),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _StatusChip(
            label: AttendanceStatus.absent.label,
            selected: status == AttendanceStatus.absent,
            onTap: () => setState(() => _statusByUser[userId] = AttendanceStatus.absent),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _StatusChip(
            label: other ? status.label : 'Diğer',
            selected: other,
            onTap: () => _pickOther(userId),
          ),
        ),
      ],
    );
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
                        const SizedBox(height: 10),
                        ..._users.entries.map((e) {
                          final status = _statusByUser[e.key]!;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor:
                                            AppColors.lime.withValues(alpha: 0.35),
                                        child: Text(
                                          e.value.name.characters.first,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: AppColors.navy,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          e.value.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  _statusRow(e.key, status),
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? (selectedColor ?? Theme.of(context).colorScheme.secondaryContainer)
          : Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected
              ? Colors.transparent
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) ...[
                const Icon(Icons.check, size: 14),
                const SizedBox(width: 2),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
