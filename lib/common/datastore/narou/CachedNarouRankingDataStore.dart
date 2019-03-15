import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/narou/CachedRankingDataStore.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';

class CachedNarouRankingDataStore extends CachedRankingDataStore {
  List<RankingEntity> _cache;

  @override
  Site siteIdentifier() {
    return Site.narou;
  }

  @override
  Future<Function> clearAll() {
    return Future(() {
      _cache = null;
    });
  }

  @override
  Future<List<RankingEntity>> fetchAll() {
    return Future(() {
      return _cache;
    });
  }

  @override
  Future<void> save(List<RankingEntity> entities) {
    return Future(() {
      return _cache = entities;
    });
  }

  @override
  Future<bool> hasCache() {
    return Future(() {
      return _cache != null;
    });
  }
}
