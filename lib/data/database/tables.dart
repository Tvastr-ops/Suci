import 'package:drift/drift.dart';

class Works extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  TextColumn get author => text().nullable().withLength(max: 200)();
  TextColumn get sourceUrl => text().nullable()();
  TextColumn get additionalUrls => text().withDefault(const Constant('[]'))();
  TextColumn get format => text().withDefault(const Constant('web_novel'))();
  TextColumn get status => text().withDefault(const Constant('reading'))();
  TextColumn get publicationStatus =>
      text().withDefault(const Constant('ongoing'))();
  TextColumn get coverPath => text().nullable()();
  TextColumn get progressUnit => text().withDefault(const Constant('chapter'))();
  IntColumn get currentProgress => integer().withDefault(const Constant(0))();
  IntColumn get totalProgress => integer().nullable()();
  IntColumn get currentVolume => integer().nullable()();
  IntColumn get totalVolumes => integer().nullable()();
  IntColumn get rating => integer().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get synopsis => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get lastReadAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique().withLength(min: 1, max: 100)();

  @override
  Set<Column> get primaryKey => {id};
}

class WorkTags extends Table {
  TextColumn get workId =>
      text().references(Works, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {workId, tagId};
}

class ProgressLogs extends Table {
  TextColumn get id => text()();
  TextColumn get workId =>
      text().references(Works, #id, onDelete: KeyAction.cascade)();
  TextColumn get progressUnit => text()();
  IntColumn get progressValue => integer()();
  IntColumn get volumeValue => integer().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
