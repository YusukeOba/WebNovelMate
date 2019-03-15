import 'package:NovelMate/common/entities/domain/NovelEntity.dart';

/// ランキング表示
class RankingEntity {
  /// 順位
  final int rank;

  /// 小説情報
  final NovelHeader novelHeader;

  RankingEntity.name(this.rank, this.novelHeader);
}