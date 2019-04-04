import 'package:NovelMate/common/datastore/CachedIndexDataStore.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';

class CachedAozoraIndexDataStore extends CachedIndexDataStore {
  List<RankingEntity> _cacheRanking;
  List<RankingEntity> _cacheSearch;

  @override
  Future<bool> hasCache(CacheType cacheType) {
    return Future(() {
      switch (cacheType) {
        case CacheType.ranking:
          return _cacheRanking != null;
        case CacheType.search:
          return _cacheSearch != null;
      }
    });
  }

  @override
  Future<List<RankingEntity>> fetchAll(CacheType cacheType) {
    return Future(() {
      switch (cacheType) {
        case CacheType.ranking:
          return _cacheRanking;
        case CacheType.search:
          return _cacheSearch;
      }
    });
  }

  @override
  Future<void> save(CacheType cacheType, List<RankingEntity> entities) {
    return Future(() {
      switch (cacheType) {
        case CacheType.ranking:
          return _cacheRanking = entities;
        case CacheType.search:
          return _cacheSearch = entities;
      }
    });
  }

  @override
  Future<void> clear(CacheType cacheType) {
    return Future(() {
      switch (cacheType) {
        case CacheType.ranking:
          return _cacheRanking = null;
        case CacheType.search:
          return _cacheSearch = null;
      }
    });
  }
}
