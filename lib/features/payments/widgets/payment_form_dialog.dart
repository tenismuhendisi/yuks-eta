import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/payment_status.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class PaymentFormDialog extends ConsumerStatefulWidget {
  const PaymentFormDialog({
    super.key,
    required this.createdById,
    this.existing,
  });

  final String createdById;
  final Payment? existing;

  @override
  ConsumerState<PaymentFormDialog> createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends ConsumerState<PaymentFormDialog> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  PaymentStatus _status = PaymentStatus.pending;
  String? _selectedUserId;
  List<User> _users = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final p = widget.existing!;
      _amountController.text = p.amount.toStringAsFixed(0);
      _descriptionController.text = p.description;
      _dueDate = p.dueDate;
      _status = PaymentStatus.fromString(p.status);
      _selectedUserId = p.userId;
    }
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final db = ref.read(databaseProvider);
    final athletes = await db.getUsersByRole('athlete');
    if (mounted) setState(() => _users = athletes);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_selectedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir sporcu seçin')),
      );
      return;
    }

    setState(() => _saving = true);
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir tutar girin')),
      );
      setState(() => _saving = false);
      return;
    }

    final db = ref.read(databaseProvider);
    if (widget.existing == null) {
      await db.insertPayment(PaymentsCompanion.insert(
        id: const Uuid().v4(),
        userId: _selectedUserId!,
        amount: amount,
        description: _descriptionController.text.trim().isEmpty
            ? 'Aidat'
            : _descriptionController.text.trim(),
        dueDate: _dueDate,
        status: _status.name,
        createdById: widget.createdById,
        createdAt: DateTime.now(),
        paidAt: Value(_status == PaymentStatus.paid ? DateTime.now() : null),
      ));
    } else {
      await db.updatePayment(
        widget.existing!.id,
        PaymentsCompanion(
          userId: Value(_selectedUserId!),
          amount: Value(amount),
          description: Value(_descriptionController.text.trim()),
          dueDate: Value(_dueDate),
          status: Value(_status.name),
          paidAt: Value(_status == PaymentStatus.paid ? DateTime.now() : null),
        ),
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Ödeme Ekle' : 'Ödemeyi Düzenle'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedUserId,
              decoration: const InputDecoration(labelText: 'Sporcu'),
              items: _users
                  .map((u) => DropdownMenuItem(value: u.id, child: Text(u.name)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedUserId = v),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Tutar (₺)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Açıklama'),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Vade tarihi'),
              subtitle: Text(AppDateFormat.fullDay(_dueDate)),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _dueDate = picked);
                },
              ),
            ),
            DropdownButtonFormField<PaymentStatus>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Durum'),
              items: PaymentStatus.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
              onChanged: (v) => setState(() => _status = v ?? PaymentStatus.pending),
            ),
          ],
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
