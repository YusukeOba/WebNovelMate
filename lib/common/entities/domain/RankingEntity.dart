import 'package:NovelMate/common/entities/domain/NovelHeader.dart';

/// ランキング表示
class RankingEntity {
  /// 順位
  final int popularity;

  /// 小説情報
  final NovelHeader novelHeader;

  RankingEntity.name(this.popularity, this.novelHeader);

}