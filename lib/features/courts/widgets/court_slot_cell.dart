import 'package:crm_app/core/services/court_availability_service.dart';
import 'package:crm_app/core/theme/coach_colors.dart';
import 'package:crm_app/core/utils/app_date_format.dart';
import 'package:flutter/material.dart';

/// Grid hücresi: Ç15 + antrenör adı; grupta sol üst G.
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

  Color get _backgroundColor {
    switch (slot.status) {
      case SlotStatus.available:
        return Colors.green.shade50;
      case SlotStatus.lesson:
        return CoachColors.fill(slot.coachId);
      case SlotStatus.rental:
        return Colors.orange.shade50;
      case SlotStatus.blocked:
        return Colors.red.shade50;
    }
  }

  Color get _borderColor {
    switch (slot.status) {
      case SlotStatus.available:
        return Colors.green.shade200;
      case SlotStatus.lesson:
        return CoachColors.border(slot.coachId, isGroup: slot.isGroupLesson);
      case SlotStatus.rental:
        return Colors.orange.shade200;
      case SlotStatus.blocked:
        return Colors.red.shade200;
    }
  }

  double get _borderWidth {
    if (slot.status == SlotStatus.lesson) {
      return CoachColors.borderWidth(isGroup: slot.isGroupLesson);
    }
    return 1;
  }

  Color get _foreground {
    if (slot.status == SlotStatus.lesson) {
      return CoachColors.onFill(slot.coachId);
    }
    return Colors.grey.shade800;
  }

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
    final fg = _foreground;
    final radius = BorderRadius.circular(compact ? 4 : 6);
    final primary = slot.primaryLabel;
    final secondary = slot.secondaryLabel;

    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 400),
      child: Material(
        color: _backgroundColor,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: canTap ? onTap : null,
          borderRadius: radius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: _borderColor, width: _borderWidth),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (slot.isGroupLesson)
                  Positioned(
                    top: compact ? 1 : 2,
                    left: compact ? 2 : 3,
                    child: Text(
                      'G',
                      style: TextStyle(
                        fontSize: compact ? 7 : 8,
                        fontWeight: FontWeight.w900,
                        color: fg,
                        height: 1,
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 2 : 4,
                    compact ? 2 : 4,
                    compact ? 2 : 4,
                    compact ? 2 : 4,
                  ),
                  child: Center(
                    child: slot.status != SlotStatus.lesson
                        ? const SizedBox.shrink()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (primary != null)
                                Text(
                                  primary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: compact ? 10 : 13,
                                    fontWeight: FontWeight.w800,
                                    color: fg,
                                    height: 1.05,
                                  ),
                                ),
                              if (!compact && secondary != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  secondary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 9,
                                    height: 1.05,
                                    color: fg.withValues(alpha: 0.92),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
