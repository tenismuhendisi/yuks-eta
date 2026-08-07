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
    this.coachId,
    this.coachName,
    this.lessonType,
    this.lessonTitle,
    this.participantInitials,
  });

  final String courtId;
  final String courtName;
  final DateTime startTime;
  final DateTime endTime;
  final SlotStatus status;
  final String? detail;
  final String? referenceId;
  final String? coachId;
  final String? coachName;
  /// 'group' | 'private'
  final String? lessonType;
  final String? lessonTitle;
  /// Özel ders: "EK·BY"
  final String? participantInitials;

  bool get isGroupLesson => status == SlotStatus.lesson && lessonType == 'group';
  bool get isPrivateLesson => status == SlotStatus.lesson && lessonType == 'private';

  /// Üst satır: Ç15 / Y22 veya öğrenci baş harfleri.
  String? get primaryLabel {
    if (isGroupLesson) {
      final t = lessonTitle?.trim();
      if (t == null || t.isEmpty) return null;
      final lower = t.toLowerCase();
      if (lower.startsWith('ço-') || lower.startsWith('co-')) {
        return 'Ç${t.split('-').last}';
      }
      if (lower.startsWith('yet-')) {
        return 'Y${t.split('-').last}';
      }
      return t;
    }
    if (isPrivateLesson) return participantInitials;
    return null;
  }

  /// Alt satır: antrenör adı.
  String? get secondaryLabel =>
      status == SlotStatus.lesson ? coachName : null;
}

class CourtAvailabilityService {
  CourtAvailabilityService(this._db);

  final AppDatabase _db;

