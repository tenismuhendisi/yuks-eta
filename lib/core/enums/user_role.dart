enum UserRole {
  admin('Yönetici'),
  coach('Antrenör'),
  athlete('Sporcu'),
  parent('Veli');

  const UserRole(this.label);
  final String label;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (r) => r.name == value,
      orElse: () => UserRole.athlete,
    );
  }
}
