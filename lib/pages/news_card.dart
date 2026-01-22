import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/news_article.dart';
import '../services/saved_news_service.dart';
import 'webview_page.dart';

class NewsCard extends StatefulWidget {
  final NewsArticle article;
  final VoidCallback? onSavedChanged;

  const NewsCard({
    super.key,
    required this.article,
    this.onSavedChanged,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final saved = await SavedNewsService.isArticleSaved(widget.article.url);
    if (mounted) {
      setState(() {
        isSaved = saved;
      });
    }
  }

  Future<void> _toggleSave() async {
    if (isSaved) {
      await SavedNewsService.removeArticle(widget.article.url);
      setState(() {
        isSaved = false;
      });
    } else {
      // Show folder selection dialog
      final folders = await SavedNewsService.getFolders();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Save to Folder'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: folders.map((folder) {
                  return ListTile(
                    title: Text(folder),
                    onTap: () {
                      SavedNewsService.saveArticle(widget.article, folder);
                      setState(() {
                        isSaved = true;
                      });
                      widget.onSavedChanged?.call();
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy HH:mm');
    final publishedAt = widget.article.publishedAt == null
        ? ''
        : formatter.format(widget.article.publishedAt!.toLocal());

    return GestureDetector(
      onTap: widget.article.url != null
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewPage(
                    url: widget.article.url!,
                    title: widget.article.title ?? 'News',
                  ),
                ),
              )
          : null,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.article.image != null)
              Image.network(
                widget.article.image!,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title ?? 'No title',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.article.description != null)
                    Text(
                      widget.article.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    [
                      widget.article.source?.name ?? '',
                      publishedAt,
                    ].where((e) => e.isNotEmpty).join(' - '),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _toggleSave,
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? Colors.amber : null,
                      ),
                      label: Text(isSaved ? 'Saved' : 'Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
