import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/features/students/widgets/student_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key, required this.coachId});

  final String coachId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesStream = ref.watch(databaseProvider).watchStudentsForCoach(coachId);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text('Öğrencilerim', style: Theme.of(context).textTheme.titleLarge),
              ),
              FilledButton.icon(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => StudentFormDialog(coachId: coachId),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Öğrenci Ekle'),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<StudentProfile>>(
            stream: profilesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final profiles = snapshot.data ?? [];
              if (profiles.isEmpty) {
                return const Center(child: Text('Henüz öğrenci eklenmemiş'));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  return _StudentTile(profile: profiles[index], coachId: coachId);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StudentTile extends ConsumerWidget {
  const _StudentTile({required this.profile, required this.coachId});

  final StudentProfile profile;
  final String coachId;

  Future<bool> _confirmRemove(BuildContext context, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Öğrenciyi Çıkar'),
        content: Text('$name listenizden çıkarılsın mı?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Çıkar'),
          ),
        ],
      ),
    );
    return confirm == true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<User?>(
      future: ref.read(databaseProvider).getUserById(profile.userId),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) return const SizedBox.shrink();

        return Dismissible(
          key: ValueKey('student-${profile.userId}-${profile.coachId}'),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmRemove(context, user.name),
          onDismissed: (_) {
            ref.read(databaseProvider).removeStudentFromCoach(profile.userId, coachId);
          },
          background: Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Çıkar',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Icon(Icons.delete_outline, color: Colors.white),
              ],
            ),
          ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(child: Text(user.name.characters.first)),
              title: Text(user.name),
              subtitle: Text(
                [
                  if (profile.age != null) '${profile.age} yaş',
                  if (profile.level != null) 'Seviye: ${profile.level}',
                  user.email,
                ].join(' · '),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (action) async {
                  if (action == 'edit') {
                    await showDialog(
                      context: context,
                      builder: (_) => StudentFormDialog(
                        coachId: coachId,
                        existingProfile: profile,
                        existingUser: user,
                      ),
                    );
                  } else if (action == 'remove') {
                    final confirmed = await _confirmRemove(context, user.name);
                    if (confirmed) {
                      await ref.read(databaseProvider).removeStudentFromCoach(profile.userId, coachId);
                    }
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Düzenle')),
                  const PopupMenuItem(value: 'remove', child: Text('Listeden Çıkar')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

