import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/narou/CachedNarouBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/narou/CachedNarouRankingDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouRankingDataStore.dart';
import 'package:NovelMate/common/repository/BookshelfRepository.dart';
import 'package:NovelMate/common/repository/BookshelfRepositoryImpl.dart';
import 'package:NovelMate/common/repository/RankingRepository.dart';
import 'package:NovelMate/common/repository/RankingRepositoryImpl.dart';

/// DIコンテナ
class RepositoryFactory {
  static final RepositoryFactory _singleton = RepositoryFactory._internal();

  factory RepositoryFactory() => _singleton;

  static RepositoryFactory get shared => _singleton;

  BookshelfRepository _bookshelfRepository;
  RankingRepository _rankingRepository;

  /// 実装クラスの解決
  RepositoryFactory._internal() {
    _bookshelfRepository = BookshelfRepositoryImpl(
        {AvailableSites.narou: CachedNarouBookshelfDataStore()},
        {AvailableSites.narou: RemoteNarouBookshelfDataStore()});
    _rankingRepository = RankingRepositoryImpl(
        {AvailableSites.narou: CachedNarouRankingDataStore()},
        {AvailableSites.narou: RemoteNarouRankingDataStore()});
  }

  /// 実装は隠して外部クラスに公開する
  BookshelfRepository getBookshelfRepository() => _bookshelfRepository;

  RankingRepository getRankingRepository() => _rankingRepository;
}
