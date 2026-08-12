import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/ball_level.dart';
import 'package:crm_app/core/utils/email_from_name.dart';
import 'package:crm_app/core/utils/student_notes.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Akademi seed: 7 antrenör, grup (ço/yet/alt/gö/yaz/luna/te/performans) + özel dersler.
class SeedData {
  static const _uuid = Uuid();

  static DateTime _mondayOf(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    return day.subtract(Duration(days: day.weekday - DateTime.monday));
  }

  static DateTime _at(DateTime monday, int weekday, int hour) {
    final day = monday.add(Duration(days: weekday - DateTime.monday));
    return DateTime(day.year, day.month, day.day, hour);
  }

  static Future<void> seed(AppDatabase db) async {
    await _seedBaseUsersAndCourts(db);
    await seedAcademyRoster(db);
    await seedMemberCredits(db);
    await seedExtraDemoGroups(db);
    await syncPrivateFocusNotes(db);
    await syncPrivateLessonBallLevels(db);
    await seedGeneralPlan(db);
    await seedYukselRealisticPeople(db);
    await seedCurrentPlanFromGeneralPlan(db, replace: true);
  }

  static Future<void> _seedBaseUsersAndCourts(AppDatabase db) async {
    const adminId = 'admin-001';
    const parent1Id = 'parent-001';

    await db.batch((batch) {
      batch.insertAll(db.users, [
        UsersCompanion.insert(
          id: adminId,
          name: 'Yönetici',
          email: 'admin@eta.com',
          password: 'admin123',
          role: 'admin',
          createdAt: DateTime.now(),
        ),
        UsersCompanion.insert(
          id: parent1Id,
          name: 'Ayşe Yılmaz',
          email: 'mehmet@eta.com',
          password: 'veli123',
          role: 'parent',
          phone: const Value('0555 123 4567'),
          createdAt: DateTime.now(),
        ),
      ]);

      batch.insertAll(db.courts, [
        CourtsCompanion.insert(id: 'court-001', name: 'SÖ1', sortOrder: const Value(1)),
        CourtsCompanion.insert(id: 'court-002', name: 'SÖ2', sortOrder: const Value(2)),
        CourtsCompanion.insert(id: 'court-003', name: 'SÖ3', sortOrder: const Value(3)),
        CourtsCompanion.insert(id: 'court-004', name: 'SÖ4', sortOrder: const Value(4)),
        CourtsCompanion.insert(id: 'court-005', name: 'KO1', sortOrder: const Value(5)),
        CourtsCompanion.insert(id: 'court-006', name: 'KO2', sortOrder: const Value(6)),
      ]);
    });
  }

