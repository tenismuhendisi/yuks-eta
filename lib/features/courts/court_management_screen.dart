import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/features/courts/widgets/court_slot_tile.dart';
import 'package:crm_app/features/courts/widgets/block_court_dialog.dart';
import 'package:crm_app/features/courts/widgets/rent_court_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourtManagementScreen extends ConsumerStatefulWidget {
  const CourtManagementScreen({
    super.key,
    required this.role,
    required this.userId,
  });

  final UserRole role;
  final String userId;

  @override
  ConsumerState<CourtManagementScreen> createState() => _CourtManagementScreenState();
}

class _CourtManagementScreenState extends ConsumerState<CourtManagementScreen> {
  DateTime _selectedDay = DateTime.now();

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null) {
      setState(() => _selectedDay = picked);
    }
  }

  Future<void> _refresh() async => setState(() {});

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(courtAvailabilityServiceProvider);
    final dateLabel = AppDateFormat.fullDay(_selectedDay);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.role == UserRole.athlete ? 'Kort Kiralama' : 'Kort Yönetimi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              OutlinedButton.icon(
                onPressed: _pickDay,
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(dateLabel),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _LegendBar(role: widget.role),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<List<CourtSlot>>(
            future: service.getSlotsForDay(_selectedDay),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final slots = snapshot.data ?? [];
              if (slots.isEmpty) {
                return const Center(child: Text('Kort bulunamadı'));
              }

              final grouped = <String, List<CourtSlot>>{};
              for (final slot in slots) {
                grouped.putIfAbsent(slot.courtName, () => []).add(slot);
              }

              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: grouped.entries.map((entry) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            ...entry.value.map((slot) => CourtSlotTile(
                                  slot: slot,
                                  onTap: () => _onSlotTap(slot),
                                )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _onSlotTap(CourtSlot slot) async {
    if (widget.role == UserRole.admin && slot.status == SlotStatus.available) {
      final result = await showDialog<bool>(
        context: context,
        builder: (_) => BlockCourtDialog(
          courtId: slot.courtId,
          courtName: slot.courtName,
          startTime: slot.startTime,
          endTime: slot.endTime,
          adminId: widget.userId,
        ),
      );
      if (result == true) _refresh();
    } else if (widget.role == UserRole.admin && slot.status == SlotStatus.blocked) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Kilidi Kaldır'),
          content: Text('${slot.courtName} - ${AppDateFormat.time(slot.startTime)} kilidi kaldırılsın mı?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Kaldır')),
          ],
        ),
      );
      if (confirm == true && slot.referenceId != null) {
        await ref.read(databaseProvider).deleteCourtBlock(slot.referenceId!);
        _refresh();
      }
    } else if (widget.role == UserRole.athlete && slot.status == SlotStatus.available) {
      final result = await showDialog<bool>(
        context: context,
        builder: (_) => RentCourtDialog(
          courtId: slot.courtId,
          courtName: slot.courtName,
          startTime: slot.startTime,
          endTime: slot.endTime,
          athleteId: widget.userId,
        ),
      );
      if (result == true) _refresh();
    }
  }
}

class _LegendBar extends StatelessWidget {
  const _LegendBar({required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        _LegendItem(color: Colors.green.shade100, label: 'Boş'),
        _LegendItem(color: Colors.blue.shade100, label: 'Ders'),
        _LegendItem(color: Colors.orange.shade100, label: 'Kiralama'),
        _LegendItem(color: Colors.red.shade100, label: 'Kilitli'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
