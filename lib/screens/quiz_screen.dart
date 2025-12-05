import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> _questions = [
    {'q': 'Little interest or pleasure in doing things?', 'a': 0},
    {'q': 'Feeling down, depressed, or hopeless?', 'a': 0},
    {'q': 'Trouble falling or staying asleep, or sleeping too much?', 'a': 0},
    {'q': 'Feeling tired or having little energy?', 'a': 0},
    {'q': 'Poor appetite or overeating?', 'a': 0},
    {'q': 'Feeling bad about yourself?', 'a': 0},
    {'q': 'Trouble concentrating?', 'a': 0},
    {'q': 'Moving or speaking slowly, or being fidgety?', 'a': 0},
    {'q': 'Thoughts that you would be better off dead?', 'a': 0},
  ];

  void _showResults() {
    int totalScore = _questions.fold(0, (sum, q) => sum + (q['a'] as int));
    String result;

    if (totalScore <= 4) {
      result = 'Minimal depression';
    } else if (totalScore <= 9) {
      result = 'Mild depression';
    } else if (totalScore <= 14) {
      result = 'Moderate depression';
    } else if (totalScore <= 19) {
      result = 'Moderately severe depression';
    } else {
      result = 'Severe depression';
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Your Score',
            style: GoogleFonts.inter(color: const Color(0xFF39FF14))),
        content: Text(
          'Total score: $totalScore\n\n$result',
          style: GoogleFonts.inter(fontSize: 18, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK',
                style: GoogleFonts.inter(color: const Color(0xFF39FF14))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _questions.length + 1,
      itemBuilder: (ctx, index) {
        if (index == _questions.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF39FF14),
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _showResults,
              child: Text('View Results',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          );
        }

        final question = _questions[index];

        return Card(
          color: const Color.fromARGB(255, 98, 111, 151),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question['q'],
                    style: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                DropdownButton<int>(
                  dropdownColor: const Color.fromARGB(255, 195, 203, 228),
                  value: question['a'],
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Not at all')),
                    DropdownMenuItem(value: 1, child: Text('Several days')),
                    DropdownMenuItem(
                        value: 2, child: Text('More than half the days')),
                    DropdownMenuItem(
                        value: 3, child: Text('Nearly every day')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      question['a'] = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
