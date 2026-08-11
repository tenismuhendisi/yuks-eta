import 'package:crm_app/core/database/app_database.dart';
import 'package:crm_app/core/enums/ball_level.dart';
import 'package:crm_app/core/utils/email_from_name.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Akademi seed: 7 antrenör, grup (ço/yet) + özel dersler, yoklama için somut instance'lar.
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
        for (var i = 1; i <= 6; i++)
          CourtsCompanion.insert(
            id: 'court-00$i',
            name: 'Kort $i',
            sortOrder: Value(i),
          ),
      ]);
    });
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
    var groupCodeSeq = 10;
    var nameIdx = 0;
    String nextAthleteId() => 'athlete-${(++athleteSeq).toString().padLeft(3, '0')}';
    String nextPersonName() {
      final name = _turkishNames[nameIdx % _turkishNames.length];
      nameIdx++;
      return name;
    }
    String nextGroupCode(bool child) {
      final n = groupCodeSeq++;
      return child ? 'ço-${n.toString().padLeft(2, '0')}' : 'yet-${n.toString().padLeft(2, '0')}';
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

      // --- 3 grup dersi (haftada 2 gün, 4–5 sporcu) ---
      for (final g in schedule.groups) {
        final code = nextGroupCode(g.isChild);
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
          // Somut dersler: geçen / bu / gelecek hafta
          for (final monday in [lastMonday, thisMonday, nextMonday]) {
            final lessonId =
                'les-${coach.id}-$code-$weekday-${monday.year}${monday.month}${monday.day}';
            final courtId = courtIds[(ci + weekday) % courtIds.length];
            final start = _at(monday, weekday, g.hour);
            lessons.add(LessonsCompanion.insert(
              id: lessonId,
              coachId: coach.id,
              courtId: Value(courtId),
              type: 'group',
              startTime: start,
              endTime: start.add(const Duration(hours: 1)),
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

            // Geçen hafta — yalnızca grup yoklaması (sporcu bazlı)
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

      // --- 4 özel ders (yoklama yok) ---
      for (var pi = 0; pi < schedule.privates.length; pi++) {
        final p = schedule.privates[pi];
        final privateAthletes = <String>[];
        final privateFirstNames = <String>[];
        for (var i = 0; i < p.memberCount; i++) {
          final id = nextAthleteId();
          final personName = nextPersonName();
          privateAthletes.add(id);
          privateFirstNames.add(personName.split(' ').first.toLowerCase());
          athleteIdsForCoach.add(id);
          final age = 13 + i;
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
            notes: Value('Özel ders ${p.memberCount} kişi'),
            updatedAt: DateTime.now(),
          ));
        }

        final title = privateFirstNames.join('-');

        for (final monday in [lastMonday, thisMonday, nextMonday]) {
          final lessonId =
              'les-${coach.id}-ozel-$pi-${monday.year}${monday.month}${monday.day}';
          final courtId = courtIds[(ci + pi) % courtIds.length];
          final start = _at(monday, p.weekday, p.hour);
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
            notes: const Value('Haftalık özel ders'),
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
    required this.isChild,
    required this.weekdays,
    required this.hour,
    required this.memberCount,
  });
  final bool isChild;
  final List<int> weekdays;
  final int hour;
  final int memberCount;
}

class _PrivateSpec {
  const _PrivateSpec({
    required this.weekday,
    required this.hour,
    required this.memberCount,
  });
  final int weekday;
  final int hour;
  final int memberCount;
}

class _CoachSchedule {
  const _CoachSchedule({required this.groups, required this.privates});
  final List<_GroupSpec> groups;
  final List<_PrivateSpec> privates;
}

const _coaches = [
  _CoachInfo('coach-yasir', 'Elif Aktuş', 'elif.aktus@eta.com', '0532 100 0001'),
  _CoachInfo('coach-elizt', 'Elif Buruk', 'elif.buruk@eta.com', '0532 100 0002'),
  _CoachInfo('coach-eliza', 'Yasin Rustem', 'yasin@eta.com', '0532 100 0003'),
  _CoachInfo('coach-gurkan', 'Görkem Vahitoğlu', 'gorkem@eta.com', '0532 100 0004'),
  _CoachInfo('coach-dogukan', 'Alperen Çeçil', 'alperen@eta.com', '0532 100 0005'),
  _CoachInfo('coach-alper', 'Yüksel Demir', 'yuksel@eta.com', '0532 100 0006'),
  _CoachInfo('coach-yucel', 'Doğan Sutaşı', 'dogan@eta.com', '0532 100 0007'),
];

const _schedules = [
  // Elif Aktuş — Mon/Wed, Tue/Thu, Fri/Sat: her gün grubunda özel de var
  _CoachSchedule(
    groups: [
      _GroupSpec(isChild: true, weekdays: [DateTime.monday, DateTime.wednesday], hour: 18, memberCount: 5),
      _GroupSpec(isChild: false, weekdays: [DateTime.tuesday, DateTime.thursday], hour: 20, memberCount: 4),
      _GroupSpec(isChild: true, weekdays: [DateTime.friday, DateTime.saturday], hour: 17, memberCount: 5),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.monday, hour: 19, memberCount: 1),
      _PrivateSpec(weekday: DateTime.tuesday, hour: 18, memberCount: 2),
      _PrivateSpec(weekday: DateTime.friday, hour: 18, memberCount: 3),
      _PrivateSpec(weekday: DateTime.friday, hour: 19, memberCount: 1),
    ],
  ),
  // Elif Buruk
  _CoachSchedule(
    groups: [
      _GroupSpec(isChild: false, weekdays: [DateTime.monday, DateTime.wednesday], hour: 19, memberCount: 4),
      _GroupSpec(isChild: true, weekdays: [DateTime.tuesday, DateTime.thursday], hour: 17, memberCount: 5),
      _GroupSpec(isChild: true, weekdays: [DateTime.friday, DateTime.saturday], hour: 11, memberCount: 4),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.monday, hour: 20, memberCount: 2),
      _PrivateSpec(weekday: DateTime.tuesday, hour: 18, memberCount: 1),
      _PrivateSpec(weekday: DateTime.friday, hour: 17, memberCount: 3),
      _PrivateSpec(weekday: DateTime.saturday, hour: 12, memberCount: 1),
    ],
  ),
  // Yasin Rustem
  _CoachSchedule(
    groups: [
      _GroupSpec(isChild: true, weekdays: [DateTime.monday, DateTime.wednesday], hour: 17, memberCount: 5),
      _GroupSpec(isChild: false, weekdays: [DateTime.tuesday, DateTime.thursday], hour: 21, memberCount: 4),
      _GroupSpec(isChild: false, weekdays: [DateTime.friday, DateTime.saturday], hour: 18, memberCount: 5),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.monday, hour: 18, memberCount: 1),
      _PrivateSpec(weekday: DateTime.tuesday, hour: 19, memberCount: 2),
      _PrivateSpec(weekday: DateTime.friday, hour: 19, memberCount: 1),
      _PrivateSpec(weekday: DateTime.saturday, hour: 19, memberCount: 3),
    ],
  ),
  // Görkem Vahitoğlu
  _CoachSchedule(
    groups: [
      _GroupSpec(isChild: true, weekdays: [DateTime.tuesday, DateTime.thursday], hour: 18, memberCount: 4),
      _GroupSpec(isChild: false, weekdays: [DateTime.monday, DateTime.wednesday], hour: 20, memberCount: 5),
      _GroupSpec(isChild: true, weekdays: [DateTime.friday, DateTime.saturday], hour: 10, memberCount: 5),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.monday, hour: 19, memberCount: 1),
      _PrivateSpec(weekday: DateTime.tuesday, hour: 19, memberCount: 2),
      _PrivateSpec(weekday: DateTime.friday, hour: 11, memberCount: 1),
      _PrivateSpec(weekday: DateTime.friday, hour: 20, memberCount: 3),
    ],
  ),
  // Alperen Çeçil
  _CoachSchedule(
    groups: [
      _GroupSpec(isChild: false, weekdays: [DateTime.monday, DateTime.wednesday], hour: 18, memberCount: 5),
      _GroupSpec(isChild: true, weekdays: [DateTime.tuesday, DateTime.thursday], hour: 19, memberCount: 4),
      _GroupSpec(isChild: true, weekdays: [DateTime.friday, DateTime.saturday], hour: 10, memberCount: 5),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.monday, hour: 19, memberCount: 2),
      _PrivateSpec(weekday: DateTime.tuesday, hour: 18, memberCount: 1),
      _PrivateSpec(weekday: DateTime.friday, hour: 11, memberCount: 1),
      _PrivateSpec(weekday: DateTime.friday, hour: 18, memberCount: 3),
    ],
  ),
  // Yüksel Demir
  _CoachSchedule(
    groups: [
      _GroupSpec(isChild: true, weekdays: [DateTime.monday, DateTime.wednesday], hour: 17, memberCount: 4),
      _GroupSpec(isChild: false, weekdays: [DateTime.tuesday, DateTime.thursday], hour: 20, memberCount: 5),
      _GroupSpec(isChild: false, weekdays: [DateTime.friday, DateTime.saturday], hour: 18, memberCount: 4),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.monday, hour: 18, memberCount: 1),
      _PrivateSpec(weekday: DateTime.tuesday, hour: 18, memberCount: 2),
      _PrivateSpec(weekday: DateTime.friday, hour: 19, memberCount: 1),
      _PrivateSpec(weekday: DateTime.saturday, hour: 19, memberCount: 3),
    ],
  ),
  // Doğan Sutaşı
  _CoachSchedule(
    groups: [
      _GroupSpec(isChild: true, weekdays: [DateTime.tuesday, DateTime.thursday], hour: 17, memberCount: 5),
      _GroupSpec(isChild: false, weekdays: [DateTime.monday, DateTime.wednesday], hour: 21, memberCount: 4),
      _GroupSpec(isChild: true, weekdays: [DateTime.friday, DateTime.saturday], hour: 12, memberCount: 5),
    ],
    privates: [
      _PrivateSpec(weekday: DateTime.monday, hour: 18, memberCount: 1),
      _PrivateSpec(weekday: DateTime.tuesday, hour: 18, memberCount: 2),
      _PrivateSpec(weekday: DateTime.friday, hour: 17, memberCount: 1),
      _PrivateSpec(weekday: DateTime.friday, hour: 18, memberCount: 3),
    ],
  ),
];

/// Anlamlı rastgele Türkçe ad-soyad havuzu.
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
