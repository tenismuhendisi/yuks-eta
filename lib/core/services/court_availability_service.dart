import 'package:crm_app/core/constants/app_constants.dart';
import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/user_role.dart';
import 'package:crm_app/core/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SlotStatus { available, lesson, rental, blocked }

class CourtSlot {
  const CourtSlot({
    required this.courtId,
    required this.courtName,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.detail,
    this.referenceId,
  });

  final String courtId;
  final String courtName;
  final DateTime startTime;
  final DateTime endTime;
  final SlotStatus status;
  final String? detail;
  final String? referenceId;
}

class CourtAvailabilityService {
  CourtAvailabilityService(this._db);

  final AppDatabase _db;

  Future<List<CourtSlot>> getSlotsForDay(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day, AppConstants.calendarStartHour);
    final end = DateTime(day.year, day.month, day.day, AppConstants.calendarEndHour);

    final courts = await _db.getActiveCourts();
    final blocks = await _db.getBlocksForRange(start, end);
    final rentals = await _db.getRentalsForRange(start, end);
    final lessons = await _db.getLessonsForRange(start, end);

    final slots = <CourtSlot>[];

    for (final court in courts) {
      var slotStart = start;
      while (slotStart.isBefore(end)) {
        final slotEnd = slotStart.add(
          const Duration(minutes: AppConstants.slotDurationMinutes),
        );
        if (slotEnd.isAfter(end)) break;

        final block = blocks.where((b) =>
            b.courtId == court.id &&
            b.startTime.isBefore(slotEnd) &&
            b.endTime.isAfter(slotStart)).firstOrNull;

        if (block != null) {
          slots.add(CourtSlot(
            courtId: court.id,
            courtName: court.name,
            startTime: slotStart,
            endTime: slotEnd,
            status: SlotStatus.blocked,
            detail: block.reason ?? 'Kilitli',
            referenceId: block.id,
          ));
        } else {
          final lesson = lessons.where((l) =>
              l.courtId == court.id &&
              !l.isTemplate &&
              l.startTime.isBefore(slotEnd) &&
              l.endTime.isAfter(slotStart)).firstOrNull;

          if (lesson != null) {
            final coach = await _db.getUserById(lesson.coachId);
            slots.add(CourtSlot(
              courtId: court.id,
              courtName: court.name,
              startTime: slotStart,
              endTime: slotEnd,
              status: SlotStatus.lesson,
              detail: '${lesson.type == 'private' ? 'Özel' : 'Grup'} ders - ${coach?.name ?? ''}',
              referenceId: lesson.id,
            ));
          } else {
            final rental = rentals.where((r) =>
                r.courtId == court.id &&
                r.startTime.isBefore(slotEnd) &&
                r.endTime.isAfter(slotStart)).firstOrNull;

            if (rental != null) {
              final athlete = await _db.getUserById(rental.athleteId);
              slots.add(CourtSlot(
                courtId: court.id,
                courtName: court.name,
                startTime: slotStart,
                endTime: slotEnd,
                status: SlotStatus.rental,
                detail: 'Kiralama - ${athlete?.name ?? ''}',
                referenceId: rental.id,
              ));
            } else {
              slots.add(CourtSlot(
                courtId: court.id,
                courtName: court.name,
                startTime: slotStart,
                endTime: slotEnd,
                status: SlotStatus.available,
              ));
            }
          }
        }

        slotStart = slotEnd;
      }
    }

    return slots;
  }

  Future<bool> isCourtAvailable(
    String courtId,
    DateTime start,
    DateTime end, {
    String? excludeLessonId,
  }) async {
    final blocks = await _db.getBlocksForRange(start, end);
    if (blocks.any((b) =>
        b.courtId == courtId && b.startTime.isBefore(end) && b.endTime.isAfter(start))) {
      return false;
    }

    final rentals = await _db.getRentalsForRange(start, end);
    if (rentals.any((r) =>
        r.courtId == courtId && r.startTime.isBefore(end) && r.endTime.isAfter(start))) {
      return false;
    }

    final lessons = await _db.getLessonsForRange(start, end);
    return !lessons.any((l) =>
        l.courtId == courtId &&
        !l.isTemplate &&
        l.id != excludeLessonId &&
        l.startTime.isBefore(end) &&
        l.endTime.isAfter(start));
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}

final courtAvailabilityServiceProvider = Provider<CourtAvailabilityService>((ref) {
  return CourtAvailabilityService(ref.watch(databaseProvider));
});

class AuthState {
  const AuthState({this.user});

  final User? user;

  bool get isLoggedIn => user != null;

  UserRole? get role =>
      user != null ? UserRole.fromString(user!.role) : null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._db) : super(const AuthState());

  final AppDatabase _db;

  Future<String?> login(String email, String password) async {
    final user = await _db.getUserByEmail(email.trim().toLowerCase());
    if (user == null || user.password != password) {
      return 'E-posta veya şifre hatalı';
    }
    state = AuthState(user: user);
    return null;
  }

  void logout() => state = const AuthState();
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(databaseProvider));
});
