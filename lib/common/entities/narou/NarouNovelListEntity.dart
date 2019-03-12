import 'package:json_annotation/json_annotation.dart';


// ジェネレートされたクラスからクラスのprivateメンバ変数にアクセスするため
part 'NarouNovelListEntity.g.dart';

/// Narou novel informations api
/// @see https://dev.syosetu.com/man/api/
@JsonSerializable()
class NarouNovelListEntity {

  NarouNovelListEntity(this.title,
      this.nCode,
      this.userId,
      this.writer,
      this.story,
      this.biggenre,
      this.gensaku,
      this.keyword,
      this.general_firstup,
      this.general_lastup,
      this.novel_type,
      this.end,
      this.general_all_no,
      this.length,
      this.time,
      this.isstop,
      this.isr15,
      this.isbl,
      this.isgl,
      this.iszankoku,
      this.istensei,
      this.istenni,
      this.pc_or_k,
      this.global_point,
      this.fav_novel_cnt,
      this.review_cnt,
      this.all_point,
      this.all_hyoka_cnt,
      this.sasie_cnt,
      this.kaiwaritu,
      this.novelupdated_at,
      this.updated_at);

  /// Novel name
  String title;

  /// Novel Identifier
  String nCode;

  /// Writers identifier
  int userId;

  /// Writer name
  String writer;

  /// Novel summary
  String story;

  /// Big category
  ///  1: 恋愛
  ///  2: ファンタジー
  ///  3: 文芸
  ///  4: SF
  ///  99: その他
  ///  98: ノンジャンル
  ///  genre	ジャンル
  ///  101: 異世界〔恋愛〕
  ///  102: 現実世界〔恋愛〕
  ///  201: ハイファンタジー〔ファンタジー〕
  ///  202: ローファンタジー〔ファンタジー〕
  ///  301: 純文学〔文芸〕
  ///  302: ヒューマンドラマ〔文芸〕
  ///  303: 歴史〔文芸〕
  ///  304: 推理〔文芸〕
  ///  305: ホラー〔文芸〕
  ///  306: アクション〔文芸〕
  ///  307: コメディー〔文芸〕
  ///  401: VRゲーム〔SF〕
  ///  402: 宇宙〔SF〕
  ///  403: 空想科学〔SF〕
  ///  404: パニック〔SF〕
  ///  9901: 童話〔その他〕
  ///  9902: 詩〔その他〕
  ///  9903: エッセイ〔その他〕
  ///  9904: リプレイ〔その他〕
  ///  9999: その他〔その他〕
  ///  9801: ノンジャンル〔ノンジャンル〕
  int biggenre;

  /// not used
  String gensaku;

  /// search tags
  String keyword;

  /// first post date
  /// YYYY-MM-DD HH:MM:SS
  String general_firstup;

  /// last post date
  /// YYYY-MM-DD HH:MM:SS
  String general_lastup;

  /// novel type
  /// - long type novel = 1
  /// - short type novel = 2
  int novel_type;

  /// finished novel = 0
  /// serializing novel = 1
  int end;

  /// Count of contents.
  /// short novels is 1.
  int general_all_no;

  /// Count of novel text length.
  int length;

  /// Completing reading time
  int time;

  /// Stop writing = 1
  /// other = 0
  int isstop;

  /// contains r15 = 1
  /// other = 0
  int isr15;

  /// contains boys love = 1
  /// other = 0
  int isbl;

  /// contains girls love = 1
  /// other = 0
  int isgl;

  /// contains harsh tag = 1
  /// other = 0
  int iszankoku;

  /// contains other world = 1
  /// other = 0
  int istensei;

  /// contains other world transition = 0
  int istenni;

  /// legacy phone only = 1
  /// pc only = 2
  /// both = 3
  int pc_or_k;

  /// Evaluation point
  int global_point;

  /// Count of bookmark.
  int fav_novel_cnt;

  // Count of review.
  int review_cnt;

  /// Evaluation point
  int all_point;

  /// Evaluation people of count.
  int all_hyoka_cnt;

  /// Count of illustration
  int sasie_cnt;

  /// conversation
  int kaiwaritu;

  /// last novel updated date
  String novelupdated_at;

  /// system time
  String updated_at;

  // _$UserFromJsonが生成される
  factory NarouNovelListEntity.fromJson(Map<String, dynamic> json) =>
      _$NarouNovelListEntityFromJson(json);

  // _$UserToJsonが生成される
  Map<String, dynamic> toJson() => _$NarouNovelListEntityToJson(this);

  @override
  String toString() {
    return 'NarouNovelListEntity{title: $title, nCode: $nCode, userId: $userId, writer: $writer, story: $story, biggenre: $biggenre, gensaku: $gensaku, keyword: $keyword, general_firstup: $general_firstup, general_lastup: $general_lastup, novel_type: $novel_type, end: $end, general_all_no: $general_all_no, length: $length, time: $time, isstop: $isstop, isr15: $isr15, isbl: $isbl, isgl: $isgl, iszankoku: $iszankoku, istensei: $istensei, istenni: $istenni, pc_or_k: $pc_or_k, global_point: $global_point, fav_novel_cnt: $fav_novel_cnt, review_cnt: $review_cnt, all_point: $all_point, all_hyoka_cnt: $all_hyoka_cnt, sasie_cnt: $sasie_cnt, kaiwaritu: $kaiwaritu, novelupdated_at: $novelupdated_at, updated_at: $updated_at}';
  }


}

