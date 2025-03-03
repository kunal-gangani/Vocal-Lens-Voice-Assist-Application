import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vocal_lens/Keys/api_keys.dart';

class ChatWithAiController extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, String>> messages = [];
  final List<String> history = [];
  bool isLoading = false;
  final box = GetStorage();
  String searchQueryVar = '';
  List<Map<String, String>> filteredMessages = [];

  final GenerativeModel generativeModel = GenerativeModel(
    model: ApiKeys.geminiModel,
    apiKey: ApiKeys.geminiApiKey,
  );

  ChatWithAiController() {
    loadMessages();
  }

  List<Map<String, String>> get getMessages => List.from(filteredMessages);

  List<String> get getHistory => List.from(history);

  void saveMessages() {
    box.write('chat_messages', messages);
  }

  void loadMessages() {
    List<dynamic>? storedMessages = box.read<List<dynamic>>('chat_messages');
    if (storedMessages != null) {
      messages.addAll(storedMessages.map((e) => Map<String, String>.from(e)));
    }
    filterMessages();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQueryVar = query;
    filterMessages();
    notifyListeners();
  }

  void filterMessages() {
    if (searchQueryVar.isEmpty) {
      filteredMessages = List.from(messages);
    } else {
      filteredMessages = messages.where((message) {
        String question = message['question'] ?? '';
        String answer = message['answer'] ?? '';

        return question.toLowerCase().contains(searchQueryVar.toLowerCase()) ||
            answer.toLowerCase().contains(searchQueryVar.toLowerCase());
      }).toList();
    }
  }

  Future<void> sendMessage() async {
    String userMessage = messageController.text.trim();
    if (userMessage.isEmpty) return;

    messages.add({'question': userMessage});
    saveMessages();
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
      saveMessages();
    } catch (error) {
      log('Error during API call: $error');
      messages.add({'answer': 'Error: Unable to fetch AI response.'});
    } finally {
      isLoading = false;
      filterMessages();
      notifyListeners();
    }
  }

  Future<void> searchQuery() async {
    String query = messageController.text.trim();
    if (query.isEmpty) return;

    messages.add({'question': query});
    history.add(query);
    saveMessages();
    messageController.clear();

    isLoading = true;
    notifyListeners();

    try {
      final response = await generativeModel.generateContent([
        Content.text(query),
      ]);

      if (response.text != null) {
        messages.add({'answer': response.text!});
      } else {
        messages.add({'answer': 'AI could not generate a response.'});
      }
      saveMessages();
    } catch (error) {
      log('Error during API call: $error');
      messages.add({
        'answer': 'Error occurred while fetching the response.',
      });
    } finally {
      isLoading = false;
      filterMessages();
      notifyListeners();
    }
  }
}
