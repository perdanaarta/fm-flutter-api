// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsResponse _$NewsResponseFromJson(Map<String, dynamic> json) => NewsResponse(
  totalArticles: (json['totalArticles'] as num).toInt(),
  articles: (json['articles'] as List<dynamic>)
      .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NewsResponseToJson(NewsResponse instance) =>
    <String, dynamic>{
      'totalArticles': instance.totalArticles,
      'articles': instance.articles,
    };
