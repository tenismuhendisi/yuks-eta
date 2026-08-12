/// Öğrenci profil notlarından grup kodu okuma / yazma.
abstract final class StudentNotes {
  static final _groupRe = RegExp(r'Grup:\s*([^\s,;]+)', caseSensitive: false);

  static String? groupCode(String? notes) {
    if (notes == null || notes.isEmpty) return null;
    return _groupRe.firstMatch(notes)?.group(1);
  }

  static String? withoutGroup(String? notes) {
    if (notes == null || notes.isEmpty) return null;
    final cleaned = notes.replaceAll(RegExp(r'Grup:\s*[^\s,;]+\s*', caseSensitive: false), '').trim();
    return cleaned.isEmpty ? null : cleaned;
  }

  static String? compose({required String group, required String rest}) {
    final g = group.trim();
    final r = rest.trim();
    if (g.isEmpty && r.isEmpty) return null;
    if (g.isEmpty) return r;
    if (r.isEmpty) return 'Grup: $g';
    return 'Grup: $g · $r';
  }

  static bool looksLikePrivate(String? notes) {
    if (notes == null || notes.isEmpty) return false;
    return notes.toLowerCase().contains('özel');
  }
}

/// "Can Yılmaz" → "Can"
String firstNameOf(String fullName) {
  final parts = fullName.trim().split(RegExp(r'\s+'));
  return parts.isEmpty ? fullName : parts.first;
}

/// Türkçe güvenli küçük harf.
///
/// Dart `toLowerCase()` "İ" → "i" + combining dot (2 code unit) üretir;
/// kısaltmada "İlayda" yanlış kesilir. Önce İ/I eşlemesi yapılır.
String turkishLower(String input) {
  final buf = StringBuffer();
  for (final rune in input.runes) {
    final ch = String.fromCharCode(rune);
    switch (ch) {
      case 'İ':
        buf.write('i');
      case 'I':
        buf.write('ı');
      case 'Ş':
        buf.write('ş');
      case 'Ğ':
        buf.write('ğ');
      case 'Ü':
        buf.write('ü');
      case 'Ö':
        buf.write('ö');
      case 'Ç':
        buf.write('ç');
      default:
        buf.write(ch.toLowerCase());
    }
  }
  // Kalan combining dot varsa temizle (önceden bozulmuş stringler için).
  return buf.toString().replaceAll('\u0307', '');
}

/// Harf (rune) sayısına göre kısalt — UTF-16 sürprizi olmadan.
String truncateLetters(String input, int maxLetters) {
  if (maxLetters <= 0) return '';
  final runes = input.runes.toList();
  if (runes.length <= maxLetters) return input;
  return String.fromCharCodes(runes.take(maxLetters));
}

