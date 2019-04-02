import 'dart:convert';

import 'package:NovelMate/common/HttpClient.dart';
import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/RemoteIndexDataStore.dart';
import 'package:NovelMate/common/entities/aozora/AozoraNovelListEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/RankingEntity.dart';

class RemoteAozoraIndexDataStore extends RemoteIndexDataStore {
  @override
  Future<List<RankingEntity>> fetchRanking(int start, int end,
      {String title, List<String> keywords, List<int> genres}) async {
    final String requestUrl =
        "http://v118-27-3-3.k722.static.cnode.io:8080/api/v0.1/ranking/txt/2019/01";

    print("request url = " + requestUrl);

    final List<AozoraNovelListEntity> aozoraLists =
        await CustomHttpClient.request(HttpMethod.get, requestUrl,
            (resultText) {
      final List result = (json.decode(resultText) as List);

      final List<AozoraNovelListEntity> entities = List();
      result.forEach((json) {
        entities.add(AozoraNovelListEntity.fromJson(json));
      });

      return entities;
    }, gzipCompress: false);

    print("aozoraList = " + aozoraLists.toString());

    return _buildDomainEntity(aozoraLists);
  }

  @override
  Future<List<RankingEntity>> fetchIndex(String title) async {
    final String requestUrl =
        "http://v118-27-3-3.k722.static.cnode.io:8080/api/v0.1/books?title=/" +
            title +
            "/";

    print("request url = " + requestUrl);

    final List<AozoraNovelListEntity> aozoraLists =
        await CustomHttpClient.request(HttpMethod.get, requestUrl,
            (resultText) {
      final List result = (json.decode(resultText) as List);

      final List<AozoraNovelListEntity> entities = List();
      result.forEach((json) {
        entities.add(AozoraNovelListEntity.fromJson(json));
      });

      return entities;
    }, gzipCompress: false);

    print("aozoraList = " + aozoraLists.toString());

    return _buildDomainEntity(aozoraLists);
  }

  List<RankingEntity> _buildDomainEntity(
      List<AozoraNovelListEntity> aozoraLists) {
    final mappedEntities = new List<RankingEntity>();

    // 単純な通信結果のModelからドメインレベルの結果にマップ
    aozoraLists.asMap().forEach((index, entity) {
      String rawAuthorName = "";
      if (entity.authors.first != null) {
        final author = entity.authors.first;
        rawAuthorName = author.last_name + " " + author.first_name;
      }

      final identifier =
          NovelIdentifier(AvailableSites.aozora, entity.book_id.toString());
      final lastUpTime =
          DateTime.parse(entity.last_modified).millisecondsSinceEpoch;

      int popularity = entity.access;
      if (entity.access == null) {
        print("access count is null. ");
        popularity = aozoraLists.length - index;
      }

      final ranking = RankingEntity.name(
          popularity,
          NovelHeader(
              identifier,
              entity.title,
              entity.first_appearance,
              rawAuthorName,
              true,
              // 必ず完結している
              lastUpTime,
              0,
              1 // 必ず1話
              ));
      mappedEntities.add(ranking);
    });

    return mappedEntities;
  }
}
