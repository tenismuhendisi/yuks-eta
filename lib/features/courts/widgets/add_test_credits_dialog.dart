import 'package:crm_app/core/constants/app_constants.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTestCreditsDialog extends ConsumerStatefulWidget {
  const AddTestCreditsDialog({super.key});

  @override
  ConsumerState<AddTestCreditsDialog> createState() => _AddTestCreditsDialogState();
}

class _AddTestCreditsDialogState extends ConsumerState<AddTestCreditsDialog> {
  double _amount = AppConstants.testCreditAmounts.first;
  bool _loading = false;

  Future<void> _load() async {
    setState(() => _loading = true);
    final userId = ref.read(authProvider).user!.id;
    final balance = await ref.read(databaseProvider).addTestCredits(
          userId: userId,
          amount: _amount,
        );
    await ref.read(authProvider.notifier).refreshUser();
    if (!mounted) return;
    Navigator.pop(context, balance);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Test Kredi Yükle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerçek ödeme entegrasyonu yok — yalnızca test için kredi ekler.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.testCreditAmounts.map((a) {
              final selected = _amount == a;
              return ChoiceChip(
                label: Text('+${a.toInt()}'),
                selected: selected,
                onSelected: (_) => setState(() => _amount = a),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _loading ? null : _load,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('${_amount.toInt()} kredi yükle'),
        ),
      ],
    );
  }
}
