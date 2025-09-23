import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_db.g.dart';

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class TimeEntries extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startAt => dateTime()();
  DateTimeColumn get endAt => dateTime().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Tasks, TimeEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // Index on time_entries.startAt
          await customStatement('CREATE INDEX IF NOT EXISTS idx_time_entries_startAt ON time_entries (start_at)');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory folder = await getApplicationSupportDirectory();
    final String filePath = p.join(folder.path, 'time_tracker.db');
    return NativeDatabase.createInBackground(File(filePath));
  });
}


