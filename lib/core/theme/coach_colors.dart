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

  /// Olası dersler için seçilebilir renkler.
  static const List<Color> tentativePalette = [
    Color(0xFF1565C0),
    Color(0xFF00838F),
    Color(0xFF2E7D32),
    Color(0xFFEF6C00),
    Color(0xFFC62828),
    Color(0xFF6A1B9A),
    Color(0xFF4527A0),
    Color(0xFFAD1457),
    Color(0xFF558B2F),
    Color(0xFF5D4037),
    Color(0xFF455A64),
    Color(0xFFF9A825),
  ];

  static Color forCoach(String? coachId, {String? colorHex}) {
    final custom = parseHex(colorHex);
    if (custom != null) return custom;
    if (coachId == null || coachId.isEmpty) {
      return const Color(0xFF546E7A);
    }
    final known = _byId[coachId];
    if (known != null) return known;
    return _fallbackPalette[coachId.hashCode.abs() % _fallbackPalette.length];
  }

  /// Soft dolgu — tip ayrımı çerçeve/koyulukla değil sol şerit ile yapılır.
  static Color fill(String? coachId, {String? colorHex, bool isGroup = false}) {
    final base = forCoach(coachId, colorHex: colorHex);
    return Color.lerp(base, Colors.white, 0.72)!;
  }

  /// İnce marka kenarlığı (eski kalın grup çerçevesi yerine).
  static Color border(String? coachId, {required bool isGroup, String? colorHex}) {
    final base = forCoach(coachId, colorHex: colorHex);
    return base.withValues(alpha: isGroup ? 0.22 : 0.12);
  }

  static double borderWidth({required bool isGroup}) => 1.0;

  static BorderRadius slotRadius({bool compact = false}) =>
      BorderRadius.circular(compact ? 8 : 10);

  static Color onFill(String? coachId, {String? colorHex, bool isGroup = false}) {
    final bg = fill(coachId, colorHex: colorHex);
    return bg.computeLuminance() > 0.45 ? const Color(0xFF0B1C2C) : Colors.white;
  }

  static String toHex(Color color) {
    final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  static Color? parseHex(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    var h = hex.trim();
    if (h.startsWith('#')) h = h.substring(1);
    if (h.length == 6) h = 'FF$h';
    if (h.length != 8) return null;
    final value = int.tryParse(h, radix: 16);
    if (value == null) return null;
    return Color(value);
  }
}
