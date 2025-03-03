import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  // Gemini API
  static String get geminiApiKey => dotenv.env['AIzaSyCzaJagaearxYYdwfRe8G_oEmcNKc3gB-Q'] ?? '';
  static String get geminiModel => dotenv.env['GEMINI_MODEL'] ?? 'gemini-pro';
  static String get geminiBaseUrl => dotenv.env['GEMINI_BASE_URL'] ?? '';

  // YouTube API
  static String get youtubeApiKey => dotenv.env['AIzaSyB5afyDgR9WOZqE7jga7P-KeyNlzQ00g00'] ?? '';
  static String get youtubeBaseUrl => dotenv.env['https://www.googleapis.com/youtube/v3'] ?? '';
}
