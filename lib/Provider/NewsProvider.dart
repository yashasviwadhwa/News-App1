// NewsProvider.dart
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:news1/Model/NewsModel.dart';

class NewsProvider extends ChangeNotifier {
  Articles? _selectedArticle;
  Articles? get selectedArticle => _selectedArticle;

  Future<List<Articles>> fetchNews(String category) async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=7aa037550b9946769cf455d607765de3"),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['articles'];
        final newsList = data.map((item) => Articles.fromJson(item)).toList();
        return newsList;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }

  void setSelectedArticle(Articles article) {
    _selectedArticle = article;
    notifyListeners();
  }
}
