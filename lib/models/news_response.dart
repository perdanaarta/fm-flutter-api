import 'package:json_annotation/json_annotation.dart';
import 'news_article.dart';

part 'news_response.g.dart';

@JsonSerializable()
class NewsResponse {
  final int totalArticles;
  final List<NewsArticle> articles;

  NewsResponse({
    required this.totalArticles,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}
