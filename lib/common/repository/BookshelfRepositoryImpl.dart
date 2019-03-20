import 'package:NovelMate/common/datastore/CachedBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteBookshelfDataStore.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';
import 'package:NovelMate/common/repository/BookshelfRepository.dart';

class BookshelfRepositoryImpl extends BookshelfRepository {
  BookshelfRepositoryImpl(List<CachedBookshelfDataStore> cacheDataStores,
      List<RemoteBookshelfDataStore> remoteDataStores)
      : super(cacheDataStores, remoteDataStores);

  @override
  Future<List<SubscribedNovelEntity>> findAll() async {
    List<Future<List<SubscribedNovelEntity>>> findResults =
        cachedDataStores.map((cacheDataStore) {
      return cacheDataStore.findAll();
    });

    List<SubscribedNovelEntity> bookshelfNovels = new List();
    findResults.forEach((fetchNovelAction) async {
      List<SubscribedNovelEntity> novels = await fetchNovelAction;
      bookshelfNovels.addAll(novels);
    });

    return bookshelfNovels;
  }

  @override
  Future<void> delete(List<SubscribedNovelEntity> delete) {}

  @override
  Future<void> updateAll() {}
}
