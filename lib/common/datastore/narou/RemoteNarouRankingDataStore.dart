import 'dart:async';
import 'dart:convert';

import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/narou/RemoteRankingDataStore.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
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
            title +
            "&order=\"hyoka\"")
        .then((response) {
      if (response.statusCode == 200) {
        final List<NarouNovelListEntity> entities = new List();
        for (var value in json.decode(response.body)) {
          entities.add(NarouNovelListEntity.fromJson(value));
        }

        // 最初の値はゴミなので削る
        if (entities.length > 0) {
          entities.removeAt(0);
        }

        print("success!!");

        final List<RankingEntity> rankings = [];
        entities.asMap().forEach((index, entity) {
          final isCompleted = entity.end == 0; // 0=完結or短編
          final date = entity.novelupdated_at;

          final dateInt =
              DateTime.parse(date).millisecondsSinceEpoch; // YYYY-MM-DD HH:MM:SS

          rankings.add(RankingEntity.name(
            entity.global_point,
            NovelHeader.name(
                NovelIdentifier.name(Narou(), entity.nCode),
                entity.title,
                entity.story,
                entity.writer,
                isCompleted,
                dateInt,
                entity.length),
          ));
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
  Site site() {
    return Narou();
  }
}
