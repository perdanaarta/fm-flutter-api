import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_response.dart';

class GNewsClient {
  final String apiKey;

  GNewsClient(this.apiKey);

  Future<NewsResponse> fetchTopHeadlines({
    required String category,
    required String lang,
    required String country,
    int max = 20,
    int page = 1,
  }) async {
    final uri = Uri.https(
      'gnews.io',
      '/api/v4/top-headlines',
      {
        'category': category,
        'lang': lang,
        'country': country,
        'max': '$max',
        'page': '$page',
        'apikey': apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final jsonMap = json.decode(response.body) as Map<String, dynamic>;
    return NewsResponse.fromJson(jsonMap);
  }
}
