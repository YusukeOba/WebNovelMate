import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';

/// Networkから本棚のデータを取得するときの抽象化レイヤ
abstract class RemoteBookshelfDataStore {
  /// 小説の種別
  Site site();

  /// ネットワークから最新の小説情報を取得する
  /// [novels] 元々本棚に入れてある小説
  Future<List<SubscribedNovelEntity>> findByNovels(
      List<SubscribedNovelEntity> novels);
}
