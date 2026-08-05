enum PaymentStatus {
  pending('Bekliyor'),
  paid('Ödendi'),
  overdue('Gecikmiş'),
  cancelled('İptal');

  const PaymentStatus(this.label);
  final String label;

  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}
