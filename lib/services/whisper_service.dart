import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WhisperService {
  static const String _baseUrl =
      'https://api.openai.com/v1/audio/transcriptions';

  static String get _apiKey {
    return dotenv.env['OPENAI_API_KEY'] ?? '';
  }

  /// Transcribe audio file using OpenAI Whisper API
  /// [audioFile] - The audio file to transcribe
  /// [language] - Optional language code (e.g., 'en', 'es') for better accuracy
  static Future<String> transcribeAudio(File audioFile,
      {String? language}) async {
    try {
      if (_apiKey.isEmpty) {
        throw Exception(
            'OpenAI API key not found. Please add OPENAI_API_KEY to your .env file');
      }

      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $_apiKey',
      });

      // Add form fields
      request.fields['model'] = 'whisper-1';
      request.fields['response_format'] = 'json';

      // Add language if specified
      if (language != null) {
        request.fields['language'] = language;
      }

      // Add audio file
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        audioFile.path,
        filename: 'audio.m4a',
      ));

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse['text'] ?? '';
      } else {
        print('Whisper API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to transcribe audio: ${response.statusCode}');
      }
    } catch (e) {
      print('Whisper transcription error: $e');
      throw Exception('Transcription failed: $e');
    }
  }

  /// Check if the service is properly configured
  static bool isConfigured() {
    return _apiKey.isNotEmpty;
  }
}
