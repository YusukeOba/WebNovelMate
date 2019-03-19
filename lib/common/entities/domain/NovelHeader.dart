import 'package:NovelMate/common/Sites.dart';

///
/// 小説概要の抽象化クラス
///
class NovelHeader {
  
  /// 小説認識用情報
  final NovelIdentifier identifier;
  
  /// 小説名
  final String novelName;
  
  /// あらすじ
  final String novelStory;

  /// 作者
  final String writer;

  /// 完結かどうか
  final bool isComplete;
  
  /// 最終更新日時
  final int lastUpdatedAt;
  
  /// 文字数
  final int textLength;

  NovelHeader.name(this.identifier, this.novelName, this.novelStory,
      this.writer, this.isComplete, this.lastUpdatedAt, this.textLength);

}

/// 小説を識別するための認識用情報
class NovelIdentifier {
  
  /// 小説サイト
  final Site site;

  /// 小説サイト固有のコード
  final String siteIdentifier;

  NovelIdentifier.name(this.site, this.siteIdentifier);

}

