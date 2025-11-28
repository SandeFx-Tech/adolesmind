import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adolesmind/screens/home_screen.dart';
import 'package:adolesmind/screens/quiz_screen.dart';
import 'package:adolesmind/screens/ai_chat_screen.dart';
import 'package:adolesmind/screens/nearby_help_screen.dart';

void main() {
  runApp(const MentalTrainingApp());
}

class MentalTrainingApp extends StatelessWidget {
  const MentalTrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1621),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const QuizScreen(),
    const AIChatScreen(),
    const NearbyHelpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1F2E),
        selectedItemColor: const Color(0xFF39FF14),
        unselectedItemColor: Colors.white38,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Nearby'),
        ],
      ),
    );
  }
}