  Future<List<CourtSlot>> getSlotsForDay(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day, AppConstants.calendarStartHour);
    final end = DateTime(day.year, day.month, day.day, AppConstants.calendarEndHour);
    return _buildSlots(rangeStart: start, rangeEnd: end, days: [DateTime(day.year, day.month, day.day)]);
  }

  /// Pazartesi–Pazar: tüm gün × kort × saat slotları.
  Future<List<CourtSlot>> getSlotsForWeek(DateTime weekStartMonday) async {
    final monday = DateTime(weekStartMonday.year, weekStartMonday.month, weekStartMonday.day);
    final days = List.generate(7, (i) => monday.add(Duration(days: i)));
    final rangeStart = DateTime(monday.year, monday.month, monday.day, AppConstants.calendarStartHour);
    final sunday = days.last;
    final rangeEnd = DateTime(sunday.year, sunday.month, sunday.day, AppConstants.calendarEndHour);
    return _buildSlots(rangeStart: rangeStart, rangeEnd: rangeEnd, days: days);
  }

  Future<List<CourtSlot>> _buildSlots({
    required DateTime rangeStart,
    required DateTime rangeEnd,
    required List<DateTime> days,
  }) async {
    final courts = await _db.getActiveCourts();
    final blocks = await _db.getBlocksForRange(rangeStart, rangeEnd);
    final rentals = await _db.getRentalsForRange(rangeStart, rangeEnd);
    final lessons = await _db.getLessonsForRange(rangeStart, rangeEnd);

    final coaches = <String, User>{};
    for (final id in lessons.map((l) => l.coachId).toSet()) {
      final u = await _db.getUserById(id);
      if (u != null) coaches[id] = u;
    }

    final privateLessonIds = lessons
        .where((l) => !l.isTemplate && l.type == 'private' && l.status != 'tentative')
        .map((l) => l.id)
        .toList();
    final allParts = await _db.getParticipantsForLessons(privateLessonIds);
    final userIds = allParts.map((p) => p.userId).toSet();
    final usersById = <String, User>{};
    for (final id in {...userIds, ...rentals.map((r) => r.athleteId)}) {
      final u = await _db.getUserById(id);
      if (u != null) usersById[id] = u;
    }
    final initialsByLesson = <String, String>{};
    final partsByLesson = <String, List<LessonParticipant>>{};
    for (final p in allParts) {
      partsByLesson.putIfAbsent(p.lessonId, () => []).add(p);
    }
    for (final entry in partsByLesson.entries) {
      final initials = entry.value
          .map((p) => _nameInitials(usersById[p.userId]?.name ?? ''))
          .where((s) => s.isNotEmpty)
          .join('·');
      initialsByLesson[entry.key] = initials;
    }

    // O(1) arama: courtId|yyyy-m-d|hour
    String key(String courtId, DateTime start) =>
        '$courtId|${start.year}-${start.month}-${start.day}|${start.hour}';

    final blockByKey = <String, CourtBlock>{};
    for (final b in blocks) {
      var t = b.startTime;
      while (t.isBefore(b.endTime)) {
        blockByKey.putIfAbsent(key(b.courtId, t), () => b);
        t = t.add(const Duration(minutes: AppConstants.slotDurationMinutes));
      }
    }

    final lessonByKey = <String, Lesson>{};
    for (final l in lessons) {
      if (l.isTemplate || l.courtId == null || l.status == 'tentative') continue;
      var t = l.startTime;
      while (t.isBefore(l.endTime)) {
        lessonByKey.putIfAbsent(key(l.courtId!, t), () => l);
        t = t.add(const Duration(minutes: AppConstants.slotDurationMinutes));
      }
    }

    final rentalByKey = <String, CourtRental>{};
    for (final r in rentals) {
      var t = r.startTime;
      while (t.isBefore(r.endTime)) {
        rentalByKey.putIfAbsent(key(r.courtId, t), () => r);
        t = t.add(const Duration(minutes: AppConstants.slotDurationMinutes));
      }
    }

    final slots = <CourtSlot>[];

    for (final day in days) {
      final dayStart = DateTime(day.year, day.month, day.day, AppConstants.calendarStartHour);
      final dayEnd = DateTime(day.year, day.month, day.day, AppConstants.calendarEndHour);

      for (final court in courts) {
        var slotStart = dayStart;
        while (slotStart.isBefore(dayEnd)) {
          final slotEnd = slotStart.add(
            const Duration(minutes: AppConstants.slotDurationMinutes),
          );
          if (slotEnd.isAfter(dayEnd)) break;

          final k = key(court.id, slotStart);
          final block = blockByKey[k];

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
            final lesson = lessonByKey[k];
            if (lesson != null) {
              final coach = coaches[lesson.coachId];
              slots.add(CourtSlot(
                courtId: court.id,
                courtName: court.name,
                startTime: slotStart,
                endTime: slotEnd,
                status: SlotStatus.lesson,
                detail: coach?.name,
                referenceId: lesson.id,
                coachId: lesson.coachId,
                coachName: coach?.name,
                lessonType: lesson.type,
                lessonTitle: lesson.title,
                participantInitials: lesson.type == 'private'
                    ? initialsByLesson[lesson.id]
                    : null,
              ));
            } else {
              final rental = rentalByKey[k];
              if (rental != null) {
                final athlete = usersById[rental.athleteId];
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
    }

    return slots;
  }

  static String _nameInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    String ch(String s) => String.fromCharCodes([s.runes.first]).toUpperCase();
    if (parts.length == 1) return ch(parts.first);
    return '${ch(parts.first)}${ch(parts.last)}';
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
        l.status != 'tentative' &&
        l.id != excludeLessonId &&
        l.startTime.isBefore(end) &&
        l.endTime.isAfter(start));
  }

  /// Verilen saat aralığında müsait kortlar.
  Future<List<Court>> getAvailableCourts(
    DateTime start,
    DateTime end, {
    String? excludeLessonId,
  }) async {
    final courts = await _db.getActiveCourts();
    final free = <Court>[];
    for (final court in courts) {
      if (await isCourtAvailable(
        court.id,
        start,
        end,
        excludeLessonId: excludeLessonId,
      )) {
        free.add(court);
      }
    }
    return free;
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