  /// Kort isimleri + Genel Plan (Söğütönü tahta programı + KO örnekleri).
  static Future<void> seedGeneralPlan(
    AppDatabase db, {
    bool replace = false,
  }) async {
    const names = {
      'court-001': 'SÖ1',
      'court-002': 'SÖ2',
      'court-003': 'SÖ3',
      'court-004': 'SÖ4',
      'court-005': 'KO1',
      'court-006': 'KO2',
    };
    for (final e in names.entries) {
      final order = int.tryParse(e.key.split('-').last) ?? 0;
      await db.updateCourt(
        e.key,
        CourtsCompanion(
          name: Value(e.value),
          sortOrder: Value(order),
          isActive: const Value(true),
        ),
      );
    }

    if (replace) {
      await db.delete(db.weeklyCourtRights).go();
    } else {
      final existing = await db.getWeeklyCourtRights();
      if (existing.isNotEmpty) return;
    }

    const elifA = 'coach-yasir';
    const elifB = 'coach-elizt';
    const yasin = 'coach-eliza';
    const gorkem = 'coach-gurkan';
    const alperen = 'coach-dogukan';
    const yuksel = 'coach-alper';
    const dogan = 'coach-yucel';

    // Tahta: EKOS=SÖ1, TEPE=SÖ2, ÇETİN=SÖ3
    const so1 = 'court-001';
    const so2 = 'court-002';
    const so3 = 'court-003';
    const so4 = 'court-004';
    const ko1 = 'court-005';
    const ko2 = 'court-006';

    final rows = <WeeklyCourtRightsCompanion>[];
    void put(int day, String court, int hour, String coach, [String? label]) {
      rows.add(WeeklyCourtRightsCompanion.insert(
        id: 'wcr-$day-$court-$hour',
        weekday: day,
        courtId: court,
        hour: hour,
        coachId: Value(coach),
        label: Value(label),
        updatedAt: DateTime.now(),
      ));
    }

    void putRange(
      int day,
      String court,
      int startHour,
      int endHourExclusive,
      String coach, [
      String? label,
    ]) {
      for (var h = startHour; h < endHourExclusive; h++) {
        put(day, court, h, coach, label);
      }
    }

    // ——— PAZARTESİ ———
    put(1, so1, 8, yasin, 'Gubse');
    putRange(1, so1, 9, 11, yasin, 'Alt-1');
    put(1, so1, 11, elifA, 'Yaz Okulu');
    put(1, so1, 12, alperen, 'Yaz Okulu 2');
    put(1, so1, 13, alperen, 'Duru');
    put(1, so1, 17, yasin, 'GÖ-31');
    put(1, so1, 18, alperen, 'GÖ-3');
    put(1, so1, 19, elifB, 'Yet-43');
    put(1, so1, 20, elifB, 'Yet-3');
    put(1, so1, 21, gorkem, 'Yet-30');

    putRange(1, so2, 8, 10, elifA, 'Luna');
    put(1, so2, 11, alperen, 'Yaz Okulu');
    put(1, so2, 12, elifB, 'Yaz Okulu 2');
    put(1, so2, 14, elifB, 'Algan');
    put(1, so2, 16, elifB, 'GÖ-17');
    put(1, so2, 17, gorkem, 'Alt-3');
    put(1, so2, 18, yasin, 'GÖ-31');
    put(1, so2, 19, yasin, 'Yet-51');
    put(1, so2, 20, gorkem, 'Yet-46');
    put(1, so2, 21, alperen, 'Yet-5');

    putRange(1, so3, 9, 11, gorkem, 'Performans');
    putRange(1, so3, 15, 18, gorkem, 'Alt-3');
    put(1, so3, 18, elifB, 'GÖ-26');
    put(1, so3, 19, alperen, 'Yet-34');
    put(1, so3, 20, yasin, 'Yet-48');
    put(1, so3, 21, elifB, 'Yet-54');

    // ——— SALI ———
    put(2, so1, 9, yasin, 'Artun');
    put(2, so1, 10, yasin, 'Alt-1');
    put(2, so1, 11, yasin, 'Doruk');
    put(2, so1, 14, elifB, 'Alya');
    put(2, so1, 15, elifB, 'Atılım');
    put(2, so1, 16, alperen, 'GÖ-25');
    put(2, so1, 17, alperen, 'GÖ-12');
    put(2, so1, 18, elifA, 'GÖ-33');
    put(2, so1, 19, alperen, 'Yet-20');
    put(2, so1, 20, alperen, 'Yet-6');
    put(2, so1, 21, elifB, 'Yet-4');

    putRange(2, so2, 8, 10, elifA, 'Luna');
    put(2, so2, 11, elifA, 'Küçük Şeyler');
    put(2, so2, 12, elifA, 'Işık');
    put(2, so2, 14, elifA, '1 pct');
    put(2, so2, 15, elifA, 'Uras');
    put(2, so2, 16, elifB, 'Yenice');
    put(2, so2, 17, gorkem, 'Alt-7');
    put(2, so2, 18, gorkem, 'Yet-18');
    put(2, so2, 19, elifB, 'Yet-12');
    put(2, so2, 20, elifB, 'Yet-41');

    putRange(2, so3, 9, 11, gorkem, 'Performans');
    putRange(2, so3, 16, 19, gorkem, 'Alt-3');
    put(2, so3, 19, elifB, 'Yet-36');
    put(2, so3, 20, gorkem, 'Yet-52');
    put(2, so3, 21, elifA, 'Yet-50');

    // ——— ÇARŞAMBA ———
    put(3, so1, 8, yasin, 'Gubse');
    putRange(3, so1, 9, 11, yasin, 'Alt-1');
    put(3, so1, 11, elifA, 'Yaz Okulu');
    put(3, so1, 16, elifA, 'Yağmur');
    put(3, so1, 17, elifA, 'Mila');
    put(3, so1, 18, alperen, 'GÖ-3');
    put(3, so1, 19, yasin, 'Yet-45');
    put(3, so1, 20, elifA, 'Yet-7');
    put(3, so1, 21, gorkem, 'Yet-30');

    putRange(3, so2, 8, 10, elifA, 'Luna');
    put(3, so2, 14, elifA, 'Uras');
    put(3, so2, 15, gorkem, 'Buğra');
    put(3, so2, 16, elifB, 'GÖ-17');
    put(3, so2, 17, gorkem, 'Alt-7');
    put(3, so2, 18, yasin, 'GÖ-31');
    put(3, so2, 19, elifB, 'Yet-43');
    put(3, so2, 20, gorkem, 'Yet-46');
    put(3, so2, 21, yasin, 'Yet-51');

    putRange(3, so3, 9, 11, gorkem, 'Performans');
    put(3, so3, 14, gorkem, 'Seher');
    put(3, so3, 15, elifB, 'Yet-2');
    putRange(3, so3, 16, 18, gorkem, 'Alt-3');
    put(3, so3, 18, elifB, 'GÖ-26');
    put(3, so3, 19, alperen, 'Yet-34');
    put(3, so3, 20, elifB, 'Yet-3');
    put(3, so3, 21, yasin, 'Yet-8');

    // ——— PERŞEMBE ———
    putRange(4, so1, 8, 10, yasin, 'Alper');
    put(4, so1, 10, yasin, 'Alt-1');
    put(4, so1, 11, yasin, 'Doruk');
    putRange(4, so1, 12, 14, elifB);
    put(4, so1, 14, elifB, 'Yenice');
    put(4, so1, 15, elifB, 'Asya');
    put(4, so1, 16, alperen, 'GÖ-25');
    put(4, so1, 17, alperen, 'GÖ-12');
    put(4, so1, 18, elifA, 'GÖ-33');
    put(4, so1, 19, alperen, 'Yet-20');
    put(4, so1, 20, alperen, 'Yet-6');
    put(4, so1, 21, alperen, 'Yet-5');

    putRange(4, so2, 8, 10, elifA, 'Luna');
    put(4, so2, 11, elifA, 'Melis');
    put(4, so2, 15, gorkem, 'Asu');
    put(4, so2, 16, elifB, 'Zeynep');
    put(4, so2, 17, gorkem, 'Alt-7');
    put(4, so2, 18, yasin, 'GÖ-31');
    put(4, so2, 19, gorkem, 'Yet-18');
    put(4, so2, 20, elifB, 'Yet-12');
    put(4, so2, 21, elifA, 'Yet-4');

    putRange(4, so3, 9, 11, gorkem, 'Performans');
    putRange(4, so3, 16, 18, gorkem, 'Alt-3');
    put(4, so3, 18, elifB, 'Yet-36');
    put(4, so3, 19, yasin, 'Yet-48');
    put(4, so3, 20, gorkem, 'Yet-52');

    // ——— CUMA ———
    put(5, so1, 8, yasin, 'Gönül');
    putRange(5, so1, 9, 11, yasin, 'Alt-1');
    put(5, so1, 11, elifA, 'Yaz Okulu');
    put(5, so1, 12, alperen, 'Yaz Okulu 2');
    put(5, so1, 13, alperen, 'Duru');
    put(5, so1, 14, elifB, 'Rüzgar');
    put(5, so1, 15, yasin, 'Ege');
    put(5, so1, 16, yasin, 'GÖ-31');
    put(5, so1, 17, elifA, 'Buse');
    put(5, so1, 18, yasin, 'Yet-45');
    put(5, so1, 19, elifA, 'Yet-50');
    put(5, so1, 20, elifA, 'Yet-41');

    putRange(5, so2, 8, 10, elifA, 'Luna');
    put(5, so2, 11, alperen, 'Yaz Okulu');
    put(5, so2, 12, elifB, 'Yaz Okulu 2');
    put(5, so2, 14, gorkem, 'Hasan');
    put(5, so2, 15, elifB, 'Yet-2');
    put(5, so2, 16, elifB);
    put(5, so2, 17, gorkem, 'Alt-7');
    put(5, so2, 18, yasin, 'GÖ-31');
    put(5, so2, 19, elifA, 'Yet-7');
    put(5, so2, 20, yasin, 'Yet-8');
    put(5, so2, 21, elifB, 'Yet-54');

    putRange(5, so3, 9, 11, gorkem, 'Performans');
    put(5, so3, 13, elifB);
    put(5, so3, 17, gorkem, 'Alt-3');
    put(5, so3, 18, alperen, 'Jan');
    put(5, so3, 19, alperen, 'Burak');
    put(5, so3, 20, alperen, 'Kaya');

    // ——— CUMARTESİ ———
    put(6, so1, 9, elifB);
    put(6, so1, 10, elifB, 'Doğa');
    put(6, so1, 15, gorkem, 'Buğra');
    put(6, so1, 16, gorkem, 'Pelin');
    put(6, so1, 17, gorkem, 'Asu');
    put(6, so1, 18, gorkem, 'Seher');
    put(6, so1, 19, gorkem, 'Deniz');
    put(6, so1, 20, gorkem, 'Davut');
    put(6, so1, 21, gorkem, 'Zeynep');

    put(6, so2, 9, elifA, 'İpek');
    put(6, so2, 10, elifA, 'TE-2');
    put(6, so2, 12, elifA, 'TE-1');
    put(6, so2, 16, elifA, 'Mila');
    put(6, so2, 17, elifA, 'Ada');
    put(6, so2, 18, elifA, 'Buse');
    put(6, so2, 19, elifA, 'Serap');
    put(6, so2, 20, elifA, 'İrem');

    put(6, so3, 16, elifB, 'Birhan');
    putRange(6, so3, 17, 21, elifB, 'Yet');

    // SÖ4 — seyrek örnek
    put(1, so4, 17, gorkem, 'Alt-3');
    put(1, so4, 18, alperen, 'Yet-5');
    put(3, so4, 18, elifA, 'GÖ-33');
    put(5, so4, 10, elifB, 'Yaz Okulu');

    // KO1 — Yüksel D (tam program)
    // Pazartesi
    put(1, ko1, 10, yuksel, 'Asay Anaokulu');
    put(1, ko1, 19, yuksel, 'Yet-2');
    put(1, ko1, 20, yuksel, 'Yet-18');
    put(1, ko1, 21, yuksel, 'Yet-6');
    put(1, ko1, 22, yuksel, 'Hazal-Simge-Yaren');
    // Salı
    put(2, ko1, 11, yuksel, 'Yaz Okulu');
    put(2, ko1, 12, yuksel, 'Yaz Okulu');
    put(2, ko1, 19, yuksel, 'Yet-3');
    put(2, ko1, 20, yuksel, 'Yet-4');
    put(2, ko1, 21, yuksel, 'Veli');
    put(2, ko1, 22, yuksel, 'Mert-Alper');
    // Çarşamba
    put(3, ko1, 18, yuksel, 'Serra');
    put(3, ko1, 19, yuksel, 'Yet-2');
    put(3, ko1, 20, yuksel, 'Yet-18');
    put(3, ko1, 21, yuksel, 'Yet-6');
    put(3, ko1, 22, yuksel, 'Hazal-Simge-Yaren');
    // Perşembe
    put(4, ko1, 9, yuksel, 'Karacapark Anaokulu');
    put(4, ko1, 10, yuksel, 'TE Yaz Okulu');
    put(4, ko1, 11, yuksel, 'Yaz Okulu');
    put(4, ko1, 12, yuksel, 'Yaz Okulu');
    put(4, ko1, 19, yuksel, 'Yet-3');
    put(4, ko1, 20, yuksel, 'Esma-Sevil');
    put(4, ko1, 21, yuksel, 'Yet-4');
    put(4, ko1, 22, yuksel, 'Mert-Alper');
    // Cumartesi
    put(6, ko1, 9, yuksel, 'Sıla');
    put(6, ko1, 10, yuksel, 'Damla-Bahadır');
    put(6, ko1, 18, yuksel, 'Yet-1');
    put(6, ko1, 19, yuksel, 'Gizem');
    put(6, ko1, 20, yuksel, 'Fatma Baltacı');
    put(6, ko1, 21, yuksel, 'Deniz-Bahar');
    // Pazar
    put(7, ko1, 9, yuksel, 'Sıla');
    put(7, ko1, 18, yuksel, 'Yet-1');
    put(7, ko1, 20, yuksel, 'Fatma-Özge');
    put(7, ko1, 21, yuksel, 'Deniz-Bahar');

    // KO2 — Doğan S (Yüksel ile çakışma yok)
    for (final day in [1, 3, 5]) {
      put(day, ko2, 18, dogan);
      put(day, ko2, 19, dogan);
    }

    await db.batch((batch) {
      batch.insertAll(db.weeklyCourtRights, rows, mode: InsertMode.insertOrIgnore);
    });
  }

