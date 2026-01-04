import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Demo pages
import '../../demo/notices_page.dart';
import '../../demo/events_page.dart';
import '../../demo/academics_page.dart';
import '../../demo/timetable_page.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage(this.text, this.isUser);
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  final String backendUrl = "http://127.0.0.1:8000/chat";

  /// ---------------- SEND MESSAGE ----------------
  Future<void> sendMessage(String text) async {
    final userText = text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(userText, true));
    });

    _controller.clear();

    // ✅ Handle navigation ONLY from user input
    handleIntentFromUser(userText);

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": userText}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["reply"] ?? "No response";

        setState(() {
          _messages.add(ChatMessage(reply, false));
        });
      } else {
        showBotError();
      }
    } catch (_) {
      showBotError();
    }
  }

  /// ---------------- INTENT FROM USER (FIX) ----------------
  void handleIntentFromUser(String userText) {
    final lower = userText.toLowerCase();

    if (lower.contains("notice")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NoticesPage()),
      );
    } else if (lower.contains("event")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EventsPage()),
      );
    } else if (lower.contains("academic")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AcademicsPage()),
      );
    } else if (lower.contains("timetable") ||
        lower.contains("schedule")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TimetablePage()),
      );
    }
  }

  void showBotError() {
    setState(() {
      _messages.add(
        ChatMessage("⚠️ Unable to connect to campus server.", false),
      );
    });
  }

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 No aggressive blue navigation behavior
      appBar: AppBar(
        title: const Text("CampusONE Assistant"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? const Color(0xFF1A73E8)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color:
                            msg.isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask CampusONE...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () =>
                      sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
