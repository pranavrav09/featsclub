import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import './chat_view_model.dart'; // This file doesn't exist yet, we'll create it next.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatViewModel _viewModel = ChatViewModel();
  final TextEditingController _textController = TextEditingController();
  // We'll store messages here
  final List<({String text, bool fromUser})> _messages = [];
  bool _isLoading = false;

  void _sendMessage() async {
    final text = _textController.text;
    if (text.isEmpty) return;

    setState(() {
      _messages.add((text: text, fromUser: true));
      _isLoading = true;
    });

    try {
      final response = await _viewModel.sendMessage(text);
      setState(() {
        _messages.add((text: response.text ?? "Sorry, I couldn't respond.", fromUser: false));
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors
      print(e);
      setState(() {
        _messages.add((text: "Something went wrong. Please try again.", fromUser: false));
        _isLoading = false;
      });
    } finally {
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FeatsClub Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: message.fromUser ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(message.text),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}