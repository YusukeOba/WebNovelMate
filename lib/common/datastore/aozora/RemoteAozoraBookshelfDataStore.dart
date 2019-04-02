import 'dart:convert';

import 'package:NovelMate/common/HttpClient.dart';
import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/RemoteBookshelfDataStore.dart';
import 'package:NovelMate/common/entities/aozora/AozoraNovelListEntity.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/SubscribedNovelEntity.dart';

class RemoteAozoraBookshelfDataStore extends RemoteBookshelfDataStore {
  @override
  Future<List<SubscribedNovelEntity>> findByNovels(
      List<SubscribedNovelEntity> novels) {
    // TODO: 青空文庫の更新実装
    return Future.value(novels);
  }
}
