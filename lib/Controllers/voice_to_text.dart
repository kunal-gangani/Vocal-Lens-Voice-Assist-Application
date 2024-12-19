import 'dart:developer';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vocal_lens/Views/ChatSection/chat_section.dart';
import 'package:vocal_lens/Views/DetailedResponsePage/detailed_response_pages.dart';
import 'package:vocal_lens/Views/FavouritesResponsesPage/favourite_responses_page.dart';
import 'package:vocal_lens/Views/PastResponsesPage/past_responses_page.dart';

class VoiceToTextController extends ChangeNotifier {
  late stt.SpeechToText speechToText;
  late FlutterTts flutterTts;
  bool isListening = false;
  bool isLoading = false;
  String text = "Press the mic to start speaking...";
  final List<String> history = [];
  final TextEditingController searchFieldController = TextEditingController();
  List<Map<String, dynamic>> responses = [];
  bool isLoadingQuery = false;
  bool isButtonEnabled = false;

  VoiceToTextController() {
    speechToText = stt.SpeechToText();
    flutterTts = FlutterTts();

    searchFieldController.addListener(() {
      isButtonEnabled = searchFieldController.text.isNotEmpty;
      notifyListeners();
    });
  }

  void startListening() async {
    bool available = await speechToText.initialize();
    if (available) {
      isListening = true;
      isLoading = true;

      speechToText.listen(onResult: (result) {
        text = result.recognizedWords;
      });
    }
    notifyListeners();
  }

  // Stop listening
  void stopListening() {
    isListening = false;
    isLoading = false;
    speechToText.stop();

    notifyListeners();
  }

  // Convert text to speech
  void speakText() async {
    await flutterTts.speak(text);
  }

  // Search on Google
  void searchOnGoogle() {
    final url = 'https://www.google.com/search?q=${Uri.encodeComponent(text)}';
    launchUrl(Uri.parse(url));
  }

  // Clear the text
  void clearText() {
    text = "Press the mic to start speaking...";
    notifyListeners();
  }

  void searchYourQuery() async {
    responses.clear();

    String apiKey = "AIzaSyCzaJagaearxYYdwfRe8G_oEmcNKc3gB-Q";

    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

    final prompt = searchFieldController.text;
    final content = [Content.text(prompt)];

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
  }

  void openChatSection() {
    Flexify.go(
      const ChatSectionPage(),
      animation: FlexifyRouteAnimations.blur,
      animationDuration: Durations.medium1,
    );
  }

  void openResponsesInZoom() {
    Flexify.go(
      const DetailedResponsePages(),
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
