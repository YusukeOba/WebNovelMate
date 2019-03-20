import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedBookshelfDataStore.dart';
import 'package:NovelMate/common/entities/DatabaseSchema.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';
import 'package:moor/moor.dart';

class CachedNarouBookshelfDataStore extends CachedBookshelfDataStore {
  @override
  Future<List<SubscribedNovelEntity>> findAll() {
    return Database()
        // ignore: invalid_use_of_visible_for_testing_member
        .select(Database().cachedNarouSubscribedNovelEntity)
        .get()
        .then((novels) {
      return Future.value(novels.map((novel) {
        return SubscribedNovelEntity(
            NovelHeader(
                NovelIdentifier(Narou(), novel.identifier),
                novel.novelName,
                novel.novelStory,
                novel.writer,
                novel.isComplete,
                novel.lastUpdatedAt,
                novel.textLength),
            novel.lastUpdatedAt,
            novel.unreadCount,
            novel.episodeCount);
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
    });

    return Future.forEach(deleteResult, (element) {});
  }

  @override
  Future<void> insertOrUpdate(List<SubscribedNovelEntity> records) {
    List<Future<void>> insertResult = records.map((entity) {
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
              episodeCount: entity.episodeCount));
    }).toList();

    return Future.forEach(insertResult, (element) {});
  }

  @override
  Site site() {
    return Narou();
  }
}