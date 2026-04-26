import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/game.dart';

class GameService {
  static const String _baseUrl = 'https://www.freetogame.com/api';

  Future<Game> fetchRandomGame() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/games'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Erreur serveur : ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final list = data as List;

    if (list.isEmpty) {
      throw Exception('Aucun jeu disponible.');
    }

    final randomIndex = Random().nextInt(list.length);
    return Game.fromJson(list[randomIndex] as Map<String, dynamic>);
  }
}
