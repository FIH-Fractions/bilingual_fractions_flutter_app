import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiChatService {
  static const String _apiKey = 'AIzaSyCXXNGv3FWa-N1MYjssj8nUrSRavoPqpqs';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent';

  static Future<String> getHint(String userMessage, String gameContext) async {
    final url = Uri.parse('$_baseUrl?key=$_apiKey');

    // Create a system prompt that instructs the model to provide hints
    final systemPrompt = '''
You are a helpful math tutor for a fractions game. The current game context is: $gameContext
Your role is to provide hints and guidance, NOT direct answers. Follow these rules:
1. Never give the exact answer
2. Break down the problem into smaller steps
3. Ask leading questions
4. Provide visual or conceptual hints
5. If the user is completely stuck, give a small hint about the next step
6. Keep responses concise and encouraging
7. If the user asks for the answer directly, explain why it's better to learn through hints
''';

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": systemPrompt},
                {"text": "User question: $userMessage"}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'].trim();
      } else {
        return "I'm having trouble connecting right now. Please try again in a moment.";
      }
    } catch (e) {
      return "Sorry, I'm having technical difficulties. Please try again later.";
    }
  }
}
