import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedTextDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteTextDataStore.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/TextEntity.dart';
import 'package:NovelMate/common/repository/TextRepository.dart';

class TextRepositoryImpl extends TextRepository {
  TextRepositoryImpl(Map<Site, CachedTextDataStore> cacheDataStores,
      Map<Site, RemoteTextDataStore> remoteDataStores)
      : super(cacheDataStores, remoteDataStores);

  @override
  Future<void> deleteByEpisode(
      NovelIdentifier novelIdentifier, String episodeIdentifier) {
    return Future(() async {
      final cache = cachedDataStores[novelIdentifier.site];
      if (cache == null) {
        print("Error. available site is not found.");
        return Future.value();
      }

      return cache.delete(novelIdentifier.siteOfIdentifier,
          episodeIdentifier: episodeIdentifier);
    });
  }

  @override
  Future<void> deleteByNovel(NovelIdentifier novelIdentifier) {
    return Future(() async {
      final cache = cachedDataStores[novelIdentifier.site];
      if (cache == null) {
        print("Error. available site is not found.");
        return Future.value();
      }

      return cache.delete(novelIdentifier.siteOfIdentifier);
    });
  }

  @override
  Future<TextEntity> findByIdentifier(
      NovelIdentifier novelIdentifier, String episodeIdentifier) async {
    return Future(() async {
      final cache = cachedDataStores[novelIdentifier.site];
      final remote = remoteDataStores[novelIdentifier.site];

      // 対応データではない
      if (cache == null || remote == null) {
        throw Exception("findEpisodesByNovel error. Found unavailable site.");
      }

      if (await cache.hasCache(
          novelIdentifier.siteOfIdentifier, episodeIdentifier)) {
        print("fetch text by cache. text id = " + episodeIdentifier);
        return cache.findByEpisodeId(
            novelIdentifier.siteOfIdentifier, episodeIdentifier);
      } else {
        print("fetch text by remote. text id = " + episodeIdentifier);
        return remote
            .findByEpisodeId(novelIdentifier, episodeIdentifier)
            .then((textEntity) async {
          await cache.insertOrUpdate([textEntity].toList());
          print("Save completed.");
          return Future.value(textEntity);
        });
      }
    });
  }
}
