import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class TagRepository {
  final AppDatabase _db;
  final Uuid _uuid;

  TagRepository(this._db, [Uuid? uuid]) : _uuid = uuid ?? const Uuid();

  Future<List<Tag>> getAllTags() {
    return (_db.select(_db.tags)..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<List<Tag>> searchTags(String query) {
    return (_db.select(_db.tags)
          ..where((t) => t.name.like('%$query%'))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<Tag> getOrCreateTag(String name) async {
    final cleanName = name.trim();
    final existing = await (_db.select(_db.tags)
          ..where((t) => t.name.collate(Collate.noCase).equals(cleanName)))
        .getSingleOrNull();

    if (existing != null) {
      return existing;
    }

    final newTag = Tag(
      id: _uuid.v4(),
      name: cleanName,
    );

    await _db.into(_db.tags).insert(newTag);
    return newTag;
  }

  Future<List<Tag>> getTagsForWork(String workId) async {
    final query = _db.select(_db.workTags).join([
      innerJoin(_db.tags, _db.tags.id.equalsExp(_db.workTags.tagId)),
    ])..where(_db.workTags.workId.equals(workId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(_db.tags)).toList();
  }

  Future<void> setTagsForWork(String workId, List<String> tagNames) async {
    await _db.transaction(() async {
      // Remove current work tags
      await (_db.delete(_db.workTags)..where((wt) => wt.workId.equals(workId)))
          .go();

      // Add each tag
      for (final name in tagNames) {
        if (name.trim().isEmpty) continue;
        final tag = await getOrCreateTag(name);
        await _db.into(_db.workTags).insert(
              WorkTagsCompanion(
                workId: Value(workId),
                tagId: Value(tag.id),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
    });
  }

  Future<void> cleanupUnusedTags() async {
    final query = _db.customStatement('''
      DELETE FROM tags WHERE id NOT IN (SELECT DISTINCT tag_id FROM work_tags);
    ''');
    await query;
  }
}
