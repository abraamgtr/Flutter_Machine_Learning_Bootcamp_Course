import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app_section18/Models/News/Article_model.dart';

class NewsApiService {
  final http.Client client;
  String baseUrl = "";

  NewsApiService(this.client);

  Future<Article> fetchArticle() async {
    final uri = Uri.parse(
        '$baseUrl/everything?q=flutter&apiKey=788576fa85e0490eacac2d580771d924');
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return Article.fromJson(json.decode(response.body));
    } else {
      throw Error();
    }
  }
}
