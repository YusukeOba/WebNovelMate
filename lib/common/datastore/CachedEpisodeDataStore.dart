import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';

/// キャッシュ上の話情報
abstract class CachedEpisodeDataStore {
  /// 話の一覧を保存する
  /// [episodes]は保存対象のEntity
  Future<void> save(NovelIdentifier identifier, List<EpisodeEntity> episodes);

  /// 話の一覧を取得する
  /// [identifier] その小説の固有ID
  Future<List<EpisodeEntity>> findAllByNovel(NovelIdentifier identifier);

  /// キャッシュに話があるかどうか
  Future<bool> hasCache(NovelIdentifier identifier);

  /// 話の一覧をすべて削除する
  Future<void> deleteByNovel(NovelIdentifier identifier);
}
