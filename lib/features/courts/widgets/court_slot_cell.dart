import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/theme/coach_colors.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/core/widgets/schedule_lesson_slot.dart';
import 'package:crm_app/core/widgets/schedule_rental_slot.dart';
import 'package:flutter/material.dart';

/// Kort grid hücresi — dersler [ScheduleLessonSlot], kiralama [ScheduleRentalSlot].
class CourtSlotCell extends StatelessWidget {
  const CourtSlotCell({
    super.key,
    required this.slot,
    this.onTap,
    this.compact = false,
  });

  final CourtSlot slot;
  final VoidCallback? onTap;
  final bool compact;

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
    final time = AppDateFormat.time(slot.startTime);
    final tooltip = [
      '${slot.courtName} · $time',
      if (slot.isRental && slot.renterName != null) 'Kiralama · ${slot.renterName}',
      if (slot.isGroupLesson && slot.primaryLabel != null) slot.primaryLabel!,
      if (slot.isPrivateLesson && slot.primaryLabel != null) slot.primaryLabel!,
      if (slot.secondaryLabel != null) slot.secondaryLabel!,
    ].join('\n');

    if (slot.status == SlotStatus.lesson) {
      return _tooltip(
        tooltip,
        ScheduleLessonSlot(
          coachId: slot.coachId,
          isGroup: slot.isGroupLesson,
          isTentative: false,
          lines: _lessonLines(slot),
          compact: compact,
          onTap: canTap ? onTap : null,
          enabled: canTap,
        ),
      );
    }

    if (slot.status == SlotStatus.rental) {
      return _tooltip(
        tooltip,
        ScheduleRentalSlot(
          renterName: slot.renterName ?? 'Kiralama',
          compact: compact,
        ),
      );
    }

    final Color bg;
    final Color border;
    final radius = BorderRadius.circular(compact ? 8 : 10);
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
        bg = CoachColors.fill(slot.coachId);
        border = Colors.transparent;
    }

    return _tooltip(
      tooltip,
      Material(
        color: bg,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: canTap ? onTap : null,
          borderRadius: radius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: border),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  Widget _tooltip(String message, Widget child) {
    return Tooltip(
      message: message,
      waitDuration: const Duration(milliseconds: 400),
      child: SizedBox.expand(child: child),
    );
  }
}