  /// Genel plan haklarını güncel plana (confirmed ders) olarak yazar.
  ///
  /// Ardışık aynı antrenör/kort/etiket saatleri tek derste birleştirilir.
  static Future<void> seedCurrentPlanFromGeneralPlan(
    AppDatabase db, {
    bool replace = false,
  }) async {
    final rights = await db.getWeeklyCourtRights();
    final claimed = rights.where((r) => r.coachId != null && r.coachId!.isNotEmpty).toList();
    if (claimed.isEmpty) return;

    if (!replace) {
      final existing = await (db.select(db.lessons)
            ..where((l) => l.id.like('les-gp-%'))
            ..limit(1))
          .get();
      if (existing.isNotEmpty) return;
    }

    await db.delete(db.lessonAttendances).go();
    await db.delete(db.lessonParticipants).go();
    await db.delete(db.lessons).go();

    // coachId|code → sporcular (grup)
    // coachId|özel-slot → sporcular (özel ders başlığı)
    final profiles = await db.select(db.studentProfiles).get();
    final athletesByCoachGroup = <String, List<String>>{};
    final athletesByCoachPrivate = <String, List<String>>{};
    for (final p in profiles) {
      final group = StudentNotes.groupCode(p.notes);
      if (group != null && group.isNotEmpty) {
        final key = '${p.coachId}|${group.toLowerCase()}';
        athletesByCoachGroup.putIfAbsent(key, () => []).add(p.userId);
      }
      final privateSlot = _privateSlotFromNotes(p.notes);
      if (privateSlot != null) {
        final key = '${p.coachId}|$privateSlot';
        athletesByCoachPrivate.putIfAbsent(key, () => []).add(p.userId);
      }
    }

    final thisMonday = _mondayOf(DateTime.now());
    final mondays = [
      thisMonday.subtract(const Duration(days: 7)),
      thisMonday,
      thisMonday.add(const Duration(days: 7)),
    ];

    // weekday|court|coach|label → sorted hours
    final buckets = <String, List<int>>{};
    final meta = <String, WeeklyCourtRight>{};
    for (final r in claimed) {
      final label = (r.label ?? '').trim();
      final key = '${r.weekday}|${r.courtId}|${r.coachId}|$label';
      buckets.putIfAbsent(key, () => []).add(r.hour);
      meta.putIfAbsent(key, () => r);
    }

    final lessons = <LessonsCompanion>[];
    final participants = <LessonParticipantsCompanion>[];
    final attendances = <LessonAttendancesCompanion>[];

    for (final e in buckets.entries) {
      final hours = [...e.value]..sort();
      final r = meta[e.key]!;
      final coachId = r.coachId!;
      final label = (r.label ?? '').trim();

      // Ardışık saatleri birleştir
      var i = 0;
      while (i < hours.length) {
        final startHour = hours[i];
        var endHour = startHour + 1;
        var j = i + 1;
        while (j < hours.length && hours[j] == endHour) {
          endHour++;
          j++;
        }
        i = j;

        for (final monday in mondays) {
          final start = _at(monday, r.weekday, startHour);
          final end = _at(monday, r.weekday, endHour);
          // Pazar: weekday 7 — _at uses DateTime weekday; Monday=1 ... Sunday=7
          // Our _at: monday.add(weekday - DateTime.monday) — DateTime.sunday is 7, DateTime.monday is 1
          // So weekday 7 → monday+6 = Sunday. Good.

          final lessonId =
              'les-gp-${r.weekday}-${r.courtId}-$startHour-$endHour-${monday.year}${monday.month.toString().padLeft(2, '0')}${monday.day.toString().padLeft(2, '0')}-$coachId';

          final isGroup = _labelLooksLikeGroup(label);
          final title = label.isEmpty ? (isGroup ? 'Grup' : 'Özel') : label;
          final privateKey = turkishLower(title.replaceAll(RegExp(r'\s+'), '-'));
          final groupKey = '$coachId|${title.toLowerCase()}';
          final privateAids = athletesByCoachPrivate['$coachId|$privateKey'] ?? const <String>[];
          final groupAids = athletesByCoachGroup[groupKey] ?? const <String>[];
          final maxP = isGroup
              ? (groupAids.isNotEmpty ? groupAids.length : 5)
              : (privateAids.isNotEmpty
                  ? privateAids.length
                  : _privateTitleParticipantCount(title));

          lessons.add(LessonsCompanion.insert(
            id: lessonId,
            coachId: coachId,
            courtId: Value(r.courtId),
            type: isGroup ? 'group' : 'private',
            startTime: start,
            endTime: end,
            maxParticipants: Value(maxP),
            isTemplate: const Value(false),
            status: const Value('confirmed'),
            title: Value(
              isGroup
                  ? title
                  : turkishLower(title.replaceAll(RegExp(r'\s+'), '-')),
            ),
            notes: Value(isGroup ? 'Genel plandan' : 'Özel ders'),
          ));

          final aids = isGroup ? groupAids : privateAids;
          for (final aid in aids.take(maxP)) {
            participants.add(LessonParticipantsCompanion.insert(
              id: _uuid.v4(),
              lessonId: lessonId,
              userId: aid,
            ));
          }
          if (monday == mondays.first && aids.isNotEmpty && isGroup) {
            final takeAids = aids.take(maxP).toList();
            for (var ai = 0; ai < takeAids.length; ai++) {
              final aid = takeAids[ai];
              final status = switch (ai % 4) {
                0 => 'present',
                1 => 'present',
                2 => 'late',
                _ => 'absent',
              };
              attendances.add(LessonAttendancesCompanion.insert(
                id: 'att-$lessonId-$aid',
                lessonId: lessonId,
                userId: aid,
                status: status,
                markedAt: start.add(const Duration(minutes: 5)),
                markedById: coachId,
              ));
            }
          }
        }
      }
    }

    await db.batch((batch) {
      batch.insertAll(db.lessons, lessons, mode: InsertMode.insertOrReplace);
      if (participants.isNotEmpty) {
        batch.insertAll(db.lessonParticipants, participants, mode: InsertMode.insertOrIgnore);
      }
      if (attendances.isNotEmpty) {
        batch.insertAll(db.lessonAttendances, attendances, mode: InsertMode.insertOrIgnore);
      }
    });
  }

  static String? _privateSlotFromNotes(String? notes) {
    if (notes == null || notes.isEmpty) return null;
    final m = RegExp(r'Özel:\s*([^\s,;]+)', caseSensitive: false).firstMatch(notes);
    return m?.group(1)?.toLowerCase();
  }

