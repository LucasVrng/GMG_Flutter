// lib/search/screens/search_screen.dart
import 'package:flutter/material.dart';
import '../models/search_model.dart';
import '../services/search_services.dart';
import '../../detail/screens/detail_screens.dart'; 

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchService _service = SearchService();
  String _selectedGenre = 'All Games';
  late Future<List<Game>> _gamesFuture;

  final Color steamDarkBlue = const Color(0xFF1b2838); 
  final Color steamGrey = const Color(0xFF171a21);
  final Color steamLightGrey = const Color(0xFFc7d5e0);
  final Color steamMenuBg = const Color(0xFF3d4450);

  @override
  void initState() {
    super.initState();
    _gamesFuture = _service.fetchGames();
  }

  void _filterGames(String genre) {
    setState(() {
      _selectedGenre = genre;
      _gamesFuture = _service.fetchGames(genre: genre);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: steamGrey,
      appBar: AppBar(
        backgroundColor: steamDarkBlue,
        elevation: 0,
        centerTitle: false,
        title: PopupMenuButton<String>(
          offset: const Offset(0, 50),
          color: steamMenuBg,
          onSelected: _filterGames,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Games List",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Icon(Icons.arrow_drop_down, color: steamLightGrey),
            ],
          ),
          itemBuilder: (context) => [
            'All Games', 'MMORPG', 'Shooter', 'MOBA', 'Anime', 'Battle Royale', 
            'Strategy', 'Fantasy', 'Sci-Fi', 'Card Games', 'Racing', 'Fighting'
          ].map((genre) => PopupMenuItem<String>(
                value: genre,
                child: Text(
                  genre, 
                  style: TextStyle(
                    color: genre == _selectedGenre ? Colors.white : steamLightGrey,
                    fontWeight: genre == _selectedGenre ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              )).toList(),
        ),
      ),
      body: FutureBuilder<List<Game>>(
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          }
          
          if (snapshot.hasError) {
            return const Center(child: Text("Erreur de connexion", style: TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun jeu trouvé", style: TextStyle(color: Colors.white)));
          }

          final games = snapshot.data!;
          return ListView.builder(
            itemCount: games.length,
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            itemBuilder: (context, index) {
              final game = games[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(game: game), 
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                          child: Image.network(
                            game.thumbnail, 
                            width: 130, 
                            height: 75, 
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                                Container(width: 130, height: 75, color: Colors.grey[900]),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                game.title, 
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                game.genre, 
                                style: const TextStyle(color: Colors.blueAccent, fontSize: 12)
                              ),
                              Text(
                                game.platform, 
                                style: TextStyle(color: steamLightGrey.withOpacity(0.5), fontSize: 10)
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Color(0xFF3d4450)),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}