import 'package:NovelMate/common/HttpClient.dart';
import 'package:NovelMate/common/entities/domain/EpisodeEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:intl/intl.dart';

/// なろうの話一覧を取得する処理
class RemoteNarouEpisodeDataStore {
  Future<List<EpisodeEntity>> fetchEpisodeList(
      NovelIdentifier identifier) async {
    final url =
        "https://ncode.syosetu.com/" + identifier.siteOfIdentifier + "/";

    String resopnseText =
        await CustomHttpClient.request(HttpMethod.get, url, (responseText) {
      return responseText;
    });

    Document rootDom = parse(resopnseText);

    List<Element> novelIndexElement =
        rootDom.body.getElementsByClassName("index_box");

    // 小説の話自体が存在しない
    if (novelIndexElement == null || novelIndexElement.length == 0) {
      throw Exception(
          "[index_box] tag is undefined. Skip this novel parse. This novel is invalid format.");
    }

    // 小説の解析処理
    var chapterTitle = "";
    List<EpisodeEntity> episodeEntities = [];
    novelIndexElement.first.children.forEach((element) {
      // 新規チャプターを検出したのでこれを現在処理中のチャプターとする
      if (element.className == "chapter_title" &&
          chapterTitle != element.text) {
        print("Delect new chapter.");
        chapterTitle = element.text;
      }

      // 話を検出
      if (element.className == "novel_sublist2") {
        print("detect episode.");

        // タイトル
        final episodeNameElement = element.children
            .firstWhere((element) => element.className == "subtitle");

        // タイトルが存在しないはありえないのでエラー
        if (episodeNameElement == null) {
          throw Exception("Error. Episode title not detected.");
        }

        final episodeName = episodeNameElement.text;

        final episodeLink = episodeNameElement.children
            .firstWhere((element) => element.localName == "a")
            .attributes["href"];

        // 例) /n6247dd/1/ のうちの「1」だけを抽出
        final episodeIdentifier = episodeLink.split("/")[2];

        // 投稿日時
        final firstWriteDateElement = element.children
            .firstWhere((element) => element.className == "long_update");

        // 投稿日時が存在しないはありえないのでエラー
        if (firstWriteDateElement == null) {
          throw Exception("Error. Episode title not detected.");
        }

        final firstWriteDate = firstWriteDateElement.text;

        // 改稿日時
        String lastUpdate;
        if (firstWriteDateElement.children.length > 0) {
          final lastUpdateElement = firstWriteDateElement.children
              .firstWhere((element) => element.localName == "span");
          lastUpdate = lastUpdateElement.attributes["title"];
        } else {
          // 改稿日時のDOMがない = 改稿されていないので投稿日時と同じ
          lastUpdate = firstWriteDate;
        }

        print("episodeName = " + episodeName);
        print("episodeIdentifier = " + episodeIdentifier);
        print("firstWriteDate = " + firstWriteDate.trim());
        print("lastWriteDate = " + lastUpdate.trim());

        // 投稿時刻をDate型へ
        int firstWriteDateLong = new DateFormat("yyyy/MM/dd HH:mm")
            .parse(firstWriteDate.trim())
            .millisecondsSinceEpoch;

        // 改稿時刻をDate型へ
        int lastUpdateDateLong = new DateFormat("yyyy/MM/dd HH:mm")
            .parse(lastUpdate.trim())
            .millisecondsSinceEpoch;

        // Domain型に変換
        episodeEntities.add(EpisodeEntity(
            identifier,
            episodeIdentifier,
            firstWriteDateLong,
            lastUpdateDateLong,
            chapterTitle.trim(),
            episodeName.trim()));
      }
    });

    print("episodes = " + episodeEntities.toString());

    return Future.value(episodeEntities);
  }
}
