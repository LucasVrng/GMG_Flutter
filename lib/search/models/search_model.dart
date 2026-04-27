// lib/search/models/search_models.dart

class Game {
  final int id;
  final String title;
  final String genre;
  final String thumbnail;
  final String shortDescription;

  Game({
    required this.id,
    required this.title,
    required this.genre,
    required this.thumbnail,
    required this.shortDescription,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      genre: json['genre'],
      thumbnail: json['thumbnail'],
      shortDescription: json['short_description'],
    );
  }
}