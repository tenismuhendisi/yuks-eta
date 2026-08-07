enum LessonStatus {
  tentative('Olası Ders'),
  confirmed('Onaylanmış Ders');

  const LessonStatus(this.label);
  final String label;

  static LessonStatus fromString(String? value) {
    return LessonStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => LessonStatus.confirmed,
    );
  }
}
