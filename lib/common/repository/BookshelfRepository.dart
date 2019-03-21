import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteBookshelfDataStore.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';

/// 本棚にある小説の取得/更新を行うRepository
abstract class BookshelfRepository {
  final Map<Site, CachedBookshelfDataStore> cachedDataStores;
  final Map<Site, RemoteBookshelfDataStore> remoteDataStores;

  BookshelfRepository(this.cachedDataStores, this.remoteDataStores);

  /// 本棚に登録した小説をすべて取得する
  Future<List<SubscribedNovelEntity>> findAll();

  /// 本棚に登録する
  Future<void> save(List<SubscribedNovelEntity> saveTargets);

  /// 本棚に登録した小説をすべて更新する
  Future<void> updateAll();

  /// 本棚から小説を削除する
  Future<void> delete(List<SubscribedNovelEntity> delete);
}
