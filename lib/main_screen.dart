import 'package:flutter/material.dart';
import 'package:gmg_flutter/home/screen/homepage.dart';
import 'package:gmg_flutter/search/screen/search_screen.dart';
import 'package:gmg_flutter/random/screen/random_game_screen.dart'; // à créer
import 'package:gmg_flutter/widgets/navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const SearchScreen(),
    const RandomGameScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}