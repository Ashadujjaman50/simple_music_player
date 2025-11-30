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
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.blue.shade300,
          inactiveTrackColor: Colors.blue.shade100,
          thumbColor: Colors.blueAccent,
          overlayColor: Colors.blue.withOpacity(0.2),
          trackHeight: 4,                       // ট্র্যাকের উচ্চতা
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 20),

        )
      ),
      home: const MusicPlayerScreen(),
    );
  }
}
