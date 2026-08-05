import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:flutter/material.dart';

class CourtSlotTile extends StatelessWidget {
  const CourtSlotTile({
    super.key,
    required this.slot,
    this.onTap,
  });

  final CourtSlot slot;
  final VoidCallback? onTap;

  Color get _backgroundColor {
    switch (slot.status) {
      case SlotStatus.available:
        return Colors.green.shade50;
      case SlotStatus.lesson:
        return Colors.blue.shade50;
      case SlotStatus.rental:
        return Colors.orange.shade50;
      case SlotStatus.blocked:
        return Colors.red.shade50;
    }
  }

  IconData get _icon {
    switch (slot.status) {
      case SlotStatus.available:
        return Icons.check_circle_outline;
      case SlotStatus.lesson:
        return Icons.school_outlined;
      case SlotStatus.rental:
        return Icons.event_available;
      case SlotStatus.blocked:
        return Icons.lock_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = AppDateFormat.timeRange(slot.startTime, slot.endTime);
    final canTap = onTap != null &&
        (slot.status == SlotStatus.available || slot.status == SlotStatus.blocked);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: canTap ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(_icon, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(time, style: const TextStyle(fontWeight: FontWeight.w600)),
                      if (slot.detail != null)
                        Text(slot.detail!, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
                if (canTap)
                  Icon(Icons.chevron_right, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
