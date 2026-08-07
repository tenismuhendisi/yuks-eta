import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/theme/coach_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    final isGroup = slot.isGroupLesson;

    final Color bg;
    final Color border;
    final double borderW;
    final Color fg;

    switch (slot.status) {
      case SlotStatus.available:
        bg = const Color(0xFFE8F5E9);
        border = const Color(0xFFA5D6A7);
        borderW = 1;
        fg = const Color(0xFF2E7D32);
      case SlotStatus.rental:
        bg = const Color(0xFFFFF3E0);
        border = const Color(0xFFFFCC80);
        borderW = 1;
        fg = const Color(0xFFEF6C00);
      case SlotStatus.blocked:
        bg = const Color(0xFFFFEBEE);
        border = const Color(0xFFEF9A9A);
        borderW = 1;
        fg = const Color(0xFFC62828);
      case SlotStatus.lesson:
        bg = CoachColors.fill(slot.coachId);
        border = CoachColors.border(slot.coachId, isGroup: isGroup);
        borderW = CoachColors.borderWidth(isGroup: isGroup);
        fg = CoachColors.onFill(slot.coachId);
    }

    final label = slot.primaryLabel;
    final canTap = onTap != null &&
        (slot.status == SlotStatus.available || slot.status == SlotStatus.blocked);

    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: border, width: borderW),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isGroup)
            Positioned(
              top: 1,
              left: 2,
              child: Text(
                'G',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                  color: fg,
                  height: 1,
                ),
              ),
            ),
          if (label != null)
            Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: fg,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
    );

    if (!canTap) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }
}
