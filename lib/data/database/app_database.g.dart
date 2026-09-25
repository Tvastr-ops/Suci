// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorksTable extends Works with TableInfo<$WorksTable, Work> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _additionalUrlsMeta = const VerificationMeta(
    'additionalUrls',
  );
  @override
  late final GeneratedColumn<String> additionalUrls = GeneratedColumn<String>(
    'additional_urls',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('web_novel'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('reading'),
  );
  static const VerificationMeta _publicationStatusMeta = const VerificationMeta(
    'publicationStatus',
  );
  @override
  late final GeneratedColumn<String> publicationStatus =
      GeneratedColumn<String>(
        'publication_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('ongoing'),
      );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressUnitMeta = const VerificationMeta(
    'progressUnit',
  );
  @override
  late final GeneratedColumn<String> progressUnit = GeneratedColumn<String>(
    'progress_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('chapter'),
  );
  static const VerificationMeta _currentProgressMeta = const VerificationMeta(
    'currentProgress',
  );
  @override
  late final GeneratedColumn<int> currentProgress = GeneratedColumn<int>(
    'current_progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalProgressMeta = const VerificationMeta(
    'totalProgress',
  );
  @override
  late final GeneratedColumn<int> totalProgress = GeneratedColumn<int>(
    'total_progress',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentVolumeMeta = const VerificationMeta(
    'currentVolume',
  );
  @override
  late final GeneratedColumn<int> currentVolume = GeneratedColumn<int>(
    'current_volume',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalVolumesMeta = const VerificationMeta(
    'totalVolumes',
  );
  @override
  late final GeneratedColumn<int> totalVolumes = GeneratedColumn<int>(
    'total_volumes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _synopsisMeta = const VerificationMeta(
    'synopsis',
  );
  @override
  late final GeneratedColumn<String> synopsis = GeneratedColumn<String>(
    'synopsis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReadAtMeta = const VerificationMeta(
    'lastReadAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReadAt = GeneratedColumn<DateTime>(
    'last_read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    sourceUrl,
    additionalUrls,
    format,
    status,
    publicationStatus,
    coverPath,
    progressUnit,
    currentProgress,
    totalProgress,
    currentVolume,
    totalVolumes,
    rating,
    notes,
    synopsis,
    createdAt,
    updatedAt,
    startedAt,
    completedAt,
    lastReadAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'works';
  @override
  VerificationContext validateIntegrity(
    Insertable<Work> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('additional_urls')) {
      context.handle(
        _additionalUrlsMeta,
        additionalUrls.isAcceptableOrUnknown(
          data['additional_urls']!,
          _additionalUrlsMeta,
        ),
      );
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('publication_status')) {
      context.handle(
        _publicationStatusMeta,
        publicationStatus.isAcceptableOrUnknown(
          data['publication_status']!,
          _publicationStatusMeta,
        ),
      );
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('progress_unit')) {
      context.handle(
        _progressUnitMeta,
        progressUnit.isAcceptableOrUnknown(
          data['progress_unit']!,
          _progressUnitMeta,
        ),
      );
    }
    if (data.containsKey('current_progress')) {
      context.handle(
        _currentProgressMeta,
        currentProgress.isAcceptableOrUnknown(
          data['current_progress']!,
          _currentProgressMeta,
        ),
      );
    }
    if (data.containsKey('total_progress')) {
      context.handle(
        _totalProgressMeta,
        totalProgress.isAcceptableOrUnknown(
          data['total_progress']!,
          _totalProgressMeta,
        ),
      );
    }
    if (data.containsKey('current_volume')) {
      context.handle(
        _currentVolumeMeta,
        currentVolume.isAcceptableOrUnknown(
          data['current_volume']!,
          _currentVolumeMeta,
        ),
      );
    }
    if (data.containsKey('total_volumes')) {
      context.handle(
        _totalVolumesMeta,
        totalVolumes.isAcceptableOrUnknown(
          data['total_volumes']!,
          _totalVolumesMeta,
        ),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('synopsis')) {
      context.handle(
        _synopsisMeta,
        synopsis.isAcceptableOrUnknown(data['synopsis']!, _synopsisMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
        _lastReadAtMeta,
        lastReadAt.isAcceptableOrUnknown(
          data['last_read_at']!,
          _lastReadAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Work map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Work(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      additionalUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}additional_urls'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      publicationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publication_status'],
      )!,
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      progressUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progress_unit'],
      )!,
      currentProgress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_progress'],
      )!,
      totalProgress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_progress'],
      ),
      currentVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_volume'],
      ),
      totalVolumes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_volumes'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      synopsis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}synopsis'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      lastReadAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_read_at'],
      ),
    );
  }

  @override
  $WorksTable createAlias(String alias) {
    return $WorksTable(attachedDatabase, alias);
  }
}

