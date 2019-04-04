import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedIndexDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteIndexDataStore.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';

/// インデックスの取得/更新を司るRepository
abstract class IndexRepository {
  final Map<Site, CachedIndexDataStore> cacheDataStores;
  final Map<Site, RemoteIndexDataStore> remoteRankingDataStores;

  IndexRepository(this.cacheDataStores, this.remoteRankingDataStores);

  /// ランキングの取得
  /// [site]で対応するサイト
  Future<List<RankingEntity>> fetchRanking(Site site);

  /// 条件付でインデックスを取得
  ///
  /// [end]で取得する最後のindex位置
  /// [freeWord]は自由な文言
  Future<List<RankingEntity>> find(
      Site site, String freeWord);

  /// インデックスの削除
  Future<void> setDirty(Site site);
}
