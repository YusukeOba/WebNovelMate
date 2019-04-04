import 'package:json_annotation/json_annotation.dart';

// ジェネレートされたクラスからクラスのprivateメンバ変数にアクセスするため
part 'AozoraNovelListEntity.g.dart';

@JsonSerializable()
class AozoraNovelListEntity {
  /// 小説の固有ID
  int book_id;

  /// 小説のタイトル
  String title;

  /// 初版発行日
  String release_date;

  /// 更新日
  String last_modified;

  /// html形式の小説へのurl
  String html_url;

  /// txt形式の小説へのurl
  String text_url;

  /// 著者
  List<AozoraAuthors> authors;

  /// 著作権が存続しているか
  bool copyright;

  /// アクセス数
  int access;

  /// 初出
  String first_appearance;


  AozoraNovelListEntity(this.book_id, this.title, this.release_date,
      this.last_modified, this.html_url, this.text_url, this.authors,
      this.copyright, this.access, this.first_appearance);

  factory AozoraNovelListEntity.fromJson(Map<String, dynamic> json) =>
      _$AozoraNovelListEntityFromJson(json);

  // _$UserToJsonが生成される
  Map<String, dynamic> toJson() => _$AozoraNovelListEntityToJson(this);
}

@JsonSerializable()
class AozoraAuthors {
  /// 名前
  String first_name;

  /// 名字
  String last_name;

  AozoraAuthors(this.first_name, this.last_name); // _$UserFromJsonが生成される

  factory AozoraAuthors.fromJson(Map<String, dynamic> json) =>
      _$AozoraAuthorsFromJson(json);

  // _$UserToJsonが生成される
  Map<String, dynamic> toJson() => _$AozoraAuthorsToJson(this);
}
