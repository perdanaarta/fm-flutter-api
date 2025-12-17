import 'package:flutter/material.dart';
import '../api/gnews_client.dart';
import 'news_card.dart';
import '../models/news_article.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  static const apiKey = 'b09c8c1fe17bed6275127df6a81c4277';

  late GNewsClient client;

  bool loading = true;
  String? error;
  List<NewsArticle> articles = [];

  @override
  void initState() {
    super.initState();
    client = GNewsClient(apiKey);
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      final res = await client.fetchTopHeadlines(
        category: 'general',
        lang: 'id',
        country: 'id',
      );

      setState(() {
        articles = res.articles;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Berita')),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (_, i) {
          return NewsCard(article: articles[i]);
        },
      ),
    );
  }
}
