// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DatabaseSchema.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class CachedSubscribedNovelEntityData {
  final String siteIdentifier;
  final String siteOfIdentifier;
  final String novelName;
  final String novelStory;
  final String writer;
  final int unreadCount;
  final bool isComplete;
  final int lastUpdatedAt;
  final int textLength;
  final int episodeCount;
  final int lastReadAt;
  final String readingEpisodeIdentifier;
  final int readingEpisodeProgress;
  final bool isShortStory;
  CachedSubscribedNovelEntityData(
      {this.siteIdentifier,
      this.siteOfIdentifier,
      this.novelName,
      this.novelStory,
      this.writer,
      this.unreadCount,
      this.isComplete,
      this.lastUpdatedAt,
      this.textLength,
      this.episodeCount,
      this.lastReadAt,
      this.readingEpisodeIdentifier,
      this.readingEpisodeProgress,
      this.isShortStory});
  factory CachedSubscribedNovelEntityData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    return CachedSubscribedNovelEntityData(
      siteIdentifier: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}site_identifier']),
      siteOfIdentifier: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}site_of_identifier']),
      novelName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}novel_name']),
      novelStory: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}novel_story']),
      writer:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}writer']),
      unreadCount: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}unread_count']),
      isComplete: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_complete']),
      lastUpdatedAt: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated_at']),
      textLength: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}text_length']),
      episodeCount: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}episode_count']),
      lastReadAt: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_read_at']),
      readingEpisodeIdentifier: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}reading_episode_identifier']),
      readingEpisodeProgress: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}reading_episode_progress']),
      isShortStory: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_short_story']),
    );
  }
  factory CachedSubscribedNovelEntityData.fromJson(Map<String, dynamic> json) {
    return CachedSubscribedNovelEntityData(
      siteIdentifier: json['siteIdentifier'] as String,
      siteOfIdentifier: json['siteOfIdentifier'] as String,
      novelName: json['novelName'] as String,
      novelStory: json['novelStory'] as String,
      writer: json['writer'] as String,
      unreadCount: json['unreadCount'] as int,
      isComplete: json['isComplete'] as bool,
      lastUpdatedAt: json['lastUpdatedAt'] as int,
      textLength: json['textLength'] as int,
      episodeCount: json['episodeCount'] as int,
      lastReadAt: json['lastReadAt'] as int,
      readingEpisodeIdentifier: json['readingEpisodeIdentifier'] as String,
      readingEpisodeProgress: json['readingEpisodeProgress'] as int,
      isShortStory: json['isShortStory'] as bool,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'siteIdentifier': siteIdentifier,
      'siteOfIdentifier': siteOfIdentifier,
      'novelName': novelName,
      'novelStory': novelStory,
      'writer': writer,
      'unreadCount': unreadCount,
      'isComplete': isComplete,
      'lastUpdatedAt': lastUpdatedAt,
      'textLength': textLength,
      'episodeCount': episodeCount,
      'lastReadAt': lastReadAt,
      'readingEpisodeIdentifier': readingEpisodeIdentifier,
      'readingEpisodeProgress': readingEpisodeProgress,
      'isShortStory': isShortStory,
    };
  }

  CachedSubscribedNovelEntityData copyWith(
          {String siteIdentifier,
          String siteOfIdentifier,
          String novelName,
          String novelStory,
          String writer,
          int unreadCount,
          bool isComplete,
          int lastUpdatedAt,
          int textLength,
          int episodeCount,
          int lastReadAt,
          String readingEpisodeIdentifier,
          int readingEpisodeProgress,
          bool isShortStory}) =>
      CachedSubscribedNovelEntityData(
        siteIdentifier: siteIdentifier ?? this.siteIdentifier,
        siteOfIdentifier: siteOfIdentifier ?? this.siteOfIdentifier,
        novelName: novelName ?? this.novelName,
        novelStory: novelStory ?? this.novelStory,
        writer: writer ?? this.writer,
        unreadCount: unreadCount ?? this.unreadCount,
        isComplete: isComplete ?? this.isComplete,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
        textLength: textLength ?? this.textLength,
        episodeCount: episodeCount ?? this.episodeCount,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        readingEpisodeIdentifier:
            readingEpisodeIdentifier ?? this.readingEpisodeIdentifier,
        readingEpisodeProgress:
            readingEpisodeProgress ?? this.readingEpisodeProgress,
        isShortStory: isShortStory ?? this.isShortStory,
      );
  @override
  String toString() {
    return (StringBuffer('CachedSubscribedNovelEntityData(')
          ..write('siteIdentifier: $siteIdentifier, ')
          ..write('siteOfIdentifier: $siteOfIdentifier, ')
          ..write('novelName: $novelName, ')
          ..write('novelStory: $novelStory, ')
          ..write('writer: $writer, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('isComplete: $isComplete, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('textLength: $textLength, ')
          ..write('episodeCount: $episodeCount, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('readingEpisodeIdentifier: $readingEpisodeIdentifier, ')
          ..write('readingEpisodeProgress: $readingEpisodeProgress, ')
          ..write('isShortStory: $isShortStory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc(
          $mrjc(
              $mrjc(
                  $mrjc(
                      $mrjc(
                          $mrjc(
                              $mrjc(
                                  $mrjc(
                                      $mrjc(
                                          $mrjc(
                                              $mrjc(
                                                  $mrjc(
                                                      $mrjc(
                                                          0,
                                                          siteIdentifier
                                                              .hashCode),
                                                      siteOfIdentifier
                                                          .hashCode),
                                                  novelName.hashCode),
                                              novelStory.hashCode),
                                          writer.hashCode),
                                      unreadCount.hashCode),
                                  isComplete.hashCode),
                              lastUpdatedAt.hashCode),
                          textLength.hashCode),
                      episodeCount.hashCode),
                  lastReadAt.hashCode),
              readingEpisodeIdentifier.hashCode),
          readingEpisodeProgress.hashCode),
      isShortStory.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is CachedSubscribedNovelEntityData &&
          other.siteIdentifier == siteIdentifier &&
          other.siteOfIdentifier == siteOfIdentifier &&
          other.novelName == novelName &&
          other.novelStory == novelStory &&
          other.writer == writer &&
          other.unreadCount == unreadCount &&
          other.isComplete == isComplete &&
          other.lastUpdatedAt == lastUpdatedAt &&
          other.textLength == textLength &&
          other.episodeCount == episodeCount &&
          other.lastReadAt == lastReadAt &&
          other.readingEpisodeIdentifier == readingEpisodeIdentifier &&
          other.readingEpisodeProgress == readingEpisodeProgress &&
          other.isShortStory == isShortStory);
}

class $CachedSubscribedNovelEntityTable extends CachedSubscribedNovelEntity
    with
        TableInfo<$CachedSubscribedNovelEntityTable,
            CachedSubscribedNovelEntityData> {
  final GeneratedDatabase _db;
  final String _alias;
  $CachedSubscribedNovelEntityTable(this._db, [this._alias]);
  GeneratedTextColumn _siteIdentifier;
  @override
  GeneratedTextColumn get siteIdentifier =>
      _siteIdentifier ??= _constructSiteIdentifier();
  GeneratedTextColumn _constructSiteIdentifier() {
    var cName = 'site_identifier';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'site_identifier',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _siteOfIdentifier;
  @override
  GeneratedTextColumn get siteOfIdentifier =>
      _siteOfIdentifier ??= _constructSiteOfIdentifier();
  GeneratedTextColumn _constructSiteOfIdentifier() {
    var cName = 'site_of_identifier';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'site_of_identifier',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _novelName;
  @override
  GeneratedTextColumn get novelName => _novelName ??= _constructNovelName();
  GeneratedTextColumn _constructNovelName() {
    var cName = 'novel_name';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'novel_name',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _novelStory;
  @override
  GeneratedTextColumn get novelStory => _novelStory ??= _constructNovelStory();
  GeneratedTextColumn _constructNovelStory() {
    var cName = 'novel_story';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'novel_story',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _writer;
  @override
  GeneratedTextColumn get writer => _writer ??= _constructWriter();
  GeneratedTextColumn _constructWriter() {
    var cName = 'writer';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'writer',
      $tableName,
      false,
    );
  }

  GeneratedIntColumn _unreadCount;
  @override
  GeneratedIntColumn get unreadCount =>
      _unreadCount ??= _constructUnreadCount();
  GeneratedIntColumn _constructUnreadCount() {
    var cName = 'unread_count';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedIntColumn(
      'unread_count',
      $tableName,
      false,
    );
  }

  GeneratedBoolColumn _isComplete;
  @override
  GeneratedBoolColumn get isComplete => _isComplete ??= _constructIsComplete();
  GeneratedBoolColumn _constructIsComplete() {
    var cName = 'is_complete';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedBoolColumn(
      'is_complete',
      $tableName,
      false,
    );
  }

  GeneratedIntColumn _lastUpdatedAt;
  @override
  GeneratedIntColumn get lastUpdatedAt =>
      _lastUpdatedAt ??= _constructLastUpdatedAt();
  GeneratedIntColumn _constructLastUpdatedAt() {
    var cName = 'last_updated_at';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedIntColumn(
      'last_updated_at',
      $tableName,
      true,
    );
  }

  GeneratedIntColumn _textLength;
  @override
  GeneratedIntColumn get textLength => _textLength ??= _constructTextLength();
  GeneratedIntColumn _constructTextLength() {
    var cName = 'text_length';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedIntColumn(
      'text_length',
      $tableName,
      false,
    );
  }

  GeneratedIntColumn _episodeCount;
  @override
  GeneratedIntColumn get episodeCount =>
      _episodeCount ??= _constructEpisodeCount();
  GeneratedIntColumn _constructEpisodeCount() {
    var cName = 'episode_count';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedIntColumn(
      'episode_count',
      $tableName,
      false,
    );
  }

  GeneratedIntColumn _lastReadAt;
  @override
  GeneratedIntColumn get lastReadAt => _lastReadAt ??= _constructLastReadAt();
  GeneratedIntColumn _constructLastReadAt() {
    var cName = 'last_read_at';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedIntColumn(
      'last_read_at',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _readingEpisodeIdentifier;
  @override
  GeneratedTextColumn get readingEpisodeIdentifier =>
      _readingEpisodeIdentifier ??= _constructReadingEpisodeIdentifier();
  GeneratedTextColumn _constructReadingEpisodeIdentifier() {
    var cName = 'reading_episode_identifier';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'reading_episode_identifier',
      $tableName,
      true,
    );
  }

  GeneratedIntColumn _readingEpisodeProgress;
  @override
  GeneratedIntColumn get readingEpisodeProgress =>
      _readingEpisodeProgress ??= _constructReadingEpisodeProgress();
  GeneratedIntColumn _constructReadingEpisodeProgress() {
    var cName = 'reading_episode_progress';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedIntColumn(
      'reading_episode_progress',
      $tableName,
      true,
    );
  }

  GeneratedBoolColumn _isShortStory;
  @override
  GeneratedBoolColumn get isShortStory =>
      _isShortStory ??= _constructIsShortStory();
  GeneratedBoolColumn _constructIsShortStory() {
    var cName = 'is_short_story';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedBoolColumn(
      'is_short_story',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        siteIdentifier,
        siteOfIdentifier,
        novelName,
        novelStory,
        writer,
        unreadCount,
        isComplete,
        lastUpdatedAt,
        textLength,
        episodeCount,
        lastReadAt,
        readingEpisodeIdentifier,
        readingEpisodeProgress,
        isShortStory
      ];
  @override
  $CachedSubscribedNovelEntityTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'cached_subscribed_novel_entity';
  @override
  final String actualTableName = 'cached_subscribed_novel_entity';
  @override
  bool validateIntegrity(
          CachedSubscribedNovelEntityData instance, bool isInserting) =>
      siteIdentifier.isAcceptableValue(instance.siteIdentifier, isInserting) &&
      siteOfIdentifier.isAcceptableValue(
          instance.siteOfIdentifier, isInserting) &&
      novelName.isAcceptableValue(instance.novelName, isInserting) &&
      novelStory.isAcceptableValue(instance.novelStory, isInserting) &&
      writer.isAcceptableValue(instance.writer, isInserting) &&
      unreadCount.isAcceptableValue(instance.unreadCount, isInserting) &&
      isComplete.isAcceptableValue(instance.isComplete, isInserting) &&
      lastUpdatedAt.isAcceptableValue(instance.lastUpdatedAt, isInserting) &&
      textLength.isAcceptableValue(instance.textLength, isInserting) &&
      episodeCount.isAcceptableValue(instance.episodeCount, isInserting) &&
      lastReadAt.isAcceptableValue(instance.lastReadAt, isInserting) &&
      readingEpisodeIdentifier.isAcceptableValue(
          instance.readingEpisodeIdentifier, isInserting) &&
      readingEpisodeProgress.isAcceptableValue(
          instance.readingEpisodeProgress, isInserting) &&
      isShortStory.isAcceptableValue(instance.isShortStory, isInserting);
  @override
  Set<GeneratedColumn> get $primaryKey => {siteIdentifier, siteOfIdentifier};
  @override
  CachedSubscribedNovelEntityData map(Map<String, dynamic> data,
      {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CachedSubscribedNovelEntityData.fromData(data, _db,
        prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(CachedSubscribedNovelEntityData d,
      {bool includeNulls = false}) {
    final map = <String, Variable>{};
    if (d.siteIdentifier != null || includeNulls) {
      map['site_identifier'] = Variable<String, StringType>(d.siteIdentifier);
    }
    if (d.siteOfIdentifier != null || includeNulls) {
      map['site_of_identifier'] =
          Variable<String, StringType>(d.siteOfIdentifier);
    }
    if (d.novelName != null || includeNulls) {
      map['novel_name'] = Variable<String, StringType>(d.novelName);
    }
    if (d.novelStory != null || includeNulls) {
      map['novel_story'] = Variable<String, StringType>(d.novelStory);
    }
    if (d.writer != null || includeNulls) {
      map['writer'] = Variable<String, StringType>(d.writer);
    }
    if (d.unreadCount != null || includeNulls) {
      map['unread_count'] = Variable<int, IntType>(d.unreadCount);
    }
    if (d.isComplete != null || includeNulls) {
      map['is_complete'] = Variable<bool, BoolType>(d.isComplete);
    }
    if (d.lastUpdatedAt != null || includeNulls) {
      map['last_updated_at'] = Variable<int, IntType>(d.lastUpdatedAt);
    }
    if (d.textLength != null || includeNulls) {
      map['text_length'] = Variable<int, IntType>(d.textLength);
    }
    if (d.episodeCount != null || includeNulls) {
      map['episode_count'] = Variable<int, IntType>(d.episodeCount);
    }
    if (d.lastReadAt != null || includeNulls) {
      map['last_read_at'] = Variable<int, IntType>(d.lastReadAt);
    }
    if (d.readingEpisodeIdentifier != null || includeNulls) {
      map['reading_episode_identifier'] =
          Variable<String, StringType>(d.readingEpisodeIdentifier);
    }
    if (d.readingEpisodeProgress != null || includeNulls) {
      map['reading_episode_progress'] =
          Variable<int, IntType>(d.readingEpisodeProgress);
    }
    if (d.isShortStory != null || includeNulls) {
      map['is_short_story'] = Variable<bool, BoolType>(d.isShortStory);
    }
    return map;
  }

  @override
  $CachedSubscribedNovelEntityTable createAlias(String alias) {
    return $CachedSubscribedNovelEntityTable(_db, alias);
  }
}

class CachedEpisodeEntityData {
  final String siteIdentifier;
  final String siteOfIdentifier;
  final String episodeIdentifier;
  final int firstWriteAt;
  final int lastUpdateAt;
  final String nullableChapterName;
  final int displayOrder;
  final String episodeName;
  CachedEpisodeEntityData(
      {this.siteIdentifier,
      this.siteOfIdentifier,
      this.episodeIdentifier,
      this.firstWriteAt,
      this.lastUpdateAt,
      this.nullableChapterName,
      this.displayOrder,
      this.episodeName});
  factory CachedEpisodeEntityData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return CachedEpisodeEntityData(
      siteIdentifier: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}site_identifier']),
      siteOfIdentifier: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}site_of_identifier']),
      episodeIdentifier: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}episode_identifier']),
      firstWriteAt: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}first_write_at']),
      lastUpdateAt: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_update_at']),
      nullableChapterName: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}nullable_chapter_name']),
      displayOrder: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}display_order']),
      episodeName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}episode_name']),
    );
  }
  factory CachedEpisodeEntityData.fromJson(Map<String, dynamic> json) {
    return CachedEpisodeEntityData(
      siteIdentifier: json['siteIdentifier'] as String,
      siteOfIdentifier: json['siteOfIdentifier'] as String,
      episodeIdentifier: json['episodeIdentifier'] as String,
      firstWriteAt: json['firstWriteAt'] as int,
      lastUpdateAt: json['lastUpdateAt'] as int,
      nullableChapterName: json['nullableChapterName'] as String,
      displayOrder: json['displayOrder'] as int,
      episodeName: json['episodeName'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'siteIdentifier': siteIdentifier,
      'siteOfIdentifier': siteOfIdentifier,
      'episodeIdentifier': episodeIdentifier,
      'firstWriteAt': firstWriteAt,
      'lastUpdateAt': lastUpdateAt,
      'nullableChapterName': nullableChapterName,
      'displayOrder': displayOrder,
      'episodeName': episodeName,
    };
  }

  CachedEpisodeEntityData copyWith(
          {String siteIdentifier,
          String siteOfIdentifier,
          String episodeIdentifier,
          int firstWriteAt,
          int lastUpdateAt,
          String nullableChapterName,
          int displayOrder,
          String episodeName}) =>
      CachedEpisodeEntityData(
        siteIdentifier: siteIdentifier ?? this.siteIdentifier,
        siteOfIdentifier: siteOfIdentifier ?? this.siteOfIdentifier,
        episodeIdentifier: episodeIdentifier ?? this.episodeIdentifier,
        firstWriteAt: firstWriteAt ?? this.firstWriteAt,
        lastUpdateAt: lastUpdateAt ?? this.lastUpdateAt,
        nullableChapterName: nullableChapterName ?? this.nullableChapterName,
        displayOrder: displayOrder ?? this.displayOrder,
        episodeName: episodeName ?? this.episodeName,
      );
  @override
  String toString() {
    return (StringBuffer('CachedEpisodeEntityData(')
          ..write('siteIdentifier: $siteIdentifier, ')
          ..write('siteOfIdentifier: $siteOfIdentifier, ')
          ..write('episodeIdentifier: $episodeIdentifier, ')
          ..write('firstWriteAt: $firstWriteAt, ')
          ..write('lastUpdateAt: $lastUpdateAt, ')
          ..write('nullableChapterName: $nullableChapterName, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('episodeName: $episodeName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc(
          $mrjc(
              $mrjc(
                  $mrjc(
                      $mrjc(
                          $mrjc($mrjc(0, siteIdentifier.hashCode),
                              siteOfIdentifier.hashCode),
                          episodeIdentifier.hashCode),
                      firstWriteAt.hashCode),
                  lastUpdateAt.hashCode),
              nullableChapterName.hashCode),
          displayOrder.hashCode),
      episodeName.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is CachedEpisodeEntityData &&
          other.siteIdentifier == siteIdentifier &&
          other.siteOfIdentifier == siteOfIdentifier &&
          other.episodeIdentifier == episodeIdentifier &&
          other.firstWriteAt == firstWriteAt &&
          other.lastUpdateAt == lastUpdateAt &&
          other.nullableChapterName == nullableChapterName &&
          other.displayOrder == displayOrder &&
          other.episodeName == episodeName);
}

class $CachedEpisodeEntityTable extends CachedEpisodeEntity
    with TableInfo<$CachedEpisodeEntityTable, CachedEpisodeEntityData> {
  final GeneratedDatabase _db;
  final String _alias;
  $CachedEpisodeEntityTable(this._db, [this._alias]);
  GeneratedTextColumn _siteIdentifier;
  @override
  GeneratedTextColumn get siteIdentifier =>
      _siteIdentifier ??= _constructSiteIdentifier();
  GeneratedTextColumn _constructSiteIdentifier() {
    var cName = 'site_identifier';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'site_identifier',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _siteOfIdentifier;
  @override
  GeneratedTextColumn get siteOfIdentifier =>
      _siteOfIdentifier ??= _constructSiteOfIdentifier();
  GeneratedTextColumn _constructSiteOfIdentifier() {
    var cName = 'site_of_identifier';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'site_of_identifier',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _episodeIdentifier;
  @override
  GeneratedTextColumn get episodeIdentifier =>
      _episodeIdentifier ??= _constructEpisodeIdentifier();
  GeneratedTextColumn _constructEpisodeIdentifier() {
    var cName = 'episode_identifier';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'episode_identifier',
      $tableName,
      false,
    );
  }

  GeneratedIntColumn _firstWriteAt;
  @override
  GeneratedIntColumn get firstWriteAt =>
      _firstWriteAt ??= _constructFirstWriteAt();
  GeneratedIntColumn _constructFirstWriteAt() {
    var cName = 'first_write_at';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedIntColumn(
      'first_write_at',
      $tableName,
      false,
    );
  }

  GeneratedIntColumn _lastUpdateAt;
  @override
  GeneratedIntColumn get lastUpdateAt =>
      _lastUpdateAt ??= _constructLastUpdateAt();
  GeneratedIntColumn _constructLastUpdateAt() {
    var cName = 'last_update_at';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedIntColumn(
      'last_update_at',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _nullableChapterName;
  @override
  GeneratedTextColumn get nullableChapterName =>
      _nullableChapterName ??= _constructNullableChapterName();
  GeneratedTextColumn _constructNullableChapterName() {
    var cName = 'nullable_chapter_name';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'nullable_chapter_name',
      $tableName,
      true,
    );
  }

  GeneratedIntColumn _displayOrder;
  @override
  GeneratedIntColumn get displayOrder =>
      _displayOrder ??= _constructDisplayOrder();
  GeneratedIntColumn _constructDisplayOrder() {
    var cName = 'display_order';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedIntColumn(
      'display_order',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _episodeName;
  @override
  GeneratedTextColumn get episodeName =>
      _episodeName ??= _constructEpisodeName();
  GeneratedTextColumn _constructEpisodeName() {
    var cName = 'episode_name';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'episode_name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        siteIdentifier,
        siteOfIdentifier,
        episodeIdentifier,
        firstWriteAt,
        lastUpdateAt,
        nullableChapterName,
        displayOrder,
        episodeName
      ];
  @override
  $CachedEpisodeEntityTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'cached_episode_entity';
  @override
  final String actualTableName = 'cached_episode_entity';
  @override
  bool validateIntegrity(CachedEpisodeEntityData instance, bool isInserting) =>
      siteIdentifier.isAcceptableValue(instance.siteIdentifier, isInserting) &&
      siteOfIdentifier.isAcceptableValue(
          instance.siteOfIdentifier, isInserting) &&
      episodeIdentifier.isAcceptableValue(
          instance.episodeIdentifier, isInserting) &&
      firstWriteAt.isAcceptableValue(instance.firstWriteAt, isInserting) &&
      lastUpdateAt.isAcceptableValue(instance.lastUpdateAt, isInserting) &&
      nullableChapterName.isAcceptableValue(
          instance.nullableChapterName, isInserting) &&
      displayOrder.isAcceptableValue(instance.displayOrder, isInserting) &&
      episodeName.isAcceptableValue(instance.episodeName, isInserting);
  @override
  Set<GeneratedColumn> get $primaryKey =>
      {siteIdentifier, siteOfIdentifier, episodeIdentifier};
  @override
  CachedEpisodeEntityData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CachedEpisodeEntityData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(CachedEpisodeEntityData d,
      {bool includeNulls = false}) {
    final map = <String, Variable>{};
    if (d.siteIdentifier != null || includeNulls) {
      map['site_identifier'] = Variable<String, StringType>(d.siteIdentifier);
    }
    if (d.siteOfIdentifier != null || includeNulls) {
      map['site_of_identifier'] =
          Variable<String, StringType>(d.siteOfIdentifier);
    }
    if (d.episodeIdentifier != null || includeNulls) {
      map['episode_identifier'] =
          Variable<String, StringType>(d.episodeIdentifier);
    }
    if (d.firstWriteAt != null || includeNulls) {
      map['first_write_at'] = Variable<int, IntType>(d.firstWriteAt);
    }
    if (d.lastUpdateAt != null || includeNulls) {
      map['last_update_at'] = Variable<int, IntType>(d.lastUpdateAt);
    }
    if (d.nullableChapterName != null || includeNulls) {
      map['nullable_chapter_name'] =
          Variable<String, StringType>(d.nullableChapterName);
    }
    if (d.displayOrder != null || includeNulls) {
      map['display_order'] = Variable<int, IntType>(d.displayOrder);
    }
    if (d.episodeName != null || includeNulls) {
      map['episode_name'] = Variable<String, StringType>(d.episodeName);
    }
    return map;
  }

  @override
  $CachedEpisodeEntityTable createAlias(String alias) {
    return $CachedEpisodeEntityTable(_db, alias);
  }
}

class CachedTextEntityData {
  final String siteIdentifier;
  final String siteOfIdentifier;
  final String episodeIdentifier;
  final String episodeText;
  CachedTextEntityData(
      {this.siteIdentifier,
      this.siteOfIdentifier,
      this.episodeIdentifier,
      this.episodeText});
  factory CachedTextEntityData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return CachedTextEntityData(
      siteIdentifier: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}site_identifier']),
      siteOfIdentifier: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}site_of_identifier']),
      episodeIdentifier: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}episode_identifier']),
      episodeText: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}episode_text']),
    );
  }
  factory CachedTextEntityData.fromJson(Map<String, dynamic> json) {
    return CachedTextEntityData(
      siteIdentifier: json['siteIdentifier'] as String,
      siteOfIdentifier: json['siteOfIdentifier'] as String,
      episodeIdentifier: json['episodeIdentifier'] as String,
      episodeText: json['episodeText'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'siteIdentifier': siteIdentifier,
      'siteOfIdentifier': siteOfIdentifier,
      'episodeIdentifier': episodeIdentifier,
      'episodeText': episodeText,
    };
  }

  CachedTextEntityData copyWith(
          {String siteIdentifier,
          String siteOfIdentifier,
          String episodeIdentifier,
          String episodeText}) =>
      CachedTextEntityData(
        siteIdentifier: siteIdentifier ?? this.siteIdentifier,
        siteOfIdentifier: siteOfIdentifier ?? this.siteOfIdentifier,
        episodeIdentifier: episodeIdentifier ?? this.episodeIdentifier,
        episodeText: episodeText ?? this.episodeText,
      );
  @override
  String toString() {
    return (StringBuffer('CachedTextEntityData(')
          ..write('siteIdentifier: $siteIdentifier, ')
          ..write('siteOfIdentifier: $siteOfIdentifier, ')
          ..write('episodeIdentifier: $episodeIdentifier, ')
          ..write('episodeText: $episodeText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc($mrjc($mrjc(0, siteIdentifier.hashCode), siteOfIdentifier.hashCode),
          episodeIdentifier.hashCode),
      episodeText.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is CachedTextEntityData &&
          other.siteIdentifier == siteIdentifier &&
          other.siteOfIdentifier == siteOfIdentifier &&
          other.episodeIdentifier == episodeIdentifier &&
          other.episodeText == episodeText);
}

class $CachedTextEntityTable extends CachedTextEntity
    with TableInfo<$CachedTextEntityTable, CachedTextEntityData> {
  final GeneratedDatabase _db;
  final String _alias;
  $CachedTextEntityTable(this._db, [this._alias]);
  GeneratedTextColumn _siteIdentifier;
  @override
  GeneratedTextColumn get siteIdentifier =>
      _siteIdentifier ??= _constructSiteIdentifier();
  GeneratedTextColumn _constructSiteIdentifier() {
    var cName = 'site_identifier';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'site_identifier',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _siteOfIdentifier;
  @override
  GeneratedTextColumn get siteOfIdentifier =>
      _siteOfIdentifier ??= _constructSiteOfIdentifier();
  GeneratedTextColumn _constructSiteOfIdentifier() {
    var cName = 'site_of_identifier';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'site_of_identifier',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _episodeIdentifier;
  @override
  GeneratedTextColumn get episodeIdentifier =>
      _episodeIdentifier ??= _constructEpisodeIdentifier();
  GeneratedTextColumn _constructEpisodeIdentifier() {
    var cName = 'episode_identifier';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'episode_identifier',
      $tableName,
      false,
    );
  }

  GeneratedTextColumn _episodeText;
  @override
  GeneratedTextColumn get episodeText =>
      _episodeText ??= _constructEpisodeText();
  GeneratedTextColumn _constructEpisodeText() {
    var cName = 'episode_text';
    if (_alias != null) cName = '$_alias.$cName';
    return GeneratedTextColumn(
      'episode_text',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [siteIdentifier, siteOfIdentifier, episodeIdentifier, episodeText];
  @override
  $CachedTextEntityTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'cached_text_entity';
  @override
  final String actualTableName = 'cached_text_entity';
  @override
  bool validateIntegrity(CachedTextEntityData instance, bool isInserting) =>
      siteIdentifier.isAcceptableValue(instance.siteIdentifier, isInserting) &&
      siteOfIdentifier.isAcceptableValue(
          instance.siteOfIdentifier, isInserting) &&
      episodeIdentifier.isAcceptableValue(
          instance.episodeIdentifier, isInserting) &&
      episodeText.isAcceptableValue(instance.episodeText, isInserting);
  @override
  Set<GeneratedColumn> get $primaryKey =>
      {siteIdentifier, siteOfIdentifier, episodeIdentifier};
  @override
  CachedTextEntityData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CachedTextEntityData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(CachedTextEntityData d,
      {bool includeNulls = false}) {
    final map = <String, Variable>{};
    if (d.siteIdentifier != null || includeNulls) {
      map['site_identifier'] = Variable<String, StringType>(d.siteIdentifier);
    }
    if (d.siteOfIdentifier != null || includeNulls) {
      map['site_of_identifier'] =
          Variable<String, StringType>(d.siteOfIdentifier);
    }
    if (d.episodeIdentifier != null || includeNulls) {
      map['episode_identifier'] =
          Variable<String, StringType>(d.episodeIdentifier);
    }
    if (d.episodeText != null || includeNulls) {
      map['episode_text'] = Variable<String, StringType>(d.episodeText);
    }
    return map;
  }

  @override
  $CachedTextEntityTable createAlias(String alias) {
    return $CachedTextEntityTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(const SqlTypeSystem.withDefaults(), e);
  $CachedSubscribedNovelEntityTable _cachedSubscribedNovelEntity;
  $CachedSubscribedNovelEntityTable get cachedSubscribedNovelEntity =>
      _cachedSubscribedNovelEntity ??= $CachedSubscribedNovelEntityTable(this);
  $CachedEpisodeEntityTable _cachedEpisodeEntity;
  $CachedEpisodeEntityTable get cachedEpisodeEntity =>
      _cachedEpisodeEntity ??= $CachedEpisodeEntityTable(this);
  $CachedTextEntityTable _cachedTextEntity;
  $CachedTextEntityTable get cachedTextEntity =>
      _cachedTextEntity ??= $CachedTextEntityTable(this);
  @override
  List<TableInfo> get allTables =>
      [cachedSubscribedNovelEntity, cachedEpisodeEntity, cachedTextEntity];
}
