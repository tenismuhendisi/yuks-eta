import 'package:crm_app/core/theme/coach_colors.dart';
import 'package:crm_app/core/utils/student_notes.dart';
import 'package:crm_app/features/calendar/widgets/dashed_rrect_border.dart';
import 'package:flutter/material.dart';

/// Takvim / kort ortak ders hücresi.
///
/// Tip ayrımı renk değil yapı ile:
/// - özel: soft dolgu, ince kenar; isimler satır satır
/// - grup: aynı dolgu + sol marka şeridi; kod + "N kişi"
/// - olası: soluk + kesikli çerçeve
class ScheduleLessonSlot extends StatelessWidget {
  const ScheduleLessonSlot({
    super.key,
    required this.coachId,
    this.colorHex,
    required this.isGroup,
    required this.isTentative,
    required this.lines,
    this.onTap,
    this.compact = false,
    this.enabled = true,
  });

  final String? coachId;
  final String? colorHex;
  final bool isGroup;
  final bool isTentative;
  /// Aynı stil; grup: [kod, "5 kişi"], özel: isim satırları (≤6 harf).
  final List<String> lines;
  final VoidCallback? onTap;
  final bool compact;
  final bool enabled;

  /// Özel ders isimlerini en fazla 6 harfe kısaltır (Türkçe İ/I güvenli).
  static List<String> privateLines(Iterable<String> firstNames) {
    return firstNames
        .map((n) => turkishLower(n.trim()))
        .where((n) => n.isNotEmpty)
        .map((n) => truncateLetters(n, 6))
        .toList();
  }

  static List<String> groupLines(String code, int? count) {
    final title = code.trim().isEmpty ? 'Grup' : code.trim();
    if (count == null || count <= 0) return [title];
    return [title, '$count kişi'];
  }

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
    final visible = lines.where((l) => l.trim().isNotEmpty).toList();

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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < visible.length; i++) ...[
                        if (i > 0) SizedBox(height: compact ? 1 : 2),
                        Text(
                          visible[i],
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
                      ],
                    ],
                  ),
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
