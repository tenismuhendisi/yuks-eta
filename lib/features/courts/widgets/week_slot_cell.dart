import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/widgets/schedule_lesson_slot.dart';
import 'package:crm_app/core/widgets/schedule_rental_slot.dart';
import 'package:flutter/material.dart';

/// Haftalık grid için hafif hücre.
class WeekSlotCell extends StatelessWidget {
  const WeekSlotCell({
    super.key,
    required this.slot,
    this.onTap,
  });

  final CourtSlot slot;
  final VoidCallback? onTap;

  static List<String> _lessonLines(CourtSlot slot) {
    if (slot.isGroupLesson) {
      return ScheduleLessonSlot.groupLines(
        slot.primaryLabel ?? 'Grup',
        slot.participantCount,
      );
    }
    final raw = slot.participantNames ?? slot.primaryLabel ?? '';
    final names = raw
        .split(RegExp(r'[-·,]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    final lines = ScheduleLessonSlot.privateLines(names);
    if (lines.isNotEmpty) return lines;
    return [slot.primaryLabel ?? 'Özel'];
  }

  @override
  Widget build(BuildContext context) {
    final canTap = onTap != null &&
        (slot.status == SlotStatus.available || slot.status == SlotStatus.blocked);

    if (slot.status == SlotStatus.lesson) {
      return SizedBox.expand(
        child: ScheduleLessonSlot(
          coachId: slot.coachId,
          isGroup: slot.isGroupLesson,
          isTentative: false,
          lines: _lessonLines(slot),
          compact: true,
          onTap: canTap ? onTap : null,
          enabled: canTap,
        ),
      );
    }

    if (slot.status == SlotStatus.rental) {
      return SizedBox.expand(
        child: ScheduleRentalSlot(
          renterName: slot.renterName ?? 'Kiralama',
          compact: true,
        ),
      );
    }

    final Color bg;
    final Color border;
    switch (slot.status) {
      case SlotStatus.available:
        bg = const Color(0xFFF7F8F7);
        border = const Color(0xFFE6E8E6);
      case SlotStatus.rental:
        bg = RentalSlotColors.fill;
        border = RentalSlotColors.border;
      case SlotStatus.blocked:
        bg = const Color(0xFFF8F1F1);
        border = const Color(0xFFE8CACA);
      case SlotStatus.lesson:
        bg = Colors.transparent;
        border = Colors.transparent;
    }

    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: const SizedBox.expand(),
    );

    if (!canTap) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }
}