  /// Yüksel D — gerçek isimli grup/özel sporcular.
  static Future<void> seedYukselRealisticPeople(AppDatabase db) async {
    const coachId = 'coach-alper';
    final coach = await db.getUserById(coachId);
    if (coach == null) return;

    final users = <UsersCompanion>[];
    final profiles = <StudentProfilesCompanion>[];
    final usedIds = <String>{};

    String slug(String name) {
      final s = emailFromPersonName(name).split('@').first;
      return s.replaceAll('.', '-');
    }

    void addPerson({
      required String id,
      required String fullName,
      required String notes,
      required int age,
      required String level,
    }) {
      if (usedIds.contains(id)) return;
      usedIds.add(id);
      users.add(UsersCompanion.insert(
        id: id,
        name: fullName,
        email: emailFromPersonName('$fullName $id'),
        password: 'sporcu123',
        role: 'athlete',
        createdAt: DateTime.now(),
      ));
      profiles.add(StudentProfilesCompanion.insert(
        userId: id,
        coachId: coachId,
        age: Value(age),
        level: Value(level),
        notes: Value(notes),
        updatedAt: DateTime.now(),
      ));
    }

    for (final e in _yukselGroupMembers.entries) {
      final code = e.key;
      final isChild = _groupCodeLooksChild(code);
      for (var i = 0; i < e.value.length; i++) {
        final first = e.value[i];
        final id = 'athlete-yd-g-${slug(code)}-${slug(first)}';
        addPerson(
          id: id,
          fullName: first.contains(' ') ? first : '$first Y.',
          notes: 'Grup: $code',
          age: isChild ? 10 + (i % 5) : 18 + (i % 10),
          level: isChild ? BallLevel.orange.label : BallLevel.yellow.label,
        );
      }
    }

    for (final e in _yukselPrivateMembers.entries) {
      final slot = e.key;
      for (var i = 0; i < e.value.length; i++) {
        final person = e.value[i];
        final id = 'athlete-yd-p-${slug(slot)}-${slug(person)}';
        addPerson(
          id: id,
          fullName: person.contains(' ') ? person : '$person Y.',
          notes: 'Özel: $slot',
          age: 14 + (i % 8),
          level: BallLevel.green.label,
        );
      }
    }

    await db.batch((batch) {
      batch.insertAll(db.users, users, mode: InsertMode.insertOrReplace);
      batch.insertAll(db.studentProfiles, profiles, mode: InsertMode.insertOrReplace);
    });
  }

  static bool _labelLooksLikeGroup(String label) {
    if (label.isEmpty) return true; // etiketsiz hak → grup varsay
    final c = label.toLowerCase();
    if (c.contains('anaokulu') ||
        c.contains('yaz') ||
        c.contains('luna') ||
        c.contains('performans') ||
        c.contains('asay') ||
        c.contains('karacapark')) {
      return true;
    }
    if (c.startsWith('ço') ||
        c.startsWith('co-') ||
        c.startsWith('gö') ||
        c.startsWith('go-') ||
        c.startsWith('yet') ||
        c.startsWith('alt') ||
        c.startsWith('te')) {
      return true;
    }
    // "Emin-Cenk", "Serra", "Veli" → özel
    return false;
  }

