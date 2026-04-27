import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gmg_flutter/details/models/details_model.dart';

Future<Game> fetchGame(int id) async {
  final response = await http.get(
    Uri.parse('https://www.freetogame.com/api/game?id=$id'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    return Game.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load game');
  }
}