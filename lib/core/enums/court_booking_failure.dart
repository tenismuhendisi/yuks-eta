import 'package:crm_app/core/database/app_database.dart';

enum CourtBookingFailure {
  slotUnavailable('Bu kort artık müsait değil'),
  insufficientCredits('Yetersiz kredi'),
  pastSlot('Geçmiş saat için kiralama yapılamaz'),
  userOverlap('Bu saatte başka bir kortunuz zaten kiralanmış'),
  userNotFound('Kullanıcı bulunamadı');

  const CourtBookingFailure(this.message);
  final String message;
}

class CourtBookingResult {
  const CourtBookingResult._({this.rental, this.failure});

  final CourtRental? rental;
  final CourtBookingFailure? failure;

  bool get success => failure == null && rental != null;

  factory CourtBookingResult.ok(CourtRental rental) =>
      CourtBookingResult._(rental: rental);

  factory CourtBookingResult.err(CourtBookingFailure failure) =>
      CourtBookingResult._(failure: failure);
}
