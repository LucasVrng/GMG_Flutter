import 'package:flutter/material.dart';
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

const Color backgroundMain = Color(0xFF1B2838);
const Color backgroundTop = Color(0xFF2A3F55);
const Color cardColor = Color(0xFF2F4A63);
const Color buttonGreen = Color(0xFF6A8F1F);
const Color textPrimary = Color(0xFFFFFFFF);
const Color textSecondary = Color(0xFFB8C6D1);
const Color labels = Color(0xFF8FA6B8);

class DetailsScreen extends StatefulWidget {
  final int id;
  const DetailsScreen({super.key, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<Game> futureGame;

  @override
  void initState() {
    super.initState();
    futureGame = fetchGame(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundMain,
      appBar: AppBar(
        title: const Text(
          "Game Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        backgroundColor: backgroundTop,
      ),
      body: FutureBuilder<Game>(
        future: futureGame,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final game = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Image.network(
                          game.thumbnail,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Card(
                          color: cardColor,
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                infoRow("Genre", game.genre),
                                infoRow("Platform", game.platform),
                                infoRow("Publisher", game.publisher),
                                infoRow("Developer", game.developer),
                                infoRow("Release Date", game.releaseDate),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          game.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: textSecondary,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Card(
                          elevation: 4,
                          color: backgroundMain,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Minimum System Requirements",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                infoRow("OS", game.minimumSystemRequirements.os),
                                infoRow("Processor", game.minimumSystemRequirements.processor),
                                infoRow("Memory", game.minimumSystemRequirements.memory),
                                infoRow("Graphics", game.minimumSystemRequirements.graphics),
                                infoRow("Storage", game.minimumSystemRequirements.storage),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        game.screenshots.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Screenshots",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...game.screenshots.map((screenshot) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        screenshot.image,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            )
                          : const Text("No screenshots found"),

                        const SizedBox(height: 70),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

Widget infoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          "$title: ",
          style: const TextStyle(
            color: labels,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}