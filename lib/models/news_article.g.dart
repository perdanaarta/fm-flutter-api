// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsArticle _$NewsArticleFromJson(Map<String, dynamic> json) => NewsArticle(
  title: json['title'] as String?,
  description: json['description'] as String?,
  content: json['content'] as String?,
  url: json['url'] as String?,
  image: json['image'] as String?,
  publishedAt: json['publishedAt'] == null
      ? null
      : DateTime.parse(json['publishedAt'] as String),
  lang: json['lang'] as String?,
  source: json['source'] == null
      ? null
      : NewsSource.fromJson(json['source'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NewsArticleToJson(NewsArticle instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'url': instance.url,
      'image': instance.image,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'lang': instance.lang,
      'source': instance.source,
    };
