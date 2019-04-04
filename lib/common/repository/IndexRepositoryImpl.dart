import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedIndexDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteIndexDataStore.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';
import 'package:NovelMate/common/repository/IndexRepository.dart';

class IndexRepositoryImpl extends IndexRepository {
  IndexRepositoryImpl(Map<Site, CachedIndexDataStore> cacheDataStores,
      Map<Site, RemoteIndexDataStore> remoteDataStores)
      : super(cacheDataStores, remoteDataStores);

  @override
  Future<void> setDirtyRanking(Site site) {
    print("called dirty");
    return cacheDataStores[site].clear(CacheType.ranking);
  }

  @override
  Future<void> setDirtyIndex(Site site) {
    print("called dirty");
    return cacheDataStores[site].clear(CacheType.search);
  }

  @override
  Future<List<RankingEntity>> find(Site site, String freeWord) async {
    final remote = remoteRankingDataStores[site];
    final cache = cacheDataStores[site];
    if (remote == null || cache == null) {
      throw Exception(
          "Error. this novel is unavailable site. Please implements");
    }

    if (await cache.hasCache(CacheType.search)) {
      return cache.fetchAll(CacheType.search);
    } else {
      return remote.fetchIndex(freeWord).then((novels) {
        cache.save(CacheType.search, novels);
        return novels;
      });
    }
  }

  @override
  Future<List<RankingEntity>> fetchRanking(Site site) async {
    final remote = remoteRankingDataStores[site];
    final cache = cacheDataStores[site];
    if (remote == null || cache == null) {
      throw Exception(
          "Error. this novel is unavailable site. Please implements");
    }

    if (await cache.hasCache(CacheType.ranking)) {
      print("fetch by cache.");
      return cache.fetchAll(CacheType.ranking);
    } else {
      return remote.fetchRanking(0, 20).then((lists) async {
        await cache.save(CacheType.ranking, lists);
        print("cache saved.");
        return lists;
      });
    }
  }
}
