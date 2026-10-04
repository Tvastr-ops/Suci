import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suci/data/database/app_database.dart';
import 'package:suci/data/repositories/progress_log_repository.dart';
import 'package:suci/data/repositories/tag_repository.dart';
import 'package:suci/data/repositories/work_repository.dart';
import 'package:suci/domain/enums/progress_unit.dart';
import 'package:suci/domain/enums/publication_status.dart';
import 'package:suci/domain/enums/reading_status.dart';
import 'package:suci/domain/enums/work_format.dart';
import 'package:suci/ui/work_form/add_edit_work_view_model.dart';

void main() {
  late AppDatabase db;
  late TagRepository tagRepo;
  late ProgressLogRepository logRepo;
  late WorkRepository workRepo;
  late AddEditWorkViewModel viewModel;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tagRepo = TagRepository(db);
    logRepo = ProgressLogRepository(db);
    workRepo = WorkRepository(db, tagRepo, logRepo);
    viewModel = AddEditWorkViewModel(workRepo: workRepo);
  });

  tearDown(() async {
    await db.close();
  });

  test('AddEditWorkViewModel detectDomain suggests format and tag', () {
    final rr = viewModel.detectDomain('https://www.royalroad.com/fiction/1234/test');
    expect(rr.suggestedFormat, equals(WorkFormat.webNovel));
    expect(rr.suggestedTag, equals('Royal Road'));

    final ao3 = viewModel.detectDomain('https://archiveofourown.org/works/9999');
    expect(ao3.suggestedFormat, equals(WorkFormat.fanfiction));
    expect(ao3.suggestedTag, equals('AO3'));

    final unknown = viewModel.detectDomain('https://example.com/books');
    expect(unknown.suggestedFormat, isNull);
    expect(unknown.suggestedTag, isNull);
  });

  test('AddEditWorkViewModel creates and updates work returning Result', () async {
    // 1. Create work
    final createResult = await viewModel.saveWork(
      title: 'Shadow Slave',
      author: 'Guiltythree',
      format: WorkFormat.webNovel,
      status: ReadingStatus.reading,
      publicationStatus: PublicationStatus.ongoing,
      progressUnit: ProgressUnit.chapter,
      currentProgress: 1500,
      totalProgress: 2000,
      tags: ['Fantasy', 'LitRPG'],
    );

    expect(createResult.isOk, isTrue);
    final workId = createResult.unwrapOr('');
    expect(workId.isNotEmpty, isTrue);

    // 2. Load work as domain model
    final loaded = await viewModel.loadWork(workId);
    expect(loaded, isNotNull);
    expect(loaded!.title, equals('Shadow Slave'));
    expect(loaded.tags, containsAll(['Fantasy', 'LitRPG']));
    expect(loaded.currentProgress, equals(1500));

    // 3. Update work
    final updateResult = await viewModel.saveWork(
      id: workId,
      title: 'Shadow Slave (Updated)',
      author: 'Guiltythree',
      format: WorkFormat.webNovel,
      status: ReadingStatus.completed,
      publicationStatus: PublicationStatus.completed,
      progressUnit: ProgressUnit.chapter,
      currentProgress: 2000,
      totalProgress: 2000,
      tags: ['Fantasy', 'LitRPG', 'Masterpiece'],
    );

    expect(updateResult.isOk, isTrue);
    final updated = await viewModel.loadWork(workId);
    expect(updated!.title, equals('Shadow Slave (Updated)'));
    expect(updated.readStatus, equals(ReadingStatus.completed));
    expect(updated.tags.length, equals(3));
  });
}
