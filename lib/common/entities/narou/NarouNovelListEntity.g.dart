// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NarouNovelListEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NarouNovelListEntity _$NarouNovelListEntityFromJson(Map<String, dynamic> json) {
  return NarouNovelListEntity(
      json['title'] as String,
      json['nCode'] as String,
      json['userId'] as int,
      json['writer'] as String,
      json['story'] as String,
      json['biggenre'] as int,
      json['gensaku'] as String,
      json['keyword'] as String,
      json['general_firstup'] as String,
      json['general_lastup'] as String,
      json['novel_type'] as int,
      json['end'] as int,
      json['general_all_no'] as int,
      json['length'] as int,
      json['time'] as int,
      json['isstop'] as int,
      json['isr15'] as int,
      json['isbl'] as int,
      json['isgl'] as int,
      json['iszankoku'] as int,
      json['istensei'] as int,
      json['istenni'] as int,
      json['pc_or_k'] as int,
      json['global_point'] as int,
      json['fav_novel_cnt'] as int,
      json['review_cnt'] as int,
      json['all_point'] as int,
      json['all_hyoka_cnt'] as int,
      json['sasie_cnt'] as int,
      json['kaiwaritu'] as int,
      json['novelupdated_at'] as String,
      json['updated_at'] as String);
}

Map<String, dynamic> _$NarouNovelListEntityToJson(
        NarouNovelListEntity instance) =>
    <String, dynamic>{
      'title': instance.title,
      'nCode': instance.nCode,
      'userId': instance.userId,
      'writer': instance.writer,
      'story': instance.story,
      'biggenre': instance.biggenre,
      'gensaku': instance.gensaku,
      'keyword': instance.keyword,
      'general_firstup': instance.general_firstup,
      'general_lastup': instance.general_lastup,
      'novel_type': instance.novel_type,
      'end': instance.end,
      'general_all_no': instance.general_all_no,
      'length': instance.length,
      'time': instance.time,
      'isstop': instance.isstop,
      'isr15': instance.isr15,
      'isbl': instance.isbl,
      'isgl': instance.isgl,
      'iszankoku': instance.iszankoku,
      'istensei': instance.istensei,
      'istenni': instance.istenni,
      'pc_or_k': instance.pc_or_k,
      'global_point': instance.global_point,
      'fav_novel_cnt': instance.fav_novel_cnt,
      'review_cnt': instance.review_cnt,
      'all_point': instance.all_point,
      'all_hyoka_cnt': instance.all_hyoka_cnt,
      'sasie_cnt': instance.sasie_cnt,
      'kaiwaritu': instance.kaiwaritu,
      'novelupdated_at': instance.novelupdated_at,
      'updated_at': instance.updated_at
    };
