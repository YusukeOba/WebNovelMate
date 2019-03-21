import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteBookshelfDataStore.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';
import 'package:NovelMate/common/repository/BookshelfRepository.dart';

import 'package:collection/collection.dart';

class BookshelfRepositoryImpl extends BookshelfRepository {
  BookshelfRepositoryImpl(Map<Site, CachedBookshelfDataStore> cacheDataStores,
      Map<Site, RemoteBookshelfDataStore> remoteDataStores)
      : super(cacheDataStores, remoteDataStores);

  @override
  Future<List<SubscribedNovelEntity>> findAll() async {
    return Future(() {
      print(cachedDataStores.toString());

      Iterable<Future<List<SubscribedNovelEntity>>> findResults =
          cachedDataStores.values.map((cacheDataStore) {
        return cacheDataStore.findAll();
      });

      return Future.value(findResults);
    }).then((fetchResults) {
      return Future.wait(fetchResults)
          // List<List<SubscribedNobelEntity>> -> List<SubscribedNovelEntity>
          // へとflatMap
          .then((findAll) =>
              findAll.expand((fetchResult) => fetchResult).toList());
    });
  }

  @override
  Future<void> delete(List<SubscribedNovelEntity> delete) async {
    return Future(() {
      List<Future<void>> deleteTasks = [];
      delete.forEach((novel) {
        // 対応するデータストアを検索する
        final site = novel.novelHeader.identifier.site;

        bool hasDataStore = cachedDataStores.containsKey(site);
        if (hasDataStore) {
          deleteTasks.add(cachedDataStores[site].delete([novel]));
        } else {
          print(
              "this novel is not available. novel data = " + novel.toString());
        }
      });
      return Future.wait(deleteTasks);
    });
  }

  @override
  Future<void> save(List<SubscribedNovelEntity> saveTargets) {
    return Future(() {
      /// 自分のキャッシュを読み出す
      Map<Site, List<SubscribedNovelEntity>> siteGroupedSaveTargets =
          groupBy(saveTargets, (SubscribedNovelEntity element) {
        return element.novelHeader.identifier.site;
      });

      List<Future<void>> saveTasks = [];

      siteGroupedSaveTargets.forEach((site, novels) {
        bool hasDataStore = cachedDataStores.containsKey(site);
        if (hasDataStore) {
          print("try database update. site = " + site.toString());
          print("and novels name = " + novels.toString());
          saveTasks.add(cachedDataStores[site].insertOrUpdate(novels));
        } else {
          // 未対応サイトなので保存できない
          throw Exception(
              "Error. This novels not avaialable site." + novels.toString());
        }
      });

      return Future.wait(saveTasks);
    });
  }

  @override
  Future<void> updateAll() async {
    /// 自分のキャッシュを読み出す
    return findAll().then((novels) {
      // 一括で更新させたほうが早く終わる上に通信コストも掛からないので、
      // サイト毎の連想配列に変換する
      Map<Site, List<SubscribedNovelEntity>> novelOfSites =
          groupBy(novels, (SubscribedNovelEntity element) {
        return element.novelHeader.identifier.site;
      });

      print("grouped by sites");
      print("novels = " + novelOfSites.toString());

      return Future.value(novelOfSites);
    }).then((novelOfSites) {
      /// リモートからの小説取得
      List<SubscribedNovelEntity> updatedNovels = [];
      novelOfSites
          .forEach((Site site, List<SubscribedNovelEntity> novels) async {
        bool hasDataStore = remoteDataStores.containsKey(site);
        if (hasDataStore) {
          // 更新結果
          List<SubscribedNovelEntity> updatedNovelsBySite =
              await remoteDataStores[site].findByNovels(novels);
          // 更新結果を格納する
          updatedNovels.addAll(updatedNovelsBySite);

          print("novel update succeeded. site = " + site.identifier);
        } else {
          // 更新に対応していないサイト
          // そのまま入れておく、、
          updatedNovels.addAll(novels);
          print("novel update failed. this novel is not available. site = " +
              site.identifier);
        }
      });
      return Future.value(updatedNovels);
    }).then((updatedNovels) {
      // 再保存
      return this.save(updatedNovels);
    });
  }
}