class Work extends DataClass implements Insertable<Work> {
  final String id;
  final String title;
  final String? author;
  final String? sourceUrl;
  final String additionalUrls;
  final String format;
  final String status;
  final String publicationStatus;
  final String? coverPath;
  final String progressUnit;
  final int currentProgress;
  final int? totalProgress;
  final int? currentVolume;
  final int? totalVolumes;
  final int? rating;
  final String? notes;
  final String? synopsis;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? lastReadAt;
  const Work({
    required this.id,
    required this.title,
    this.author,
    this.sourceUrl,
    required this.additionalUrls,
    required this.format,
    required this.status,
    required this.publicationStatus,
    this.coverPath,
    required this.progressUnit,
    required this.currentProgress,
    this.totalProgress,
    this.currentVolume,
    this.totalVolumes,
    this.rating,
    this.notes,
    this.synopsis,
    required this.createdAt,
    required this.updatedAt,
    this.startedAt,
    this.completedAt,
    this.lastReadAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    map['additional_urls'] = Variable<String>(additionalUrls);
    map['format'] = Variable<String>(format);
    map['status'] = Variable<String>(status);
    map['publication_status'] = Variable<String>(publicationStatus);
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    map['progress_unit'] = Variable<String>(progressUnit);
    map['current_progress'] = Variable<int>(currentProgress);
    if (!nullToAbsent || totalProgress != null) {
      map['total_progress'] = Variable<int>(totalProgress);
    }
    if (!nullToAbsent || currentVolume != null) {
      map['current_volume'] = Variable<int>(currentVolume);
    }
    if (!nullToAbsent || totalVolumes != null) {
      map['total_volumes'] = Variable<int>(totalVolumes);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || synopsis != null) {
      map['synopsis'] = Variable<String>(synopsis);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || lastReadAt != null) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt);
    }
    return map;
  }

  WorksCompanion toCompanion(bool nullToAbsent) {
    return WorksCompanion(
      id: Value(id),
      title: Value(title),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      additionalUrls: Value(additionalUrls),
      format: Value(format),
      status: Value(status),
      publicationStatus: Value(publicationStatus),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      progressUnit: Value(progressUnit),
      currentProgress: Value(currentProgress),
      totalProgress: totalProgress == null && nullToAbsent
          ? const Value.absent()
          : Value(totalProgress),
      currentVolume: currentVolume == null && nullToAbsent
          ? const Value.absent()
          : Value(currentVolume),
      totalVolumes: totalVolumes == null && nullToAbsent
          ? const Value.absent()
          : Value(totalVolumes),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      synopsis: synopsis == null && nullToAbsent
          ? const Value.absent()
          : Value(synopsis),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      lastReadAt: lastReadAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadAt),
    );
  }

  factory Work.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Work(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      additionalUrls: serializer.fromJson<String>(json['additionalUrls']),
      format: serializer.fromJson<String>(json['format']),
      status: serializer.fromJson<String>(json['status']),
      publicationStatus: serializer.fromJson<String>(json['publicationStatus']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      progressUnit: serializer.fromJson<String>(json['progressUnit']),
      currentProgress: serializer.fromJson<int>(json['currentProgress']),
      totalProgress: serializer.fromJson<int?>(json['totalProgress']),
      currentVolume: serializer.fromJson<int?>(json['currentVolume']),
      totalVolumes: serializer.fromJson<int?>(json['totalVolumes']),
      rating: serializer.fromJson<int?>(json['rating']),
      notes: serializer.fromJson<String?>(json['notes']),
      synopsis: serializer.fromJson<String?>(json['synopsis']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      lastReadAt: serializer.fromJson<DateTime?>(json['lastReadAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'additionalUrls': serializer.toJson<String>(additionalUrls),
      'format': serializer.toJson<String>(format),
      'status': serializer.toJson<String>(status),
      'publicationStatus': serializer.toJson<String>(publicationStatus),
      'coverPath': serializer.toJson<String?>(coverPath),
      'progressUnit': serializer.toJson<String>(progressUnit),
      'currentProgress': serializer.toJson<int>(currentProgress),
      'totalProgress': serializer.toJson<int?>(totalProgress),
      'currentVolume': serializer.toJson<int?>(currentVolume),
      'totalVolumes': serializer.toJson<int?>(totalVolumes),
      'rating': serializer.toJson<int?>(rating),
      'notes': serializer.toJson<String?>(notes),
      'synopsis': serializer.toJson<String?>(synopsis),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'lastReadAt': serializer.toJson<DateTime?>(lastReadAt),
    };
  }

  Work copyWith({
    String? id,
    String? title,
    Value<String?> author = const Value.absent(),
    Value<String?> sourceUrl = const Value.absent(),
    String? additionalUrls,
    String? format,
    String? status,
    String? publicationStatus,
    Value<String?> coverPath = const Value.absent(),
    String? progressUnit,
    int? currentProgress,
    Value<int?> totalProgress = const Value.absent(),
    Value<int?> currentVolume = const Value.absent(),
    Value<int?> totalVolumes = const Value.absent(),
    Value<int?> rating = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> synopsis = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> lastReadAt = const Value.absent(),
  }) => Work(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author.present ? author.value : this.author,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    additionalUrls: additionalUrls ?? this.additionalUrls,
    format: format ?? this.format,
    status: status ?? this.status,
    publicationStatus: publicationStatus ?? this.publicationStatus,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    progressUnit: progressUnit ?? this.progressUnit,
    currentProgress: currentProgress ?? this.currentProgress,
    totalProgress: totalProgress.present
        ? totalProgress.value
        : this.totalProgress,
    currentVolume: currentVolume.present
        ? currentVolume.value
        : this.currentVolume,
    totalVolumes: totalVolumes.present ? totalVolumes.value : this.totalVolumes,
    rating: rating.present ? rating.value : this.rating,
    notes: notes.present ? notes.value : this.notes,
    synopsis: synopsis.present ? synopsis.value : this.synopsis,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    lastReadAt: lastReadAt.present ? lastReadAt.value : this.lastReadAt,
  );
  Work copyWithCompanion(WorksCompanion data) {
    return Work(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      additionalUrls: data.additionalUrls.present
          ? data.additionalUrls.value
          : this.additionalUrls,
      format: data.format.present ? data.format.value : this.format,
      status: data.status.present ? data.status.value : this.status,
      publicationStatus: data.publicationStatus.present
          ? data.publicationStatus.value
          : this.publicationStatus,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      progressUnit: data.progressUnit.present
          ? data.progressUnit.value
          : this.progressUnit,
      currentProgress: data.currentProgress.present
          ? data.currentProgress.value
          : this.currentProgress,
      totalProgress: data.totalProgress.present
          ? data.totalProgress.value
          : this.totalProgress,
      currentVolume: data.currentVolume.present
          ? data.currentVolume.value
          : this.currentVolume,
      totalVolumes: data.totalVolumes.present
          ? data.totalVolumes.value
          : this.totalVolumes,
      rating: data.rating.present ? data.rating.value : this.rating,
      notes: data.notes.present ? data.notes.value : this.notes,
      synopsis: data.synopsis.present ? data.synopsis.value : this.synopsis,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      lastReadAt: data.lastReadAt.present
          ? data.lastReadAt.value
          : this.lastReadAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Work(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('additionalUrls: $additionalUrls, ')
          ..write('format: $format, ')
          ..write('status: $status, ')
          ..write('publicationStatus: $publicationStatus, ')
          ..write('coverPath: $coverPath, ')
          ..write('progressUnit: $progressUnit, ')
          ..write('currentProgress: $currentProgress, ')
          ..write('totalProgress: $totalProgress, ')
          ..write('currentVolume: $currentVolume, ')
          ..write('totalVolumes: $totalVolumes, ')
          ..write('rating: $rating, ')
          ..write('notes: $notes, ')
          ..write('synopsis: $synopsis, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastReadAt: $lastReadAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    author,
    sourceUrl,
    additionalUrls,
    format,
    status,
    publicationStatus,
    coverPath,
    progressUnit,
    currentProgress,
    totalProgress,
    currentVolume,
    totalVolumes,
    rating,
    notes,
    synopsis,
    createdAt,
    updatedAt,
    startedAt,
    completedAt,
    lastReadAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Work &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.sourceUrl == this.sourceUrl &&
          other.additionalUrls == this.additionalUrls &&
          other.format == this.format &&
          other.status == this.status &&
          other.publicationStatus == this.publicationStatus &&
          other.coverPath == this.coverPath &&
          other.progressUnit == this.progressUnit &&
          other.currentProgress == this.currentProgress &&
          other.totalProgress == this.totalProgress &&
          other.currentVolume == this.currentVolume &&
          other.totalVolumes == this.totalVolumes &&
          other.rating == this.rating &&
          other.notes == this.notes &&
          other.synopsis == this.synopsis &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.lastReadAt == this.lastReadAt);
}

class WorksCompanion extends UpdateCompanion<Work> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> author;
  final Value<String?> sourceUrl;
  final Value<String> additionalUrls;
  final Value<String> format;
  final Value<String> status;
  final Value<String> publicationStatus;
  final Value<String?> coverPath;
  final Value<String> progressUnit;
  final Value<int> currentProgress;
  final Value<int?> totalProgress;
  final Value<int?> currentVolume;
  final Value<int?> totalVolumes;
  final Value<int?> rating;
  final Value<String?> notes;
  final Value<String?> synopsis;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> lastReadAt;
  final Value<int> rowid;
  const WorksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.additionalUrls = const Value.absent(),
    this.format = const Value.absent(),
    this.status = const Value.absent(),
    this.publicationStatus = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.progressUnit = const Value.absent(),
    this.currentProgress = const Value.absent(),
    this.totalProgress = const Value.absent(),
    this.currentVolume = const Value.absent(),
    this.totalVolumes = const Value.absent(),
    this.rating = const Value.absent(),
    this.notes = const Value.absent(),
    this.synopsis = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorksCompanion.insert({
    required String id,
    required String title,
    this.author = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.additionalUrls = const Value.absent(),
    this.format = const Value.absent(),
    this.status = const Value.absent(),
    this.publicationStatus = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.progressUnit = const Value.absent(),
    this.currentProgress = const Value.absent(),
    this.totalProgress = const Value.absent(),
    this.currentVolume = const Value.absent(),
    this.totalVolumes = const Value.absent(),
    this.rating = const Value.absent(),
    this.notes = const Value.absent(),
    this.synopsis = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Work> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? sourceUrl,
    Expression<String>? additionalUrls,
    Expression<String>? format,
    Expression<String>? status,
    Expression<String>? publicationStatus,
    Expression<String>? coverPath,
    Expression<String>? progressUnit,
    Expression<int>? currentProgress,
    Expression<int>? totalProgress,
    Expression<int>? currentVolume,
    Expression<int>? totalVolumes,
    Expression<int>? rating,
    Expression<String>? notes,
    Expression<String>? synopsis,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? lastReadAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (additionalUrls != null) 'additional_urls': additionalUrls,
      if (format != null) 'format': format,
      if (status != null) 'status': status,
      if (publicationStatus != null) 'publication_status': publicationStatus,
      if (coverPath != null) 'cover_path': coverPath,
      if (progressUnit != null) 'progress_unit': progressUnit,
      if (currentProgress != null) 'current_progress': currentProgress,
      if (totalProgress != null) 'total_progress': totalProgress,
      if (currentVolume != null) 'current_volume': currentVolume,
      if (totalVolumes != null) 'total_volumes': totalVolumes,
      if (rating != null) 'rating': rating,
      if (notes != null) 'notes': notes,
      if (synopsis != null) 'synopsis': synopsis,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? author,
    Value<String?>? sourceUrl,
    Value<String>? additionalUrls,
    Value<String>? format,
    Value<String>? status,
    Value<String>? publicationStatus,
    Value<String?>? coverPath,
    Value<String>? progressUnit,
    Value<int>? currentProgress,
    Value<int?>? totalProgress,
    Value<int?>? currentVolume,
    Value<int?>? totalVolumes,
    Value<int?>? rating,
    Value<String?>? notes,
    Value<String?>? synopsis,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? lastReadAt,
    Value<int>? rowid,
  }) {
    return WorksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      additionalUrls: additionalUrls ?? this.additionalUrls,
      format: format ?? this.format,
      status: status ?? this.status,
      publicationStatus: publicationStatus ?? this.publicationStatus,
      coverPath: coverPath ?? this.coverPath,
      progressUnit: progressUnit ?? this.progressUnit,
      currentProgress: currentProgress ?? this.currentProgress,
      totalProgress: totalProgress ?? this.totalProgress,
      currentVolume: currentVolume ?? this.currentVolume,
      totalVolumes: totalVolumes ?? this.totalVolumes,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      synopsis: synopsis ?? this.synopsis,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (additionalUrls.present) {
      map['additional_urls'] = Variable<String>(additionalUrls.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (publicationStatus.present) {
      map['publication_status'] = Variable<String>(publicationStatus.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (progressUnit.present) {
      map['progress_unit'] = Variable<String>(progressUnit.value);
    }
    if (currentProgress.present) {
      map['current_progress'] = Variable<int>(currentProgress.value);
    }
    if (totalProgress.present) {
      map['total_progress'] = Variable<int>(totalProgress.value);
    }
    if (currentVolume.present) {
      map['current_volume'] = Variable<int>(currentVolume.value);
    }
    if (totalVolumes.present) {
      map['total_volumes'] = Variable<int>(totalVolumes.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (synopsis.present) {
      map['synopsis'] = Variable<String>(synopsis.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('additionalUrls: $additionalUrls, ')
          ..write('format: $format, ')
          ..write('status: $status, ')
          ..write('publicationStatus: $publicationStatus, ')
          ..write('coverPath: $coverPath, ')
          ..write('progressUnit: $progressUnit, ')
          ..write('currentProgress: $currentProgress, ')
          ..write('totalProgress: $totalProgress, ')
          ..write('currentVolume: $currentVolume, ')
          ..write('totalVolumes: $totalVolumes, ')
          ..write('rating: $rating, ')
          ..write('notes: $notes, ')
          ..write('synopsis: $synopsis, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  const Tag({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), name: Value(name));
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith({String? id, String? name}) =>
      Tag(id: id ?? this.id, name: name ?? this.name);
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag && other.id == this.id && other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkTagsTable extends WorkTags with TableInfo<$WorkTagsTable, WorkTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workIdMeta = const VerificationMeta('workId');
  @override
  late final GeneratedColumn<String> workId = GeneratedColumn<String>(
    'work_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES works (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [workId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('work_id')) {
      context.handle(
        _workIdMeta,
        workId.isAcceptableOrUnknown(data['work_id']!, _workIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workId, tagId};
  @override
  WorkTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkTag(
      workId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $WorkTagsTable createAlias(String alias) {
    return $WorkTagsTable(attachedDatabase, alias);
  }
}

class WorkTag extends DataClass implements Insertable<WorkTag> {
  final String workId;
  final String tagId;
  const WorkTag({required this.workId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['work_id'] = Variable<String>(workId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  WorkTagsCompanion toCompanion(bool nullToAbsent) {
    return WorkTagsCompanion(workId: Value(workId), tagId: Value(tagId));
  }

  factory WorkTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkTag(
      workId: serializer.fromJson<String>(json['workId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workId': serializer.toJson<String>(workId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  WorkTag copyWith({String? workId, String? tagId}) =>
      WorkTag(workId: workId ?? this.workId, tagId: tagId ?? this.tagId);
  WorkTag copyWithCompanion(WorkTagsCompanion data) {
    return WorkTag(
      workId: data.workId.present ? data.workId.value : this.workId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkTag(')
          ..write('workId: $workId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(workId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkTag &&
          other.workId == this.workId &&
          other.tagId == this.tagId);
}

class WorkTagsCompanion extends UpdateCompanion<WorkTag> {
  final Value<String> workId;
  final Value<String> tagId;
  final Value<int> rowid;
  const WorkTagsCompanion({
    this.workId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkTagsCompanion.insert({
    required String workId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : workId = Value(workId),
       tagId = Value(tagId);
  static Insertable<WorkTag> custom({
    Expression<String>? workId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workId != null) 'work_id': workId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkTagsCompanion copyWith({
    Value<String>? workId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return WorkTagsCompanion(
      workId: workId ?? this.workId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workId.present) {
      map['work_id'] = Variable<String>(workId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkTagsCompanion(')
          ..write('workId: $workId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressLogsTable extends ProgressLogs
    with TableInfo<$ProgressLogsTable, ProgressLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workIdMeta = const VerificationMeta('workId');
  @override
  late final GeneratedColumn<String> workId = GeneratedColumn<String>(
    'work_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES works (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _progressUnitMeta = const VerificationMeta(
    'progressUnit',
  );
  @override
  late final GeneratedColumn<String> progressUnit = GeneratedColumn<String>(
    'progress_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressValueMeta = const VerificationMeta(
    'progressValue',
  );
  @override
  late final GeneratedColumn<int> progressValue = GeneratedColumn<int>(
    'progress_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _volumeValueMeta = const VerificationMeta(
    'volumeValue',
  );
  @override
  late final GeneratedColumn<int> volumeValue = GeneratedColumn<int>(
    'volume_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workId,
    progressUnit,
    progressValue,
    volumeValue,
    note,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('work_id')) {
      context.handle(
        _workIdMeta,
        workId.isAcceptableOrUnknown(data['work_id']!, _workIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workIdMeta);
    }
    if (data.containsKey('progress_unit')) {
      context.handle(
        _progressUnitMeta,
        progressUnit.isAcceptableOrUnknown(
          data['progress_unit']!,
          _progressUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_progressUnitMeta);
    }
    if (data.containsKey('progress_value')) {
      context.handle(
        _progressValueMeta,
        progressValue.isAcceptableOrUnknown(
          data['progress_value']!,
          _progressValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_progressValueMeta);
    }
    if (data.containsKey('volume_value')) {
      context.handle(
        _volumeValueMeta,
        volumeValue.isAcceptableOrUnknown(
          data['volume_value']!,
          _volumeValueMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_id'],
      )!,
      progressUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progress_unit'],
      )!,
      progressValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress_value'],
      )!,
      volumeValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}volume_value'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $ProgressLogsTable createAlias(String alias) {
    return $ProgressLogsTable(attachedDatabase, alias);
  }
}

class ProgressLog extends DataClass implements Insertable<ProgressLog> {
  final String id;
  final String workId;
  final String progressUnit;
  final int progressValue;
  final int? volumeValue;
  final String? note;
  final DateTime recordedAt;
  const ProgressLog({
    required this.id,
    required this.workId,
    required this.progressUnit,
    required this.progressValue,
    this.volumeValue,
    this.note,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['work_id'] = Variable<String>(workId);
    map['progress_unit'] = Variable<String>(progressUnit);
    map['progress_value'] = Variable<int>(progressValue);
    if (!nullToAbsent || volumeValue != null) {
      map['volume_value'] = Variable<int>(volumeValue);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  ProgressLogsCompanion toCompanion(bool nullToAbsent) {
    return ProgressLogsCompanion(
      id: Value(id),
      workId: Value(workId),
      progressUnit: Value(progressUnit),
      progressValue: Value(progressValue),
      volumeValue: volumeValue == null && nullToAbsent
          ? const Value.absent()
          : Value(volumeValue),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      recordedAt: Value(recordedAt),
    );
  }

  factory ProgressLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressLog(
      id: serializer.fromJson<String>(json['id']),
      workId: serializer.fromJson<String>(json['workId']),
      progressUnit: serializer.fromJson<String>(json['progressUnit']),
      progressValue: serializer.fromJson<int>(json['progressValue']),
      volumeValue: serializer.fromJson<int?>(json['volumeValue']),
      note: serializer.fromJson<String?>(json['note']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workId': serializer.toJson<String>(workId),
      'progressUnit': serializer.toJson<String>(progressUnit),
      'progressValue': serializer.toJson<int>(progressValue),
      'volumeValue': serializer.toJson<int?>(volumeValue),
      'note': serializer.toJson<String?>(note),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  ProgressLog copyWith({
    String? id,
    String? workId,
    String? progressUnit,
    int? progressValue,
    Value<int?> volumeValue = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? recordedAt,
  }) => ProgressLog(
    id: id ?? this.id,
    workId: workId ?? this.workId,
    progressUnit: progressUnit ?? this.progressUnit,
    progressValue: progressValue ?? this.progressValue,
    volumeValue: volumeValue.present ? volumeValue.value : this.volumeValue,
    note: note.present ? note.value : this.note,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  ProgressLog copyWithCompanion(ProgressLogsCompanion data) {
    return ProgressLog(
      id: data.id.present ? data.id.value : this.id,
      workId: data.workId.present ? data.workId.value : this.workId,
      progressUnit: data.progressUnit.present
          ? data.progressUnit.value
          : this.progressUnit,
      progressValue: data.progressValue.present
          ? data.progressValue.value
          : this.progressValue,
      volumeValue: data.volumeValue.present
          ? data.volumeValue.value
          : this.volumeValue,
      note: data.note.present ? data.note.value : this.note,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressLog(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('progressUnit: $progressUnit, ')
          ..write('progressValue: $progressValue, ')
          ..write('volumeValue: $volumeValue, ')
          ..write('note: $note, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workId,
    progressUnit,
    progressValue,
    volumeValue,
    note,
    recordedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressLog &&
          other.id == this.id &&
          other.workId == this.workId &&
          other.progressUnit == this.progressUnit &&
          other.progressValue == this.progressValue &&
          other.volumeValue == this.volumeValue &&
          other.note == this.note &&
          other.recordedAt == this.recordedAt);
}

class ProgressLogsCompanion extends UpdateCompanion<ProgressLog> {
  final Value<String> id;
  final Value<String> workId;
  final Value<String> progressUnit;
  final Value<int> progressValue;
  final Value<int?> volumeValue;
  final Value<String?> note;
  final Value<DateTime> recordedAt;
  final Value<int> rowid;
  const ProgressLogsCompanion({
    this.id = const Value.absent(),
    this.workId = const Value.absent(),
    this.progressUnit = const Value.absent(),
    this.progressValue = const Value.absent(),
    this.volumeValue = const Value.absent(),
    this.note = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressLogsCompanion.insert({
    required String id,
    required String workId,
    required String progressUnit,
    required int progressValue,
    this.volumeValue = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime recordedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workId = Value(workId),
       progressUnit = Value(progressUnit),
       progressValue = Value(progressValue),
       recordedAt = Value(recordedAt);
  static Insertable<ProgressLog> custom({
    Expression<String>? id,
    Expression<String>? workId,
    Expression<String>? progressUnit,
    Expression<int>? progressValue,
    Expression<int>? volumeValue,
    Expression<String>? note,
    Expression<DateTime>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workId != null) 'work_id': workId,
      if (progressUnit != null) 'progress_unit': progressUnit,
      if (progressValue != null) 'progress_value': progressValue,
      if (volumeValue != null) 'volume_value': volumeValue,
      if (note != null) 'note': note,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? workId,
    Value<String>? progressUnit,
    Value<int>? progressValue,
    Value<int?>? volumeValue,
    Value<String?>? note,
    Value<DateTime>? recordedAt,
    Value<int>? rowid,
  }) {
    return ProgressLogsCompanion(
      id: id ?? this.id,
      workId: workId ?? this.workId,
      progressUnit: progressUnit ?? this.progressUnit,
      progressValue: progressValue ?? this.progressValue,
      volumeValue: volumeValue ?? this.volumeValue,
      note: note ?? this.note,
      recordedAt: recordedAt ?? this.recordedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workId.present) {
      map['work_id'] = Variable<String>(workId.value);
    }
    if (progressUnit.present) {
      map['progress_unit'] = Variable<String>(progressUnit.value);
    }
    if (progressValue.present) {
      map['progress_value'] = Variable<int>(progressValue.value);
    }
    if (volumeValue.present) {
      map['volume_value'] = Variable<int>(volumeValue.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressLogsCompanion(')
          ..write('id: $id, ')
          ..write('workId: $workId, ')
          ..write('progressUnit: $progressUnit, ')
          ..write('progressValue: $progressValue, ')
          ..write('volumeValue: $volumeValue, ')
          ..write('note: $note, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorksTable works = $WorksTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $WorkTagsTable workTags = $WorkTagsTable(this);
  late final $ProgressLogsTable progressLogs = $ProgressLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    works,
    tags,
    workTags,
    progressLogs,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'works',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('work_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('work_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'works',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('progress_logs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WorksTableCreateCompanionBuilder = WorksCompanion Function({
  required String id,
  required String title,
  Value<String?> author,
  Value<String?> sourceUrl,
  Value<String> additionalUrls,
  Value<String> format,
  Value<String> status,
  Value<String> publicationStatus,
  Value<String?> coverPath,
  Value<String> progressUnit,
  Value<int> currentProgress,
  Value<int?> totalProgress,
  Value<int?> currentVolume,
  Value<int?> totalVolumes,
  Value<int?> rating,
  Value<String?> notes,
  Value<String?> synopsis,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
  Value<DateTime?> lastReadAt,
  Value<int> rowid,
});
typedef $$WorksTableUpdateCompanionBuilder = WorksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> author,
  Value<String?> sourceUrl,
  Value<String> additionalUrls,
  Value<String> format,
  Value<String> status,
  Value<String> publicationStatus,
  Value<String?> coverPath,
  Value<String> progressUnit,
  Value<int> currentProgress,
  Value<int?> totalProgress,
  Value<int?> currentVolume,
  Value<int?> totalVolumes,
  Value<int?> rating,
  Value<String?> notes,
  Value<String?> synopsis,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
  Value<DateTime?> lastReadAt,
  Value<int> rowid,
});

final class $$WorksTableReferences
    extends BaseReferences<_$AppDatabase, $WorksTable, Work> {
  $$WorksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkTagsTable, List<WorkTag>> _workTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.workTags,
    aliasName: 'works__id__work_tags__work_id',
  );

  $$WorkTagsTableProcessedTableManager get workTagsRefs {
    final manager = $$WorkTagsTableTableManager(
      $_db,
      $_db.workTags,
    ).filter((f) => f.workId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProgressLogsTable, List<ProgressLog>>
  _progressLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.progressLogs,
    aliasName: 'works__id__progress_logs__work_id',
  );

  $$ProgressLogsTableProcessedTableManager get progressLogsRefs {
    final manager = $$ProgressLogsTableTableManager(
      $_db,
      $_db.progressLogs,
    ).filter((f) => f.workId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_progressLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorksTableFilterComposer extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get additionalUrls => $composableBuilder(
    column: $table.additionalUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicationStatus => $composableBuilder(
    column: $table.publicationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get progressUnit => $composableBuilder(
    column: $table.progressUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentProgress => $composableBuilder(
    column: $table.currentProgress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalProgress => $composableBuilder(
    column: $table.totalProgress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentVolume => $composableBuilder(
    column: $table.currentVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalVolumes => $composableBuilder(
    column: $table.totalVolumes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get synopsis => $composableBuilder(
    column: $table.synopsis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workTagsRefs(
    Expression<bool> Function($$WorkTagsTableFilterComposer f) f,
  ) {
    final $$WorkTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workTags,
      getReferencedColumn: (t) => t.workId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkTagsTableFilterComposer(
            $db: $db,
            $table: $db.workTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> progressLogsRefs(
    Expression<bool> Function($$ProgressLogsTableFilterComposer f) f,
  ) {
    final $$ProgressLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.progressLogs,
      getReferencedColumn: (t) => t.workId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressLogsTableFilterComposer(
            $db: $db,
            $table: $db.progressLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorksTableOrderingComposer
    extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get additionalUrls => $composableBuilder(
    column: $table.additionalUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicationStatus => $composableBuilder(
    column: $table.publicationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progressUnit => $composableBuilder(
    column: $table.progressUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentProgress => $composableBuilder(
    column: $table.currentProgress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalProgress => $composableBuilder(
    column: $table.totalProgress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentVolume => $composableBuilder(
    column: $table.currentVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalVolumes => $composableBuilder(
    column: $table.totalVolumes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get synopsis => $composableBuilder(
    column: $table.synopsis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get additionalUrls => $composableBuilder(
    column: $table.additionalUrls,
    builder: (column) => column,
  );

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get publicationStatus => $composableBuilder(
    column: $table.publicationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<String> get progressUnit => $composableBuilder(
    column: $table.progressUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentProgress => $composableBuilder(
    column: $table.currentProgress,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalProgress => $composableBuilder(
    column: $table.totalProgress,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentVolume => $composableBuilder(
    column: $table.currentVolume,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalVolumes => $composableBuilder(
    column: $table.totalVolumes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get synopsis =>
      $composableBuilder(column: $table.synopsis, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => column,
  );

  Expression<T> workTagsRefs<T extends Object>(
    Expression<T> Function($$WorkTagsTableAnnotationComposer a) f,
  ) {
    final $$WorkTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workTags,
      getReferencedColumn: (t) => t.workId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.workTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> progressLogsRefs<T extends Object>(
    Expression<T> Function($$ProgressLogsTableAnnotationComposer a) f,
  ) {
    final $$ProgressLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.progressLogs,
      getReferencedColumn: (t) => t.workId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.progressLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorksTable,
          Work,
          $$WorksTableFilterComposer,
          $$WorksTableOrderingComposer,
          $$WorksTableAnnotationComposer,
          $$WorksTableCreateCompanionBuilder,
          $$WorksTableUpdateCompanionBuilder,
          (Work, $$WorksTableReferences),
          Work,
          PrefetchHooks Function({bool workTagsRefs, bool progressLogsRefs})
        > {
  $$WorksTableTableManager(_$AppDatabase db, $WorksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<String> additionalUrls = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> publicationStatus = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String> progressUnit = const Value.absent(),
                Value<int> currentProgress = const Value.absent(),
                Value<int?> totalProgress = const Value.absent(),
                Value<int?> currentVolume = const Value.absent(),
                Value<int?> totalVolumes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> synopsis = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> lastReadAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorksCompanion(
                id: id,
                title: title,
                author: author,
                sourceUrl: sourceUrl,
                additionalUrls: additionalUrls,
                format: format,
                status: status,
                publicationStatus: publicationStatus,
                coverPath: coverPath,
                progressUnit: progressUnit,
                currentProgress: currentProgress,
                totalProgress: totalProgress,
                currentVolume: currentVolume,
                totalVolumes: totalVolumes,
                rating: rating,
                notes: notes,
                synopsis: synopsis,
                createdAt: createdAt,
                updatedAt: updatedAt,
                startedAt: startedAt,
                completedAt: completedAt,
                lastReadAt: lastReadAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> author = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<String> additionalUrls = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> publicationStatus = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String> progressUnit = const Value.absent(),
                Value<int> currentProgress = const Value.absent(),
                Value<int?> totalProgress = const Value.absent(),
                Value<int?> currentVolume = const Value.absent(),
                Value<int?> totalVolumes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> synopsis = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> lastReadAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorksCompanion.insert(
                id: id,
                title: title,
                author: author,
                sourceUrl: sourceUrl,
                additionalUrls: additionalUrls,
                format: format,
                status: status,
                publicationStatus: publicationStatus,
                coverPath: coverPath,
                progressUnit: progressUnit,
                currentProgress: currentProgress,
                totalProgress: totalProgress,
                currentVolume: currentVolume,
                totalVolumes: totalVolumes,
                rating: rating,
                notes: notes,
                synopsis: synopsis,
                createdAt: createdAt,
                updatedAt: updatedAt,
                startedAt: startedAt,
                completedAt: completedAt,
                lastReadAt: lastReadAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorksTable, Work>(table),
                  $$WorksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workTagsRefs = false, progressLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workTagsRefs) db.workTags,
                    if (progressLogsRefs) db.progressLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workTagsRefs)
                        await $_getPrefetchedData<Work, $WorksTable, WorkTag>(
                          currentTable: table,
                          referencedTable: $$WorksTableReferences
                              ._workTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorksTableReferences(
                                db,
                                table,
                                p0,
                              ).workTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (progressLogsRefs)
                        await $_getPrefetchedData<
                          Work,
                          $WorksTable,
                          ProgressLog
                        >(
                          currentTable: table,
                          referencedTable: $$WorksTableReferences
                              ._progressLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorksTableReferences(
                                db,
                                table,
                                p0,
                              ).progressLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorksTable,
      Work,
      $$WorksTableFilterComposer,
      $$WorksTableOrderingComposer,
      $$WorksTableAnnotationComposer,
      $$WorksTableCreateCompanionBuilder,
      $$WorksTableUpdateCompanionBuilder,
      (Work, $$WorksTableReferences),
      Work,
      PrefetchHooks Function({bool workTagsRefs, bool progressLogsRefs})
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  required String id,
  required String name,
  Value<int> rowid,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> rowid,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkTagsTable, List<WorkTag>> _workTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.workTags,
    aliasName: 'tags__id__work_tags__tag_id',
  );

  $$WorkTagsTableProcessedTableManager get workTagsRefs {
    final manager = $$WorkTagsTableTableManager(
      $_db,
      $_db.workTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workTagsRefs(
    Expression<bool> Function($$WorkTagsTableFilterComposer f) f,
  ) {
    final $$WorkTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkTagsTableFilterComposer(
            $db: $db,
            $table: $db.workTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> workTagsRefs<T extends Object>(
    Expression<T> Function($$WorkTagsTableAnnotationComposer a) f,
  ) {
    final $$WorkTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.workTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool workTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => TagsCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int> rowid = const Value.absent(),
          }) => TagsCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, Tag>(table),
                  $$TagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (workTagsRefs) db.workTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, WorkTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences._workTagsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).workTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool workTagsRefs})
    >;
typedef $$WorkTagsTableCreateCompanionBuilder = WorkTagsCompanion Function({
  required String workId,
  required String tagId,
  Value<int> rowid,
});
typedef $$WorkTagsTableUpdateCompanionBuilder = WorkTagsCompanion Function({
  Value<String> workId,
  Value<String> tagId,
  Value<int> rowid,
});

final class $$WorkTagsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkTagsTable, WorkTag> {
  $$WorkTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorksTable _workIdTable(_$AppDatabase db) =>
      db.works.createAlias('work_tags__work_id__works__id');

  $$WorksTableProcessedTableManager get workId {
    final $_column = $_itemColumn<String>('work_id')!;

    final manager = $$WorksTableTableManager(
      $_db,
      $_db.works,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('work_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkTagsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkTagsTable> {
  $$WorkTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$WorksTableFilterComposer get workId {
    final $$WorksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableFilterComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkTagsTable> {
  $$WorkTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$WorksTableOrderingComposer get workId {
    final $$WorksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableOrderingComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkTagsTable> {
  $$WorkTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$WorksTableAnnotationComposer get workId {
    final $$WorksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableAnnotationComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkTagsTable,
          WorkTag,
          $$WorkTagsTableFilterComposer,
          $$WorkTagsTableOrderingComposer,
          $$WorkTagsTableAnnotationComposer,
          $$WorkTagsTableCreateCompanionBuilder,
          $$WorkTagsTableUpdateCompanionBuilder,
          (WorkTag, $$WorkTagsTableReferences),
          WorkTag,
          PrefetchHooks Function({bool workId, bool tagId})
        > {
  $$WorkTagsTableTableManager(_$AppDatabase db, $WorkTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> workId = const Value.absent(),
            Value<String> tagId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => WorkTagsCompanion(workId: workId, tagId: tagId, rowid: rowid),
          createCompanionCallback:
              ({
                required String workId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => WorkTagsCompanion.insert(
                workId: workId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkTagsTable, WorkTag>(table),
                  $$WorkTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.workId,
                        referencedTable: $$WorkTagsTableReferences._workIdTable(
                          db,
                        ),
                        referencedColumn: $$WorkTagsTableReferences
                            ._workIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$WorkTagsTableReferences._tagIdTable(
                          db,
                        ),
                        referencedColumn: $$WorkTagsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkTagsTable,
      WorkTag,
      $$WorkTagsTableFilterComposer,
      $$WorkTagsTableOrderingComposer,
      $$WorkTagsTableAnnotationComposer,
      $$WorkTagsTableCreateCompanionBuilder,
      $$WorkTagsTableUpdateCompanionBuilder,
      (WorkTag, $$WorkTagsTableReferences),
      WorkTag,
      PrefetchHooks Function({bool workId, bool tagId})
    >;
typedef $$ProgressLogsTableCreateCompanionBuilder =
    ProgressLogsCompanion Function({
      required String id,
      required String workId,
      required String progressUnit,
      required int progressValue,
      Value<int?> volumeValue,
      Value<String?> note,
      required DateTime recordedAt,
      Value<int> rowid,
    });
typedef $$ProgressLogsTableUpdateCompanionBuilder =
    ProgressLogsCompanion Function({
      Value<String> id,
      Value<String> workId,
      Value<String> progressUnit,
      Value<int> progressValue,
      Value<int?> volumeValue,
      Value<String?> note,
      Value<DateTime> recordedAt,
      Value<int> rowid,
    });

final class $$ProgressLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ProgressLogsTable, ProgressLog> {
  $$ProgressLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorksTable _workIdTable(_$AppDatabase db) =>
      db.works.createAlias('progress_logs__work_id__works__id');

  $$WorksTableProcessedTableManager get workId {
    final $_column = $_itemColumn<String>('work_id')!;

    final manager = $$WorksTableTableManager(
      $_db,
      $_db.works,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProgressLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressLogsTable> {
  $$ProgressLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get progressUnit => $composableBuilder(
    column: $table.progressUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressValue => $composableBuilder(
    column: $table.progressValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get volumeValue => $composableBuilder(
    column: $table.volumeValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorksTableFilterComposer get workId {
    final $$WorksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableFilterComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressLogsTable> {
  $$ProgressLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progressUnit => $composableBuilder(
    column: $table.progressUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressValue => $composableBuilder(
    column: $table.progressValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get volumeValue => $composableBuilder(
    column: $table.volumeValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorksTableOrderingComposer get workId {
    final $$WorksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableOrderingComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressLogsTable> {
  $$ProgressLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get progressUnit => $composableBuilder(
    column: $table.progressUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progressValue => $composableBuilder(
    column: $table.progressValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get volumeValue => $composableBuilder(
    column: $table.volumeValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  $$WorksTableAnnotationComposer get workId {
    final $$WorksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workId,
      referencedTable: $db.works,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorksTableAnnotationComposer(
            $db: $db,
            $table: $db.works,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressLogsTable,
          ProgressLog,
          $$ProgressLogsTableFilterComposer,
          $$ProgressLogsTableOrderingComposer,
          $$ProgressLogsTableAnnotationComposer,
          $$ProgressLogsTableCreateCompanionBuilder,
          $$ProgressLogsTableUpdateCompanionBuilder,
          (ProgressLog, $$ProgressLogsTableReferences),
          ProgressLog,
          PrefetchHooks Function({bool workId})
        > {
  $$ProgressLogsTableTableManager(_$AppDatabase db, $ProgressLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workId = const Value.absent(),
                Value<String> progressUnit = const Value.absent(),
                Value<int> progressValue = const Value.absent(),
                Value<int?> volumeValue = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressLogsCompanion(
                id: id,
                workId: workId,
                progressUnit: progressUnit,
                progressValue: progressValue,
                volumeValue: volumeValue,
                note: note,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workId,
                required String progressUnit,
                required int progressValue,
                Value<int?> volumeValue = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime recordedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProgressLogsCompanion.insert(
                id: id,
                workId: workId,
                progressUnit: progressUnit,
                progressValue: progressValue,
                volumeValue: volumeValue,
                note: note,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgressLogsTable, ProgressLog>(table),
                  $$ProgressLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.workId,
                        referencedTable: $$ProgressLogsTableReferences
                            ._workIdTable(db),
                        referencedColumn: $$ProgressLogsTableReferences
                            ._workIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProgressLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressLogsTable,
      ProgressLog,
      $$ProgressLogsTableFilterComposer,
      $$ProgressLogsTableOrderingComposer,
      $$ProgressLogsTableAnnotationComposer,
      $$ProgressLogsTableCreateCompanionBuilder,
      $$ProgressLogsTableUpdateCompanionBuilder,
      (ProgressLog, $$ProgressLogsTableReferences),
      ProgressLog,
      PrefetchHooks Function({bool workId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorksTableTableManager get works =>
      $$WorksTableTableManager(_db, _db.works);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$WorkTagsTableTableManager get workTags =>
      $$WorkTagsTableTableManager(_db, _db.workTags);
  $$ProgressLogsTableTableManager get progressLogs =>
      $$ProgressLogsTableTableManager(_db, _db.progressLogs);
}
