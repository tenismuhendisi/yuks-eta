import 'package:crm_app/core/utils/student_notes.dart';
import 'package:flutter/material.dart';

/// Kiralama hücresi — grup (sol şerit) ve özel dersten (antrenör rengi) ayrılır.
/// Sağ turuncu şerit + üstte raket ikonu, altta kiracı adı.
abstract final class RentalSlotColors {
  static const fill = Color(0xFFFFF3E8);
  static const rail = Color(0xFFE65100);
  static const border = Color(0xFFFFB74D);
  static const ink = Color(0xFF5D2E0A);
}

class ScheduleRentalSlot extends StatelessWidget {
  const ScheduleRentalSlot({
    super.key,
    required this.renterName,
    this.compact = false,
    this.onTap,
    this.enabled = false,
  });

  final String renterName;
  final bool compact;
  final VoidCallback? onTap;
  final bool enabled;

  static String firstName(String full) {
    final t = full.trim();
    if (t.isEmpty) return 'Kiralama';
    return t.split(RegExp(r'\s+')).first;
  }

  static String compactLabel(String full) {
    final first = turkishLower(firstName(full));
    return truncateLetters(first, 6);
  }

  @override
  Widget build(BuildContext context) {
    final label = compact ? compactLabel(renterName) : firstName(renterName);
    final radius = BorderRadius.circular(compact ? 8 : 10);
    final railW = compact ? 3.0 : 4.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: RentalSlotColors.border.withValues(alpha: 0.65)),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: RentalSlotColors.fill,
          child: InkWell(
            onTap: enabled ? onTap : null,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 4 : 6,
                    compact ? 3 : 4,
                    railW + (compact ? 3 : 4),
                    compact ? 3 : 4,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.sports_tennis,
                          size: compact ? 11 : 13,
                          color: RentalSlotColors.rail.withValues(alpha: 0.9),
                        ),
                        SizedBox(height: compact ? 2 : 3),
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: compact ? 10 : 12,
                            fontWeight: FontWeight.w700,
                            color: RentalSlotColors.ink,
                            height: 1.1,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: ColoredBox(
                    color: RentalSlotColors.rail,
                    child: SizedBox(width: railW),
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
