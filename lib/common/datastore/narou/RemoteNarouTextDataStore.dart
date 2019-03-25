import 'package:NovelMate/common/HttpClient.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class RemoteNarouTextDataStore {
  /// リモートから小説データを取得する
  /// [identifier] 小説サイト、小説サイト中話の固有情報
  /// [episodeIdentifier] 話を特定する固有情報
  Future<String> findByEpisodeId(
      NovelIdentifier identifier, String episodeIdentifier) {
    final String requestUrl = "https://ncode.syosetu.com/" +
        identifier.siteOfIdentifier +
        "/" +
        episodeIdentifier +
        "/";

    print("requestUrl = " + requestUrl);

    return CustomHttpClient.request(HttpMethod.get, requestUrl, (text) => text)
        .then((responseText) {
      return Future.value(_buildByResponseText(responseText));
    });
  }

  String _buildByResponseText(String responseText) {
    Document rootDom = parse(responseText);

    // 本文のdomを抽出
    List<Element> textElements = rootDom.getElementsByClassName("novel_view");

    List<String> texts =
        textElements.map((textElement) => textElement.text.trim()).toList();

    return texts.join();
  }
}
