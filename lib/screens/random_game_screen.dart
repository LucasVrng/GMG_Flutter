import 'package:flutter/material.dart';

import '../models/game.dart';
import '../services/game_service.dart';

class _SteamColors {
  static const Color background = Color(0xFF1B2838);
  static const Color panel = Color(0xFF2A475E);
  static const Color panelLight = Color(0xFF66C0F4);
  static const Color accent = Color(0xFFA4D007);
  static const Color accentDark = Color(0xFF5C7E10);
  static const Color textPrimary = Color(0xFFC7D5E0);
  static const Color textMuted = Color(0xFF8F98A0);
}

class RandomGameScreen extends StatefulWidget {
  const RandomGameScreen({super.key});

  @override
  State<RandomGameScreen> createState() => _RandomGameScreenState();
}

class _RandomGameScreenState extends State<RandomGameScreen> {
  final GameService _service = GameService();
  late Future<Game> _futureGame;

  @override
  void initState() {
    super.initState();
    _futureGame = _service.fetchRandomGame();
  }

  void _reroll() {
    setState(() {
      _futureGame = _service.fetchRandomGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _SteamColors.background,
      appBar: AppBar(
        backgroundColor: _SteamColors.panel,
        foregroundColor: _SteamColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Random discovery',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to home',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: 'Pick another game',
            onPressed: _reroll,
          ),
        ],
      ),
      body: FutureBuilder<Game>(
        future: _futureGame,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingView();
          }
          if (snapshot.hasError) {
            return _ErrorView(
              message: snapshot.error.toString(),
              onRetry: _reroll,
            );
          }
          final game = snapshot.data;
          if (game == null) {
            return _ErrorView(
              message: 'No game received.',
              onRetry: _reroll,
            );
          }
          return _GameDetailView(game: game, onReroll: _reroll);
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: _SteamColors.panelLight),
          SizedBox(height: 16),
          Text(
            'Loading game...',
            style: TextStyle(color: _SteamColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                color: _SteamColors.panelLight, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _SteamColors.textPrimary),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _SteamColors.accentDark,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameDetailView extends StatelessWidget {
  const _GameDetailView({required this.game, required this.onReroll});

  final Game game;
  final VoidCallback onReroll;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  game.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: _SteamColors.panel,
                    child: const Icon(Icons.broken_image,
                        color: _SteamColors.textMuted, size: 48),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        _SteamColors.background,
                      ],
                      stops: [0.6, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.devices,
                        size: 16, color: _SteamColors.textMuted),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        game.platform,
                        style: const TextStyle(
                          color: _SteamColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _SteamColors.panel,
                        Color(0xFF1F3A50),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.shortDescription,
                        style: const TextStyle(
                          color: _SteamColors.textPrimary,
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _InfoRow(label: 'Genre', value: game.genre),
                      _InfoRow(label: 'Developer', value: game.developer),
                      _InfoRow(label: 'Publisher', value: game.publisher),
                      _InfoRow(
                        label: 'Release date',
                        value: game.releaseDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onReroll,
                    icon: const Icon(Icons.casino),
                    label: const Text('Pick another game'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _SteamColors.accentDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: _SteamColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                color: _SteamColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
