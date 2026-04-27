// lib/search/screens/search_screen.dart
import 'package:flutter/material.dart';
import '../models/search_model.dart';
import '../services/search_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchService _service = SearchService();
  String _selectedGenre = 'All Games';
  late Future<List<Game>> _gamesFuture;

  // Couleurs Steam
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
        title: PopupMenuButton<String>(
          offset: const Offset(0, 50),
          color: steamMenuBg,
          onSelected: _filterGames,
          // Le bouton de la AppBar
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Games List",
                style: TextStyle(color: steamLightGrey, fontSize: 18),
              ),
              Icon(Icons.arrow_drop_down, color: steamLightGrey),
            ],
          ),
          itemBuilder: (context) => [
            'MMORPG', 'Shooter', 'MOBA', 'Anime', 'Battle Royale', 
            'Strategy', 'Fantasy', 'Sci-Fi', 'Card Games', 
            'Racing', 'Fighting', 'Social', 'Sports', 'All Games'
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
            return const Center(child: CircularProgressIndicator(color: Colors.blueGrey));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun jeu trouvé", style: TextStyle(color: Colors.white)));
          }

          final games = snapshot.data!;
          return ListView.builder(
            itemCount: games.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final game = games[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(game.thumbnail, width: 100, fit: BoxFit.cover),
                  ),
                  title: Text(
                    game.title, 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(game.genre, style: const TextStyle(color: Colors.blueAccent, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        game.shortDescription, 
                        maxLines: 2, 
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: steamLightGrey.withOpacity(0.7), fontSize: 11),
                      ),
                    ],
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