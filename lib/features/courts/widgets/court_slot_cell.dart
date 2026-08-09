import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/theme/coach_colors.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:crm_app/core/widgets/schedule_lesson_slot.dart';
import 'package:flutter/material.dart';

/// Kort grid hücresi — dersler [ScheduleLessonSlot] ile takvimle aynı dil.
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

  @override
  Widget build(BuildContext context) {
    final canTap = onTap != null &&
        (slot.status == SlotStatus.available || slot.status == SlotStatus.blocked);
    final time = AppDateFormat.time(slot.startTime);
    final tooltip = [
      '${slot.courtName} · $time',
      if (slot.primaryLabel != null) slot.primaryLabel!,
      if (slot.secondaryLabel != null) slot.secondaryLabel!,
    ].join('\n');

    if (slot.status == SlotStatus.lesson) {
      return Tooltip(
        message: tooltip,
        waitDuration: const Duration(milliseconds: 400),
        child: ScheduleLessonSlot(
          coachId: slot.coachId,
          isGroup: slot.isGroupLesson,
          isTentative: false,
          primary: slot.primaryLabel ?? '',
          secondary: compact ? null : slot.secondaryLabel,
          groupCount: slot.isGroupLesson ? slot.participantCount : null,
          compact: compact,
          onTap: canTap ? onTap : null,
          enabled: canTap,
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
        bg = const Color(0xFFFFF6EB);
        border = const Color(0xFFFFE0B8);
      case SlotStatus.blocked:
        bg = const Color(0xFFF8F1F1);
        border = const Color(0xFFE8CACA);
      case SlotStatus.lesson:
        bg = CoachColors.fill(slot.coachId);
        border = Colors.transparent;
    }

    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 400),
      child: Material(
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
          ),
        ),
      ),
    );
  }
}
