import 'package:NovelMate/common/HttpClient.dart';
import 'package:NovelMate/common/datastore/RemoteTextDataStore.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/TextEntity.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

class RemoteAozoraTextDataStore extends RemoteTextDataStore {
  @override
  Future<TextEntity> findByEpisodeId(
      NovelIdentifier identifier, String episodeIdentifier) {
    final String requestUrl =
        "http://v118-27-3-3.k722.static.cnode.io:8080/api/v0.1/books/" +
            identifier.siteOfIdentifier +
            "/content?format=html";
    print("requestUrl = " + requestUrl);

    return CustomHttpClient.request(HttpMethod.get, requestUrl, (text) => text)
        .then((responseText) {
      return TextEntity(
          identifier.siteOfIdentifier, episodeIdentifier, _build(responseText));
    });
  }

  String _build(String response) {
    Document rootDom = parse(response);

    List<String> outerHtml = new List();
    rootDom.body.children.forEach((element) {
      if (element.id == "contents") {
        return;
      }
      outerHtml.add(element.text);
    });

    return outerHtml.join();
  }
}
