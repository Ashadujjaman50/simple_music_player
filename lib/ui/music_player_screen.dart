import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Song> _playlist = [
    Song(songName: "3-second synth melody", artistName: "Sample MP3", songUrl: "https://samplelib.com/lib/preview/mp3/sample-3s.mp3", durationSecond: 3),
    Song(songName: "6-second synth melody", artistName: "Sample MP3", songUrl: "https://samplelib.com/lib/preview/mp3/sample-6s.mp3", durationSecond: 6),
    Song(songName: "9-second melody ", artistName: "Sample MP3", songUrl: "https://samplelib.com/lib/preview/mp3/sample-9s.mp3", durationSecond: 9),
    Song(songName: "12-second melody drum ", artistName: "Sample MP3", songUrl: "https://samplelib.com/lib/preview/mp3/sample-12s.mp3", durationSecond: 12),
    Song(songName: "19 seconds awesome music", artistName: "Sample MP3", songUrl: "https://samplelib.com/lib/preview/mp3/sample-15s.mp3", durationSecond: 19),
  ];

  int _currentSongIndex = 0;
  bool _isPlaying = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _playSong(_currentSongIndex);
    _listenerToPlayer();
  }

  void _listenerToPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onPlayerComplete.listen((_) => _nextSong());
  }

  Future<void> _playSong(int index) async {
    _currentSongIndex = index;
    final song = _playlist[index];

    setState(() {
      _position = Duration.zero;
      _duration = Duration(seconds: song.durationSecond);
    });

    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(song.songUrl));
  }

  Future<void> _nextSong() async {
    final int next = (_currentSongIndex + 1) % _playlist.length;
    await _playSong(next);
  }

  Future<void> _previousSong() async {
    final int previous = (_currentSongIndex - 1 + _playlist.length) % _playlist.length;
    await _playSong(previous);
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {

    final Song currentSong = _playlist[_currentSongIndex];
    final double maxSecond = max(_duration.inSeconds.toDouble(), 1);
    final double currentSecond = _position.inSeconds.toDouble().clamp(0, maxSecond);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    currentSong.songName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(currentSong.artistName),

                  Slider(
                    min: 0,
                    max: maxSecond,
                    value: currentSecond,
                    onChanged: (value) async {
                      final pos = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(pos);
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_position)),
                        Text(_formatDuration(_duration)),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _previousSong,
                        icon: Icon(Icons.skip_previous),
                        iconSize: 32,
                      ),
                      IconButton(
                        onPressed: _togglePlayPause,
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        iconSize: 40,
                      ),
                      IconButton(
                        onPressed: _nextSong,
                        icon: Icon(Icons.skip_next),
                        iconSize: 32,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: _playlist.length,
                itemBuilder: (context, index) {
                  final Song song = _playlist[index];
                  final bool isCurrent = index == _currentSongIndex;

                  return ListTile(
                    title: Text(song.songName),
                    subtitle: Text(song.artistName),
                    trailing: Icon(isCurrent && _isPlaying ? Icons.pause : Icons.play_arrow),
                    leading: CircleAvatar(child: Text("${index + 1}")),
                    onTap: () => _playSong(index),

                    selected: isCurrent,
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class Song {
  final String songName;
  final String artistName;
  final String songUrl;
  final int durationSecond;

  const Song({
    required this.songName,
    required this.artistName,
    required this.songUrl,
    required this.durationSecond,
  });
}
