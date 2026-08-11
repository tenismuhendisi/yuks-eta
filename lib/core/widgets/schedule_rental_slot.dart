import 'package:flutter/material.dart';

/// Kiralama hücresi — grup (sol şerit) ve özel dersten (antrenör rengi) ayrılır.
/// Sağ turuncu şerit + kiracı adı.
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
    final first = firstName(full);
    if (first.length <= 7) return first;
    return first.substring(0, 7);
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
                    compact ? 5 : 7,
                    compact ? 3 : 4,
                    railW + (compact ? 4 : 5),
                    compact ? 3 : 4,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.sports_tennis,
                          size: compact ? 10 : 12,
                          color: RentalSlotColors.rail.withValues(alpha: 0.85),
                        ),
                        SizedBox(width: compact ? 3 : 4),
                        Expanded(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: compact ? 10 : 12,
                              fontWeight: FontWeight.w700,
                              color: RentalSlotColors.ink,
                              height: 1.1,
                              letterSpacing: -0.1,
                            ),
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
