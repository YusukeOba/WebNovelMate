/// なろうの小説中の話のデータ
class NarouEpisodesEntity {
  /// 話数
  final int episodeId;

  /// 投稿日時
  final int firstWriteAt;

  /// 最終更新日時（改稿含む)
  final int lastUpdateAt;

  /// 属するチャプター
  /// チャプターを設定していない話の場合はnull
  final String nullableChapterName;

  /// 話の名前
  final String episodeName;

  NarouEpisodesEntity(this.episodeId, this.firstWriteAt, this.lastUpdateAt,
      this.nullableChapterName, this.episodeName);

  @override
  String toString() {
    return 'NarouEpisodesEntity{episodeId: $episodeId, firstWriteAt: $firstWriteAt, lastUpdateAt: $lastUpdateAt, nullableChapterName: $nullableChapterName, episodeName: $episodeName}';
  }
}
