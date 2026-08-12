/// Söğütönü / Kent Ormanı kort grupları.
class CourtLocations {
  CourtLocations._();

  static const sogutonuIds = {
    'court-001',
    'court-002',
    'court-003',
    'court-004',
  };

  static const kentOrmaniIds = {
    'court-005',
    'court-006',
  };

  static const allIds = {...sogutonuIds, ...kentOrmaniIds};

  static String shortLabel(String courtId) => switch (courtId) {
        'court-001' => 'SÖ1',
        'court-002' => 'SÖ2',
        'court-003' => 'SÖ3',
        'court-004' => 'SÖ4',
        'court-005' => 'KO1',
        'court-006' => 'KO2',
        _ => courtId,
      };

  static bool isSogutonu(String courtId) => sogutonuIds.contains(courtId);
  static bool isKentOrmani(String courtId) => kentOrmaniIds.contains(courtId);

  /// Chip sırası: SÖ1…SÖ4, KO1, KO2.
  static const orderedIds = [
    'court-001',
    'court-002',
    'court-003',
    'court-004',
    'court-005',
    'court-006',
  ];
}
