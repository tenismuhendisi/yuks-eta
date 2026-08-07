enum AttendanceStatus {
  present('Geldi'),
  absent('Gelmedi'),
  late('Geç'),
  excused('İzinli');

  const AttendanceStatus(this.label);
  final String label;

  static AttendanceStatus fromString(String value) {
    return AttendanceStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => AttendanceStatus.absent,
    );
  }
}
