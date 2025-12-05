import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<Map<String, String>> _tracks = [
    {
      'title': 'The Daily Deuce',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
    {
      'title': 'Motivation Booster',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    },
    {
      'title': 'Mindfulness Session',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    },
  ];

  int _currentTrackIndex = 0;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() => _isPlaying = false);
    });

    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(
        UrlSource(_tracks[_currentTrackIndex]['url']!),
      );
      setState(() => _isPlaying = true);
    }
  }

  void _switchTrack(int index) async {
    _currentTrackIndex = index;
    _position = Duration.zero;
    _duration = Duration.zero;

    await _audioPlayer.stop();
    await _audioPlayer.play(
      UrlSource(_tracks[_currentTrackIndex]['url']!),
    );

    setState(() => _isPlaying = true);
  }

  @override
  Widget build(BuildContext context) {
    final currentTrack = _tracks[_currentTrackIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0F111D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Adolesmind Audio Sessions',
                  style: GoogleFonts.orbitron(
                    color: const Color(0xFF39FF14),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tracks.length,
                    itemBuilder: (ctx, index) {
                      final isSelected = index == _currentTrackIndex;

                      return GestureDetector(
                        onTap: () => _switchTrack(index),
                        child: Container(
                          width: 180,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF39FF14)
                                : const Color(0xFF1A1F2E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              _tracks[index]['title']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color:
                                    isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  currentTrack['title']!,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble() > 0
                      ? _duration.inSeconds.toDouble()
                      : 1,
                  value: _position.inSeconds
                      .toDouble()
                      .clamp(0, _duration.inSeconds.toDouble()),
                  onChanged: (value) async {
                    await _audioPlayer
                        .seek(Duration(seconds: value.toInt()));
                  },
                  activeColor: const Color(0xFF39FF14),
                  inactiveColor: Colors.white24,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xFF39FF14),
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 36,
                      color: Colors.black,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
