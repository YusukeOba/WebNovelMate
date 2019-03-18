import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/narou/CachedRankingDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteRankingDataStore.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';
import 'package:NovelMate/common/repository/RankingRepository.dart';

class RankingRepositoryImpl extends RankingRepository {
  RankingRepositoryImpl.name(List<CachedRankingDataStore> cacheDataStores,
      List<RemoteRankingDataStore> remoteRankingDataStores)
      : super.name(cacheDataStores, remoteRankingDataStores);

  @override
  Future<void> setDirty(Site site) {
    final cache =
        cacheDataStores.firstWhere((store) => store.site().identifier == site.identifier);
    return cache.clearAll();
  }

  @override
  Future<List<RankingEntity>> find(
      Site site, int start, int end, String freeWord) async {
    final cache =
        cacheDataStores.firstWhere((store) => store.site().identifier == site.identifier);

    final remote = remoteRankingDataStores
        .firstWhere((store) => store.site().identifier == site.identifier);

    // キャッシュがなければリモート経由で取りに行く、あればキャッシュで取りに行く
    if (await cache.hasCache()) {
      print("find with cache");
      return cache.fetchAll();
    } else {
      print("find with remote");
      return remote.fetchRanking(start, end, title: freeWord).then((rankings) {
        cache.save(rankings);
        return Future(() => rankings);
      });
    }
  }

  @override
  Future<List<RankingEntity>> fetchLatest(Site site) async {
    // 20件のみ取得
    return find(site, 0, 20, "");
  }
}
