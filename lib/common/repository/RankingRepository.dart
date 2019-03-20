import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedRankingDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteRankingDataStore.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';

/// ランキングの取得/更新を司るRepository
abstract class RankingRepository {
  final List<CachedRankingDataStore> cacheDataStores;
  final List<RemoteRankingDataStore> remoteRankingDataStores;

  RankingRepository(this.cacheDataStores, this.remoteRankingDataStores);

  /// ランキングの取得
  /// [site]で対応するサイト
  Future<List<RankingEntity>> fetchLatest(Site site);

  /// 条件付でランキングを取得
  ///
  /// [site]で対応するサイト
  /// [start]で開始ランキング
  /// [end]で取得する最後のランキング
  /// [freeWord]は自由な文言
  Future<List<RankingEntity>> find(
      Site site, int start, int end, String freeWord);

  /// ランキングの削除
  Future<void> setDirty(Site site);
}
