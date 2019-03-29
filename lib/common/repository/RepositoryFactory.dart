import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/narou/CachedNarouBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/narou/CachedNarouEpisodeDataStore.dart';
import 'package:NovelMate/common/datastore/narou/CachedNarouRankingDataStore.dart';
import 'package:NovelMate/common/datastore/narou/CachedNarouTextDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouEpisodeDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouRankingDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouTextDataStore.dart';
import 'package:NovelMate/common/repository/BookshelfRepository.dart';
import 'package:NovelMate/common/repository/BookshelfRepositoryImpl.dart';
import 'package:NovelMate/common/repository/EpisodeRepository.dart';
import 'package:NovelMate/common/repository/EpisodeRepositoryImpl.dart';
import 'package:NovelMate/common/repository/RankingRepository.dart';
import 'package:NovelMate/common/repository/RankingRepositoryImpl.dart';
import 'package:NovelMate/common/repository/SettingRepository.dart';
import 'package:NovelMate/common/repository/SettingRepositoryImpl.dart';
import 'package:NovelMate/common/repository/TextRepository.dart';
import 'package:NovelMate/common/repository/TextRepositoryImpl.dart';

/// DIコンテナ
class RepositoryFactory {
  static final RepositoryFactory _singleton = RepositoryFactory._internal();

  factory RepositoryFactory() => _singleton;

  static RepositoryFactory get shared => _singleton;

  BookshelfRepository _bookshelfRepository;
  RankingRepository _rankingRepository;
  EpisodeRepository _episodeRepository;
  TextRepository _textRepository;
  SettingRepository _settingRepository;

  /// 実装クラスの解決
  RepositoryFactory._internal() {
    _bookshelfRepository = BookshelfRepositoryImpl(
        {AvailableSites.narou: CachedNarouBookshelfDataStore()},
        {AvailableSites.narou: RemoteNarouBookshelfDataStore()});
    _rankingRepository = RankingRepositoryImpl(
        {AvailableSites.narou: CachedNarouRankingDataStore()},
        {AvailableSites.narou: RemoteNarouRankingDataStore()});
    _episodeRepository = EpisodeRepositoryImpl(
        {AvailableSites.narou: CachedNarouEpisodeDataStore()},
        {AvailableSites.narou: RemoteNarouEpisodeDataStore()});
    _textRepository = TextRepositoryImpl(
        {AvailableSites.narou: CachedNarouTextDataStore()},
        {AvailableSites.narou: RemoteNarouTextDataStore()});
    _settingRepository = SettingRepositoryImpl();
  }

  /// 実装は隠して外部クラスに公開する
  BookshelfRepository getBookshelfRepository() => _bookshelfRepository;

  RankingRepository getRankingRepository() => _rankingRepository;

  EpisodeRepository getEpisodeRepository() => _episodeRepository;

  TextRepository getTextRepository() => _textRepository;

  SettingRepository getSettingRepository() => _settingRepository;
}
