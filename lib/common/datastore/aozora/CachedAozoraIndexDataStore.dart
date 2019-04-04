import 'package:NovelMate/common/datastore/CachedIndexDataStore.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';

class CachedAozoraIndexDataStore extends CachedIndexDataStore {
  List<RankingEntity> _cache;

  @override
  Future<void> clearAll() {
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
