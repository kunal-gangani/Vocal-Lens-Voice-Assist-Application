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

    messages.add({'question': userMessage});
    messageController.clear();

    isLoading = true;
    notifyListeners();

    try {
      final response = await generativeModel.generateContent([
        Content.text(userMessage),
      ]);

      if (response.text != null) {
        messages.add({'answer': response.text!});
      } else {
        messages.add({'answer': 'AI could not generate a response.'});
      }
    } catch (error) {
      log('Error during API call: $error');
      messages.add({'answer': 'Error: Unable to fetch AI response.'});
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchQuery() async {
    String query = messageController.text.trim();
    if (query.isEmpty) return;

    history.add(query);
    messageController.clear();

    isLoading = true;
    notifyListeners();

    try {
      final response = await generativeModel.generateContent([
        Content.text(query),
      ]);

      if (response.text != null) {
        messages.add({'question': query, 'answer': response.text!});
      } else {
        messages.add(
            {'question': query, 'answer': 'AI could not generate a response.'});
      }

      log('AI Response: ${response.text}');
    } catch (error) {
      log('Error during API call: $error');
      messages.add({
        'question': query,
        'answer': 'Error occurred while fetching the response.'
      });
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
