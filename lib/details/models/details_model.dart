import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Game> fetchGame(int id) async {
  final response = await http.get(Uri.parse('https://www.freetogame.com/api/game?id=$id'),
  headers: {'Accept': 'application/json'},
  );
  if (response.statusCode==200){
    return Game.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load game');
  }
}

class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String description;
  final String gameUrl;
  final String genre;
  final String platform; 
  final String publisher;
  final String developer;
  final String releaseDate;
  final SystemRequirements minimumSystemRequirements;
  final List <Screenshot> screenshots;

  const Game({required this.id, required this.title, required this.thumbnail, required this.description, required this.gameUrl, required this.genre,
  required this.platform, required this.publisher, required this.developer, required this.releaseDate, required this.minimumSystemRequirements, required this.screenshots});

  factory Game.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'title': String title, 'thumbnail': String thumbnail, 'description': String description, 'game_url': String gameUrl, 'genre': String genre,
      'platform': String platform, 'publisher': String publisher, 'developer': String developer, 'release_date': String releaseDate, 'minimum_system_requirements': Map <String, dynamic> minimumSystemRequirements, 'screenshots': List <dynamic>? screenshots} 
      => Game(
          id: id,
          title: title,
          thumbnail: thumbnail,
          description: description,
          gameUrl: gameUrl,
          genre: genre,
          platform: platform,
          publisher: publisher,
          developer: developer,
          releaseDate: releaseDate,
          minimumSystemRequirements: SystemRequirements.fromJson(
            json['minimum_system_requirements'],
          ),
          screenshots: (json['screenshots'] as List)
          .map((e) => Screenshot.fromJson(e))
          .toList(),
        ),
        _ => throw const FormatException('Failed to load the game')
      };
    }
  }


class Screenshot {
  final int id;
  final String image;

  Screenshot({required this.id, required this.image});

  factory Screenshot.fromJson(Map<String, dynamic> json) {
    return Screenshot(id: json['id'], image: json['image'],);
  }
}

class SystemRequirements {
  final String os;
  final String processor;
  final String memory;
  final String graphics;
  final String storage;

  SystemRequirements({
    required this.os,
    required this.processor,
    required this.memory,
    required this.graphics,
    required this.storage,
  });

  factory SystemRequirements.fromJson(Map<String, dynamic> json) {
    return SystemRequirements(
      os: json['os'],
      processor: json['processor'],
      memory: json['memory'],
      graphics: json['graphics'],
      storage: json['storage'],
    );
  }
}