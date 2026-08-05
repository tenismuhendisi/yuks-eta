import 'package:crm_app/core/database/connection/connect.dart';
import 'package:crm_app/core/database/seed_data.dart';
import 'package:drift/drift.dart';

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get password => text()();
  TextColumn get role => text()();
  TextColumn get phone => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Courts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class CourtBlocks extends Table {
  TextColumn get id => text()();
  TextColumn get courtId => text().references(Courts, #id)();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get reason => text().nullable()();
  TextColumn get createdById => text().references(Users, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

class CourtRentals extends Table {
  TextColumn get id => text()();
  TextColumn get courtId => text().references(Courts, #id)();
  TextColumn get athleteId => text().references(Users, #id)();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Lessons extends Table {
  TextColumn get id => text()();
  TextColumn get coachId => text().references(Users, #id)();
  TextColumn get courtId => text().nullable().references(Courts, #id)();
  TextColumn get type => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get maxParticipants => integer().withDefault(const Constant(1))();
  BoolColumn get isTemplate => boolean().withDefault(const Constant(false))();
  TextColumn get title => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LessonParticipants extends Table {
  TextColumn get id => text()();
  TextColumn get lessonId => text().references(Lessons, #id)();
  TextColumn get userId => text().references(Users, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

class Payments extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  RealColumn get amount => real()();
  TextColumn get description => text()();
  DateTimeColumn get dueDate => dateTime()();
  DateTimeColumn get paidAt => dateTime().nullable()();
  TextColumn get status => text()();
  TextColumn get createdById => text().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class StudentProfiles extends Table {
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get coachId => text().references(Users, #id)();
  IntColumn get age => integer().nullable()();
  TextColumn get level => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId};
}

class ParentAthleteLinks extends Table {
  TextColumn get parentId => text().references(Users, #id)();
  TextColumn get athleteId => text().references(Users, #id)();

  @override
  Set<Column> get primaryKey => {parentId, athleteId};
}

@DriftDatabase(tables: [
  Users,
  Courts,
  CourtBlocks,
  CourtRentals,
  Lessons,
  LessonParticipants,
  Payments,
  StudentProfiles,
  ParentAthleteLinks,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await SeedData.seed(this);
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await SeedData.addExtraCourts(this);
          }
        },
      );

  // --- Users ---

  Future<User?> getUserByEmail(String email) {
    return (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();
  }

  Future<User?> getUserById(String id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  Future<List<User>> getUsersByRole(String role) {
    return (select(users)..where((u) => u.role.equals(role))).get();
  }

  Future<List<User>> getAllUsers() => select(users).get();

  Future<void> insertUser(UsersCompanion user) => into(users).insert(user);

  // --- Courts ---

  Stream<List<Court>> watchActiveCourts() {
    return (select(courts)
          ..where((c) => c.isActive.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .watch();
  }

  Future<List<Court>> getActiveCourts() {
    return (select(courts)
          ..where((c) => c.isActive.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
  }

  Future<void> insertCourt(CourtsCompanion court) => into(courts).insert(court);

  // --- Court Blocks ---

  Future<List<CourtBlock>> getBlocksForRange(DateTime start, DateTime end) {
    return (select(courtBlocks)
          ..where((b) => b.startTime.isSmallerThanValue(end))
          ..where((b) => b.endTime.isBiggerThanValue(start)))
        .get();
  }

  Future<void> insertCourtBlock(CourtBlocksCompanion block) =>
      into(courtBlocks).insert(block);

  Future<void> deleteCourtBlock(String id) =>
      (delete(courtBlocks)..where((b) => b.id.equals(id))).go();

  // --- Court Rentals ---

  Future<List<CourtRental>> getRentalsForRange(DateTime start, DateTime end) {
    return (select(courtRentals)
          ..where((r) => r.startTime.isSmallerThanValue(end))
          ..where((r) => r.endTime.isBiggerThanValue(start)))
        .get();
  }

  Future<void> insertRental(CourtRentalsCompanion rental) =>
      into(courtRentals).insert(rental);

  // --- Lessons ---

  Stream<List<Lesson>> watchLessonsForCoach(String coachId) {
    return (select(lessons)..where((l) => l.coachId.equals(coachId))).watch();
  }

  Future<List<Lesson>> getLessonsForCoachInRange(
    String coachId,
    DateTime start,
    DateTime end,
  ) {
    return (select(lessons)
          ..where((l) => l.coachId.equals(coachId))
          ..where((l) => l.startTime.isSmallerThanValue(end))
          ..where((l) => l.endTime.isBiggerThanValue(start)))
        .get();
  }

  Future<List<Lesson>> getLessonsForRange(DateTime start, DateTime end) {
    return (select(lessons)
          ..where((l) => l.startTime.isSmallerThanValue(end))
          ..where((l) => l.endTime.isBiggerThanValue(start)))
        .get();
  }

  Future<void> insertLesson(LessonsCompanion lesson) => into(lessons).insert(lesson);

  Future<void> updateLesson(String id, LessonsCompanion lesson) =>
      (update(lessons)..where((l) => l.id.equals(id))).write(lesson);

  Future<void> deleteLesson(String id) async {
    await (delete(lessonParticipants)..where((p) => p.lessonId.equals(id))).go();
    await (delete(lessons)..where((l) => l.id.equals(id))).go();
  }

  // --- Lesson Participants ---

  Future<List<LessonParticipant>> getParticipantsForLesson(String lessonId) {
    return (select(lessonParticipants)..where((p) => p.lessonId.equals(lessonId)))
        .get();
  }

  Future<void> insertParticipant(LessonParticipantsCompanion p) =>
      into(lessonParticipants).insert(p);

  Future<void> removeParticipant(String lessonId, String userId) {
    return (delete(lessonParticipants)
          ..where((p) => p.lessonId.equals(lessonId))
          ..where((p) => p.userId.equals(userId)))
        .go();
  }

  // --- Payments ---

  Stream<List<Payment>> watchAllPayments() {
    return (select(payments)..orderBy([(p) => OrderingTerm.desc(p.dueDate)])).watch();
  }

  Stream<List<Payment>> watchPaymentsForUser(String userId) {
    return (select(payments)
          ..where((p) => p.userId.equals(userId))
          ..orderBy([(p) => OrderingTerm.desc(p.dueDate)]))
        .watch();
  }

  Future<void> insertPayment(PaymentsCompanion payment) => into(payments).insert(payment);

  Future<void> updatePayment(String id, PaymentsCompanion payment) =>
      (update(payments)..where((p) => p.id.equals(id))).write(payment);

  // --- Student Profiles ---

  Stream<List<StudentProfile>> watchStudentsForCoach(String coachId) {
    return (select(studentProfiles)..where((s) => s.coachId.equals(coachId))).watch();
  }

  Future<void> upsertStudentProfile(StudentProfilesCompanion profile) =>
      into(studentProfiles).insertOnConflictUpdate(profile);

  Future<void> removeStudentFromCoach(String userId, String coachId) {
    return (delete(studentProfiles)
          ..where((s) => s.userId.equals(userId))
          ..where((s) => s.coachId.equals(coachId)))
        .go();
  }

  Future<StudentProfile?> getStudentProfile(String userId, String coachId) {
    return (select(studentProfiles)
          ..where((s) => s.userId.equals(userId))
          ..where((s) => s.coachId.equals(coachId)))
        .getSingleOrNull();
  }

  // --- Parent Links ---

  Future<List<User>> getAthletesForParent(String parentId) async {
    final links = await (select(parentAthleteLinks)
          ..where((l) => l.parentId.equals(parentId)))
        .get();
    if (links.isEmpty) return [];
    final ids = links.map((l) => l.athleteId).toList();
    return (select(users)..where((u) => u.id.isIn(ids))).get();
  }
}

