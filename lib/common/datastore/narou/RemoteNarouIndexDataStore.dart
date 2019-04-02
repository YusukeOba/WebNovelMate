import 'dart:async';
import 'dart:convert';

import 'package:NovelMate/common/HttpClient.dart';
import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/RemoteIndexDataStore.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';
import 'package:NovelMate/common/entities/narou/NarouNovelListEntity.dart';

class RemoteNarouIndexDataStore extends RemoteIndexDataStore {
  /// 検索ワードを元に小説家になろうのタイトルを検索する
  @override
  Future<List<RankingEntity>> fetchRanking(int start, int end,
      {String title, List<String> keywords, List<int> genres}) async {
    final requestUrl = "https://api.syosetu.com/novelapi/api/"
        "?out=json&" +
        "st=" +
        start.toString() +
        "&lim=" +
        end.toString() +
        "&word=" +
        (title ?? "") +
        "&gzip=5" +
        "&order=hyoka";

    print("request url = " + requestUrl);

    // HTTPリクエスト -> JSONをModelにマップ
    Future<List<NarouNovelListEntity>> mappedEntities =
        CustomHttpClient.request(HttpMethod.get, requestUrl, ((responseText) {
      final List<NarouNovelListEntity> entities = new List();

      for (var value in json.decode(responseText)) {
        entities.add(NarouNovelListEntity.fromJson(value));
      }
      return entities;
    }), gzipCompress: true);

    // 単純な通信結果のModelからドメインレベルの結果にマップ
    return mappedEntities.then((entities) {
      // 最初の"allcount"は不要なので削る
      if (entities.length > 0) {
        entities.removeAt(0);
      }

      final List<RankingEntity> rankings = [];
      entities.asMap().forEach((index, entity) {
        final isCompleted = entity.end == 0; // 0=完結or短編

        final formattedLastUpTimeText = entity.general_lastup;
        final lastUpTime = DateTime.parse(formattedLastUpTimeText)
            .millisecondsSinceEpoch; // YYYY-MM-DD HH:MM:SS

        rankings.add(RankingEntity.name(
          entity.global_point,
          NovelHeader(
              NovelIdentifier(AvailableSites.narou, entity.ncode),
              entity.title,
              entity.story,
              entity.writer,
              isCompleted,
              lastUpTime,
              entity.length,
              entity.general_all_no),
        ));
      });
      return Future.value(rankings);
    });
  }

  @override
  Future<List<RankingEntity>> fetchIndex(String title) {
    // 内部的に検索API = ランキング取得APIは同一
    return fetchRanking(0, 100, title: title);
  }
}
