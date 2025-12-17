import 'package:json_annotation/json_annotation.dart';

part 'news_source.g.dart';

@JsonSerializable()
class NewsSource {
  final String? name;
  final String? url;

  NewsSource({this.name, this.url});

  factory NewsSource.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceFromJson(json);

  Map<String, dynamic> toJson() => _$NewsSourceToJson(this);
}
