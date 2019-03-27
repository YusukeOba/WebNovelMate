import 'dart:async';

import 'package:NovelMate/common/Sites.dart';
import 'package:NovelMate/common/datastore/CachedTextDataStore.dart';
import 'package:NovelMate/common/datastore/RemoteTextDataStore.dart';
import 'package:NovelMate/common/entities/domain/NovelHeader.dart';
import 'package:NovelMate/common/entities/domain/TextEntity.dart';

abstract class TextRepository {
  Map<Site, CachedTextDataStore> cachedDataStores;

  Map<Site, RemoteTextDataStore> remoteDataStores;

  TextRepository(this.cachedDataStores, this.remoteDataStores);

  /// 小説および話の固有情報から本文を取得する
  Future<TextEntity> findByIdentifier(
      NovelIdentifier novelIdentifier, String episodeIdentifier);

  /// 小説に紐づく話をすべて削除する
  /// (=小説を削除したケース
  Future<void> deleteByNovel(NovelIdentifier novelIdentifier);

  /// 小説の本文を一つ削除する
  Future<void> deleteByEpisode(
      NovelIdentifier novelIdentifier, String episodeIdentifier);
}
