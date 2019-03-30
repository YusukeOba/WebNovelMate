import 'package:NovelMate/common/entities/domain/NovelHeader.dart';

class SubscribedNovelEntity {
  /// 小説情報
  final NovelHeader novelHeader;

  /// 最終閲覧日時
  final int lastReadAt;

  /// 未読数
  final int unreadCount;

  /// 話数
  final int episodeCount;

  /// 現在読んでいる話
  String readingEpisodeIdentifier;

  SubscribedNovelEntity(
      this.novelHeader, this.lastReadAt, this.unreadCount, this.episodeCount,
      {String readingEpisodeIdentifier}) {
    this.readingEpisodeIdentifier = readingEpisodeIdentifier;
  }

  @override
  String toString() {
    return 'SubscribedNovelEntity{novelHeader: $novelHeader, lastReadAt: $lastReadAt, unreadCount: $unreadCount, episodeCount: $episodeCount, readingEpisodeIdentifier: $readingEpisodeIdentifier}';
  }
}
