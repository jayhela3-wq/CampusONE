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
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  final String backendUrl = "http://127.0.0.1:8000/chat";

  bool awaitingSummaryConfirmation = false;

  /// ---------------- SEND MESSAGE ----------------
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text, true));
    });

    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["reply"] ?? "No response";

        setState(() {
          _messages.add(ChatMessage(reply, false));
        });

        handleIntent(reply);
      } else {
        showBotError();
      }
    } catch (e) {
      showBotError();
    }
  }

  /// ---------------- HANDLE INTENTS ----------------
  void handleIntent(String reply) {
    final lower = reply.toLowerCase();

    if (lower.contains("notices")) {
      awaitingSummaryConfirmation = true;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NoticesPage()),
      );
    } else if (lower.contains("events")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EventsPage()),
      );
    } else if (lower.contains("academics")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AcademicsPage()),
      );
    } else if (lower.contains("timetable")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TimetablePage()),
      );
    } else if (
        awaitingSummaryConfirmation &&
        (lower.contains("yes") || lower.contains("summarize"))) {
      awaitingSummaryConfirmation = false;
      sendMessage("summarize latest notices");
    }
  }

  void showBotError() {
    setState(() {
      _messages.add(
        ChatMessage("⚠️ Unable to connect to server.", false),
      );
    });
  }

  /// ---------------- QUICK REPLIES ----------------
  Widget quickReplies() {
    return Wrap(
      spacing: 8,
      children: [
        quickButton("Notices"),
        quickButton("Events"),
        quickButton("Academics"),
        quickButton("Timetable"),
      ],
    );
  }

  Widget quickButton(String label) {
    return ElevatedButton(
      onPressed: () => sendMessage("show $label"),
      child: Text(label),
    );
  }

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CampusONE Assistant"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: quickReplies(),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isUser ? Colors.white : Colors.black,
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
                  onPressed: () => sendMessage(_controller.text),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
