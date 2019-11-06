// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return Asset(
      json['id'] as int,
      json['name'] as String,
      json['cover'] as String,
      json['v_url'] as String,
      json['i_time'] as String,
      json['refer'] as String,
      json['key_word'] as String);
}

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cover': instance.cover,
      'v_url': instance.v_url,
      'i_time': instance.i_time,
      'key_word': instance.key_word,
      'refer': instance.refer
    };
