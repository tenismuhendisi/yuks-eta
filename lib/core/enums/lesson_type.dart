enum LessonType {
  private('Özel Ders'),
  group('Grup Dersi');

  const LessonType(this.label);
  final String label;

  static LessonType fromString(String value) {
    return LessonType.values.firstWhere(
      (t) => t.name == value,
      orElse: () => LessonType.private,
    );
  }
}
