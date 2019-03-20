import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';

/// ネットワークから小説のランキングを取得する処理の抽象化
/// 対応サイトを追加する際、このインタフェースを実装すること
abstract class RemoteRankingDataStore {
  /// 小説の種別
  Site site();

  /// 小説のランキングを取得する
  /// [start]から[end]で順位の取得範囲を決める
  /// [title]は小説のタイトル
  /// [keywords]は小説のタグ
  /// [genres]は小説のジャンル
  Future<List<RankingEntity>> fetchRanking(int start, int end,
      {String title,

      /// フリーワード
      List<String> keywords,

      /// ジャンル
      List<int> genres});
}
