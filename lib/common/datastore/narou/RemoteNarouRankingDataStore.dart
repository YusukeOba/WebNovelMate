import 'dart:async';
import 'dart:convert';

import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/narou/RemoteRankingDataStore.dart';
import 'package:NovelMate/common/entities/domain/NovelEntity.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';
import 'package:NovelMate/common/entities/narou/NarouNovelListEntity.dart';
import 'package:http/http.dart' as http;

class RemoteNarouRankingDataStore extends RemoteRankingDataStore {
  /// 検索ワードを元に小説家になろうのタイトルを検索する
  @override
  Future<List<RankingEntity>> fetchRanking(int start, int end,
      {String title, List<String> keywords, List<int> genres}) async {
    return http
        .get("https://api.syosetu.com/novelapi/api/"
            "?out=json&" +
            "st=" +
            start.toString() +
            "&lim=" +
            end.toString() +
            "&word=" +
            title)
        .then((response) {
      if (response.statusCode == 200) {
        final List<NarouNovelListEntity> entities = new List();
        for (var value in json.decode(response.body)) {
          entities.add(NarouNovelListEntity.fromJson(value));
        }

//        entities.forEach((e) => print(e));

        // 最初の値はゴミなので削る
        if (entities.length > 0) {
          entities.removeAt(0);
        }

        print("success!!");
        entities
            .sort((lhs, rhs) => rhs.global_point.compareTo(lhs.global_point));

        final List<RankingEntity> rankings = [];
        entities.asMap().forEach((index, entity) {
          rankings.add(RankingEntity.name(
              index + 1,
              NovelHeader.name(
                  NovelIdentifier.name(Site.narou, "小説家になろう", entity.nCode),
                  entity.title,
                  entity.story,
                  entity.writer)));
        });
        return rankings;
      } else {
        print("failue!!");
        print(response);
        throw Exception('Failed to load post');
      }
    });
  }

  @override
  Site siteIdentifier() {
    return Site.narou;
  }
}
