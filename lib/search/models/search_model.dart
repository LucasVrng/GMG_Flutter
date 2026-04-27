
class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String shortDescription;
  final String gameUrl;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;
  final String freetogameProfileUrl;

  Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.shortDescription,
    required this.gameUrl,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.freetogameProfileUrl,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'N/A',
      thumbnail: json['thumbnail'] ?? '',
      shortDescription: json['short_description'] ?? '',
      gameUrl: json['game_url'] ?? '',
      genre: json['genre'] ?? 'N/A',
      platform: json['platform'] ?? 'N/A',
      publisher: json['publisher'] ?? 'N/A',
      developer: json['developer'] ?? 'N/A',
      releaseDate: json['release_date'] ?? 'N/A',
      freetogameProfileUrl: json['freetogame_profile_url'] ?? '',
    );
  }
}