  static int _privateTitleParticipantCount(String title) {
    final parts = title
        .split(RegExp(r'[-/+,]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.length <= 1) return 1;
    return parts.length.clamp(1, 3);
  }

  /// Mevcut sporcuların seviye/e-posta alanlarını ITF top + isim mailine çevirir.
  static Future<void> syncAthleteBallLevelsAndEmails(AppDatabase db) async {
    final athletes = await db.getUsersByRole('athlete');
    for (final u in athletes) {
      final email = emailFromPersonName(u.name);
      if (u.email != email) {
        await db.updateUser(u.id, UsersCompanion(email: Value(email)));
      }
    }

    final profiles = await db.select(db.studentProfiles).get();
    for (final p in profiles) {
      final normalized = BallLevel.normalizeLabel(p.level);
      if (p.level != normalized) {
        await db.upsertStudentProfile(StudentProfilesCompanion(
          userId: Value(p.userId),
          coachId: Value(p.coachId),
          age: Value(p.age),
          level: Value(normalized),
          notes: Value(p.notes),
          updatedAt: Value(DateTime.now()),
        ));
      }
    }
  }

  /// Antrenör ad/e-posta güncellemesi (mevcut DB için).
  static Future<void> syncCoachNames(AppDatabase db) async {
    for (final coach in _coaches) {
      await (db.update(db.users)..where((u) => u.id.equals(coach.id))).write(
        UsersCompanion(
          name: Value(coach.name),
          email: Value(coach.email),
          phone: Value(coach.phone),
        ),
      );
    }
  }

  /// Mevcut DB'ye (v2→v3) veya eksik roster için antrenör/ders seed.
  static Future<void> seedAcademyRoster(AppDatabase db) async {
    final existing = await db.getUserById(_coaches.first.id);
    if (existing != null) {
      await syncCoachNames(db);
      await syncAthleteBallLevelsAndEmails(db);
      return;
    }

    var courts = await db.getActiveCourts();
    if (courts.isEmpty) {
      await _seedBaseUsersAndCourts(db);
      courts = await db.getActiveCourts();
    }
    final courtIds = courts.map((c) => c.id).toList();

    final thisMonday = _mondayOf(DateTime.now());
    final lastMonday = thisMonday.subtract(const Duration(days: 7));
    final nextMonday = thisMonday.add(const Duration(days: 7));

    final users = <UsersCompanion>[];
    final profiles = <StudentProfilesCompanion>[];
    final parentLinks = <ParentAthleteLinksCompanion>[];
    final lessons = <LessonsCompanion>[];
    final participants = <LessonParticipantsCompanion>[];
    final attendances = <LessonAttendancesCompanion>[];

    var athleteSeq = 0;
    var nameIdx = 0;
    String nextAthleteId() => 'athlete-${(++athleteSeq).toString().padLeft(3, '0')}';
    String nextPersonName() {
      final name = _turkishNames[nameIdx % _turkishNames.length];
      nameIdx++;
      return name;
    }

    for (var ci = 0; ci < _coaches.length; ci++) {
      final coach = _coaches[ci];
      users.add(UsersCompanion.insert(
        id: coach.id,
        name: coach.name,
        email: coach.email,
        password: 'coach123',
        role: 'coach',
        phone: Value(coach.phone),
        createdAt: DateTime.now(),
      ));

      final schedule = _schedules[ci];
      final athleteIdsForCoach = <String>[];

      // --- Grup dersleri (ço/yet/alt/gö/yaz/luna/te/performans) ---
      for (final g in schedule.groups) {
        final code = g.code;
        final groupAthletes = <String>[];
        for (var i = 0; i < g.memberCount; i++) {
          final id = nextAthleteId();
          final personName = nextPersonName();
          groupAthletes.add(id);
          athleteIdsForCoach.add(id);
          final age = g.isChild ? 9 + (i % 5) : 20 + (i % 8);
          users.add(UsersCompanion.insert(
            id: id,
            name: personName,
            email: emailFromPersonName(personName),
            password: 'sporcu123',
            role: 'athlete',
            createdAt: DateTime.now(),
          ));
          profiles.add(StudentProfilesCompanion.insert(
            userId: id,
            coachId: coach.id,
            age: Value(age),
            level: Value(_ballLevelForAge(age)),
            notes: Value('Grup: $code'),
            updatedAt: DateTime.now(),
          ));
        }

        for (final weekday in g.weekdays) {
          for (final monday in [lastMonday, thisMonday, nextMonday]) {
            final safeCode = code.replaceAll(RegExp(r'[^a-zA-Z0-9\-]+'), '-');
            final lessonId =
                'les-${coach.id}-$safeCode-$weekday-${g.hour}-${monday.year}${monday.month}${monday.day}';
            final courtId = g.courtId ?? courtIds[(ci + weekday) % courtIds.length];
            final start = _at(monday, weekday, g.hour);
            lessons.add(LessonsCompanion.insert(
              id: lessonId,
              coachId: coach.id,
              courtId: Value(courtId),
              type: 'group',
              startTime: start,
              endTime: start.add(Duration(hours: g.durationHours)),
              maxParticipants: Value(g.memberCount),
              isTemplate: const Value(false),
              title: Value(code),
              notes: const Value('Haftalık grup dersi'),
            ));
            for (final aid in groupAthletes) {
              participants.add(LessonParticipantsCompanion.insert(
                id: _uuid.v4(),
                lessonId: lessonId,
                userId: aid,
              ));
            }

            if (monday == lastMonday) {
              for (var i = 0; i < groupAthletes.length; i++) {
                final status = switch (i % 4) {
                  0 => 'present',
                  1 => 'present',
                  2 => 'late',
                  _ => 'absent',
                };
                attendances.add(LessonAttendancesCompanion.insert(
                  id: 'att-$lessonId-${groupAthletes[i]}',
                  lessonId: lessonId,
                  userId: groupAthletes[i],
                  status: status,
                  markedAt: start.add(const Duration(minutes: 5)),
                  markedById: coach.id,
                ));
              }
            }
          }
        }
      }

      // --- 4 özel ders (yoklama yok); aynı dersteki herkes aynı top seviyesinde ---
      for (var pi = 0; pi < schedule.privates.length; pi++) {
        final p = schedule.privates[pi];
        final privateAthletes = <String>[];
        final privateFirstNames = <String>[];
        final sharedLevel = BallLevel.values[(ci + pi) % BallLevel.values.length];
        final sharedAge = switch (sharedLevel) {
          BallLevel.red => 9,
          BallLevel.orange => 11,
          BallLevel.green => 13,
          BallLevel.yellow => 17,
        };
        for (var i = 0; i < p.memberCount; i++) {
          final id = nextAthleteId();
          final personName = nextPersonName();
          privateAthletes.add(id);
          privateFirstNames.add(turkishLower(personName.split(' ').first));
          athleteIdsForCoach.add(id);
          users.add(UsersCompanion.insert(
            id: id,
            name: personName,
            email: emailFromPersonName(personName),
            password: 'sporcu123',
            role: 'athlete',
            createdAt: DateTime.now(),
          ));
          profiles.add(StudentProfilesCompanion.insert(
            userId: id,
            coachId: coach.id,
            age: Value(sharedAge),
            level: Value(sharedLevel.label),
            notes: Value('Özel ders ${p.memberCount} kişi'),
            updatedAt: DateTime.now(),
          ));
        }

        final title = p.title ?? privateFirstNames.join('-');

        for (final monday in [lastMonday, thisMonday, nextMonday]) {
          final lessonId =
              'les-${coach.id}-ozel-$pi-${monday.year}${monday.month}${monday.day}';
          final courtId = p.courtId ?? courtIds[(ci + pi) % courtIds.length];
          final start = _at(monday, p.weekday, p.hour);
          final focusNote = monday == lastMonday
              ? _privateFocusNotes[(ci + pi) % _privateFocusNotes.length]
              : null;
          lessons.add(LessonsCompanion.insert(
            id: lessonId,
            coachId: coach.id,
            courtId: Value(courtId),
            type: 'private',
            startTime: start,
            endTime: start.add(const Duration(hours: 1)),
            maxParticipants: Value(p.memberCount),
            isTemplate: const Value(false),
            title: Value(title),
            notes: Value(focusNote ?? 'Haftalık özel ders'),
          ));
          for (final aid in privateAthletes) {
            participants.add(LessonParticipantsCompanion.insert(
              id: _uuid.v4(),
              lessonId: lessonId,
              userId: aid,
            ));
          }
        }
      }

      // İlk antrenörün grup sporcularını veliye bağla
      if (ci == 0 && athleteIdsForCoach.isNotEmpty) {
        for (final aid in athleteIdsForCoach.take(4)) {
          parentLinks.add(ParentAthleteLinksCompanion.insert(
            parentId: 'parent-001',
            athleteId: aid,
          ));
        }
      }
    }

    // Demo sporcu / hızlı giriş
    users.add(UsersCompanion.insert(
      id: 'athlete-demo',
      name: 'Can Yılmaz',
      email: emailFromPersonName('Can Yılmaz'),
      password: 'sporcu123',
      role: 'athlete',
      phone: const Value('0544 777 8899'),
      creditBalance: const Value(20),
      createdAt: DateTime.now(),
    ));
    profiles.add(StudentProfilesCompanion.insert(
      userId: 'athlete-demo',
      coachId: _coaches.first.id,
      age: const Value(14),
      level: Value(BallLevel.green.label),
      updatedAt: DateTime.now(),
    ));
    parentLinks.add(ParentAthleteLinksCompanion.insert(
      parentId: 'parent-001',
      athleteId: 'athlete-demo',
    ));

    await db.batch((batch) {
      batch.insertAll(db.users, users, mode: InsertMode.insertOrIgnore);
      batch.insertAll(db.studentProfiles, profiles, mode: InsertMode.insertOrIgnore);
      batch.insertAll(db.parentAthleteLinks, parentLinks, mode: InsertMode.insertOrIgnore);
      batch.insertAll(db.lessons, lessons, mode: InsertMode.insertOrIgnore);
      batch.insertAll(db.lessonParticipants, participants, mode: InsertMode.insertOrIgnore);
      batch.insertAll(db.lessonAttendances, attendances, mode: InsertMode.insertOrIgnore);
    });
  }

  /// Aynı özel dersteki sporcuları tek top seviyesine hizalar.
  static Future<void> syncPrivateLessonBallLevels(AppDatabase db) async {
    final privateLessons = await (db.select(db.lessons)
          ..where((l) => l.type.equals('private'))
          ..where((l) => l.isTemplate.equals(false)))
        .get();
    if (privateLessons.isEmpty) return;

    final parts = await db.getParticipantsForLessons(
      privateLessons.map((l) => l.id).toList(),
    );
    final byLesson = <String, List<String>>{};
    for (final p in parts) {
      byLesson.putIfAbsent(p.lessonId, () => []).add(p.userId);
    }

    final seenClusters = <String>{};
    for (final lesson in privateLessons) {
      final ids = [...(byLesson[lesson.id] ?? const <String>[])]..sort();
      if (ids.length < 2) continue;
      final key = ids.join('|');
      if (!seenClusters.add(key)) continue;

      final profiles = await (db.select(db.studentProfiles)
            ..where((s) => s.userId.isIn(ids)))
          .get();
      if (profiles.length < 2) continue;

      final counts = <String, int>{};
      for (final p in profiles) {
        final label = BallLevel.normalizeLabel(p.level);
        counts[label] = (counts[label] ?? 0) + 1;
      }
      final target = counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
      final now = DateTime.now();
      for (final p in profiles) {
        if (BallLevel.normalizeLabel(p.level) == target) continue;
        await db.upsertStudentProfile(StudentProfilesCompanion(
          userId: Value(p.userId),
          coachId: Value(p.coachId),
          age: Value(p.age),
          level: Value(target),
          notes: Value(p.notes),
          updatedAt: Value(now),
        ));
      }
    }
  }

  /// Geçmiş özel derslere kısa çalışma notu (mevcut DB).
  static Future<void> syncPrivateFocusNotes(AppDatabase db) async {
    final now = DateTime.now();
    final lessons = await (db.select(db.lessons)
          ..where((l) => l.type.equals('private'))
          ..where((l) => l.isTemplate.equals(false))
          ..where((l) => l.startTime.isSmallerThanValue(now)))
        .get();
    var i = 0;
    for (final lesson in lessons) {
      final n = lesson.notes?.trim().toLowerCase() ?? '';
      if (n.isNotEmpty && n != 'haftalık özel ders') continue;
      final note = _privateFocusNotes[i % _privateFocusNotes.length];
      i++;
      await db.updateLesson(
        lesson.id,
        LessonsCompanion(notes: Value(note)),
      );
    }
  }

  /// Demo antrenöre ~12 grup — öğrenci sekmesinde 4×3 bakış için.
  static Future<void> seedExtraDemoGroups(AppDatabase db) async {
    const coachId = 'coach-yasir';
    final coach = await db.getUserById(coachId);
    if (coach == null) return;

    final profiles = await (db.select(db.studentProfiles)
          ..where((s) => s.coachId.equals(coachId)))
        .get();
    final existingCodes = <String>{
      for (final p in profiles)
        if (StudentNotes.groupCode(p.notes) != null)
          StudentNotes.groupCode(p.notes)!.toLowerCase(),
    };
    if (existingCodes.length >= 12) return;

    const extraCodes = [
      'yet-90',
      'ço-91',
      'alt-4',
      'gö-40',
      'performans-2',
      'yaz-okulu',
      'luna',
      'te-3',
      'yet-97',
    ];
    final toAdd = extraCodes
        .where((c) => !existingCodes.contains(c.toLowerCase()))
        .take(12 - existingCodes.length)
        .toList();
    if (toAdd.isEmpty) return;

    final users = <UsersCompanion>[];
    final extraProfiles = <StudentProfilesCompanion>[];
    var seq = 0;
    for (final code in toAdd) {
      final isChild = _groupCodeLooksChild(code);
      const memberCount = 4;
      for (var i = 0; i < memberCount; i++) {
        seq++;
        final id = 'athlete-xg-$code-${i + 1}';
        final personName = _turkishNames[(80 + seq) % _turkishNames.length];
        final age = isChild ? 9 + (i % 5) : 20 + (i % 8);
        users.add(UsersCompanion.insert(
          id: id,
          name: personName,
          email: '${id.replaceAll('ç', 'c').replaceAll('ö', 'o')}@eta.com',
          password: 'sporcu123',
          role: 'athlete',
          createdAt: DateTime.now(),
        ));
        extraProfiles.add(StudentProfilesCompanion.insert(
          userId: id,
          coachId: coachId,
          age: Value(age),
          level: Value(_ballLevelForAge(age)),
          notes: Value('Grup: $code'),
          updatedAt: DateTime.now(),
        ));
      }
    }

    await db.batch((batch) {
      batch.insertAll(db.users, users, mode: InsertMode.insertOrIgnore);
      batch.insertAll(db.studentProfiles, extraProfiles, mode: InsertMode.insertOrIgnore);
    });
  }

  /// Demo üye hesabına başlangıç kredisi (migration v8).
  static Future<void> seedMemberCredits(AppDatabase db) async {
    const demoId = 'athlete-demo';
    final user = await db.getUserById(demoId);
    if (user == null || user.creditBalance > 0) return;

    await db.addTestCredits(userId: demoId, amount: 20);
  }

  /// Mevcut veritabanlarına Kort 5 ve 6 ekler (şema v1 → v2).
  static Future<void> addExtraCourts(AppDatabase db) async {
    final existing = await db.getActiveCourts();
    if (existing.length >= 6) return;

    final names = existing.map((c) => c.name).toSet();
    final toAdd = <CourtsCompanion>[];
    for (var i = 5; i <= 6; i++) {
      final name = 'Kort $i';
      if (!names.contains(name)) {
        toAdd.add(CourtsCompanion.insert(
          id: 'court-00$i',
          name: name,
          sortOrder: Value(i),
        ));
      }
    }
    if (toAdd.isNotEmpty) {
      await db.batch((batch) => batch.insertAll(db.courts, toAdd));
    }
  }

  static String _ballLevelForAge(int age) {
    if (age <= 9) return BallLevel.red.label;
    if (age <= 11) return BallLevel.orange.label;
    if (age <= 14) return BallLevel.green.label;
    return BallLevel.yellow.label;
  }
}

class _CoachInfo {
  const _CoachInfo(this.id, this.name, this.email, this.phone);
  final String id;
  final String name;
  final String email;
  final String phone;
}

class _GroupSpec {
  const _GroupSpec({
    required this.code,
    required this.weekdays,
    required this.hour,
    required this.memberCount,
    this.durationHours = 1,
    this.courtId,
  });

  final String code;
  final List<int> weekdays;
  final int hour;
  final int memberCount;
  final int durationHours;
  final String? courtId;

  bool get isChild => _groupCodeLooksChild(code);
}

bool _groupCodeLooksChild(String code) {
  final c = code.toLowerCase();
  return c.startsWith('ço') ||
      c.startsWith('co-') ||
      c.startsWith('gö') ||
      c.startsWith('go-') ||
      c.startsWith('alt') ||
      c.startsWith('yaz') ||
      c.startsWith('luna') ||
      c.startsWith('te') ||
      c.contains('anaokulu') ||
      c.contains('asay');
}

class _PrivateSpec {
  const _PrivateSpec({
    required this.weekday,
    required this.hour,
    required this.memberCount,
    this.courtId,
    this.title,
  });
  final int weekday;
  final int hour;
  final int memberCount;
  final String? courtId;
  /// Verilirse özel ders başlığı (örn. emin-cenk); yoksa sporcu adlarından üretilir.
  final String? title;
}

class _CoachSchedule {
  const _CoachSchedule({required this.groups, required this.privates});
  final List<_GroupSpec> groups;
  final List<_PrivateSpec> privates;
}

const _yukselGroupMembers = <String, List<String>>{
  'Yet-18': ['İrem', 'Murat', 'Gizem'],
  'Yet-3': ['Yiğit', 'Cansu', 'Can'],
  'Yet-4': ['Orçun', 'Burak', 'Elif', 'Ebru', 'Hüseyin'],
  'Yet-2': ['Havva', 'Esra', 'Betül', 'Aylin'],
  'Yet-6': ['Hilal', 'Turana', 'Esin', 'Gülşah', 'Merve'],
  'Yet-1': ['İsmail', 'Ebru', 'Mina', 'Ilgaz'],
};

/// Özel ders slot anahtarı → katılımcı isimleri (her biri ayrı sporcu).
const _yukselPrivateMembers = <String, List<String>>{
  'hazal-simge-yaren': ['Hazal', 'Simge', 'Yaren'],
  'veli': ['Veli'],
  'mert-alper': ['Mert', 'Alper'],
  'serra': ['Serra'],
  'esma-sevil': ['Esma', 'Sevil'],
  'sıla': ['Sıla'],
  'damla-bahadır': ['Damla', 'Bahadır'],
  'gizem': ['Gizem'],
  'fatma-baltacı': ['Fatma Baltacı'],
  'deniz-bahar': ['Deniz', 'Bahar'],
  'fatma-özge': ['Fatma', 'Özge'],
};

const _coaches = [
  _CoachInfo('coach-yasir', 'Elif A', 'elif.a@eta.com', '0532 100 0001'),
  _CoachInfo('coach-elizt', 'Elif B', 'elif.b@eta.com', '0532 100 0002'),
  _CoachInfo('coach-eliza', 'Yasin R', 'yasin.r@eta.com', '0532 100 0003'),
  _CoachInfo('coach-gurkan', 'Görkem V', 'gorkem.v@eta.com', '0532 100 0004'),
  _CoachInfo('coach-dogukan', 'Alperen Ç', 'alperen.c@eta.com', '0532 100 0005'),
  _CoachInfo('coach-alper', 'Yüksel D', 'yuksel.d@eta.com', '0532 100 0006'),
  _CoachInfo('coach-yucel', 'Doğan S', 'dogan.s@eta.com', '0532 100 0007'),
];

const _schedules = [
  // Elif A — Luna / Yaz / GÖ / Yet (SÖ2 ağırlıklı)
  _CoachSchedule(
    groups: [
      _GroupSpec(
        code: 'Luna',
        weekdays: [DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday],
        hour: 8,
        memberCount: 5,
        durationHours: 2,
        courtId: 'court-002',
      ),
      _GroupSpec(
        code: 'Yaz Okulu',
        weekdays: [DateTime.monday, DateTime.wednesday, DateTime.friday],
        hour: 11,
        memberCount: 5,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'GÖ-33',
        weekdays: [DateTime.tuesday, DateTime.thursday],
        hour: 18,
        memberCount: 4,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'Yet-50',
        weekdays: [DateTime.tuesday, DateTime.friday],
        hour: 19,
        memberCount: 4,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'TE-1',
        weekdays: [DateTime.saturday],
        hour: 12,
        memberCount: 5,
        courtId: 'court-002',
      ),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.tuesday, hour: 15, memberCount: 1, courtId: 'court-002'),
      _PrivateSpec(weekday: DateTime.wednesday, hour: 16, memberCount: 1, courtId: 'court-001'),
      _PrivateSpec(weekday: DateTime.wednesday, hour: 17, memberCount: 1, courtId: 'court-001'),
      _PrivateSpec(weekday: DateTime.saturday, hour: 9, memberCount: 1, courtId: 'court-002'),
    ],
  ),
  // Elif B — Yet / GÖ / Yaz
  _CoachSchedule(
    groups: [
      _GroupSpec(
        code: 'Yet-43',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 19,
        memberCount: 4,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'Yet-3',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 20,
        memberCount: 4,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'GÖ-26',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 18,
        memberCount: 5,
        courtId: 'court-003',
      ),
      _GroupSpec(
        code: 'Yaz Okulu 2',
        weekdays: [DateTime.monday, DateTime.friday],
        hour: 12,
        memberCount: 5,
        courtId: 'court-002',
      ),
      _GroupSpec(
        code: 'Yet-12',
        weekdays: [DateTime.tuesday, DateTime.thursday],
        hour: 19,
        memberCount: 4,
        courtId: 'court-002',
      ),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.monday, hour: 14, memberCount: 1, courtId: 'court-002'),
      _PrivateSpec(weekday: DateTime.tuesday, hour: 14, memberCount: 1, courtId: 'court-001'),
      _PrivateSpec(weekday: DateTime.friday, hour: 14, memberCount: 1, courtId: 'court-001'),
      _PrivateSpec(weekday: DateTime.saturday, hour: 10, memberCount: 1, courtId: 'court-001'),
    ],
  ),
  // Yasin R — Alt-1 / GÖ / Yet (SÖ1 sabah)
  _CoachSchedule(
    groups: [
      _GroupSpec(
        code: 'Alt-1',
        weekdays: [DateTime.monday, DateTime.wednesday, DateTime.friday],
        hour: 9,
        memberCount: 5,
        durationHours: 2,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'GÖ-31',
        weekdays: [DateTime.monday, DateTime.wednesday, DateTime.friday],
        hour: 17,
        memberCount: 5,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'Yet-51',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 19,
        memberCount: 4,
        courtId: 'court-002',
      ),
      _GroupSpec(
        code: 'Yet-45',
        weekdays: [DateTime.wednesday, DateTime.friday],
        hour: 18,
        memberCount: 4,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'Yet-48',
        weekdays: [DateTime.monday, DateTime.thursday],
        hour: 20,
        memberCount: 4,
        courtId: 'court-003',
      ),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.monday, hour: 8, memberCount: 1, courtId: 'court-001'),
      _PrivateSpec(weekday: DateTime.tuesday, hour: 9, memberCount: 1, courtId: 'court-001'),
      _PrivateSpec(weekday: DateTime.tuesday, hour: 11, memberCount: 1, courtId: 'court-001'),
      _PrivateSpec(weekday: DateTime.friday, hour: 15, memberCount: 1, courtId: 'court-001'),
    ],
  ),
  // Görkem V — Performans / Alt / Yet
  _CoachSchedule(
    groups: [
      _GroupSpec(
        code: 'Performans',
        weekdays: [
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday,
        ],
        hour: 9,
        memberCount: 5,
        durationHours: 2,
        courtId: 'court-003',
      ),
      _GroupSpec(
        code: 'Alt-3',
        weekdays: [DateTime.monday, DateTime.tuesday, DateTime.thursday],
        hour: 16,
        memberCount: 5,
        durationHours: 2,
        courtId: 'court-003',
      ),
      _GroupSpec(
        code: 'Alt-7',
        weekdays: [DateTime.tuesday, DateTime.thursday, DateTime.friday],
        hour: 17,
        memberCount: 4,
        courtId: 'court-002',
      ),
      _GroupSpec(
        code: 'Yet-46',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 20,
        memberCount: 4,
        courtId: 'court-002',
      ),
      _GroupSpec(
        code: 'Yet-30',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 21,
        memberCount: 4,
        courtId: 'court-001',
      ),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.wednesday, hour: 14, memberCount: 1, courtId: 'court-003'),
      _PrivateSpec(weekday: DateTime.thursday, hour: 15, memberCount: 1, courtId: 'court-002'),
      _PrivateSpec(weekday: DateTime.friday, hour: 14, memberCount: 1, courtId: 'court-002'),
      _PrivateSpec(weekday: DateTime.saturday, hour: 15, memberCount: 1, courtId: 'court-001'),
    ],
  ),
  // Alperen Ç — GÖ / Yet / Yaz
  _CoachSchedule(
    groups: [
      _GroupSpec(
        code: 'GÖ-3',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 18,
        memberCount: 5,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'GÖ-25',
        weekdays: [DateTime.tuesday, DateTime.thursday],
        hour: 16,
        memberCount: 4,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'GÖ-12',
        weekdays: [DateTime.tuesday, DateTime.thursday],
        hour: 17,
        memberCount: 4,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'Yet-34',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 19,
        memberCount: 4,
        courtId: 'court-003',
      ),
      _GroupSpec(
        code: 'Yaz Okulu 2',
        weekdays: [DateTime.monday, DateTime.friday],
        hour: 12,
        memberCount: 5,
        courtId: 'court-001',
      ),
      _GroupSpec(
        code: 'Yet-20',
        weekdays: [DateTime.tuesday, DateTime.thursday],
        hour: 19,
        memberCount: 4,
        courtId: 'court-001',
      ),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.monday, hour: 13, memberCount: 1, courtId: 'court-001'),
      _PrivateSpec(weekday: DateTime.friday, hour: 13, memberCount: 1, courtId: 'court-001'),
      _PrivateSpec(weekday: DateTime.friday, hour: 18, memberCount: 1, courtId: 'court-003'),
      _PrivateSpec(weekday: DateTime.friday, hour: 20, memberCount: 1, courtId: 'court-003'),
    ],
  ),
  // Yüksel D — KO1
  _CoachSchedule(
    groups: [
      _GroupSpec(
        code: 'Asay Anaokulu',
        weekdays: [DateTime.monday],
        hour: 10,
        memberCount: 5,
        courtId: 'court-005',
      ),
      _GroupSpec(
        code: 'Yet-2',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 19,
        memberCount: 4,
        courtId: 'court-005',
      ),
      _GroupSpec(
        code: 'Yet-18',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 20,
        memberCount: 3,
        courtId: 'court-005',
      ),
      _GroupSpec(
        code: 'Yet-6',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 21,
        memberCount: 5,
        courtId: 'court-005',
      ),
      _GroupSpec(
        code: 'Yaz Okulu',
        weekdays: [DateTime.tuesday],
        hour: 11,
        memberCount: 5,
        durationHours: 2,
        courtId: 'court-005',
      ),
      _GroupSpec(
        code: 'Yet-3',
        weekdays: [DateTime.tuesday, DateTime.thursday],
        hour: 19,
        memberCount: 3,
        courtId: 'court-005',
      ),
      _GroupSpec(
        code: 'Yet-4',
        weekdays: [DateTime.tuesday],
        hour: 20,
        memberCount: 5,
        courtId: 'court-005',
      ),
      _GroupSpec(
        code: 'Karacapark Anaokulu',
        weekdays: [DateTime.thursday],
        hour: 9,
        memberCount: 5,
        courtId: 'court-005',
      ),
      _GroupSpec(
        code: 'TE Yaz Okulu',
        weekdays: [DateTime.thursday],
        hour: 10,
        memberCount: 5,
        courtId: 'court-005',
      ),
      _GroupSpec(
        code: 'Yaz Okulu',
        weekdays: [DateTime.thursday],
        hour: 11,
        memberCount: 5,
        durationHours: 2,
        courtId: 'court-005',
      ),
      _GroupSpec(
        code: 'Yet-4',
        weekdays: [DateTime.thursday],
        hour: 21,
        memberCount: 5,
        courtId: 'court-005',
      ),
      _GroupSpec(
        code: 'Yet-1',
        weekdays: [DateTime.saturday, DateTime.sunday],
        hour: 18,
        memberCount: 4,
        courtId: 'court-005',
      ),
    ],
    privates: [
      _PrivateSpec(
        weekday: DateTime.monday,
        hour: 22,
        memberCount: 3,
        courtId: 'court-005',
        title: 'hazal-simge-yaren',
      ),
      _PrivateSpec(
        weekday: DateTime.tuesday,
        hour: 21,
        memberCount: 1,
        courtId: 'court-005',
        title: 'veli',
      ),
      _PrivateSpec(
        weekday: DateTime.tuesday,
        hour: 22,
        memberCount: 2,
        courtId: 'court-005',
        title: 'mert-alper',
      ),
      _PrivateSpec(
        weekday: DateTime.wednesday,
        hour: 18,
        memberCount: 1,
        courtId: 'court-005',
        title: 'serra',
      ),
      _PrivateSpec(
        weekday: DateTime.wednesday,
        hour: 22,
        memberCount: 3,
        courtId: 'court-005',
        title: 'hazal-simge-yaren',
      ),
      _PrivateSpec(
        weekday: DateTime.thursday,
        hour: 20,
        memberCount: 2,
        courtId: 'court-005',
        title: 'esma-sevil',
      ),
      _PrivateSpec(
        weekday: DateTime.thursday,
        hour: 22,
        memberCount: 2,
        courtId: 'court-005',
        title: 'mert-alper',
      ),
      _PrivateSpec(
        weekday: DateTime.saturday,
        hour: 9,
        memberCount: 1,
        courtId: 'court-005',
        title: 'sıla',
      ),
      _PrivateSpec(
        weekday: DateTime.saturday,
        hour: 10,
        memberCount: 2,
        courtId: 'court-005',
        title: 'damla-bahadır',
      ),
      _PrivateSpec(
        weekday: DateTime.saturday,
        hour: 19,
        memberCount: 1,
        courtId: 'court-005',
        title: 'gizem',
      ),
      _PrivateSpec(
        weekday: DateTime.saturday,
        hour: 20,
        memberCount: 1,
        courtId: 'court-005',
        title: 'fatma-baltacı',
      ),
      _PrivateSpec(
        weekday: DateTime.saturday,
        hour: 21,
        memberCount: 2,
        courtId: 'court-005',
        title: 'deniz-bahar',
      ),
      _PrivateSpec(
        weekday: DateTime.sunday,
        hour: 9,
        memberCount: 1,
        courtId: 'court-005',
        title: 'sıla',
      ),
      _PrivateSpec(
        weekday: DateTime.sunday,
        hour: 20,
        memberCount: 2,
        courtId: 'court-005',
        title: 'fatma-özge',
      ),
      _PrivateSpec(
        weekday: DateTime.sunday,
        hour: 21,
        memberCount: 2,
        courtId: 'court-005',
        title: 'deniz-bahar',
      ),
    ],
  ),
  // Doğan S — KO2 + seyrek SÖ
  _CoachSchedule(
    groups: [
      _GroupSpec(
        code: 'Yet-60',
        weekdays: [DateTime.monday, DateTime.wednesday],
        hour: 18,
        memberCount: 4,
        courtId: 'court-006',
      ),
      _GroupSpec(
        code: 'GÖ-15',
        weekdays: [DateTime.tuesday, DateTime.thursday],
        hour: 17,
        memberCount: 5,
        courtId: 'court-006',
      ),
      _GroupSpec(
        code: 'ço-22',
        weekdays: [DateTime.friday, DateTime.saturday],
        hour: 12,
        memberCount: 5,
        courtId: 'court-006',
      ),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.monday, hour: 19, memberCount: 1, courtId: 'court-006'),
      _PrivateSpec(weekday: DateTime.tuesday, hour: 18, memberCount: 2, courtId: 'court-006'),
      _PrivateSpec(weekday: DateTime.friday, hour: 18, memberCount: 1, courtId: 'court-006'),
      _PrivateSpec(weekday: DateTime.friday, hour: 19, memberCount: 2, courtId: 'court-006'),
    ],
  ),
];

