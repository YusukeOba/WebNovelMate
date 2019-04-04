import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedBookshelfDataStore.dart';
import 'package:NovelMate/common/entities/DatabaseSchema.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';

/// 汎用の本棚の本を取得する処理
abstract class BaseCachedBookshelfDataStore extends CachedBookshelfDataStore {
  /// 依存する対応サイト
  Site get sourceSite;

  @override
  Future<List<SubscribedNovelEntity>> findAll() {
    return (Database()
            // ignore: invalid_use_of_visible_for_testing_member
            .select(Database().cachedSubscribedNovelEntity)
              ..where((entity) =>
                  entity.siteIdentifier.equals(sourceSite.identifier)))
        .get()
        .then((novels) {
      return Future.value(novels.map((novel) {
        print("novel data = " + novel.toString());
        return SubscribedNovelEntity(
            NovelHeader(
                NovelIdentifier(sourceSite, novel.siteOfIdentifier),
                novel.novelName,
                novel.novelStory,
                novel.writer,
                novel.isComplete,
                novel.lastUpdatedAt,
                novel.textLength,
                novel.episodeCount,
                novel.isShortStory),
            novel.lastReadAt,
            novel.unreadCount,
            novel.episodeCount,
            readingProgress: novel.readingEpisodeProgress,
            readingEpisodeIdentifier: novel.readingEpisodeIdentifier);
      }).toList());
    });
  }

  @override
  Future<SubscribedNovelEntity> find(NovelIdentifier identifier) {
    return (Database()
            // ignore: invalid_use_of_visible_for_testing_member
            .select(Database().cachedSubscribedNovelEntity)
              ..where((entity) =>
                  entity.siteOfIdentifier.equals(identifier.siteOfIdentifier))
              ..where((entity) =>
                  entity.siteIdentifier.equals(sourceSite.identifier)))
        .get()
        .then((novels) {
      if (novels == null || novels.length == 0) {
        return null;
      } else {
        final novel = novels.first;
        return SubscribedNovelEntity(
            NovelHeader(
                NovelIdentifier(sourceSite, novel.siteOfIdentifier),
                novel.novelName,
                novel.novelStory,
                novel.writer,
                novel.isComplete,
                novel.lastUpdatedAt,
                novel.textLength,
                novel.episodeCount,
                novel.isShortStory),
            novel.lastReadAt,
            novel.unreadCount,
            novel.episodeCount,
            readingProgress: novel.readingEpisodeProgress,
            readingEpisodeIdentifier: novel.readingEpisodeIdentifier);
      }
    });
  }

  @override
  Future<void> delete(List<SubscribedNovelEntity> records) {
    List<Future<int>> deleteResult = records.map((record) {
      // ignore: invalid_use_of_visible_for_testing_member
      return (Database().delete(Database().cachedSubscribedNovelEntity)
            ..where((cacheEntity) => cacheEntity.siteOfIdentifier
                .equals(record.novelHeader.identifier.siteOfIdentifier))
            ..where((cacheEntity) => cacheEntity.siteIdentifier
                .equals(record.novelHeader.identifier.site.identifier)))
          .go();
    }).toList();

    return Future.wait(deleteResult);
  }

  @override
  Future<bool> hasCache(SubscribedNovelEntity record) {
    print("start hasCache. siteOfIdentifier = " +
        record.novelHeader.identifier.siteOfIdentifier);
    print("start hasCache. site = " +
        record.novelHeader.identifier.site.identifier);
    return (Database().select(Database().cachedSubscribedNovelEntity)
          ..where((text) => text.siteOfIdentifier
              .equals(record.novelHeader.identifier.siteOfIdentifier))
          ..where((cacheEntity) => cacheEntity.siteIdentifier
              .equals(record.novelHeader.identifier.site.identifier))
          ..limit(1))
        .get()
        .then((episode) {
      return Future.value(episode != null && episode.length > 0);
    });
  }

  @override
  Future<void> insertOrUpdate(List<SubscribedNovelEntity> records) async {
    List<Future<void>> insertResult = records.map((entity) async {
      return Database()
          // ignore: invalid_use_of_visible_for_testing_member
          .into(Database().cachedSubscribedNovelEntity)
          .insertOrReplace(CachedSubscribedNovelEntityData(
              siteIdentifier: sourceSite.identifier,
              siteOfIdentifier: entity.novelHeader.identifier.siteOfIdentifier,
              novelName: entity.novelHeader.novelName,
              novelStory: entity.novelHeader.novelStory,
              writer: entity.novelHeader.writer,
              unreadCount: entity.unreadCount,
              isComplete: entity.novelHeader.isComplete,
              lastUpdatedAt: entity.novelHeader.lastUpdatedAt,
              textLength: entity.novelHeader.textLength,
              episodeCount: entity.episodeCount,
              lastReadAt: entity.lastReadAt,
              isShortStory: entity.novelHeader.isShortStory,
              readingEpisodeProgress: entity.readingProgress,
              readingEpisodeIdentifier: entity.readingEpisodeIdentifier));
    }).toList();

    return Future.wait(insertResult);
  }
}
