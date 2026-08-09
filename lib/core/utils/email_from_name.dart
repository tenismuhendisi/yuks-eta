/// Türkçe karakterleri e-posta slug'ına çevirir: "Ece Kaya" → ece.kaya@eta.com
String emailFromPersonName(String fullName, {String domain = 'eta.com'}) {
  const map = {
    'ç': 'c',
    'Ç': 'c',
    'ğ': 'g',
    'Ğ': 'g',
    'ı': 'i',
    'İ': 'i',
    'I': 'i',
    'ö': 'o',
    'Ö': 'o',
    'ş': 's',
    'Ş': 's',
    'ü': 'u',
    'Ü': 'u',
  };

  String slugPart(String part) {
    final buf = StringBuffer();
    for (final rune in part.runes) {
      final ch = String.fromCharCode(rune);
      if (map.containsKey(ch)) {
        buf.write(map[ch]);
      } else if (RegExp(r'[A-Za-z0-9]').hasMatch(ch)) {
        buf.write(ch.toLowerCase());
      }
    }
    return buf.toString();
  }

  final parts = fullName
      .trim()
      .split(RegExp(r'\s+'))
      .map(slugPart)
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return 'sporcu@$domain';
  return '${parts.join('.')}@$domain';
}
