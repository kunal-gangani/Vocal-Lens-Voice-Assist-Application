import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer';

class ChatWithAiController extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, String>> messages = [];
  final List<String> history = [];
  bool isLoading = false;

  final GenerativeModel generativeModel = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'AIzaSyCzaJagaearxYYdwfRe8G_oEmcNKc3gB-Q',
  );

  List<Map<String, String>> get getMessages => List.from(messages);

  List<String> get getHistory => List.from(history);

  Future<void> sendMessage() async {
    String userMessage = messageController.text.trim();
    if (userMessage.isEmpty) return;

    messages.add({'user': userMessage});
    messageController.clear();

    history.add(userMessage);

    isLoading = true;

    notifyListeners();

    try {
      final response = await generativeModel.generateContent([
        Content.text(userMessage),
      ]);

      if (response.text != null) {
        messages.add({'ai': response.text!});
      }
    } catch (error) {
      messages.add(
        {
          'ai': 'Error: Unable to fetch AI response.',
        },
      );
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> searchQuery() async {
    String query = messageController.text.trim();
    if (query.isEmpty) return;

    history.add(query);

    isLoading = true;
    notifyListeners();

    try {
      final response = await generativeModel.generateContent([
        Content.text(query),
      ]);

      isLoading = false;
      notifyListeners();

      if (response.text != null) {
        messages.add({
          'question': query,
          'answer': response.text!,
        });
        messageController.clear();
      }

      log('Response: ${response.text}');
    } catch (error) {
      log('Error occurred: $error');
      isLoading = false;
      notifyListeners();
    }
  }
}
