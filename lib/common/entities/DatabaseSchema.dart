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

  @override
  Set<TextColumn> get primaryKey => {identifier};
}

@UseMoor(tables: [CachedNarouSubscribedNovelEntity])
class Database extends _$Database {
  Database()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'database.sqlite'));

  @override
  int get schemaVersion {
    return 1;
  }
}
