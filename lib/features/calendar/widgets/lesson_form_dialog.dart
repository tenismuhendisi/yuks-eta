import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/core/constants/app_constants.dart';
import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/lesson_status.dart';
import 'package:crm_app/core/enums/lesson_type.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/features/attendance/widgets/take_attendance_dialog.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class LessonFormDialog extends ConsumerStatefulWidget {
  const LessonFormDialog({
    super.key,
    required this.coachId,
    this.existingLesson,
    this.initialStart,
    this.initialEnd,
  });

  final String coachId;
  final Lesson? existingLesson;
  final DateTime? initialStart;
  final DateTime? initialEnd;

  @override
  ConsumerState<LessonFormDialog> createState() => _LessonFormDialogState();
}

class _LessonFormDialogState extends ConsumerState<LessonFormDialog> {
  late LessonType _type;
  late DateTime _start;
  late DateTime _end;
  late int _maxParticipants;
  String? _selectedCourtId;
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  bool _saving = false;
  List<User> _myStudents = [];
  final Set<String> _selectedStudentIds = {};

  @override
  void initState() {
    super.initState();
    final lesson = widget.existingLesson;
    _type = lesson != null ? LessonType.fromString(lesson.type) : LessonType.private;
    _start = lesson?.startTime ?? widget.initialStart ?? DateTime.now();
    _end = lesson?.endTime ?? widget.initialEnd ?? _start.add(const Duration(hours: 1));
    _maxParticipants = lesson?.maxParticipants ?? 1;
    _selectedCourtId = lesson?.courtId;
    _titleController.text = lesson?.title ?? '';
    _notesController.text = lesson?.notes ?? '';
    _loadStudents();
    if (lesson != null) _loadParticipants(lesson.id);
  }

  Future<void> _loadStudents() async {
    final profiles = await ref.read(databaseProvider).watchStudentsForCoach(widget.coachId).first;
    final users = <User>[];
    for (final p in profiles) {
      final u = await ref.read(databaseProvider).getUserById(p.userId);
      if (u != null) users.add(u);
    }
    if (mounted) setState(() => _myStudents = users);
  }

