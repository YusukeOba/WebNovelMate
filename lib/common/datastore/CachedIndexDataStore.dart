import 'dart:async';
import 'dart:core';

import 'package:NovelMate/common/entities/domain/RankingEntity.dart';

/// インデックス種別
enum CacheType { ranking, search }

/// キャッシュから小説のインデックスを取得する処理の抽象化
/// 対応サイトを追加する際、このインタフェースを実装すること
abstract class CachedIndexDataStore {
  /// キャッシュがあるか
  Future<bool> hasCache(CacheType cacheType);

  /// キャッシュから小説のインデックスを全て取得する
  /// 既にユーザ自身が取得済のキャッシュなので特にここから絞り込みなどする必要はない
  Future<List<RankingEntity>> fetchAll(CacheType cacheType);

  /// キャッシュにデータを保存する
  Future<void> save(CacheType cacheType, List<RankingEntity> entities);

  /// インデックスのキャッシュを削除する
  Future<void> clear(CacheType cacheType);
}
