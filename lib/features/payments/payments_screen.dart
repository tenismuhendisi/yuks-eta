import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/payment_status.dart';
import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/features/payments/widgets/payment_form_dialog.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({
    super.key,
    required this.role,
    required this.userId,
  });

  final UserRole role;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final canCreate = role == UserRole.admin || role == UserRole.coach;

    Stream<List<Payment>> stream;
    if (role == UserRole.admin || role == UserRole.coach) {
      stream = db.watchAllPayments();
    } else if (role == UserRole.parent) {
      stream = _parentPaymentsStream(db, userId);
    } else {
      stream = db.watchPaymentsForUser(userId);
    }

    return Column(
      children: [
        if (canCreate)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => PaymentFormDialog(createdById: userId),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Ödeme Ekle'),
              ),
            ),
          ),
        Expanded(
          child: StreamBuilder<List<Payment>>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final payments = snapshot.data ?? [];
              if (payments.isEmpty) {
                return const Center(child: Text('Kayıtlı ödeme yok'));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  return _PaymentTile(
                    payment: payments[index],
                    canManage: canCreate,
                    userId: userId,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Stream<List<Payment>> _parentPaymentsStream(AppDatabase db, String parentId) async* {
    final athletes = await db.getAthletesForParent(parentId);
    if (athletes.isEmpty) {
      yield [];
      return;
    }
    await for (final all in db.watchAllPayments()) {
      final ids = athletes.map((a) => a.id).toSet();
      yield all.where((p) => ids.contains(p.userId)).toList();
    }
  }
}

class _PaymentTile extends ConsumerWidget {
  const _PaymentTile({
    required this.payment,
    required this.canManage,
    required this.userId,
  });

  final Payment payment;
  final bool canManage;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = PaymentStatus.fromString(payment.status);
    final color = switch (status) {
      PaymentStatus.paid => Colors.green,
      PaymentStatus.pending => Colors.orange,
      PaymentStatus.overdue => Colors.red,
      PaymentStatus.cancelled => Colors.grey,
    };

    return FutureBuilder<User?>(
      future: ref.read(databaseProvider).getUserById(payment.userId),
      builder: (context, snapshot) {
        final userName = snapshot.data?.name ?? '...';

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(Icons.payments, color: color, size: 20),
            ),
            title: Text('${payment.amount.toStringAsFixed(0)} ₺ - $userName'),
            subtitle: Text(
              '${payment.description}\nVade: ${AppDateFormat.shortDate(payment.dueDate)}',
            ),
            isThreeLine: true,
            trailing: canManage
                ? PopupMenuButton<String>(
                    onSelected: (action) async {
                      final db = ref.read(databaseProvider);
                      if (action == 'paid') {
                        await db.updatePayment(
                          payment.id,
                          PaymentsCompanion(
                            status: const Value('paid'),
                            paidAt: Value(DateTime.now()),
                          ),
                        );
                      } else if (action == 'edit') {
                        await showDialog(
                          context: context,
                          builder: (_) => PaymentFormDialog(
                            createdById: userId,
                            existing: payment,
                          ),
                        );
                      }
                    },
                    itemBuilder: (_) => [
                      if (status != PaymentStatus.paid)
                        const PopupMenuItem(value: 'paid', child: Text('Ödendi işaretle')),
                      const PopupMenuItem(value: 'edit', child: Text('Düzenle')),
                    ],
                  )
                : Chip(
                    label: Text(status.label, style: TextStyle(color: color, fontSize: 11)),
                    side: BorderSide(color: color),
                  ),
          ),
        );
      },
    );
  }
}
