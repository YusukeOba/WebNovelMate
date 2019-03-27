/// 本文のドメインモデル
class TextEntity {
  /// 小説固有のID
  final String siteOfIdentifier;

  /// 話の固有のID
  final String episodeOfIdentifier;

  /// 本文
  final String episodeText;

  TextEntity(this.siteOfIdentifier, this.episodeOfIdentifier, this.episodeText);
}