  Future<void> _loadParticipants(String lessonId) async {
    final parts = await ref.read(databaseProvider).getParticipantsForLesson(lessonId);
    if (mounted) {
      setState(() => _selectedStudentIds.addAll(parts.map((p) => p.userId)));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_type == LessonType.private && _maxParticipants > AppConstants.privateLessonMaxParticipants) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Özel ders en fazla ${AppConstants.privateLessonMaxParticipants} kişi olabilir')),
      );
      return;
    }

    if (_selectedCourtId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kort seçmelisiniz')),
      );
      return;
    }

    setState(() => _saving = true);

    if (_selectedCourtId != null) {
      final service = ref.read(courtAvailabilityServiceProvider);
      final available = await service.isCourtAvailable(
        _selectedCourtId!,
        _start,
        _end,
        excludeLessonId: widget.existingLesson?.id,
      );
      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Seçilen kort bu saatte müsait değil')),
          );
          setState(() => _saving = false);
        }
        return;
      }
    }

    final db = ref.read(databaseProvider);
    final lessonId = widget.existingLesson?.id ?? const Uuid().v4();

    if (widget.existingLesson == null) {
      await db.insertLesson(LessonsCompanion.insert(
        id: lessonId,
        coachId: widget.coachId,
        courtId: Value(_selectedCourtId),
        type: _type.name,
        startTime: _start,
        endTime: _end,
        maxParticipants: Value(_type == LessonType.group ? _maxParticipants : _maxParticipants.clamp(1, 3)),
        isTemplate: const Value(false),
        status: Value(LessonStatus.confirmed.name),
        title: Value(_titleController.text.trim().isEmpty ? null : _titleController.text.trim()),
        notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
      ));
    } else {
      await db.updateLesson(
        lessonId,
        LessonsCompanion(
          courtId: Value(_selectedCourtId),
          type: Value(_type.name),
          startTime: Value(_start),
          endTime: Value(_end),
          maxParticipants: Value(_type == LessonType.group ? _maxParticipants : _maxParticipants.clamp(1, 3)),
          isTemplate: const Value(false),
          status: Value(LessonStatus.confirmed.name),
          title: Value(_titleController.text.trim().isEmpty ? null : _titleController.text.trim()),
          notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        ),
      );
      final existing = await db.getParticipantsForLesson(lessonId);
      for (final p in existing) {
        if (!_selectedStudentIds.contains(p.userId)) {
          await db.removeParticipant(lessonId, p.userId);
        }
      }
    }

    for (final studentId in _selectedStudentIds) {
      final existing = await db.getParticipantsForLesson(lessonId);
      if (!existing.any((p) => p.userId == studentId)) {
        await db.insertParticipant(LessonParticipantsCompanion.insert(
          id: const Uuid().v4(),
          lessonId: lessonId,
          userId: studentId,
        ));
      }
    }

    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dersi Sil'),
        content: const Text('Bu dersi silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sil')),
        ],
      ),
    );
    if (confirm == true && widget.existingLesson != null) {
      await ref.read(databaseProvider).deleteLesson(widget.existingLesson!.id);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final courtsAsync = ref.watch(databaseProvider).getActiveCourts();

    return AlertDialog(
      title: Text(widget.existingLesson == null ? 'Ders Planla' : 'Dersi Düzenle'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<LessonType>(
                segments: LessonType.values
                    .map((t) => ButtonSegment(value: t, label: Text(t.label)))
                    .toList(),
                selected: {_type},
                onSelectionChanged: (s) {
                  setState(() {
                    _type = s.first;
                    if (_type == LessonType.group) _maxParticipants = 10;
                    if (_type == LessonType.private && _maxParticipants > 3) _maxParticipants = 1;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Başlık (opsiyonel)'),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Başlangıç'),
                subtitle: Text(AppDateFormat.dateTime(_start)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_calendar),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _start,
                      firstDate: DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date == null || !mounted) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_start),
                    );
                    if (time == null || !mounted) return;
                    setState(() {
                      _start = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      if (!_end.isAfter(_start)) {
                        _end = _start.add(const Duration(hours: 1));
                      }
                    });
                  },
                ),
              ),
              if (_type == LessonType.private)
                DropdownButtonFormField<int>(
                  value: _maxParticipants.clamp(1, 3),
                  decoration: const InputDecoration(labelText: 'Kişi sayısı'),
                  items: [1, 2, 3]
                      .map((n) => DropdownMenuItem(value: n, child: Text('$n kişi')))
                      .toList(),
                  onChanged: (v) => setState(() => _maxParticipants = v ?? 1),
                )
              else
                TextField(
                  decoration: const InputDecoration(labelText: 'Maks. katılımcı (sınırsız için yüksek değer)'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: '$_maxParticipants'),
                  onChanged: (v) => _maxParticipants = int.tryParse(v) ?? 10,
                ),
              const SizedBox(height: 8),
              FutureBuilder(
                future: courtsAsync,
                builder: (context, snapshot) {
                  final courts = snapshot.data ?? [];
                  return DropdownButtonFormField<String>(
                    value: _selectedCourtId,
                    decoration: const InputDecoration(labelText: 'Kort'),
                    items: courts
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCourtId = v),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text('Katılımcılar', style: Theme.of(context).textTheme.titleSmall),
              if (_myStudents.isEmpty)
                const Text('Henüz öğrenci eklenmemiş', style: TextStyle(fontSize: 12))
              else
                ..._myStudents.map((s) => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.name),
                      value: _selectedStudentIds.contains(s.id),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            if (_type == LessonType.private &&
                                _selectedStudentIds.length >= _maxParticipants) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('En fazla $_maxParticipants kişi seçebilirsiniz')),
                              );
                              return;
                            }
                            _selectedStudentIds.add(s.id);
                          } else {
                            _selectedStudentIds.remove(s.id);
                          }
                        });
                      },
                    )),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notlar'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.existingLesson != null && widget.existingLesson!.type == 'group')
          TextButton(
            onPressed: () async {
              await showDialog<bool>(
                context: context,
                builder: (_) => TakeAttendanceDialog(
                  lesson: widget.existingLesson!,
                  coachId: widget.coachId,
                ),
              );
            },
            child: const Text('Yoklama'),
          ),
        if (widget.existingLesson != null)
          TextButton(onPressed: _delete, child: const Text('Sil', style: TextStyle(color: Colors.red))),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Kaydet'),
        ),
      ],
    );
  }
}
