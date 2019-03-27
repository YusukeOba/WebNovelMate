import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/TextEntity.dart';

abstract class RemoteTextDataStore {
  /// リモートから小説データを取得する
  Future<TextEntity> findByEpisodeId(
      NovelIdentifier identifier, String episodeIdentifier);
}
