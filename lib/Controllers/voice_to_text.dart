import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_speech/text_to_speech.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flexify/flexify.dart';
import 'package:vocal_lens/Views/ChatSection/chat_section.dart';
import 'package:vocal_lens/Views/FavouritesResponsesPage/favourite_responses_page.dart';
import 'package:vocal_lens/Views/PastResponsesPage/past_responses_page.dart';
import 'package:vocal_lens/Views/UserSettingsPage/user_settings_page.dart';

class VoiceToTextController extends ChangeNotifier {
  late stt.SpeechToText speechToText;
  bool isListening = false;
  bool isLoading = false;
  bool isSpeaking = false;
  bool isPaused = false;
  String text = "Press the mic to start speaking...";
  List<String> history = [];
  List<String> _favoritesList = []; // Store favorites here
  TextEditingController searchFieldController = TextEditingController();
  List<Map<String, dynamic>> responses = [];
  bool isLoadingQuery = false;
  bool isButtonEnabled = false;
  final textToSpeech = TextToSpeech();
  String? lastSpokenAnswer;
  final _storage = GetStorage();
  final String _historyKey = 'history';
  final String _favoritesKey = 'favorites'; // Key to store favorites

  List<String> get favoritesList => _favoritesList;

  VoiceToTextController() {
    speechToText = stt.SpeechToText();

    // Load saved history from storage
    List<dynamic>? savedHistory = _storage.read<List<dynamic>>(_historyKey);
    if (savedHistory != null) {
      history = savedHistory.cast<String>();
    }

    // Load saved favorites from storage
    List<dynamic>? savedFavorites = _storage.read<List<dynamic>>(_favoritesKey);
    if (savedFavorites != null) {
      _favoritesList = savedFavorites.cast<String>();
    }

    searchFieldController.addListener(() {
      isButtonEnabled = searchFieldController.text.isNotEmpty;
      notifyListeners();
    });
  }

  void _saveHistory() {
    _storage.write(_historyKey, history);
  }

  void _saveFavorites() {
    _storage.write(_favoritesKey, _favoritesList);
  }

  void toggleListening() {
    isListening = !isListening;
    notifyListeners();

    if (isListening) {
      startListening();
    } else {
      stopListening();
    }
  }

  void readOrPromptResponse() async {
    log("Checking responses and speaking status...");
    if (responses.isNotEmpty) {
      String answer = responses[0]['answer'];
      log("Answer to speak: $answer");

      if (!isSpeaking && !isPaused) {
        isSpeaking = true;
        lastSpokenAnswer = answer;
        await textToSpeech.speak(answer);
        log("Speaking the answer: $answer");
      }
    } else {
      log("No response found, prompting user.");
      if (!isSpeaking && !isPaused) {
        isSpeaking = true;
        lastSpokenAnswer = "Please search for a question or request first.";
        await textToSpeech.speak(lastSpokenAnswer!);
      }
    }

    notifyListeners();
  }

  void stopSpeaking() {
    textToSpeech.stop();
    isSpeaking = false;
    isPaused = true;
    log("Speech stopped.");
    notifyListeners();
  }

  void resumeSpeaking() {
    if (!isSpeaking && isPaused) {
      isSpeaking = true;
      isPaused = false;
      if (lastSpokenAnswer != null) {
        textToSpeech.speak(lastSpokenAnswer!);
        log("Speech resumed.");
      }
    }
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

  void deleteHistory(int index) {
    history.removeAt(index);
    _saveHistory();
    notifyListeners();
  }

  void addToFavorites(String response) {
    if (!_favoritesList.contains(response)) {
      _favoritesList.add(response);
      _saveFavorites();
      notifyListeners();
    }
  }

  void removeFromFavorites(String response) {
    _favoritesList.remove(response);
    _saveFavorites();
    notifyListeners();
  }

  Future<void> searchYourQuery() async {
    responses.clear();

    const String apiKey = "AIzaSyCzaJagaearxYYdwfRe8G_oEmcNKc3gB-Q";

    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );

    final prompt = searchFieldController.text.trim();
    if (prompt.isEmpty) return;

    final content = [Content.text(prompt)];
    history.add(prompt);
    _saveHistory();

    isLoading = true;
    notifyListeners();

    try {
      final response = await model.generateContent(content);
      log("API Response: ${response.text}");

      if (response.text != null) {
        responses.add({
          "question": prompt,
          "answer": response.text!,
        });

        searchFieldController.clear();
      }
    } catch (e) {
      log("Error during API call: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // New method to clear all responses
  void clearAllResponses() {
    responses.clear();
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
