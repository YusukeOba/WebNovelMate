import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';

/// DBから本棚のデータを取得するときの抽象化レイヤ
abstract class CachedBookshelfDataStore {
  /// すべて検索する
  Future<List<SubscribedNovelEntity>> findAll();

  /// DBを更新する
  Future<void> insertOrUpdate(List<SubscribedNovelEntity> records);

  /// キャッシュがあるかどうか
  Future<bool> hasCache(SubscribedNovelEntity record);

  /// 削除する
  Future<void> delete(List<SubscribedNovelEntity> records);
}
