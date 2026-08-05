import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentFormDialog extends ConsumerStatefulWidget {
  const StudentFormDialog({
    super.key,
    required this.coachId,
    this.existingProfile,
    this.existingUser,
  });

  final String coachId;
  final StudentProfile? existingProfile;
  final User? existingUser;

  @override
  ConsumerState<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends ConsumerState<StudentFormDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _levelController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedAthleteId;
  List<User> _availableAthletes = [];
  bool _saving = false;
  bool get _isEdit => widget.existingProfile != null;

  static const _levels = ['Başlangıç', 'Orta', 'İleri', 'Turnuva'];

  @override
  void initState() {
    super.initState();
    if (_isEdit && widget.existingUser != null) {
      _nameController.text = widget.existingUser!.name;
      _emailController.text = widget.existingUser!.email;
      _phoneController.text = widget.existingUser!.phone ?? '';
      _ageController.text = widget.existingProfile!.age?.toString() ?? '';
      _levelController.text = widget.existingProfile!.level ?? '';
      _notesController.text = widget.existingProfile!.notes ?? '';
    } else {
      _loadAvailableAthletes();
    }
  }

  Future<void> _loadAvailableAthletes() async {
    final db = ref.read(databaseProvider);
    final athletes = await db.getUsersByRole('athlete');
    final myProfiles = await db.watchStudentsForCoach(widget.coachId).first;
    final myIds = myProfiles.map((p) => p.userId).toSet();
    if (mounted) {
      setState(() {
        _availableAthletes = athletes.where((a) => !myIds.contains(a.id)).toList();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _levelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);

    if (_isEdit) {
      await (db.update(db.users)..where((u) => u.id.equals(widget.existingUser!.id))).write(
            UsersCompanion(
              name: Value(_nameController.text.trim()),
              email: Value(_emailController.text.trim()),
              phone: Value(_phoneController.text.trim().isEmpty ? null : _phoneController.text.trim()),
            ),
          );
      await db.upsertStudentProfile(StudentProfilesCompanion(
            userId: Value(widget.existingProfile!.userId),
            coachId: Value(widget.coachId),
            age: Value(int.tryParse(_ageController.text)),
            level: Value(_levelController.text.trim().isEmpty ? null : _levelController.text.trim()),
            notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
            updatedAt: Value(DateTime.now()),
          ));
    } else {
      if (_selectedAthleteId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir sporcu seçin')),
        );
        setState(() => _saving = false);
        return;
      }
      await db.upsertStudentProfile(StudentProfilesCompanion(
            userId: Value(_selectedAthleteId!),
            coachId: Value(widget.coachId),
            age: Value(int.tryParse(_ageController.text)),
            level: Value(_levelController.text.trim().isEmpty ? null : _levelController.text.trim()),
            notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
            updatedAt: Value(DateTime.now()),
          ));
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Öğrenciyi Düzenle' : 'Öğrenci Ekle'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isEdit) ...[
                DropdownButtonFormField<String>(
                  value: _selectedAthleteId,
                  decoration: const InputDecoration(labelText: 'Sporcu seç'),
                  items: _availableAthletes
                      .map((a) => DropdownMenuItem(value: a.id, child: Text('${a.name} (${a.email})')))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedAthleteId = v;
                      final athlete = _availableAthletes.firstWhere((a) => a.id == v);
                      _nameController.text = athlete.name;
                      _emailController.text = athlete.email;
                    });
                  },
                ),
                const SizedBox(height: 8),
              ] else ...[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Ad Soyad'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-posta'),
                ),
              ],
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Yaş'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _levels.contains(_levelController.text) ? _levelController.text : null,
                decoration: const InputDecoration(labelText: 'Oyun seviyesi'),
                items: _levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (v) => setState(() => _levelController.text = v ?? ''),
              ),
              const SizedBox(height: 8),
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
