import 'dart:developer';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vocal_lens/Views/ChatSection/chat_section.dart';
import 'package:vocal_lens/Views/FavouritesResponsesPage/favourite_responses_page.dart';
import 'package:vocal_lens/Views/PastResponsesPage/past_responses_page.dart';
import 'package:vocal_lens/Views/UserSettingsPage/user_settings_page.dart';
import 'package:text_to_speech/text_to_speech.dart';

class VoiceToTextController extends ChangeNotifier {
  late stt.SpeechToText speechToText;
  bool isListening = false;
  bool isLoading = false;
  String text = "Press the mic to start speaking...";
  List<String> history = [];
  TextEditingController searchFieldController = TextEditingController();
  List<Map<String, dynamic>> responses = [];
  bool isLoadingQuery = false;
  bool isButtonEnabled = false;
  final textToSpeech = TextToSpeech();

  VoiceToTextController() {
    speechToText = stt.SpeechToText();
    searchFieldController.addListener(() {
      isButtonEnabled = searchFieldController.text.isNotEmpty;
      notifyListeners();
    });
  }

  // Method to toggle the listening state
  void toggleListening() {
    isListening = !isListening;
    notifyListeners();

    if (isListening) {
      startListening();
    } else {
      stopListening();
    }
  }

  void readResponse({required VoiceToTextController value}) {
    textToSpeech.speak(value.responses[0]['answer']);
    notifyListeners();
  }

  void startListening() async {
    bool available = await speechToText.initialize();
    if (available) {
      isListening = true;
      isLoading = true;

      speechToText.listen(onResult: (result) {
        text = result.recognizedWords;
        notifyListeners();
      });
    } else {
      text = "Speech recognition is not available.";
      notifyListeners();
    }
  }

  void stopListening() {
    isListening = false;
    isLoading = false;
    speechToText.stop();
    notifyListeners();
  }

  // Method to delete a response from history
  void deleteHistory(int index) {
    history.removeAt(index);
    notifyListeners();
  }

  void searchYourQuery() async {
    responses.clear();

    String apiKey = "AIzaSyCzaJagaearxYYdwfRe8G_oEmcNKc3gB-Q";

    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );

    final prompt = searchFieldController.text;
    final content = [Content.text(prompt)];

    // Save the search query in history
    history.add(prompt);

    isLoading = true;

    final response = await model.generateContent(content);

    isLoading = false;

    log("${response.text}");

    if (response.text != null) {
      responses.add({
        "question": prompt,
        "answer": response.text,
      });

      searchFieldController.clear();
    }

    notifyListeners();
  }

  void openChatSection() {
    Flexify.go(
      const ChatSectionPage(),
      animation: FlexifyRouteAnimations.blur,
      animationDuration: Durations.medium1,
    );
  }

  void openUserSettings() {
    Flexify.go(
      const UserSettingsPage(),
      animation: FlexifyRouteAnimations.blur,
      animationDuration: Durations.medium1,
    );
  }

  void openPastResponses() {
    Flexify.go(
      const PastResponsesPage(),
      animation: FlexifyRouteAnimations.blur,
      animationDuration: Durations.medium1,
    );
  }

  void openFavoriteResponses() {
    Flexify.go(
      const FavouriteResponsesPage(),
      animation: FlexifyRouteAnimations.blur,
      animationDuration: Durations.medium1,
    );
  }
}
