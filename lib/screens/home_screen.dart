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
  Duration _duration = const Duration(minutes: 2, seconds: 29);
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() => _position = newPosition);
    });
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() => _duration = newDuration);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // Use a sample audio URL; replace with your real one
      await _audioPlayer.play(UrlSource('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'));
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Start your day off right\nwith a 2 minute dose of\nscience, wisdom, & humor.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          // Phone-like container
          Container(
            width: 320,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white10, width: 8),
            ),
            child: Column(
              children: [
                Text(
                  'MÉNTAL',
                  style: GoogleFonts.orbitron(
                    fontSize: 32,
                    color: const Color(0xFF39FF14),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  'Training',
                  style: GoogleFonts.inter(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 30),
                // Daily Deuce Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F2E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.headphones, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            'The Daily Deuce',
                            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Host image with wave (use your own assets or network images)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Stack(
                          children: [
                            Image.network(
                              'https://randomuser.me/api/portraits/men/32.jpg', // Placeholder
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned.fill(
                              child: Container(
                                color: Colors.cyan.withValues(alpha: 0.4), // Wave overlay simulation
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF39FF14),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'New Deuce every day',
                          style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'SHOVE Yourself',
                        style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_position.inMinutes}:${_position.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Slider(
                              value: _position.inSeconds.toDouble(),
                              max: _duration.inSeconds.toDouble(),
                              onChanged: (value) async {
                                await _audioPlayer.seek(Duration(seconds: value.toInt()));
                              },
                              activeColor: const Color(0xFF39FF14),
                              inactiveColor: Colors.white24,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${_duration.inMinutes}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'The necessary balance of pushing\nyourself and loving yourself',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(color: Colors.white, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChip('Balance', true),
                          const SizedBox(width: 12),
                          _buildChip('Training', false),
                        ],
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: const Color(0xFF39FF14),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 44,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Locked Daily Do
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F2E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            'The Daily Do',
                            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          const Icon(Icons.lock, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.play_arrow, color: Colors.white),
                            const SizedBox(width: 12),
                            Text('Listen to The Daily Deuce to unlock', style: GoogleFonts.inter()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF39FF14) : Colors.white10,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}