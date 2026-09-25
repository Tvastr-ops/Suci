import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../database/app_database.dart';
import '../repositories/tag_repository.dart';
import 'import_resolver.dart';

class ImportPreview {
  final int workCount;
  final int tagCount;
  final int progressLogCount;
  final int version;
  final Map<String, dynamic> rawData;

  const ImportPreview({
    required this.workCount,
    required this.tagCount,
    required this.progressLogCount,
    required this.version,
    required this.rawData,
  });
}

class BackupService {
  final AppDatabase _db;
  final TagRepository _tagRepo;
  late final ImportResolver _resolver;

  BackupService(this._db, this._tagRepo) {
    _resolver = ImportResolver(_db);
  }

  Future<String> exportToJson() async {
    final allWorks = await (_db.select(_db.works)
          ..orderBy([(w) => OrderingTerm.desc(w.updatedAt)]))
        .get();

    final allTags = await _db.select(_db.tags).get();
    final allLogs = await _db.select(_db.progressLogs).get();

    final worksList = <Map<String, dynamic>>[];

    for (final work in allWorks) {
      final tags = await _tagRepo.getTagsForWork(work.id);

      List<String> additionalUrls = [];
      try {
        final decoded = jsonDecode(work.additionalUrls);
        if (decoded is List) {
          additionalUrls = decoded.cast<String>();
        }
      } catch (_) {}

      worksList.add({
        'id': work.id,
        'title': work.title,
        'author': work.author,
        'source_url': work.sourceUrl,
        'additional_urls': additionalUrls,
        'format': work.format,
        'status': work.status,
        'publication_status': work.publicationStatus,
        'cover_path': work.coverPath,
        'progress': {
          'unit': work.progressUnit,
          'current': work.currentProgress,
          'total': work.totalProgress,
          'current_volume': work.currentVolume,
          'total_volumes': work.totalVolumes,
        },
        'rating': work.rating,
        'tags': tags.map((t) => t.name).toList(),
        'synopsis': work.synopsis,
        'notes': work.notes,
        'started_at': work.startedAt?.toIso8601String(),
        'completed_at': work.completedAt?.toIso8601String(),
        'last_read_at': work.lastReadAt?.toIso8601String(),
        'created_at': work.createdAt.toIso8601String(),
        'updated_at': work.updatedAt.toIso8601String(),
      });
    }

    final backupMap = {
      'suci_version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'works': worksList,
      'tags': allTags.map((t) => {'id': t.id, 'name': t.name}).toList(),
      'progress_logs': allLogs
          .map((l) => {
                'id': l.id,
                'work_id': l.workId,
                'progress_unit': l.progressUnit,
                'progress_value': l.progressValue,
                'volume_value': l.volumeValue,
                'note': l.note,
                'recorded_at': l.recordedAt.toIso8601String(),
              })
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(backupMap);
  }

  Future<String> exportToCsv() async {
    final allWorks = await (_db.select(_db.works)
          ..orderBy([(w) => OrderingTerm.desc(w.updatedAt)]))
        .get();

    final List<List<dynamic>> rows = [
      [
        'Title',
        'Author',
        'Status',
        'Format',
        'Current Progress',
        'Total Progress',
        'Progress Unit',
        'Rating',
        'Source URL',
        'Tags',
        'Last Read',
        'Date Started',
        'Date Completed',
        'Synopsis',
        'Notes',
      ]
    ];

    for (final work in allWorks) {
      final tags = await _tagRepo.getTagsForWork(work.id);
      rows.add([
        work.title,
        work.author ?? '',
        work.status,
        work.format,
        work.currentProgress,
        work.totalProgress ?? '',
        work.progressUnit,
        work.rating != null ? (work.rating! / 2.0).toString() : '',
        work.sourceUrl ?? '',
        tags.map((t) => t.name).join('; '),
        work.lastReadAt?.toIso8601String() ?? '',
        work.startedAt?.toIso8601String() ?? '',
        work.completedAt?.toIso8601String() ?? '',
        work.synopsis ?? '',
        work.notes ?? '',
      ]);
    }

    return csv.encode(rows);
  }

  Future<File> exportToZip() async {
    final jsonStr = await exportToJson();
    final archive = Archive();

    // Add library.json
    final jsonBytes = utf8.encode(jsonStr);
    archive.addFile(ArchiveFile('library.json', jsonBytes.length, jsonBytes));

    // Add cover images if any
    final docsDir = await getApplicationDocumentsDirectory();
    final coversDir = Directory(p.join(docsDir.path, 'suci', 'covers'));
    if (await coversDir.exists()) {
      await for (final entity in coversDir.list()) {
        if (entity is File) {
          final bytes = await entity.readAsBytes();
          final filename = p.basename(entity.path);
          archive.addFile(
              ArchiveFile('covers/$filename', bytes.length, bytes));
        }
      }
    }

    final zipData = ZipEncoder().encode(archive);
    final tempDir = await getTemporaryDirectory();
    final zipFile = File(p.join(tempDir.path,
        'suci_backup_${DateTime.now().millisecondsSinceEpoch}.zip'));
    await zipFile.writeAsBytes(zipData);
    return zipFile;
  }

  ImportPreview parseAndValidateJson(String jsonString) {
    final dynamic decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid backup: Expected a JSON object root');
    }

    final version = decoded['suci_version'] as int? ?? 1;
    final works = decoded['works'] as List? ?? [];
    final tags = decoded['tags'] as List? ?? [];
    final logs = decoded['progress_logs'] as List? ?? [];

    return ImportPreview(
      workCount: works.length,
      tagCount: tags.length,
      progressLogCount: logs.length,
      version: version,
      rawData: decoded,
    );
  }

  Future<void> importBackup(Map<String, dynamic> data,
      {required bool overwrite}) async {
    if (overwrite) {
      await _resolver.executeOverwrite(data);
    } else {
      await _resolver.executeMerge(data);
    }
  }
}
