import 'package:google_generative_ai/google_generative_ai.dart';
import './chatbot_service.dart';

class ChatViewModel {
  // Get the API key from dart-define
  static const _apiKey = String.fromEnvironment('GEMINI_API_KEY');
  final ChatbotService _service = ChatbotService();

  late final GenerativeModel _model;
  late final ChatSession _chat;

  ChatViewModel() {
    if (_apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not set.');
    }

    // Initialize the model WITHOUT tools for now
    _model = GenerativeModel(
      model: 'gemini-1.5-pro-latest',
      apiKey: _apiKey,
    );

    // Start a chat session
    _chat = _model.startChat();
  }

  // Simple method to send a text message and get a text response
  Future<GenerateContentResponse> sendMessage(String text) async {
    final response = await _chat.sendMessage(Content.text(text));
    return response;
  }
}