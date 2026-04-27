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
  final SystemRequirements? minimumSystemRequirements;
  final List<Screenshot> screenshots;

  const Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.gameUrl,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.minimumSystemRequirements,
    required this.screenshots,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      description: json['description'],
      gameUrl: json['game_url'],
      genre: json['genre'],
      platform: json['platform'],
      publisher: json['publisher'],
      developer: json['developer'],
      releaseDate: json['release_date'],
      minimumSystemRequirements: json['minimum_system_requirements'] != null
          ? SystemRequirements.fromJson(json['minimum_system_requirements'])
          : null,
      screenshots: (json['screenshots'] as List)
          .map((e) => Screenshot.fromJson(e))
          .toList(),
    );
  }
}

class Screenshot {
  final int id;
  final String image;

  Screenshot({required this.id, required this.image});

  factory Screenshot.fromJson(Map<String, dynamic> json) {
    return Screenshot(id: json['id'], image: json['image']);
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
    os: json['os'] ?? 'N/A',
    processor: json['processor'] ?? 'N/A',
    memory: json['memory'] ?? 'N/A',
    graphics: json['graphics'] ?? 'N/A',
    storage: json['storage'] ?? 'N/A',
    );
  }
}