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

  NovelHeader.name(this.identifier, this.novelName, this.novelStory, this.writer);

}

/// 小説を識別するための認識用情報
class NovelIdentifier {
  
  /// 小説サイト
  final Site site;

  /// 小説サイト名
  final String siteName;
  
  /// 小説サイト固有のコード
  final String siteIdentifier;

  NovelIdentifier.name(this.site, this.siteName, this.siteIdentifier);

}

