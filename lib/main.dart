import 'package:flutter/material.dart';
import 'package:gmg_flutter/main_screen.dart';
import 'package:gmg_flutter/details/screen/details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainScreen(), // 👈 remplace HomePage
      routes: {
        '/detail': (context) {
          final id = ModalRoute.of(context)!.settings.arguments as int;
          return DetailsScreen(id: id);
        },
      },
    );
  }
}