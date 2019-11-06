import 'package:json_annotation/json_annotation.dart';

part 'Asset.g.dart';

@JsonSerializable()
class Asset {
  int id;
  String name;
  String cover;
  String v_url;
  String i_time;
  String key_word;
  String refer;

  Asset(this.id, this.name, this.cover, this.v_url, this.i_time, this.key_word,this.refer);

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

  Map<String, dynamic> toJson() => _$AssetToJson(this);
}
