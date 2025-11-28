import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'role': 'assistant', 'content': 'Hey warrior 🖤\nI\'m here 24/7. What\'s on your mind today?'},
  ];
  final ScrollController _scrollController = ScrollController();

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': _controller.text});
      _messages.add({'role': 'assistant', 'content': 'Thinking...'});
    });
    _scrollToBottom();

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'), // Swap for Grok API if needed
      headers: {
        'Authorization': 'Bearer YOUR_API_KEY_HERE',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini', // Or 'grok-beta' if using xAI
        'messages': [
          {'role': 'system', 'content': 'You are a compassionate, witty mental health coach.'},
          {'role': 'user', 'content': _controller.text},
        ],
        'temperature': 0.8,
      }),
    );

    setState(() {
      _messages.removeLast();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _messages.add({'role': 'assistant', 'content': data['choices'][0]['message']['content']});
      } else {
        _messages.add({'role': 'assistant', 'content': 'I\'m having trouble connecting. Try again? 🖤'});
      }
    });
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (ctx, index) {
              final isUser = _messages[index]['role'] == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF39FF14) : const Color(0xFF1A1F2E),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    _messages[index]['content']!,
                    style: GoogleFonts.inter(color: isUser ? Colors.black : Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Talk to me...',
                    hintStyle: GoogleFonts.inter(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF1A1F2E),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: const Color(0xFF39FF14),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}