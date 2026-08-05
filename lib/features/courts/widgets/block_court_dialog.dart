import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class BlockCourtDialog extends ConsumerStatefulWidget {
  const BlockCourtDialog({
    super.key,
    required this.courtId,
    required this.courtName,
    required this.startTime,
    required this.endTime,
    required this.adminId,
  });

  final String courtId;
  final String courtName;
  final DateTime startTime;
  final DateTime endTime;
  final String adminId;

  @override
  ConsumerState<BlockCourtDialog> createState() => _BlockCourtDialogState();
}

class _BlockCourtDialogState extends ConsumerState<BlockCourtDialog> {
  final _reasonController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _reasonController.dispose();
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
          const SnackBar(content: Text('Bu saat dilimi artık müsait değil')),
        );
        Navigator.pop(context, false);
      }
      return;
    }

    await ref.read(databaseProvider).insertCourtBlock(
          CourtBlocksCompanion.insert(
            id: const Uuid().v4(),
            courtId: widget.courtId,
            startTime: widget.startTime,
            endTime: widget.endTime,
            reason: Value(_reasonController.text.trim().isEmpty
                ? 'Yönetici kilidi'
                : _reasonController.text.trim()),
            createdById: widget.adminId,
          ),
        );

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kort Kilitle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.courtName} bu saatte rezerve edilemeyecek.'),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(labelText: 'Sebep (opsiyonel)'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Kilitle'),
        ),
      ],
    );
  }
}
