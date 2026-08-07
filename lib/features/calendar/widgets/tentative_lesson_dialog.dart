import 'package:crm_app/core/constants/app_constants.dart';
import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/lesson_status.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Olası özel ders oluşturma sihirbazı: kişi sayısı → isimler → fiyat.
class TentativeLessonDialog extends ConsumerStatefulWidget {
  const TentativeLessonDialog({
    super.key,
    required this.coachId,
    required this.start,
    required this.end,
    this.existingLesson,
  });

  final String coachId;
  final DateTime start;
  final DateTime end;
  final Lesson? existingLesson;

  @override
  ConsumerState<TentativeLessonDialog> createState() => _TentativeLessonDialogState();
}

class _TentativeLessonDialogState extends ConsumerState<TentativeLessonDialog> {
  int _step = 0;
  int _personCount = 1;
  late final List<TextEditingController> _nameControllers;
  late final List<User?> _resolvedUsers;
  double? _price;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingLesson;
    _personCount = existing?.maxParticipants.clamp(1, AppConstants.privateLessonMaxParticipants) ?? 1;
    _price = existing?.price ?? AppConstants.privateLessonPrices[2];
    _nameControllers = List.generate(
      AppConstants.privateLessonMaxParticipants,
      (_) => TextEditingController(),
    );
    _resolvedUsers = List.filled(AppConstants.privateLessonMaxParticipants, null);
    if (existing != null) {
      _loadExistingParticipants(existing.id);
    }
  }

  Future<void> _loadExistingParticipants(String lessonId) async {
    final db = ref.read(databaseProvider);
    final parts = await db.getParticipantsForLesson(lessonId);
    for (var i = 0; i < parts.length && i < _nameControllers.length; i++) {
      final user = await db.getUserById(parts[i].userId);
      if (user != null && mounted) {
        setState(() {
          _nameControllers[i].text = user.name;
          _resolvedUsers[i] = user;
        });
      }
    }
  }

  @override
  void dispose() {
    for (final c in _nameControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<User?> _resolveOrCreateAthlete(String rawName) async {
    final name = rawName.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (name.isEmpty) return null;

    final db = ref.read(databaseProvider);
    final existing = _resolvedUsers.whereType<User>().where(
          (u) => u.name.toLowerCase() == name.toLowerCase(),
        );
    if (existing.isNotEmpty) return existing.first;

    final matches = await db.searchAthletesByName(name);
    final exact = matches.where((u) => u.name.toLowerCase() == name.toLowerCase()).toList();
    if (exact.isNotEmpty) {
      final user = exact.first;
      await db.upsertStudentProfile(StudentProfilesCompanion(
        userId: Value(user.id),
        coachId: Value(widget.coachId),
        updatedAt: Value(DateTime.now()),
      ));
      return user;
    }

    final save = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni sporcu'),
        content: Text(
          '"$name" sistemde bulunamadı. Kaydedilsin mi?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hayır')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Kaydet')),
        ],
      ),
    );
    if (save != true || !mounted) return null;

    final id = const Uuid().v4();
    final slug = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9ğüşıöçĞÜŞİÖÇ\s]', caseSensitive: false), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '.');
    await db.insertUser(UsersCompanion.insert(
      id: id,
      name: name,
      email: '$slug.$id@eta.com',
      password: 'sporcu123',
      role: 'athlete',
      createdAt: DateTime.now(),
    ));
    await db.upsertStudentProfile(StudentProfilesCompanion(
      userId: Value(id),
      coachId: Value(widget.coachId),
      notes: const Value('Olası dersten eklendi'),
      updatedAt: Value(DateTime.now()),
    ));
    return db.getUserById(id);
  }

  Future<void> _save() async {
    if (_price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fiyat seçmelisiniz')),
      );
      return;
    }

    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    final users = <User>[];

    for (var i = 0; i < _personCount; i++) {
      final user = await _resolveOrCreateAthlete(_nameControllers[i].text);
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${i + 1}. kişi için geçerli bir isim gerekli')),
          );
          setState(() => _saving = false);
        }
        return;
      }
      users.add(user);
    }

    final lessonId = widget.existingLesson?.id ?? const Uuid().v4();
    final title = users.map((u) => u.name.split(' ').first).join(' · ');

    if (widget.existingLesson == null) {
      await db.insertLesson(LessonsCompanion.insert(
        id: lessonId,
        coachId: widget.coachId,
        courtId: const Value(null),
        type: 'private',
        startTime: widget.start,
        endTime: widget.end,
        maxParticipants: Value(_personCount),
        isTemplate: const Value(false),
        status: Value(LessonStatus.tentative.name),
        price: Value(_price),
        title: Value(title),
        notes: const Value('Olası özel ders'),
      ));
    } else {
      await db.updateLesson(
        lessonId,
        LessonsCompanion(
          maxParticipants: Value(_personCount),
          status: Value(LessonStatus.tentative.name),
          price: Value(_price),
          title: Value(title),
          courtId: const Value(null),
        ),
      );
      final existing = await db.getParticipantsForLesson(lessonId);
      for (final p in existing) {
        await db.removeParticipant(lessonId, p.userId);
      }
    }

    for (final user in users) {
      await db.insertParticipant(LessonParticipantsCompanion.insert(
        id: const Uuid().v4(),
        lessonId: lessonId,
        userId: user.id,
      ));
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['Kişi sayısı', 'İsimler', 'Fiyat'];

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.existingLesson == null ? 'Olası ders planla' : 'Olası dersi düzenle'),
          const SizedBox(height: 4),
          Text(
            AppDateFormat.dateTime(widget.start),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  if (i > 0) const Expanded(child: Divider()),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: i <= _step
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    foregroundColor: i <= _step ? Colors.white : Colors.grey.shade700,
                    child: Text('${i + 1}', style: const TextStyle(fontSize: 11)),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              steps[_step],
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (_step == 0) _buildPersonStep(),
            if (_step == 1) _buildNamesStep(),
            if (_step == 2) _buildPriceStep(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        if (_step > 0)
          TextButton(
            onPressed: _saving ? null : () => setState(() => _step--),
            child: const Text('Geri'),
          ),
        if (_step < 2)
          FilledButton(
            onPressed: () {
              if (_step == 1) {
                for (var i = 0; i < _personCount; i++) {
                  if (_nameControllers[i].text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${i + 1}. isim boş olamaz')),
                    );
                    return;
                  }
                }
              }
              setState(() => _step++);
            },
            child: const Text('İleri'),
          )
        else
          FilledButton(
            onPressed: _saving ? null : _save,
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

  Widget _buildPersonStep() {
    return DropdownButtonFormField<int>(
      value: _personCount,
      decoration: const InputDecoration(labelText: 'Kaç kişilik?'),
      items: List.generate(
        AppConstants.privateLessonMaxParticipants,
        (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1} kişi')),
      ),
      onChanged: (v) => setState(() => _personCount = v ?? 1),
    );
  }

  Widget _buildNamesStep() {
    return Column(
      children: [
        for (var i = 0; i < _personCount; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _NameAutocompleteField(
              index: i,
              controller: _nameControllers[i],
              selectedUser: _resolvedUsers[i],
              onSelected: (user) => setState(() => _resolvedUsers[i] = user),
              onChanged: () => setState(() => _resolvedUsers[i] = null),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.privateLessonPrices.map((p) {
            final selected = _price == p;
            return ChoiceChip(
              label: Text('${p.toStringAsFixed(0)} ₺'),
              selected: selected,
              onSelected: (_) => setState(() => _price = p),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Özel tutar (₺)',
            hintText: 'Listede yoksa yazın',
          ),
          keyboardType: TextInputType.number,
          onChanged: (v) {
            final parsed = double.tryParse(v.replaceAll(',', '.'));
            if (parsed != null && parsed > 0) {
              setState(() => _price = parsed);
            }
          },
        ),
        if (_price != null) ...[
          const SizedBox(height: 8),
          Text(
            'Seçilen: ${_price!.toStringAsFixed(0)} ₺',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }
}

class _NameAutocompleteField extends ConsumerStatefulWidget {
  const _NameAutocompleteField({
    required this.index,
    required this.controller,
    required this.selectedUser,
    required this.onSelected,
    required this.onChanged,
  });

  final int index;
  final TextEditingController controller;
  final User? selectedUser;
  final ValueChanged<User?> onSelected;
  final VoidCallback onChanged;

  @override
  ConsumerState<_NameAutocompleteField> createState() => _NameAutocompleteFieldState();
}

class _NameAutocompleteFieldState extends ConsumerState<_NameAutocompleteField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<User>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: (textEditingValue) async {
        final q = textEditingValue.text.trim();
        if (q.length < 2) return const Iterable<User>.empty();
        return ref.read(databaseProvider).searchAthletesByName(q);
      },
      displayStringForOption: (u) => u.name,
      onSelected: widget.onSelected,
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: '${widget.index + 1}. sporcu adı soyadı',
            helperText: widget.selectedUser != null ? 'Sistemde: ${widget.selectedUser!.name}' : null,
            suffixIcon: widget.selectedUser != null
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : null,
          ),
          onChanged: (_) => widget.onChanged(),
        );
      },
      optionsViewBuilder: (context, onSelectedOption, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 360),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, i) {
                  final user = options.elementAt(i);
                  return ListTile(
                    dense: true,
                    title: Text(user.name),
                    subtitle: Text(user.email, style: const TextStyle(fontSize: 11)),
                    onTap: () => onSelectedOption(user),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