/// Anlamlı rastgele Türkçe ad-soyad havuzu.
const _privateFocusNotes = [
  'servis ritmi',
  'backhand topspin',
  'vole ayak işi',
  'forehand derinlik',
  'return pozisyon',
  'slice kontrol',
  'net oyun',
  'ayak hızı',
];

const _turkishNames = [
  'Ece Kaya', 'Deniz Aydın', 'Mert Öztürk', 'Zeynep Çelik', 'Emir Yıldız',
  'Elif Demir', 'Burak Şahin', 'İrem Arslan', 'Kaan Yılmaz', 'Defne Koç',
  'Onur Aksoy', 'Selin Erdoğan', 'Yiğit Çetin', 'Melis Acar', 'Baran Kurt',
  'Nazlı Polat', 'Emre Güneş', 'İlayda Doğan', 'Alp Kara', 'Sude Özdemir',
  'Cemal Taş', 'Beren Ünal', 'Tolga Aslan', 'Yağmur İnce', 'Kerim Bozkurt',
  'Aylin Tekin', 'Furkan Bulut', 'Ceren Mutlu', 'Oğuz Han', 'Pelin Soylu',
  'Hakan Erdem', 'Duru Akın', 'Serkan Yavuz', 'Nehir Çakır', 'Berkay Sezer',
  'Asya Güler', 'Umut Kaplan', 'Eylül Şen', 'Arda Bilgin', 'Lara Özer',
  'Melih Avcı', 'İpek Sarı', 'Caner Duman', 'Ada Kılıç', 'Rüzgar Ateş',
  'Melike Bayrak', 'Emirhan Koçak', 'Sena Yücel', 'Tuna Ergin', 'Gökçe Akbaş',
  'Doruk Çiftçi', 'Eda Narin', 'Kerem Vural', 'Nilay Sağlam', 'Ata Boz',
  'Sude Naz', 'Efe Karaca', 'Buse Aktaş', 'Yusuf Eren', 'İrem Su',
  'Alperen Korkmaz', 'Zehra Nur', 'Mertcan Özkan', 'Ecrin Yalçın', 'Denizhan Işık',
  'Cansu Akbulut', 'Barış Eren', 'Melisa Tan', 'Koray Dinç', 'Ayşe Sena',
  'Emir Ali', 'Şevval Korkut', 'Ozan Ersoy', 'Ebrar Yurt', 'Tuğrul Ak',
  'Nilüfer Demirtaş', 'Samet Uçar', 'Dila Kaynar', 'Eray Solmaz', 'Hazal Oruç',
  'Batuhan Kaya', 'Miray Aydın', 'Kaan Emre', 'Selinay Öz', 'Yunus Emre',
  'Ela Nur', 'Çınar Demir', 'İpek Naz', 'Mehmet Ali', 'Sude Ece',
  'Ahmet Can', 'Zeynep Su', 'Mustafa Emir', 'Ayşe Defne', 'Hüseyin Mert',
  'Fatma Zehra', 'Ali Rıza', 'Hatice Nur', 'Osman Yiğit', 'Esra Melis',
];
