import 'package:flutter/material.dart';

/// Her antrenör için tek marka rengi.
abstract final class CoachColors {
  static const Map<String, Color> _byId = {
    'coach-yasir': Color(0xFF1565C0),
    'coach-elizt': Color(0xFF6A1B9A),
    'coach-eliza': Color(0xFF00838F),
    'coach-gurkan': Color(0xFFC62828),
    'coach-dogukan': Color(0xFFEF6C00),
    'coach-alper': Color(0xFF2E7D32),
    'coach-yucel': Color(0xFF4527A0),
  };

  static const List<Color> _fallbackPalette = [
    Color(0xFF0277BD),
    Color(0xFFAD1457),
    Color(0xFF558B2F),
    Color(0xFF6D4C41),
    Color(0xFF37474F),
  ];

  static Color forCoach(String? coachId) {
    if (coachId == null || coachId.isEmpty) {
      return const Color(0xFF546E7A);
    }
    final known = _byId[coachId];
    if (known != null) return known;
    return _fallbackPalette[coachId.hashCode.abs() % _fallbackPalette.length];
  }

  /// Ortak dolgu (grup ve özel aynı).
  static Color fill(String? coachId) =>
      Color.lerp(forCoach(coachId), Colors.white, 0.55)!;

  /// Grup: kalın koyu çerçeve. Özel: ince aynı renk.
  static Color border(String? coachId, {required bool isGroup}) {
    final base = forCoach(coachId);
    return isGroup ? Color.lerp(base, Colors.black, 0.5)! : base.withValues(alpha: 0.55);
  }

  static double borderWidth({required bool isGroup}) => isGroup ? 3.0 : 1.0;

  static Color onFill(String? coachId) {
    final bg = fill(coachId);
    return bg.computeLuminance() > 0.45 ? const Color(0xFF0B1C2C) : Colors.white;
  }
}
