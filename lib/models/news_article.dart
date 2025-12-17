import 'package:json_annotation/json_annotation.dart';
import 'news_source.dart';

part 'news_article.g.dart';

@JsonSerializable()
class NewsArticle {
  final String? title;
  final String? description;
  final String? content;
  final String? url;
  final String? image;
  final DateTime? publishedAt;
  final String? lang;
  final NewsSource? source;

  NewsArticle({
    this.title,
    this.description,
    this.content,
    this.url,
    this.image,
    this.publishedAt,
    this.lang,
    this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleFromJson(json);

  Map<String, dynamic> toJson() => _$NewsArticleToJson(this);
}
