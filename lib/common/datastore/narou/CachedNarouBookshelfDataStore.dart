import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedBookshelfDataStore.dart';
import 'package:NovelMate/common/entities/DatabaseSchema.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';

class CachedNarouBookshelfDataStore extends CachedBookshelfDataStore {
  @override
  Future<List<SubscribedNovelEntity>> findAll() {
    return Database()
        // ignore: invalid_use_of_visible_for_testing_member
        .select(Database().cachedNarouSubscribedNovelEntity)
        .get()
        .then((novels) {
      return Future.value(novels.map((novel) {
        print("novel data = " + novel.toString());
        return SubscribedNovelEntity(
            NovelHeader(
                NovelIdentifier(AvailableSites.narou, novel.identifier),
                novel.novelName,
                novel.novelStory,
                novel.writer,
                novel.isComplete,
                novel.lastUpdatedAt,
                novel.textLength,
                novel.episodeCount),
            novel.lastReadAt,
            novel.unreadCount,
            novel.episodeCount,
            readingEpisodeIdentifier: novel.readingEpisodeIdentifier);
      }).toList());
    });
  }

  @override
  Future<void> delete(List<SubscribedNovelEntity> records) {
    List<Future<int>> deleteResult = records.map((record) {
      // ignore: invalid_use_of_visible_for_testing_member
      return (Database().delete(Database().cachedNarouSubscribedNovelEntity)
            ..where((cacheEntity) => cacheEntity.identifier
                .equals(record.novelHeader.identifier.siteOfIdentifier)))
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
    return (Database().select(Database().cachedNarouSubscribedNovelEntity)
          ..where((text) => text.identifier
              .equals(record.novelHeader.identifier.siteOfIdentifier))
          ..limit(1))
        .get()
        .then((episode) {
      return Future.value(episode != null && episode.length > 0);
    });
  }

  @override
  Future<void> insertOrUpdate(List<SubscribedNovelEntity> records) async {
    List<Future<void>> insertResult = records.map((entity) async {
      final rawHasCache = await hasCache(entity);
      if (rawHasCache) {
        print("update novel." + entity.toString());
        return Database()
            // ignore: invalid_use_of_visible_for_testing_member
            .update(Database().cachedNarouSubscribedNovelEntity)
            .replace(CachedNarouSubscribedNovelEntityData(
                identifier: entity.novelHeader.identifier.siteOfIdentifier,
                novelName: entity.novelHeader.novelName,
                novelStory: entity.novelHeader.novelStory,
                writer: entity.novelHeader.writer,
                unreadCount: entity.unreadCount,
                isComplete: entity.novelHeader.isComplete,
                lastUpdatedAt: entity.novelHeader.lastUpdatedAt,
                textLength: entity.novelHeader.textLength,
                episodeCount: entity.episodeCount,
                lastReadAt: entity.lastReadAt,
                readingEpisodeIdentifier: entity.readingEpisodeIdentifier))
            .then((result) {
          print("result = " + result.toString());
        });
      } else {
        print("insert novel." + entity.toString());
        return Database()
            // ignore: invalid_use_of_visible_for_testing_member
            .into(Database().cachedNarouSubscribedNovelEntity)
            .insert(CachedNarouSubscribedNovelEntityData(
                identifier: entity.novelHeader.identifier.siteOfIdentifier,
                novelName: entity.novelHeader.novelName,
                novelStory: entity.novelHeader.novelStory,
                writer: entity.novelHeader.writer,
                unreadCount: entity.unreadCount,
                isComplete: entity.novelHeader.isComplete,
                lastUpdatedAt: entity.novelHeader.lastUpdatedAt,
                textLength: entity.novelHeader.textLength,
                episodeCount: entity.episodeCount,
                lastReadAt: entity.lastReadAt,
                readingEpisodeIdentifier: entity.readingEpisodeIdentifier));
      }
    }).toList();

    return Future.wait(insertResult);
  }
}
