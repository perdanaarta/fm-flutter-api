import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/news_article.dart';

class SavedNewsService {
  static const String _foldersKey = 'saved_news_folders';
  static const String _defaultFolder = 'Default';
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final folders = await getFolders();
    if (!folders.contains(_defaultFolder)) {
      await createFolder(_defaultFolder);
    }
  }

  static Future<List<String>> getFolders() async {
    final jsonString = _prefs.getString(_foldersKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [_defaultFolder];
    }

    try {
      final List<dynamic> folderList = jsonDecode(jsonString);
      return folderList.cast<String>();
    } catch (e) {
      print('Error: $e');
      return [_defaultFolder];
    }
  }

  static Future<void> createFolder(String folderName) async {
    final folders = await getFolders();
    if (!folders.contains(folderName)) {
      folders.add(folderName);
      await _prefs.setString(_foldersKey, jsonEncode(folders));
    }
  }

  static Future<void> deleteFolder(String folderName) async {
    if (folderName == _defaultFolder) return;

    final folders = await getFolders();
    folders.remove(folderName);
    await _prefs.setString(_foldersKey, jsonEncode(folders));

    final articles = await getSavedArticles(folderName);
    for (var article in articles) {
      await saveArticle(article, _defaultFolder);
    }
  }

  static Future<void> renameFolder(String oldName, String newName) async {
    if (oldName == _defaultFolder) return;

    final folders = await getFolders();
    if (!folders.contains(newName)) {
      final index = folders.indexOf(oldName);
      if (index != -1) {
        folders[index] = newName;
        await _prefs.setString(_foldersKey, jsonEncode(folders));

        final articles = await getSavedArticles(oldName);
        await _prefs.remove('articles_$oldName');
        await _saveArticlesToPref(newName, articles);
      }
    }
  }

  static Future<void> saveArticle(NewsArticle article, [String? folder]) async {
    final folderName = folder ?? _defaultFolder;
    final savedArticles = await getSavedArticles(folderName);

    if (!savedArticles.any((a) => a.url == article.url)) {
      savedArticles.add(article);
      await _saveArticlesToPref(folderName, savedArticles);
    }
  }

  static Future<void> removeArticle(String? url, [String? folder]) async {
    if (url == null) return;

    final folderName = folder ?? _defaultFolder;
    final savedArticles = await getSavedArticles(folderName);
    savedArticles.removeWhere((a) => a.url == url);
    await _saveArticlesToPref(folderName, savedArticles);
  }

  static Future<bool> isArticleSaved(String? url) async {
    if (url == null) return false;

    final folders = await getFolders();
    for (var folder in folders) {
      final savedArticles = await getSavedArticles(folder);
      if (savedArticles.any((a) => a.url == url)) {
        return true;
      }
    }
    return false;
  }

  static Future<List<NewsArticle>> getSavedArticles([String? folder]) async {
    final folderName = folder ?? _defaultFolder;
    final jsonString = _prefs.getString('articles_$folderName');

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => NewsArticle.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading saved articles: $e');
      return [];
    }
  }

  static Future<void> _saveArticlesToPref(
    String folder,
    List<NewsArticle> articles,
  ) async {
    final jsonList = articles.map((a) => a.toJson()).toList();
    await _prefs.setString('articles_$folder', jsonEncode(jsonList));
  }

  static Future<void> clearAll() async {
    final folders = await getFolders();
    for (var folder in folders) {
      await _prefs.remove('articles_$folder');
    }
  }
}
