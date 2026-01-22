import 'package:flutter/material.dart';
import '../api/gnews_client.dart';
import 'news_card.dart';
import 'settings_page.dart';
import 'saved_news_page.dart';
import '../models/news_article.dart';

class NewsPage extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;

  const NewsPage({super.key, this.onThemeChanged});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  static const apiKey = 'b09c8c1fe17bed6275127df6a81c4277';
  static const genres = [
    'general',
    'world',
    'business',
    'technology',
    'entertainment',
    'sports',
    'science',
    'health'
  ];

  late GNewsClient client;

  bool loading = true;
  String? error;
  String selectedGenre = 'general';
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
        category: selectedGenre,
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

  void _changeGenre(String genre) {
    setState(() {
      selectedGenre = genre;
      loading = true;
    });
    loadNews();
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Berita'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      currentThemeMode: Theme.of(context).brightness == Brightness.dark
                          ? ThemeMode.dark
                          : ThemeMode.light,
                      onThemeChanged: (themeMode) {
                        widget.onThemeChanged?.call(themeMode);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedNewsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    currentThemeMode: Theme.of(context).brightness == Brightness.dark
                        ? ThemeMode.dark
                        : ThemeMode.light,
                    onThemeChanged: (themeMode) {
                      widget.onThemeChanged?.call(themeMode);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: genres.map((genre) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(genre[0].toUpperCase() + genre.substring(1)),
                    selected: selectedGenre == genre,
                    onSelected: (selected) {
                      if (selected) {
                        _changeGenre(genre);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (_, i) {
                      return NewsCard(article: articles[i]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
