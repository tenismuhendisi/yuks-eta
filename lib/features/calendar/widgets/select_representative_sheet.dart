import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Grup dersi için temsilci öğrenci seçimi.
Future<String?> showSelectRepresentativeSheet(
  BuildContext context, {
  required Lesson lesson,
}) async {
  final container = ProviderScope.containerOf(context);
  final db = container.read(databaseProvider);
  final parts = await db.getParticipantsForLesson(lesson.id);
  if (parts.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bu grupta kayıtlı öğrenci yok')),
      );
    }
    return null;
  }

  final users = await db.getUsersByIds(parts.map((p) => p.userId).toList());
  users.sort((a, b) => a.name.compareTo(b.name));

  if (!context.mounted) return null;

  return showModalBottomSheet<String>(
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
                'Temsilci seç',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                lesson.title ?? 'Grup dersi',
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(ctx).height * 0.45,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (_, i) {
                    final u = users[i];
                    final selected = u.id == lesson.representativeUserId;
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(u.name.characters.first.toUpperCase()),
                      ),
                      title: Text(u.name),
                      trailing: selected
                          ? Icon(Icons.check_circle, color: Colors.green.shade700)
                          : null,
                      onTap: () => Navigator.pop(ctx, u.id),
                    );
                  },
                ),
              ),
              if (lesson.representativeUserId != null)
                TextButton(
                  onPressed: () => Navigator.pop(ctx, ''),
                  child: const Text('Temsilciyi kaldır'),
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
