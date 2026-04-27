// lib/search/services/search_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_model.dart';

class SearchService {
  final String baseUrl = "https://www.freetogame.com/api";

  Future<List<Game>> fetchGames({String? genre}) async {
    String url = "$baseUrl/games";
    if (genre != null && genre != 'All Games') {
      String category = genre.toLowerCase().replaceAll(' ', '-');
      url = "$baseUrl/games?category=$category";
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Game.fromJson(item)).toList();
      } else {
        throw Exception("Erreur lors du chargement des jeux");
      }
    } catch (e) {
      print("Erreur API : $e");
      return [];
    }
  }
}