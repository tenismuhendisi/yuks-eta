/// ITF oyun topu seviyeleri.
import 'package:flutter/material.dart';

enum BallLevel {
  red('Kırmızı Top'),
  orange('Turuncu Top'),
  green('Yeşil Top'),
  yellow('Sarı Top');

  const BallLevel(this.label);
  final String label;

  static const labels = [
    'Kırmızı Top',
    'Turuncu Top',
    'Yeşil Top',
    'Sarı Top',
  ];

  static BallLevel? tryParse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final t = raw.trim().toLowerCase();
    for (final level in BallLevel.values) {
      if (level.label.toLowerCase() == t) return level;
    }
    // Eski seviye etiketleri
    switch (t) {
      case 'başlangıç':
      case 'baslangic':
        return BallLevel.red;
      case 'orta':
        return BallLevel.orange;
      case 'ileri':
        return BallLevel.green;
      case 'turnuva':
        return BallLevel.yellow;
      default:
        return null;
    }
  }

  static String normalizeLabel(String? raw) =>
      tryParse(raw)?.label ?? BallLevel.yellow.label;

  /// Kart / rozet rengi — ITF topuna yakın soft ton.
  Color get softFill => switch (this) {
        BallLevel.red => const Color(0xFFFFEBEE),
        BallLevel.orange => const Color(0xFFFFF3E0),
        BallLevel.green => const Color(0xFFF1F8E9),
        BallLevel.yellow => const Color(0xFFFFFDE7),
      };

  /// Başlık rengi — sarı amber değil, net sarı; turuncu ayrı kalsın.
  Color get strong => switch (this) {
        BallLevel.red => const Color(0xFFD32F2F),
        BallLevel.orange => const Color(0xFFFB8C00),
        BallLevel.green => const Color(0xFF7CB342),
        BallLevel.yellow => const Color(0xFFF5D000),
      };

  Color get onStrong => switch (this) {
        BallLevel.yellow => const Color(0xFF1A1A1A),
        BallLevel.green => const Color(0xFF0B1C2C),
        _ => Colors.white,
      };
}
