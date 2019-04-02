// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AozoraNovelListEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AozoraNovelListEntity _$AozoraNovelListEntityFromJson(
    Map<String, dynamic> json) {
  return AozoraNovelListEntity(
      json['book_id'] as int,
      json['title'] as String,
      json['release_date'] as String,
      json['last_modified'] as String,
      json['html_url'] as String,
      json['text_url'] as String,
      json['copyright'] as bool,
      json['access'] as int)
    ..authors = (json['authors'] as List)
        ?.map((e) => e == null
            ? null
            : AozoraAuthors.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AozoraNovelListEntityToJson(
        AozoraNovelListEntity instance) =>
    <String, dynamic>{
      'book_id': instance.book_id,
      'title': instance.title,
      'release_date': instance.release_date,
      'last_modified': instance.last_modified,
      'html_url': instance.html_url,
      'text_url': instance.text_url,
      'authors': instance.authors,
      'copyright': instance.copyright,
      'access': instance.access
    };

AozoraAuthors _$AozoraAuthorsFromJson(Map<String, dynamic> json) {
  return AozoraAuthors(
      json['first_name'] as String, json['last_name'] as String);
}

Map<String, dynamic> _$AozoraAuthorsToJson(AozoraAuthors instance) =>
    <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name
    };
