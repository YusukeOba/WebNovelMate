import 'package:moor_flutter/moor_flutter.dart';

part 'DatabaseSchema.g.dart';

/// DBスキーマ群をここに定義する
///
///

///
/// なろうの本棚
///
class CachedNarouSubscribedNovelEntity extends Table {
  /// 対応サイトの中のID
  TextColumn get identifier => text()();

  /// 小説名
  TextColumn get novelName => text()();

  /// あらすじ
  TextColumn get novelStory => text()();

  /// 作者
  TextColumn get writer => text()();

  /// 未読話数
  IntColumn get unreadCount => integer()();

  /// 完結かどうか
  BoolColumn get isComplete => boolean()();

  /// 最終更新日時
  IntColumn get lastUpdatedAt => integer()();

  /// 文字数
  IntColumn get textLength => integer()();

  /// 話数
  IntColumn get episodeCount => integer()();

  /// 最終閲覧日時
  IntColumn get lastReadAt => integer()();

  /// 最後に読んだ話
  TextColumn get readingEpisodeIdentifier => text().nullable()();

  @override
  Set<TextColumn> get primaryKey => {identifier};
}

/// なろうの小説の話情報
class CachedNarouEpisodeEntity extends Table {
  /// 対応サイトの中のID
  TextColumn get siteOfIdentifier => text()();

  /// 話へのリンク
  TextColumn get episodeIdentifier => text()();

  /// 投稿日時
  IntColumn get firstWriteAt => integer()();

  /// 最終更新日時（改稿含む)
  IntColumn get lastUpdateAt => integer()();

  /// 属するチャプター
  /// チャプターを設定していない話の場合はnull
  TextColumn get nullableChapterName => text().nullable()();

  /// 話の名前
  TextColumn get episodeName => text()();

  @override
  Set<TextColumn> get primaryKey => {siteOfIdentifier, episodeIdentifier};
}

/// なろうの小説本文情報
class CachedNarouTextEntity extends Table {
  /// 対応サイトの中のID
  TextColumn get siteOfIdentifier => text()();

  /// 話へのリンク
  TextColumn get episodeIdentifier => text()();

  /// 本文
  TextColumn get episodeText => text()();

  @override
  Set<TextColumn> get primaryKey => {siteOfIdentifier, episodeIdentifier};
}

@UseMoor(tables: [
  CachedNarouSubscribedNovelEntity,
  CachedNarouEpisodeEntity,
  CachedNarouTextEntity
])
class Database extends _$Database {
  Database()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'database.sqlite'));

  @override
  int get schemaVersion {
    return 1;
  }
}
