import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/aozora/CachedAozoraBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/aozora/CachedAozoraIndexDataStore.dart';
import 'package:NovelMate/common/datastore/aozora/CachedAozoraTextDataStore.dart';
import 'package:NovelMate/common/datastore/aozora/RemoteAozoraBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/aozora/RemoteAozoraIndexDataStore.dart';
import 'package:NovelMate/common/datastore/aozora/RemoteAozoraTextDataStore.dart';
import 'package:NovelMate/common/datastore/narou/CachedNarouBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/narou/CachedNarouEpisodeDataStore.dart';
import 'package:NovelMate/common/datastore/narou/CachedNarouIndexDataStore.dart';
import 'package:NovelMate/common/datastore/narou/CachedNarouTextDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouBookshelfDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouEpisodeDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouIndexDataStore.dart';
import 'package:NovelMate/common/datastore/narou/RemoteNarouTextDataStore.dart';
import 'package:NovelMate/common/repository/BookshelfRepository.dart';
import 'package:NovelMate/common/repository/BookshelfRepositoryImpl.dart';
import 'package:NovelMate/common/repository/EpisodeRepository.dart';
import 'package:NovelMate/common/repository/EpisodeRepositoryImpl.dart';
import 'package:NovelMate/common/repository/IndexRepository.dart';
import 'package:NovelMate/common/repository/IndexRepositoryImpl.dart';
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
  IndexRepository _indexRepository;
  EpisodeRepository _episodeRepository;
  TextRepository _textRepository;
  SettingRepository _settingRepository;

  /// 実装クラスの解決
  RepositoryFactory._internal() {
    _bookshelfRepository = BookshelfRepositoryImpl({
      AvailableSites.narou: CachedNarouBookshelfDataStore(),
      AvailableSites.aozora: CachedAozoraBookshelfDataStore()
    }, {
      AvailableSites.narou: RemoteNarouBookshelfDataStore(),
      AvailableSites.aozora: RemoteAozoraBookshelfDataStore()
    });
    _indexRepository = IndexRepositoryImpl({
      AvailableSites.narou: CachedNarouIndexDataStore(),
      AvailableSites.aozora: CachedAozoraIndexDataStore()
    }, {
      AvailableSites.narou: RemoteNarouIndexDataStore(),
      AvailableSites.aozora: RemoteAozoraIndexDataStore()
    });
    _episodeRepository = EpisodeRepositoryImpl(
        {AvailableSites.narou: CachedNarouEpisodeDataStore()},
        {AvailableSites.narou: RemoteNarouEpisodeDataStore()});
    _textRepository = TextRepositoryImpl({
      AvailableSites.narou: CachedNarouTextDataStore(),
      AvailableSites.aozora: CachedAozoraTextDataStore()
    }, {
      AvailableSites.narou: RemoteNarouTextDataStore(),
      AvailableSites.aozora: RemoteAozoraTextDataStore()
    });
    _settingRepository = SettingRepositoryImpl();
  }

  /// 実装は隠して外部クラスに公開する
  BookshelfRepository getBookshelfRepository() => _bookshelfRepository;

  IndexRepository getIndexRepository() => _indexRepository;

  EpisodeRepository getEpisodeRepository() => _episodeRepository;

  TextRepository getTextRepository() => _textRepository;

  SettingRepository getSettingRepository() => _settingRepository;
}
