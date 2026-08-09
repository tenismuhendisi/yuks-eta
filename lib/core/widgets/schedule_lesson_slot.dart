import 'package:crm_app/core/theme/coach_colors.dart';
import 'package:crm_app/features/calendar/widgets/dashed_rrect_border.dart';
import 'package:flutter/material.dart';

/// Takvim / kort ortak ders hücresi.
///
/// Tip ayrımı renk değil yapı ile:
/// - özel: soft dolgu, ince kenar
/// - grup: aynı dolgu + sol marka şeridi + kişi sayısı pill
/// - olası: soluk + kesikli çerçeve
class ScheduleLessonSlot extends StatelessWidget {
  const ScheduleLessonSlot({
    super.key,
    required this.coachId,
    this.colorHex,
    required this.isGroup,
    required this.isTentative,
    required this.primary,
    this.secondary,
    this.groupCount,
    this.onTap,
    this.compact = false,
    this.enabled = true,
  });

  final String? coachId;
  final String? colorHex;
  final bool isGroup;
  final bool isTentative;
  final String primary;
  final String? secondary;
  final int? groupCount;
  final VoidCallback? onTap;
  final bool compact;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final brand = CoachColors.forCoach(coachId, colorHex: colorHex);
    final fill = isTentative
        ? Color.lerp(CoachColors.fill(coachId, colorHex: colorHex), Colors.white, 0.42)!
        : CoachColors.fill(coachId, colorHex: colorHex);
    final ink = CoachColors.onFill(coachId, colorHex: colorHex);
    final mutedInk = ink.withValues(alpha: isTentative ? 0.55 : 0.88);
    final radius = BorderRadius.circular(compact ? 8 : 10);
    final railW = compact ? 3.0 : 4.0;

    final body = Material(
      color: fill,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: radius,
        child: Row(
          children: [
            if (isGroup)
              Container(
                width: railW,
                color: isTentative ? brand.withValues(alpha: 0.45) : brand,
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isGroup ? (compact ? 4 : 6) : (compact ? 5 : 7),
                  compact ? 3 : 4,
                  compact ? 4 : 6,
                  compact ? 3 : 4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isGroup && groupCount != null) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: compact ? 4 : 5,
                                  vertical: compact ? 1 : 2,
                                ),
                                decoration: BoxDecoration(
                                  color: brand.withValues(
                                    alpha: isTentative ? 0.18 : 0.16,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '$groupCount',
                                  style: TextStyle(
                                    fontSize: compact ? 10 : 12,
                                    fontWeight: FontWeight.w700,
                                    color: brand.withValues(
                                      alpha: isTentative ? 0.7 : 1,
                                    ),
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              SizedBox(width: compact ? 4 : 5),
                            ],
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  primary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: compact ? 10 : 12,
                                    fontWeight: FontWeight.w700,
                                    color: mutedInk,
                                    height: 1.1,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                                if (secondary != null &&
                                    secondary!.isNotEmpty &&
                                    !compact) ...[
                                  const SizedBox(height: 1),
                                  Text(
                                    secondary!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: mutedInk.withValues(alpha: 0.75),
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (isTentative) {
      return DashedRRectBorder(
        color: brand.withValues(alpha: 0.55),
        radius: radius,
        strokeWidth: 1.25,
        dash: 3.5,
        gap: 2.5,
        child: body,
      );
    }

    // Özel: neredeyse bordersız; grup: soft hairline
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(
          color: brand.withValues(alpha: isGroup ? 0.18 : 0.10),
          width: 1,
        ),
      ),
      child: body,
    );
  }
}
