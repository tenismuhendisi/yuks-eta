import 'package:crm_app/core/constants/app_constants.dart';
import 'package:crm_app/core/enums/court_booking_failure.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
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

  double get _creditCost => AppConstants.courtRentalCreditCost;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    final notes = _notesController.text.trim();

    final result = await db.bookCourtRental(
      rentalId: const Uuid().v4(),
      courtId: widget.courtId,
      athleteId: widget.athleteId,
      startTime: widget.startTime,
      endTime: widget.endTime,
      creditCost: _creditCost,
      notes: notes.isEmpty ? null : notes,
    );

    if (!mounted) return;

    if (result.success) {
      await ref.read(authProvider.notifier).refreshUser();
      if (!mounted) return;
      Navigator.pop(context, true);
      return;
    }

    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.failure!.message)),
    );
    if (result.failure == CourtBookingFailure.slotUnavailable ||
        result.failure == CourtBookingFailure.userOverlap) {
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final balance = user?.creditBalance ?? 0;
    final enough = balance >= _creditCost;

    return AlertDialog(
      title: const Text('Kort Kirala'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.courtName} · ${AppDateFormat.dateTime(widget.startTime)}'),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.monetization_on_outlined, size: 18, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(
                'Ücret: ${_creditCost.toInt()} kredi',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Bakiyeniz: ${balance.toInt()} kredi',
            style: TextStyle(
              color: enough ? Colors.green.shade800 : Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (!enough) ...[
            const SizedBox(height: 8),
            Text(
              'Yetersiz kredi. Test kredi yükleyerek deneyebilirsiniz.',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
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
          onPressed: _saving || !enough ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Kirala'),
        ),
      ],
    );
  }
}
