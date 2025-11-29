import 'package:flutter/material.dart';
import 'package:simple_music_player/ui/music_player_screen.dart';

class SimpleMusicPlayerApp extends StatelessWidget {
  const SimpleMusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: Colors.blue.shade100,
        cardTheme: CardThemeData(
          color: Colors.blue.shade200,
        )
      ),
      home: const MusicPlayerScreen(),
    );
  }
}
