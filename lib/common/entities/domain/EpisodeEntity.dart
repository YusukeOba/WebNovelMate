import 'package:NovelMate/common/entities/domain/NovelHeader.dart';

/// 小説中の話をまとめたデータ
class EpisodeListEntity {
  /// 現在読んでいる話
  /// 読んでいない場合はnull
  final EpisodeEntity nullableReadingEpisode;

  /// 小説一覧
  final List<EpisodeEntity> episodes;

  EpisodeListEntity(this.nullableReadingEpisode, this.episodes);
}

/// 小説中の話のデータ
class EpisodeEntity {
  /// 小説データ
  final NovelIdentifier novelIdentifier;

  /// 話へのリンク
  final String episodeIdentifier;

  /// 投稿日時
  final int firstWriteAt;

  /// 最終更新日時（改稿含む)
  final int lastUpdateAt;

  /// 属するチャプター
  /// チャプターを設定していない話の場合はnull
  final String nullableChapterName;

  /// 表示順序
  final int displayOrder;

  /// 話の名前
  final String episodeName;

  EpisodeEntity(
      this.novelIdentifier,
      this.episodeIdentifier,
      this.firstWriteAt,
      this.lastUpdateAt,
      this.nullableChapterName,
      this.displayOrder,
      this.episodeName);

  @override
  String toString() {
    return 'EpisodeEntity{novelIdentifier: $novelIdentifier, episodeIdentifier: $episodeIdentifier, firstWriteAt: $firstWriteAt, lastUpdateAt: $lastUpdateAt, nullableChapterName: $nullableChapterName, displayOrder: $displayOrder, episodeName: $episodeName}';
  }
}
