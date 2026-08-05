/// Locale yükleme gerektirmeyen Türkçe tarih/saat formatları.
class AppDateFormat {
  static const _months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];

  static const _monthsShort = [
    'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
  ];

  static const _weekdays = [
    'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar',
  ];

  static const _weekdaysShort = [
    'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz',
  ];

  static String time(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String timeRange(DateTime start, DateTime end) =>
      '${time(start)} - ${time(end)}';

  static String dayHeader(DateTime date) =>
      '${_weekdaysShort[date.weekday - 1]}\n${date.day} ${_monthsShort[date.month - 1]}';

  static String fullDay(DateTime date) =>
      '${date.day} ${_months[date.month - 1]} ${date.year}, ${_weekdays[date.weekday - 1]}';

  static String shortDate(DateTime date) =>
      '${date.day} ${_monthsShort[date.month - 1]} ${date.year}';

  static String weekRange(DateTime start, DateTime end) =>
      '${start.day} ${_monthsShort[start.month - 1]} - ${end.day} ${_monthsShort[end.month - 1]} ${end.year}';

  static String dateTime(DateTime date) =>
      '${date.day} ${_monthsShort[date.month - 1]} ${date.year} ${time(date)}';
}
