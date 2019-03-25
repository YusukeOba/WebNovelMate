import 'package:NovelMate/common/datastore/CachedEpisodeDataStore.dart';
import 'package:NovelMate/common/entities/DatabaseSchema.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';

class CachedNarouEpisodeDataStore extends CachedEpisodeDataStore {
  /// 話の一覧を保存する
  /// [episodes]は保存対象のEntity
  Future<void> save(NovelIdentifier identifier, List<EpisodeEntity> episodes) {
    List<Future<void>> insertResult = episodes.map((episode) {
      return Database().into(Database().cachedNarouEpisodeEntity).insert(
          CachedNarouEpisodeEntityData(
              siteOfIdentifier: identifier.siteOfIdentifier,
              episodeIdentifier: episode.episodeIdentifier,
              firstWriteAt: episode.firstWriteAt,
              lastUpdateAt: episode.lastUpdateAt,
              nullableChapterName: episode.nullableChapterName,
              episodeName: episode.episodeName));
    }).toList();

    return Future.wait(insertResult);
  }

  /// 話の一覧をすべて削除する
  Future<void> deleteByNovel(NovelIdentifier identifier) {
    return (Database().delete(Database().cachedNarouEpisodeEntity)
          ..where((episode) =>
              episode.siteOfIdentifier.equals(identifier.siteOfIdentifier)))
        .go();
  }

  @override
  Future<bool> hasCache(NovelIdentifier identifier) {
    return (Database().select(Database().cachedNarouEpisodeEntity)
          ..where((episode) =>
              episode.siteOfIdentifier.equals(identifier.siteOfIdentifier))
          ..limit(1))
        .get()
        .then((episode) {
      return Future.value(episode != null && episode.length > 0);
    });
  }

  @override
  Future<List<EpisodeEntity>> findAllByNovel(NovelIdentifier identifier) {
    return (Database().select(Database().cachedNarouEpisodeEntity)
          ..where((episode) =>
              episode.siteOfIdentifier.equals(identifier.siteOfIdentifier)))
        .get()
        .then((episodes) {
      if (episodes.length < 1) {
        return Future.value([]);
      } else {
        return Future.value(episodes.map((episode) {
          return EpisodeEntity(
              identifier,
              episode.episodeIdentifier,
              episode.firstWriteAt,
              episode.lastUpdateAt,
              episode.nullableChapterName,
              episode.episodeName);
        }).toList());
      }
    });
  }
}
