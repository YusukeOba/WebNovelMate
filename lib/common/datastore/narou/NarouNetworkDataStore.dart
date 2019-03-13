import 'dart:async';
import 'dart:convert';

import 'package:NovelMate/common/entities/narou/NarouNovelListEntity.dart';
import 'package:http/http.dart' as http;

class NarouNetworkDataStore {
  /// 検索ワードを元に小説家になろうのタイトルを検索する
  Future<List<NarouNovelListEntity>> searchTest(String searchWord) async {
    return await http
        .get("https://api.syosetu.com/novelapi/api/" +
            "?out=json&" +
            "lim=500&" // 件数
            "word=" +
            searchWord)
        .then((rawResponse) {
      if (rawResponse.statusCode == 200) {
        final List<NarouNovelListEntity> entities = new List();
        for (var value in json.decode(rawResponse.body)) {
          entities.add(NarouNovelListEntity.fromJson(value));
        }

        entities.forEach((e) => print(e));

        // 最初の値はゴミなので削る
        if (entities.length > 0) {
          entities.removeAt(0);
        }

        print("success!!");
        entities
            .sort((lhs, rhs) => rhs.global_point.compareTo(lhs.global_point));

        return entities;
      } else {
        print("failue!!");
        print(rawResponse);
        throw Exception('Failed to load post');
      }
    });
  }
}
