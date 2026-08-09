/// ITF oyun topu seviyeleri.
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
}
