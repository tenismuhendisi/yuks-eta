class AppConstants {
  static const appName = 'ETA Tenis Akademisi';
  static const calendarStartHour = 8;
  static const calendarEndHour = 24;
  static const slotDurationMinutes = 60;
  static const privateLessonMaxParticipants = 3;

  /// Kort kiralama başına düşülen kredi (1 saatlik slot).
  static const courtRentalCreditCost = 1.0;

  /// Test kredi yükleme seçenekleri.
  static const testCreditAmounts = [5.0, 10.0, 20.0, 50.0];

  /// Özel ders fiyat seçenekleri (₺).
  static const List<double> privateLessonPrices = [
    500,
    750,
    1000,
    1250,
    1500,
    2000,
  ];

  /// Takvim günü: sabah / öğle / akşam.
  /// expandedByDefault = antrenör takvimi; courtExpandedByDefault = kortlar.
  static const List<CalendarTimeBlock> calendarTimeBlocks = [
    CalendarTimeBlock(
      id: 'morning',
      label: 'Sabah',
      startHour: 8,
      endHour: 13,
      expandedByDefault: true,
      courtExpandedByDefault: false,
    ),
    CalendarTimeBlock(
      id: 'midday',
      label: 'Öğle',
      startHour: 13,
      endHour: 17,
      expandedByDefault: false,
      courtExpandedByDefault: false,
    ),
    CalendarTimeBlock(
      id: 'evening',
      label: 'Akşam',
      startHour: 17,
      endHour: 24,
      expandedByDefault: true,
      courtExpandedByDefault: true,
    ),
  ];
}

class CalendarTimeBlock {
  const CalendarTimeBlock({
    required this.id,
    required this.label,
    required this.startHour,
    required this.endHour,
    required this.expandedByDefault,
    this.courtExpandedByDefault = false,
  });

  final String id;
  final String label;
  /// Dahil
  final int startHour;
  /// Hariç
  final int endHour;
  final bool expandedByDefault;
  final bool courtExpandedByDefault;

  List<int> get hours =>
      List.generate(endHour - startHour, (i) => startHour + i);

  String get rangeLabel {
    final start = '${startHour.toString().padLeft(2, '0')}:00';
    final end = endHour == 24 ? '24:00' : '${endHour.toString().padLeft(2, '0')}:00';
    return '$start–$end';
  }
}
