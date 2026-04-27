import 'package:flutter/material.dart';
import 'package:gmg_flutter/search/screen/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 70, 13, 5)),
      ),
      home: const SearchScreen(),
    );
  }
}



