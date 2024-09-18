import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/music_home_screen.dart';
import 'provider/music_player_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MusicPlayerProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iPod Music Player',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MusicHomeScreen(),
    );
  }
}
