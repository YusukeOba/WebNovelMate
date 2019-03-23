import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedRankingDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteRankingDataStore.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';
import 'package:NovelMate/common/repository/RankingRepository.dart';

class RankingRepositoryImpl extends RankingRepository {
  RankingRepositoryImpl(Map<Site, CachedRankingDataStore> cacheDataStores,
      Map<Site, RemoteRankingDataStore> remoteDataStores)
      : super(cacheDataStores, remoteDataStores);

  @override
  Future<void> setDirty(Site site) {
    return cacheDataStores[site].clearAll();
  }

  @override
  Future<List<RankingEntity>> find(
      Site site, int start, int end, String freeWord) async {
    final cache = cacheDataStores[site];

    final remote = remoteRankingDataStores[site];

    if (cache == null || remote == null) {
      // 非対応サイト
      throw Exception(
          "Error. this novel is unavailable site. Please implements.");
    }

    // キャッシュがなければリモート経由で取りに行く、あればキャッシュで取りに行く
    if (await cache.hasCache()) {
      print("find with cache");
      return cache.fetchAll().then((rankings) {
        if (rankings.length == 0) {
          return Future.value([]);
        }
        if (rankings.length < end) {
          return Future.value(rankings.sublist(0, rankings.length));
        }

        return Future.value(rankings.sublist(0, end));
      });
    } else {
      print("find with remote");
      return remote.fetchRanking(start, end, title: freeWord).then((rankings) {
        cache.save(rankings);
        if (rankings.length == 0) {
          return Future.value([]);
        }
        if (rankings.length < end) {
          return Future.value(rankings.sublist(0, rankings.length));
        }

        return Future.value(rankings.sublist(0, end));
      });
    }
  }

  @override
  Future<List<RankingEntity>> fetchLatest(Site site) {
    // 20件のみ取得
    return find(site, 0, 20, "");
  }
}
