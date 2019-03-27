import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/TextEntity.dart';

abstract class CachedTextDataStore {
  /// キャッシュから小説データを取得する
  Future<TextEntity> findByEpisodeId(
      NovelIdentifier identifier, String episodeIdentifier);

  /// キャッシュ上の小説データを更新or新規作成する
  Future<void> insertOrUpdate(List<TextEntity> textEntities);

  /// キャッシュ上の小説データを削除する
  Future<void> delete(NovelIdentifier identifier,
      {String episodeIdentifier = ""});

  /// キャッシュが存在するかどうか
  Future<bool> hasCache(NovelIdentifier identifier, String episodeIdentifier);
}
