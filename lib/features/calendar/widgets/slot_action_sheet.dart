import 'package:flutter/material.dart';

enum SlotPlanAction {
  tentativePrivate,
  planLesson,
}

/// Boş slota tıklanınca: ne yapmak istediğini sorar.
Future<SlotPlanAction?> showSlotActionSheet(BuildContext context) {
  return showModalBottomSheet<SlotPlanAction>(
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
                'Ne yapmak istersiniz?',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber.shade100,
                  child: Icon(Icons.schedule, color: Colors.amber.shade900),
                ),
                title: const Text('Olası ders'),
                subtitle: const Text('Özel ders planla — henüz genel takvimde görünmez'),
                onTap: () => Navigator.pop(ctx, SlotPlanAction.tentativePrivate),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: Icon(Icons.event_note, color: Colors.blue.shade800),
                ),
                title: const Text('Ders planla'),
                subtitle: const Text('Grup veya onaylı özel ders (kort gerekir)'),
                onTap: () => Navigator.pop(ctx, SlotPlanAction.planLesson),
              ),
              const SizedBox(height: 4),
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
