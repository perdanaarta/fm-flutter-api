import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/news_article.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;

  const NewsCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy HH:mm');
    final publishedAt = article.publishedAt == null
        ? ''
        : formatter.format(article.publishedAt!.toLocal());

    return ListTile(
      trailing: article.image == null
          ? const Icon(Icons.article)
          : Image.network(
              article.image!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
      title: Text(
        article.title ?? 'No title',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.description != null)
            Text(
              article.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          Text(
            [
              article.source?.name ?? '',
              publishedAt,
            ].where((e) => e.isNotEmpty).join(' - '),
          ),
        ],
      ),
    );
  }
}
