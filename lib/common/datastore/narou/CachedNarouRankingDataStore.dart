import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedRankingDataStore.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';

class CachedNarouRankingDataStore extends CachedRankingDataStore {
  List<RankingEntity> _cache;

  @override
  Site site() {
    return Narou();
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
