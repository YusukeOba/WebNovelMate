/// 本文のドメインモデル
class TextEntity {
  /// 小説のタイトル
  final String title;

  /// 実際の文言
  /// TODO: ルビ対応
  final String text;

  /// 読破率
  final double readingAmount;

  TextEntity(this.title, this.text, this.readingAmount);
}
