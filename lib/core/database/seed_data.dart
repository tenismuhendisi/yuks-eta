import 'package:crm_app/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class SeedData {
  static const _uuid = Uuid();

  static Future<void> seed(AppDatabase db) async {
    const adminId = 'admin-001';
    const coach1Id = 'coach-001';
    const coach2Id = 'coach-002';
    const athlete1Id = 'athlete-001';
    const athlete2Id = 'athlete-002';
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
          id: coach1Id,
          name: 'Ahmet Antrenör',
          email: 'ahmet@eta.com',
          password: 'coach123',
          role: 'coach',
          phone: const Value('0532 111 2233'),
          createdAt: DateTime.now(),
        ),
        UsersCompanion.insert(
          id: coach2Id,
          name: 'Zeynep Antrenör',
          email: 'zeynep@eta.com',
          password: 'coach123',
          role: 'coach',
          phone: const Value('0533 444 5566'),
          createdAt: DateTime.now(),
        ),
        UsersCompanion.insert(
          id: athlete1Id,
          name: 'Can Sporcu',
          email: 'can@eta.com',
          password: 'sporcu123',
          role: 'athlete',
          phone: const Value('0544 777 8899'),
          createdAt: DateTime.now(),
        ),
        UsersCompanion.insert(
          id: athlete2Id,
          name: 'Elif Sporcu',
          email: 'elif@eta.com',
          password: 'sporcu123',
          role: 'athlete',
          createdAt: DateTime.now(),
        ),
        UsersCompanion.insert(
          id: parent1Id,
          name: 'Mehmet Veli',
          email: 'mehmet@eta.com',
          password: 'veli123',
          role: 'parent',
          phone: const Value('0555 123 4567'),
          createdAt: DateTime.now(),
        ),
      ]);

      batch.insertAll(db.courts, [
        CourtsCompanion.insert(id: _uuid.v4(), name: 'Kort 1', sortOrder: const Value(1)),
        CourtsCompanion.insert(id: _uuid.v4(), name: 'Kort 2', sortOrder: const Value(2)),
        CourtsCompanion.insert(id: _uuid.v4(), name: 'Kort 3', sortOrder: const Value(3)),
        CourtsCompanion.insert(id: _uuid.v4(), name: 'Kort 4', sortOrder: const Value(4)),
        CourtsCompanion.insert(id: _uuid.v4(), name: 'Kort 5', sortOrder: const Value(5)),
        CourtsCompanion.insert(id: _uuid.v4(), name: 'Kort 6', sortOrder: const Value(6)),
      ]);

      batch.insert(db.parentAthleteLinks, ParentAthleteLinksCompanion.insert(
        parentId: parent1Id,
        athleteId: athlete1Id,
      ));

      batch.insert(db.studentProfiles, StudentProfilesCompanion.insert(
        userId: athlete1Id,
        coachId: coach1Id,
        age: const Value(14),
        level: const Value('Orta'),
        updatedAt: DateTime.now(),
      ));

      batch.insert(db.studentProfiles, StudentProfilesCompanion.insert(
        userId: athlete2Id,
        coachId: coach1Id,
        age: const Value(12),
        level: const Value('Başlangıç'),
        updatedAt: DateTime.now(),
      ));
    });
  }

  /// Mevcut veritabanlarına Kort 5 ve 6 ekler (şema v1 → v2).
  static Future<void> addExtraCourts(AppDatabase db) async {
    const uuid = Uuid();
    final existing = await db.getActiveCourts();
    if (existing.length >= 6) return;

    final names = existing.map((c) => c.name).toSet();
    final toAdd = <CourtsCompanion>[];
    for (var i = 5; i <= 6; i++) {
      final name = 'Kort $i';
      if (!names.contains(name)) {
        toAdd.add(CourtsCompanion.insert(
          id: uuid.v4(),
          name: name,
          sortOrder: Value(i),
        ));
      }
    }
    if (toAdd.isNotEmpty) {
      await db.batch((batch) => batch.insertAll(db.courts, toAdd));
    }
  }
}
