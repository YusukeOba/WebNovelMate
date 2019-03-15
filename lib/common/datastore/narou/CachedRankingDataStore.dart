import 'dart:async';
import 'dart:core';

import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';

/// キャッシュから小説のランキングを取得する処理の抽象化
/// 対応サイトを追加する際、このインタフェースを実装すること
abstract class CachedRankingDataStore {
  /// 小説の種別
  Site siteIdentifier();

  /// キャッシュがあるか
  Future<bool> hasCache();

  /// キャッシュから小説のランキングを全て取得する
  /// 既にユーザ自身が取得済のキャッシュなので特にここから絞り込みなどする必要はない
  Future<List<RankingEntity>> fetchAll();

  /// キャッシュにデータを保存する
  Future<void> save(List<RankingEntity> entities);

  /// ランキングのキャッシュを削除する
  Future<void> clearAll();
}
