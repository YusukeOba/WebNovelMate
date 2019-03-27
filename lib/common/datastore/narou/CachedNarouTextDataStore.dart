import 'package:NovelMate/common/datastore/CachedTextDataStore.dart';
import 'package:NovelMate/common/entities/DatabaseSchema.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/TextEntity.dart';

class CachedNarouTextDataStore extends CachedTextDataStore {
  @override
  Future<TextEntity> findByEpisodeId(
      NovelIdentifier identifier, String episodeIdentifier) {
    print("start find by episode id." + episodeIdentifier);
    return (Database().select(Database().cachedNarouTextEntity)
          ..where((text) =>
              text.siteOfIdentifier.equals(identifier.siteOfIdentifier))
          ..where((text) => text.episodeIdentifier.equals(episodeIdentifier)))
        .get()
        .then((textEntities) {
      if (textEntities.length < 1) {
        throw Exception("Error. This episode text is not found.");
      } else {
        final cachedTextEntity = textEntities.first;
        print("findResult = " + cachedTextEntity.toString());
        return Future.value(TextEntity(cachedTextEntity.siteOfIdentifier,
            cachedTextEntity.episodeIdentifier, cachedTextEntity.episodeText));
      }
    });
  }

  @override
  Future<void> delete(NovelIdentifier identifier,
      {String episodeIdentifier = ""}) {
    print("start text delete.");
    if (episodeIdentifier.isEmpty) {
      return (Database().delete(Database().cachedNarouTextEntity)
            ..where((text) =>
                text.siteOfIdentifier.equals(identifier.siteOfIdentifier)))
          .go();
    } else {
      return (Database().delete(Database().cachedNarouTextEntity)
            ..where((text) =>
                text.siteOfIdentifier.equals(identifier.siteOfIdentifier))
            ..where((text) => text.episodeIdentifier.equals(episodeIdentifier)))
          .go();
    }
  }

  @override
  Future<void> insertOrUpdate(List<TextEntity> textEntities) {
    print("start text insert.");
    List<Future<void>> insertResult = textEntities.map((text) {
      return Database().update(Database().cachedNarouTextEntity).replace(
          CachedNarouTextEntityData(
              siteOfIdentifier: text.siteOfIdentifier,
              episodeIdentifier: text.episodeOfIdentifier,
              episodeText: text.episodeText));
    }).toList();

    return Future.wait(insertResult);
  }

  @override
  Future<bool> hasCache(NovelIdentifier identifier, String episodeIdentifier) {
    print("start hasCache." + episodeIdentifier);
    return (Database().select(Database().cachedNarouTextEntity)
          ..where((text) =>
              text.siteOfIdentifier.equals(identifier.siteOfIdentifier))
          ..where((text) => text.episodeIdentifier.equals(episodeIdentifier))
          ..limit(1))
        .get()
        .then((episode) {
      return Future.value(episode != null && episode.length > 0);
    });
  }
}
