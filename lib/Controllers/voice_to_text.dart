import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_speech/text_to_speech.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flexify/flexify.dart';
import 'package:vocal_lens/Views/ChatSection/chat_section.dart';
import 'package:vocal_lens/Views/ConnectionsRequestPage/connection_request_page.dart';
import 'package:vocal_lens/Views/FavouritesResponsesPage/favourite_responses_page.dart';
import 'package:vocal_lens/Views/PastResponsesPage/past_responses_page.dart';
import 'package:vocal_lens/Views/UserSettingsPage/user_settings_page.dart';
import 'package:share_plus/share_plus.dart';

class VoiceToTextController extends ChangeNotifier {
  late stt.SpeechToText speechToText;
  bool isListening = false;
  bool isLoading = false;
  bool isSpeaking = false;
  bool isPaused = false;
  String text = "Press the mic to start speaking...";
  List<String> history = [];
  List<String> _favoritesList = [];
  TextEditingController searchFieldController = TextEditingController();
  List<Map<String, dynamic>> responses = [];
  bool isLoadingQuery = false;
  bool isButtonEnabled = false;
  final textToSpeech = TextToSpeech();
  String? lastSpokenAnswer;
  final storage = GetStorage();
  final String historyKey = 'history';
  final String favoritesKey = 'favorites';
  List<String> pinnedList = [];

  List<String> get favoritesList => _favoritesList;

  VoiceToTextController() {
    speechToText = stt.SpeechToText();

    List<dynamic>? savedHistory = storage.read<List<dynamic>>(historyKey);
    if (savedHistory != null) {
      history = savedHistory.cast<String>();
    }

    List<dynamic>? savedFavorites = storage.read<List<dynamic>>(favoritesKey);
    if (savedFavorites != null) {
      _favoritesList = savedFavorites.cast<String>();
    }

    searchFieldController.addListener(() {
      isButtonEnabled = searchFieldController.text.isNotEmpty;
      notifyListeners();
    });
  }

  void _saveHistory() {
    storage.write(historyKey, history);
  }

  void _saveFavorites() {
    storage.write(favoritesKey, _favoritesList);
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

  void deleteAllHistory() {
    history.clear();
    _saveHistory();
    notifyListeners();
  }

  void readOrPromptResponse() async {
    log("Checking responses and speaking status...");

    if (responses.isNotEmpty) {
      String currentAnswer = responses.last['answer'];
      log("Answer to speak: $currentAnswer");

      if (!isSpeaking) {
        isSpeaking = true;
        isPaused = false;
        lastSpokenAnswer = currentAnswer;
        log("Speaking the answer: $currentAnswer");
        await textToSpeech.speak(currentAnswer).then((_) {
          isSpeaking = false;
        });
      }
    } else {
      log("No response found, prompting user.");
      if (!isSpeaking && !isPaused) {
        isSpeaking = true;
        lastSpokenAnswer = "Please search for a question or request first.";
        log("Speaking default prompt: $lastSpokenAnswer");
        await textToSpeech.speak(lastSpokenAnswer!).then((_) {
          isSpeaking = false;
        });
      }
    }

    notifyListeners();
  }

  void stopSpeaking() {
    textToSpeech.stop();
    isSpeaking = false;
    isPaused = true;
    log("Speech stopped. isSpeaking: $isSpeaking, isPaused: $isPaused");
    notifyListeners();
  }

  void resumeSpeaking() {
    if (!isSpeaking && isPaused) {
      isSpeaking = true;
      isPaused = false;
      log("Resuming speech. isSpeaking: $isSpeaking, isPaused: $isPaused");
      textToSpeech.speak(lastSpokenAnswer!);
    }
    notifyListeners();
  }

  void startListening() async {
    bool available = await speechToText.initialize();
    if (available) {
      isListening = true;
      speechToText.listen(onResult: (result) {
        String recognizedText = result.recognizedWords.toLowerCase();
        handleVoiceCommand(recognizedText);
        notifyListeners();
      });
    } else {
      text = "Speech recognition is not available.";
      notifyListeners();
    }
  }

  void shareResponse({required String response}) {
    Share.share(response, subject: "Check out this response!");
  }

  void shareMultipleResponses(List<Map<String, dynamic>> responses) {
    String allResponses = responses.map((r) => r['answer']).join('\n\n');
    Share.share(
      allResponses,
      subject: "Check out these responses!",
    );
  }

  void copyToClipboard({required String text, required BuildContext context}) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Copied to clipboard!",
        ),
      ),
    );
  }

  void handleVoiceCommand(String command) {
    if (command.contains("help")) {
      String helpMessage = "Here are the commands you can say: "
          "Open settings, show my favorites, show my history, start chat, delete all history. And many more";
      textToSpeech.speak(helpMessage);
    } else if (command.contains("open settings")) {
      openUserSettings();
      textToSpeech.speak("Opening settings.");
    } else if (command.contains("show my favorites") ||
        command.contains("show my favorite")) {
      openFavoriteResponses();
      textToSpeech.speak("Showing your favourites.");
    } else if (command.contains("show my history")) {
      openPastResponses();
      textToSpeech.speak("Showing past history.");
    } else if (command.contains("start chat")) {
      openChatSection();
      textToSpeech.speak("Opening chat section.");
    } else if (command.contains("delete all history")) {
      deleteAllHistory();
      textToSpeech.speak("Deleting History.");
    } else if (command.contains("stop speaking")) {
      stopSpeaking();
    } else if (command.contains("resume speaking")) {
      resumeSpeaking();
    } else {
      log("Command not recognized: $command");
      textToSpeech.speak(
          "Sorry, I didn't understand that command Would you mind repeating it?");
    }
  }

  void togglePin(String query) {
    if (pinnedList.contains(query)) {
      pinnedList.remove(query);
    } else {
      pinnedList.add(query);
    }
    notifyListeners();
  }

  void lockResource(int index) {
    responses[index]['isLocked'] = true;
    notifyListeners();
  }

  void unlockResource(int index) {
    responses[index]['isLocked'] = false;
    notifyListeners();
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
    log("Starting query search...");
    responses.clear();
    log("Cleared previous responses: $responses");

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

        log("Added new response: $responses");
        readOrPromptResponse();
        searchFieldController.clear();
      }
    } catch (e) {
      log("Error during API call: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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

  void openConnectionReuqestPage() {
    Flexify.go(
      const ConnectionRequestPage(),
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
