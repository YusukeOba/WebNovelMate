// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DatabaseSchema.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

class CachedNarouSubscribedNovelEntityData {
  final String identifier;
  final String novelName;
  final String novelStory;
  final String writer;
  final int unreadCount;
  final bool isComplete;
  final int lastUpdatedAt;
  final int textLength;
  final int episodeCount;
  final int lastReadAt;
  CachedNarouSubscribedNovelEntityData(
      {this.identifier,
      this.novelName,
      this.novelStory,
      this.writer,
      this.unreadCount,
      this.isComplete,
      this.lastUpdatedAt,
      this.textLength,
      this.episodeCount,
      this.lastReadAt});
  factory CachedNarouSubscribedNovelEntityData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db) {
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    return CachedNarouSubscribedNovelEntityData(
      identifier: stringType.mapFromDatabaseResponse(data['identifier']),
      novelName: stringType.mapFromDatabaseResponse(data['novel_name']),
      novelStory: stringType.mapFromDatabaseResponse(data['novel_story']),
      writer: stringType.mapFromDatabaseResponse(data['writer']),
      unreadCount: intType.mapFromDatabaseResponse(data['unread_count']),
      isComplete: boolType.mapFromDatabaseResponse(data['is_complete']),
      lastUpdatedAt: intType.mapFromDatabaseResponse(data['last_updated_at']),
      textLength: intType.mapFromDatabaseResponse(data['text_length']),
      episodeCount: intType.mapFromDatabaseResponse(data['episode_count']),
      lastReadAt: intType.mapFromDatabaseResponse(data['last_read_at']),
    );
  }
  CachedNarouSubscribedNovelEntityData copyWith(
          {String identifier,
          String novelName,
          String novelStory,
          String writer,
          int unreadCount,
          bool isComplete,
          int lastUpdatedAt,
          int textLength,
          int episodeCount,
          int lastReadAt}) =>
      CachedNarouSubscribedNovelEntityData(
        identifier: identifier ?? this.identifier,
        novelName: novelName ?? this.novelName,
        novelStory: novelStory ?? this.novelStory,
        writer: writer ?? this.writer,
        unreadCount: unreadCount ?? this.unreadCount,
        isComplete: isComplete ?? this.isComplete,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
        textLength: textLength ?? this.textLength,
        episodeCount: episodeCount ?? this.episodeCount,
        lastReadAt: lastReadAt ?? this.lastReadAt,
      );
  @override
  String toString() {
    return (StringBuffer('CachedNarouSubscribedNovelEntityData(')
          ..write('identifier: $identifier, ')
          ..write('novelName: $novelName, ')
          ..write('novelStory: $novelStory, ')
          ..write('writer: $writer, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('isComplete: $isComplete, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('textLength: $textLength, ')
          ..write('episodeCount: $episodeCount, ')
          ..write('lastReadAt: $lastReadAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      (((((((((identifier.hashCode) * 31 + novelName.hashCode) * 31 +
                                                              novelStory
                                                                  .hashCode) *
                                                          31 +
                                                      writer.hashCode) *
                                                  31 +
                                              unreadCount.hashCode) *
                                          31 +
                                      isComplete.hashCode) *
                                  31 +
                              lastUpdatedAt.hashCode) *
                          31 +
                      textLength.hashCode) *
                  31 +
              episodeCount.hashCode) *
          31 +
      lastReadAt.hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is CachedNarouSubscribedNovelEntityData &&
          other.identifier == identifier &&
          other.novelName == novelName &&
          other.novelStory == novelStory &&
          other.writer == writer &&
          other.unreadCount == unreadCount &&
          other.isComplete == isComplete &&
          other.lastUpdatedAt == lastUpdatedAt &&
          other.textLength == textLength &&
          other.episodeCount == episodeCount &&
          other.lastReadAt == lastReadAt);
}

class $CachedNarouSubscribedNovelEntityTable
    extends CachedNarouSubscribedNovelEntity
    implements
        TableInfo<CachedNarouSubscribedNovelEntity,
            CachedNarouSubscribedNovelEntityData> {
  final GeneratedDatabase _db;
  $CachedNarouSubscribedNovelEntityTable(this._db);
  @override
  GeneratedTextColumn get identifier => GeneratedTextColumn(
        'identifier',
        false,
      );
  @override
  GeneratedTextColumn get novelName => GeneratedTextColumn(
        'novel_name',
        false,
      );
  @override
  GeneratedTextColumn get novelStory => GeneratedTextColumn(
        'novel_story',
        false,
      );
  @override
  GeneratedTextColumn get writer => GeneratedTextColumn(
        'writer',
        false,
      );
  @override
  GeneratedIntColumn get unreadCount => GeneratedIntColumn(
        'unread_count',
        false,
      );
  @override
  GeneratedBoolColumn get isComplete => GeneratedBoolColumn(
        'is_complete',
        false,
      );
  @override
  GeneratedIntColumn get lastUpdatedAt => GeneratedIntColumn(
        'last_updated_at',
        false,
      );
  @override
  GeneratedIntColumn get textLength => GeneratedIntColumn(
        'text_length',
        false,
      );
  @override
  GeneratedIntColumn get episodeCount => GeneratedIntColumn(
        'episode_count',
        false,
      );
  @override
  GeneratedIntColumn get lastReadAt => GeneratedIntColumn(
        'last_read_at',
        false,
      );
  @override
  List<GeneratedColumn> get $columns => [
        identifier,
        novelName,
        novelStory,
        writer,
        unreadCount,
        isComplete,
        lastUpdatedAt,
        textLength,
        episodeCount,
        lastReadAt
      ];
  @override
  CachedNarouSubscribedNovelEntity get asDslTable => this;
  @override
  String get $tableName => 'cached_narou_subscribed_novel_entity';
  @override
  bool validateIntegrity(
          CachedNarouSubscribedNovelEntityData instance, bool isInserting) =>
      identifier.isAcceptableValue(instance.identifier, isInserting) &&
      novelName.isAcceptableValue(instance.novelName, isInserting) &&
      novelStory.isAcceptableValue(instance.novelStory, isInserting) &&
      writer.isAcceptableValue(instance.writer, isInserting) &&
      unreadCount.isAcceptableValue(instance.unreadCount, isInserting) &&
      isComplete.isAcceptableValue(instance.isComplete, isInserting) &&
      lastUpdatedAt.isAcceptableValue(instance.lastUpdatedAt, isInserting) &&
      textLength.isAcceptableValue(instance.textLength, isInserting) &&
      episodeCount.isAcceptableValue(instance.episodeCount, isInserting) &&
      lastReadAt.isAcceptableValue(instance.lastReadAt, isInserting);
  @override
  Set<GeneratedColumn> get $primaryKey => {identifier};
  @override
  CachedNarouSubscribedNovelEntityData map(Map<String, dynamic> data) {
    return CachedNarouSubscribedNovelEntityData.fromData(data, _db);
  }

  @override
  Map<String, Variable> entityToSql(CachedNarouSubscribedNovelEntityData d,
      {bool includeNulls = false}) {
    final map = <String, Variable>{};
    if (d.identifier != null || includeNulls) {
      map['identifier'] = Variable<String, StringType>(d.identifier);
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
    return map;
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(const SqlTypeSystem.withDefaults(), e);
  $CachedNarouSubscribedNovelEntityTable get cachedNarouSubscribedNovelEntity =>
      $CachedNarouSubscribedNovelEntityTable(this);
  @override
  List<TableInfo> get allTables => [cachedNarouSubscribedNovelEntity];
}
