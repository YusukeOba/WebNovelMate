import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedEpisodeDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteEpisodeDataStore.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';

/// 小説の話情報を取得するRepository
abstract class EpisodeRepository {
  Map<Site, CachedEpisodeDataStore> cachedDataStores;
  Map<Site, RemoteEpisodeDataStore> remoteDataStores;

  EpisodeRepository(this.cachedDataStores, this.remoteDataStores);

  /// 小説の固有情報から小説の話情報を取得する
  /// [identifier] 小説の固有情報
  Future<List<EpisodeEntity>> findEpisodesByNovel(NovelIdentifier identifier);

  /// 小説の固有情報から小説の話一覧をすべて削除する
  /// [identifier] 小説の固有情報
  Future<void> deleteByNovel(NovelIdentifier identifier);

  /// 小説の話情報が古くなったフラグを付ける
  /// この関数を呼んだあとは、findEpisodesByNovelで必ずリモート情報を取得する
  Future<void> setDirty();
}
