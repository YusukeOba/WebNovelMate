import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedEpisodeDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteEpisodeDataStore.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/repository/EpisodeRepository.dart';

class EpisodeRepositoryImpl extends EpisodeRepository {
  EpisodeRepositoryImpl(Map<Site, CachedEpisodeDataStore> cacheDataStores,
      Map<Site, RemoteEpisodeDataStore> remoteDataStores)
      : super(cacheDataStores, remoteDataStores);

  bool isDirty = false;

  @override
  Future<List<EpisodeEntity>> findEpisodesByNovel(
      NovelIdentifier identifier) async {
    return Future(() async {
      final cache = cachedDataStores[identifier.site];
      final remote = remoteDataStores[identifier.site];

      // 対応データではない
      if (cache == null || remote == null) {
        print("findEpisodesByNovel error. Found unavailable site.");
        return [];
      }

      final hasCache = await cache.hasCache(identifier);

      print("isDirty = " + isDirty.toString());
      print("hasCache = " + hasCache.toString());

      if (isDirty || !hasCache) {
        print("fetch by remote.");
        return remote.findAllByNovel(identifier).then((episodes) {
          print("Remote fetch succeeded. try saving cache.");
          return cache.save(identifier, episodes).then((_) {
            print("Cache save suceeded.");
            return Future.value(episodes);
          });
        });
      } else {
        print("fetch by cache.");
        return cache.findAllByNovel(identifier);
      }
    });
  }

  @override
  Future<Function> setDirty() {
    return Future(() {
      this.isDirty = true;
    });
  }

  @override
  Future<void> deleteByNovel(NovelIdentifier identifier) {
    return Future(() async {
      final cache = cachedDataStores[identifier.site];

      if (cache == null) {
        print("Error. available site is not found.");
        return Future.value();
      }

      return cache.deleteByNovel(identifier);
    });
  }
}
