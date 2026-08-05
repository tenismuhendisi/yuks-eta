import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class RentCourtDialog extends ConsumerStatefulWidget {
  const RentCourtDialog({
    super.key,
    required this.courtId,
    required this.courtName,
    required this.startTime,
    required this.endTime,
    required this.athleteId,
  });

  final String courtId;
  final String courtName;
  final DateTime startTime;
  final DateTime endTime;
  final String athleteId;

  @override
  ConsumerState<RentCourtDialog> createState() => _RentCourtDialogState();
}

class _RentCourtDialogState extends ConsumerState<RentCourtDialog> {
  final _notesController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final service = ref.read(courtAvailabilityServiceProvider);
    final available = await service.isCourtAvailable(
      widget.courtId,
      widget.startTime,
      widget.endTime,
    );
    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bu kort artık müsait değil')),
        );
        Navigator.pop(context, false);
      }
      return;
    }

    await ref.read(databaseProvider).insertRental(
          CourtRentalsCompanion.insert(
            id: const Uuid().v4(),
            courtId: widget.courtId,
            athleteId: widget.athleteId,
            startTime: widget.startTime,
            endTime: widget.endTime,
            notes: Value(_notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim()),
          ),
        );

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kort Kirala'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.courtName} kiralamak istiyor musunuz?'),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Not (opsiyonel)'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Kirala'),
        ),
      ],
    );
  }
}
