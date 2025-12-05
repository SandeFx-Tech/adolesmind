import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'content': 'Hey warrior 🖤\nI\'m here 24/7. What\'s on your mind today?'
    },
  ];

  bool _isSending = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _messages.add({'role': 'assistant', 'content': 'Thinking...'});
      _isSending = true;
    });

    _scrollToBottom();
    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse('https://api.grok.ai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['GROK_API_KEY']}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "grok-beta",
          "messages": [
            {"role": "system", "content": "You are a compassionate coach."},
            {"role": "user", "content": text}
          ],
        }),
      );

      setState(() {
        _messages.removeLast(); // remove “Thinking...”
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final content = data["choices"]?[0]?["message"]?["content"] ??
              "I’m having trouble forming a response 🖤";

          _messages.add({'role': 'assistant', 'content': content});
        } else {
          _messages.add({
            'role': 'assistant',
            'content': "Grok server error. Try again 🖤"
          });
        }

        _isSending = false;
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add({
          'role': 'assistant',
          'content': "Network error. Check your connection 🖤"
        });
        _isSending = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double bubbleMaxWidth = constraints.maxWidth * 0.70;
        double fontSize = constraints.maxWidth > 600 ? 18 : 15;
        double inputHeight = constraints.maxWidth > 600 ? 60 : 52;

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
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 14),
                      decoration: BoxDecoration(
                        color: isUser
                            ? const Color(0xFF39FF14)
                            : const Color(0xFF1E2639),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _messages[index]['content']!,
                        style: GoogleFonts.inter(
                          color: isUser ? Colors.black : Colors.white,
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // INPUT AREA
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: inputHeight,
                      child: TextField(
                        controller: _controller,
                        style: GoogleFonts.inter(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Talk to me...",
                          hintStyle: GoogleFonts.inter(color: Colors.black54),
                          filled: true,
                          fillColor: const Color(0xFFDDE3F7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: constraints.maxWidth > 600 ? 30 : 26,
                    backgroundColor: const Color(0xFF39FF14),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.black),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
