import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedTextDataStore.dart';
import 'package:NovelMate/common/entities/DatabaseSchema.dart';
import 'package:NovelMate/common/entities/domain/TextEntity.dart';

abstract class BaseCachedTextDataStore extends CachedTextDataStore {

  /// 対応するWebサイト
  Site get sourceSite;

  @override
  Future<TextEntity> findByEpisodeId(
      String siteOfIdentifier, String episodeIdentifier) {
    print("start find by episode id." + episodeIdentifier);
    return (Database().select(Database().cachedTextEntity)
      ..where((text) =>
          text.siteIdentifier.equals(sourceSite.identifier))
      ..where((text) => text.siteOfIdentifier.equals(siteOfIdentifier))
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
  Future<void> delete(String siteOfIdentifier,
      {String episodeIdentifier = ""}) {
    print("start text delete.");
    if (episodeIdentifier.isEmpty) {
      return (Database().delete(Database().cachedTextEntity)
        ..where((text) =>
            text.siteIdentifier.equals(sourceSite.identifier))
        ..where((text) => text.siteOfIdentifier.equals(siteOfIdentifier)))
          .go();
    } else {
      return (Database().delete(Database().cachedTextEntity)
        ..where((text) =>
            text.siteIdentifier.equals(sourceSite.identifier))
        ..where((text) => text.siteOfIdentifier.equals(siteOfIdentifier))
        ..where((text) => text.episodeIdentifier.equals(episodeIdentifier)))
          .go();
    }
  }

  @override
  Future<void> insertOrUpdate(List<TextEntity> textEntities) async {
    print("start text insert.");
    List<Future<void>> insertResult = textEntities.map((text) async {
      return Database().into(Database().cachedTextEntity).insertOrReplace(
          CachedTextEntityData(
              siteIdentifier: sourceSite.identifier,
              siteOfIdentifier: text.siteOfIdentifier,
              episodeIdentifier: text.episodeOfIdentifier,
              episodeText: text.episodeText));
    }).toList();

    return Future.wait(insertResult);
  }

  @override
  Future<bool> hasCache(String siteOfIdentifier, String episodeIdentifier) {
    print("start hasCache. siteOfIdentifier = " + siteOfIdentifier);
    print("start hasCache. episodeIdentifier = " + episodeIdentifier);
    return (Database().select(Database().cachedTextEntity)
      ..where((text) =>
          text.siteIdentifier.equals(sourceSite.identifier))
      ..where((text) => text.siteOfIdentifier.equals(siteOfIdentifier))
      ..where((text) => text.episodeIdentifier.equals(episodeIdentifier))
      ..limit(1))
        .get()
        .then((episode) {
      return Future.value(episode != null && episode.length > 0);
    });
  }
}
