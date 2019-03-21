import 'dart:convert';

import 'package:NovelMate/common/HttpClient.dart';
import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/RemoteBookshelfDataStore.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';
import 'package:NovelMate/common/entities/narou/NarouNovelListEntity.dart';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

/// なろうの小説の更新処理
class RemoteNarouBookshelfDataStore extends RemoteBookshelfDataStore {
  @override
  Future<List<SubscribedNovelEntity>> findByNovels(
      List<SubscribedNovelEntity> novels) {
    // 更新対象の小説
    // 負荷がかからないように<nCode, 小説データ>の連想配列を作っておく
    final Map<String, SubscribedNovelEntity> updateTargetNovels =
        novels.asMap().map((index, SubscribedNovelEntity novel) {
      return MapEntry(novel.novelHeader.identifier.siteOfIdentifier, novel);
    });

    final nCodes = novels.map((novel) {
      return novel.novelHeader.identifier.siteOfIdentifier;
    });

    // "-"で区切ることでOR検索となる
    final nCodesString = nCodes.join("-");

    final requestUrl = "https://api.syosetu.com/novelapi/api/"
        "?out=json&" +
        "st=" +
        0.toString() +
        "&lim=" +
        novels.length.toString() +
        "&word=" +
        nCodesString +
        "&gzip=5" +
        "&order=hyoka";

    // HTTPリクエスト -> JSONをModelにマップ
    Future<List<NarouNovelListEntity>> mappedEntities =
        CustomHttpClient.request(HttpMethod.get, requestUrl, null,
            ((responseText) {
      final List<NarouNovelListEntity> entities = new List();

      for (var value in json.decode(responseText)) {
        entities.add(NarouNovelListEntity.fromJson(value));
      }
      return entities;
    }), gzipCompress: true);

    // 最新の小説情報Modelを元に、最新の本棚データを返す
    Future<List<SubscribedNovelEntity>> updatedNovels =
        mappedEntities.then((entities) {
      entities.forEach((remoteNovel) {
        // 最新データのnCodeで引っ掛ける
        final cachedNovel = updateTargetNovels[remoteNovel.ncode];

        // 最新データにキャッシュ中の小説が見つからない
        // = その小説がダイジェスト化などで消されている
        if (cachedNovel == null) {
          return; // あえて何もしない
        }

        // 最終更新日時の更新
        final formattedLastUpTimeText = remoteNovel.general_lastup;
        final lastUpTime = DateTime.parse(formattedLastUpTimeText)
            .millisecondsSinceEpoch; // YYYY-MM-DD HH:MM:SS

        // 未読数の計算
        final cachedEpisodeCount = cachedNovel.episodeCount;
        final remoteEpisodeCount = remoteNovel.general_all_no;
        final diffEpisodeCount = remoteEpisodeCount - cachedEpisodeCount;

        // 最新話の数を未読数に追加する
        final newUnreadCount = cachedNovel.unreadCount + diffEpisodeCount;

        // 話数がダイジェスト化等により減った場合は未読数がマイナスになるので、そのときは0にしておく
        final correctUnreadCount = newUnreadCount < 0 ? 0 : newUnreadCount;

        // 最新情報をマッピングした小説情報を作成する
        updateTargetNovels[remoteNovel.ncode] = SubscribedNovelEntity(
            NovelHeader(
                NovelIdentifier(AvailableSites.narou, remoteNovel.ncode),
                remoteNovel.title,
                remoteNovel.story,
                remoteNovel.writer,
                remoteNovel.end == 0,
                lastUpTime,
                remoteNovel.length),
            cachedNovel.lastReadAt,
            correctUnreadCount,
            remoteEpisodeCount);
      });

      return updateTargetNovels.values.toList();
    });

    return updatedNovels;
  }
}
