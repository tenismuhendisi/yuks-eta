import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/lesson_status.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LessonTapAction {
  confirm,
  editTentative,
  editFull,
  delete,
}

/// Mevcut derse tıklanınca aksiyon seçimi.
Future<LessonTapAction?> showLessonActionSheet(
  BuildContext context, {
  required Lesson lesson,
}) {
  final isTentative = LessonStatus.fromString(lesson.status) == LessonStatus.tentative;

  return showModalBottomSheet<LessonTapAction>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                lesson.title ?? 'Ders',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                AppDateFormat.dateTime(lesson.startTime),
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              if (isTentative) ...[
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade50,
                    child: Icon(Icons.check_circle, color: Colors.green.shade800),
                  ),
                  title: const Text('Onaylanmış ders'),
                  subtitle: const Text('Kort seçip genel takvime taşı'),
                  onTap: () => Navigator.pop(ctx, LessonTapAction.confirm),
                ),
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Olası dersi düzenle'),
                  onTap: () => Navigator.pop(ctx, LessonTapAction.editTentative),
                ),
              ] else
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Dersi düzenle'),
                  onTap: () => Navigator.pop(ctx, LessonTapAction.editFull),
                ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red.shade700),
                title: Text('Sil', style: TextStyle(color: Colors.red.shade700)),
                onTap: () => Navigator.pop(ctx, LessonTapAction.delete),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Vazgeç'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Olası dersi onayla: müsait kort seçimi.
class ConfirmLessonDialog extends ConsumerStatefulWidget {
  const ConfirmLessonDialog({
    super.key,
    required this.lesson,
  });

  final Lesson lesson;

  @override
  ConsumerState<ConfirmLessonDialog> createState() => _ConfirmLessonDialogState();
}

class _ConfirmLessonDialogState extends ConsumerState<ConfirmLessonDialog> {
  String? _selectedCourtId;
  bool _loading = true;
  bool _saving = false;
  List<Court> _availableCourts = [];

  @override
  void initState() {
    super.initState();
    _loadCourts();
  }

  Future<void> _loadCourts() async {
    final service = ref.read(courtAvailabilityServiceProvider);
    final courts = await service.getAvailableCourts(
      widget.lesson.startTime,
      widget.lesson.endTime,
      excludeLessonId: widget.lesson.id,
    );
    if (!mounted) return;
    setState(() {
      _availableCourts = courts;
      _selectedCourtId = courts.isNotEmpty ? courts.first.id : null;
      _loading = false;
    });
  }

  Future<void> _confirm() async {
    if (_selectedCourtId == null) return;
    setState(() => _saving = true);
    await ref.read(databaseProvider).updateLesson(
          widget.lesson.id,
          LessonsCompanion(
            status: Value(LessonStatus.confirmed.name),
            courtId: Value(_selectedCourtId),
            isTemplate: const Value(false),
          ),
        );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const AlertDialog(
        content: SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_availableCourts.isEmpty) {
      return AlertDialog(
        title: const Text('Boş kort yok'),
        content: Text(
          '${AppDateFormat.dateTime(widget.lesson.startTime)} saatinde müsait kort bulunamadı. '
          'Dersi onaylamak için başka bir saat seçin veya bir kortu boşaltın.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tamam'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text('Dersi onayla'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bu ders onaylandığında yöneticiler ve diğer antrenörler genel takvimde görebilecek.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCourtId,
              decoration: const InputDecoration(labelText: 'Kort'),
              items: _availableCourts
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCourtId = v),
            ),
            if (widget.lesson.price != null) ...[
              const SizedBox(height: 12),
              Text(
                'Fiyat: ${widget.lesson.price!.toStringAsFixed(0)} ₺',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _saving ? null : _confirm,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Onayla'),
        ),
      ],
    );
  }
}
