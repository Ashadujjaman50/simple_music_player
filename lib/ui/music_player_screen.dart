import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:simple_music_player/model/Song.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Song> _playlist = [
    Song(
      songName: "3-second synth melody",
      artistName: "Sample MP3",
      songUrl: "https://samplelib.com/lib/preview/mp3/sample-3s.mp3",
      durationSecond: 3,
    ),
    Song(
      songName: "6-second synth melody",
      artistName: "Sample MP3",
      songUrl: "https://samplelib.com/lib/preview/mp3/sample-6s.mp3",
      durationSecond: 6,
    ),
    Song(
      songName: "9-second melody ",
      artistName: "Sample MP3",
      songUrl: "https://samplelib.com/lib/preview/mp3/sample-9s.mp3",
      durationSecond: 9,
    ),
    Song(
      songName: "12-second melody drum ",
      artistName: "Sample MP3",
      songUrl: "https://samplelib.com/lib/preview/mp3/sample-12s.mp3",
      durationSecond: 12,
    ),
    Song(
      songName: "19 seconds awesome music",
      artistName: "Sample MP3",
      songUrl: "https://samplelib.com/lib/preview/mp3/sample-15s.mp3",
      durationSecond: 19,
    ),
  ];

  int _currentSongIndex = 0;
  bool _isPlaying = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    //_playSong(_currentSongIndex);
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
    final int previous =
        (_currentSongIndex - 1 + _playlist.length) % _playlist.length;
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
    final double currentSecond = _position.inSeconds.toDouble().clamp(
      0,
      maxSecond,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Music Player',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://img.freepik.com/premium-photo/unique-blue-banner-background-music-icon-generative-ai_1219132-6147.jpg?semt=ais_hybrid&w=740&q=80",
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    Text(
                      currentSong.songName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 5),
                    Text(
                      currentSong.artistName,
                      style: TextStyle(color: Colors.white70),
                    ),

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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: IconButton(
                            onPressed: _previousSong,
                            color: Colors.white,
                            icon: Icon(Icons.skip_previous),
                            iconSize: 32,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: IconButton(
                            onPressed: _togglePlayPause,
                            color: Colors.white,
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                            iconSize: 40,
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: IconButton(
                            onPressed: _nextSong,
                            color: Colors.white,
                            icon: Icon(Icons.skip_next),
                            iconSize: 32,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: _playlist.length,
                itemBuilder: (context, index) {
                  final Song song = _playlist[index];
                  final bool isCurrent = index == _currentSongIndex;

                  return Card(
                    color: isCurrent ? Colors.blue.shade100 : Colors.blue.shade50,
                    elevation: isCurrent ? 4 : 1,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        song.songName,
                        style: TextStyle(
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          color: isCurrent ? Colors.blue.shade600 : Colors.black,
                        ),
                      ),

                      subtitle: Text(
                        song.artistName,
                        style: TextStyle(
                          color: isCurrent ? Colors.blue.shade500 : Colors.grey[700],
                        ),
                      ),

                      trailing: Icon(
                        isCurrent && _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: isCurrent ? Colors.blue : Colors.grey[800],
                      ),

                      leading: CircleAvatar(
                        backgroundColor: isCurrent ? Colors.blue : Colors.grey.shade300,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(color: isCurrent ? Colors.white : Colors.black),
                        ),
                      ),

                      onTap: () => _playSong(index),
                    ),
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
