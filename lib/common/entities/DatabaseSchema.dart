import 'package:moor_flutter/moor_flutter.dart';

part 'DatabaseSchema.g.dart';

///
/// DBスキーマ群をここに定義する
///

///
/// 本棚
///
class CachedSubscribedNovelEntity extends Table {
  /// 対応サイト
  TextColumn get siteIdentifier => text()();

  /// 対応サイトの中のID
  TextColumn get siteOfIdentifier => text()();

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
  IntColumn get lastUpdatedAt => integer().nullable()();

  /// 文字数
  IntColumn get textLength => integer()();

  /// 話数
  IntColumn get episodeCount => integer()();

  /// 最終閲覧日時
  IntColumn get lastReadAt => integer()();

  /// 最後に読んだ話
  TextColumn get readingEpisodeIdentifier => text().nullable()();

  /// 最後に読んだ話の進捗度
  IntColumn get readingEpisodeProgress => integer().nullable()();

  /// 短編かどうか
  BoolColumn get isShortStory => boolean()();

  @override
  Set<TextColumn> get primaryKey => {siteIdentifier, siteOfIdentifier};
}

/// 小説の話情報
class CachedEpisodeEntity extends Table {
  /// 対応サイト
  TextColumn get siteIdentifier => text()();

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

  /// 表示順序
  IntColumn get displayOrder => integer()();

  /// 話の名前
  TextColumn get episodeName => text()();

  @override
  Set<TextColumn> get primaryKey =>
      {siteIdentifier, siteOfIdentifier, episodeIdentifier};
}

/// 小説本文情報
class CachedTextEntity extends Table {
  /// 対応サイト
  TextColumn get siteIdentifier => text()();

  /// 対応サイトの中のID
  TextColumn get siteOfIdentifier => text()();

  /// 話へのリンク
  TextColumn get episodeIdentifier => text()();

  /// 本文
  TextColumn get episodeText => text()();

  @override
  Set<TextColumn> get primaryKey =>
      {siteIdentifier, siteOfIdentifier, episodeIdentifier};
}

@UseMoor(tables: [
  CachedSubscribedNovelEntity,
  CachedEpisodeEntity,
  CachedTextEntity
])
class Database extends _$Database {
  Database()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'novelmate.sqlite'));

  @override
  int get schemaVersion {
    return 1;
  }
}
