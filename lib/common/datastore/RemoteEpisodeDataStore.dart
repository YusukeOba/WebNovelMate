import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';

abstract class RemoteEpisodeDataStore {
  /// 話の一覧を取得する
  Future<List<EpisodeEntity>> findAllByNovel(NovelIdentifier identifier);
}
