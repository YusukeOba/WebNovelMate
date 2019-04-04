import 'package:NovelMate/common/datastore/CachedEpisodeDataStore.dart';
import 'package:NovelMate/common/entities/DatabaseSchema.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:moor_flutter/moor_flutter.dart';

class CachedNarouEpisodeDataStore extends CachedEpisodeDataStore {
  /// 話の一覧を保存する
  /// [episodes]は保存対象のEntity
  Future save(NovelIdentifier identifier, List<EpisodeEntity> episodes) {
    FlutterQueryExecutor executor = Database().executor;
    return executor.ensureOpen().then((_) {
      final batch = executor.db.batch();
      print("batch query creating..");

      episodes.forEach((episode) {
        batch.insert("cached_episode_entity", {
          "site_identifier": episode.novelIdentifier.site.identifier,
          "site_of_identifier": episode.novelIdentifier.siteOfIdentifier,
          "episode_identifier": episode.episodeIdentifier,
          "first_write_at": episode.firstWriteAt,
          "last_update_at": episode.lastUpdateAt,
          "nullable_chapter_name": episode.nullableChapterName,
          "display_order": episode.displayOrder,
          "episode_name": episode.episodeName
        });
      });

      print("batch start");
      return batch.commit(noResult: true);
    });
  }

  /// 話の一覧をすべて削除する
  Future<void> deleteByNovel(NovelIdentifier identifier) {
    return (Database().delete(Database().cachedEpisodeEntity)
          ..where((episode) =>
              episode.siteIdentifier.equals(identifier.site.identifier))
          ..where((episode) =>
              episode.siteOfIdentifier.equals(identifier.siteOfIdentifier)))
        .go();
  }

  @override
  Future<bool> hasCache(NovelIdentifier identifier) {
    return (Database().select(Database().cachedEpisodeEntity)
          ..where((episode) =>
              episode.siteIdentifier.equals(identifier.site.identifier))
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
    return (Database().select(Database().cachedEpisodeEntity)
          ..where((episode) =>
              episode.siteIdentifier.equals(identifier.site.identifier))
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
              episode.displayOrder,
              episode.episodeName);
        }).toList());
      }
    });
  }
}
