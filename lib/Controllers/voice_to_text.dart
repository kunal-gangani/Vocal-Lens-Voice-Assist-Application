import 'dart:developer';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vocal_lens/Views/ChatSection/chat_section.dart';
import 'package:vocal_lens/Views/ConnectionsRequestPage/connection_request_page.dart';
import 'package:vocal_lens/Views/FavouritesResponsesPage/favourite_responses_page.dart';
import 'package:vocal_lens/Views/HowToUsePage/how_to_use_page.dart';
import 'package:vocal_lens/Views/PastResponsesPage/past_responses_page.dart';
import 'package:vocal_lens/Views/UserSettingsPage/user_settings_page.dart';
import 'package:vocal_lens/Views/VoiceModificationPage/voice_modification_page.dart';

class VoiceToTextController extends ChangeNotifier {
  // Speech-to-Text and Text-to-Speech instances
  late stt.SpeechToText speechToText;
  final FlutterTts flutterTts = FlutterTts();

  // States and properties
  bool isListening = false;
  bool isLoading = false;
  bool isSpeaking = false;
  bool isPaused = false;
  String text = "Press the mic to start speaking...";
  String? lastSpokenAnswer;

  // Voice settings
  String voice = "en-us"; // Default voice model
  double pitch = 1.0; // Default pitch
  double speechRate = 0.5; // Default speech rate

  // Data storage and history
  final GetStorage storage = GetStorage();
  final String historyKey = 'history';
  final String favoritesKey = 'favorites';
  final String pinnedKey = 'pinned';
  List<String> history = [];
  List<String> _favoritesList = [];
  List<String> pinnedList = [];
  List<Map<String, dynamic>> responses = [];

  // Input and UI controls
  bool isButtonEnabled = false;
  final TextEditingController searchFieldController = TextEditingController();

  // API key for Google Generative AI
  static const String apiKey = "AIzaSyCzaJagaearxYYdwfRe8G_oEmcNKc3gB-Q";

  // Getters
  List<String> get favoritesList => _favoritesList;

  // Constructor
  VoiceToTextController() {
    Future<void> getAvailableVoices() async {
      List<dynamic> voices = await flutterTts.getVoices;
      log("Available Voices: $voices");
    }

    speechToText = stt.SpeechToText();
    initializeTts();

    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(pitch);
    flutterTts.setSpeechRate(speechRate);

    // Load saved data
    history = (storage.read<List<dynamic>>(historyKey) ?? []).cast<String>();
    _favoritesList =
        (storage.read<List<dynamic>>(favoritesKey) ?? []).cast<String>();
    pinnedList = (storage.read<List<dynamic>>(pinnedKey) ?? []).cast<String>();

    // Enable search button based on input
    searchFieldController.addListener(() {
      isButtonEnabled = searchFieldController.text.isNotEmpty;
      notifyListeners();
    });
  }

  Future<void> requestMicrophonePermission() async {
    // Check current permission status
    PermissionStatus status = await Permission.microphone.status;

    // If permission is denied or restricted, request it
    if (status.isDenied || status.isRestricted) {
      PermissionStatus result = await Permission.microphone.request();

      if (result.isGranted) {
        log('Microphone permission granted!');
        Fluttertoast.showToast(msg: 'Microphone permission granted!');
      } else if (result.isPermanentlyDenied) {
        log('Microphone permission permanently denied. Please enable it in settings.');
        Fluttertoast.showToast(
            msg: 'Permission permanently denied. Enable it in settings.');
        openAppSettings();
      } else {
        log('Microphone permission denied.');
        Fluttertoast.showToast(msg: 'Microphone permission denied.');
      }
    } else if (status.isGranted) {
      log('Microphone permission already granted.');
      Fluttertoast.showToast(msg: 'Microphone permission already granted.');
    }
  }

  // Setters for voice settings
  void setVoice(String newVoice) async {
    List<dynamic> availableVoices = await flutterTts.getVoices;

    if (availableVoices.contains(newVoice)) {
      voice = newVoice;
      await flutterTts.setVoice({"name": newVoice, "locale": "en-US"});
      log("Voice set to: $newVoice");
    } else {
      log("Voice model not found: $newVoice");
    }
    notifyListeners();
  }

  void setPitch(double newPitch) {
    pitch = newPitch;
    flutterTts.setPitch(pitch);
    notifyListeners();
  }

  void setSpeechRate(double newSpeechRate) {
    speechRate = newSpeechRate;
    flutterTts.setSpeechRate(speechRate);
    notifyListeners();
  }

  // Save history to storage
  void _saveHistory() => storage.write(historyKey, history);

  // Save favorites to storage
  void _saveFavorites() => storage.write(favoritesKey, _favoritesList);

  // Save pinned responses to storage
  void _savePinned() => storage.write(pinnedKey, pinnedList);

  // Delete specific history item
  void deleteHistory(String item) {
    history.remove(item);
    _saveHistory();
    notifyListeners();
  }

  void initializeTts() {
    flutterTts.setLanguage(voice); // Use the selected voice language
    flutterTts.setPitch(pitch); // Use the selected pitch
    flutterTts.setSpeechRate(speechRate); // Use the selected speech rate

    // Handle TTS completion event
    flutterTts.setCompletionHandler(() {
      isSpeaking = false;
      notifyListeners();
    });

    // Handle TTS error event
    flutterTts.setErrorHandler((msg) {
      log("TTS Error: $msg");
      isSpeaking = false;
      notifyListeners();
    });
  }

  // Toggle pin status for a response
  void togglePin(String response) {
    if (pinnedList.contains(response)) {
      pinnedList.remove(response);
    } else {
      pinnedList.add(response);
    }
    _savePinned();
    notifyListeners();
  }

  // Toggle listening state
  void toggleListening() {
    isListening = !isListening;
    notifyListeners();

    if (isListening) {
      startListening();
    } else {
      stopListening();
    }
  }

  // Delete all history
  void deleteAllHistory() {
    history.clear();
    _saveHistory();
    notifyListeners();
  }

  // Start listening using speech-to-text
  Future<void> startListening() async {
    PermissionStatus status = await Permission.microphone.request();

    if (status.isGranted) {
      bool available = await speechToText.initialize(
        onError: (error) => log('SpeechToText Error: $error'),
        onStatus: (status) => log('SpeechToText Status: $status'),
      );

      if (available) {
        isListening = true;
        notifyListeners();

        speechToText.listen(
          onResult: (result) {
            text = result.recognizedWords;
            log('Recognized Words: $text');
            notifyListeners();
          },
        );
      } else {
        text = "Speech recognition is not available.";
        log('Speech recognition unavailable');
        notifyListeners();
      }
    } else {
      log('Microphone permission denied. Cannot start listening.');
      Fluttertoast.showToast(msg: 'Microphone permission denied.');
    }
  }

  // Stop listening
  void stopListening() {
    isListening = false;
    speechToText.stop();
    notifyListeners();
  }

  Future<void> previewVoice() async {
    String previewText = "Hello! This is how your selected voice sounds.";
    isSpeaking = true;
    isPaused = false;
    notifyListeners();

    try {
      await flutterTts.speak(previewText);
    } catch (e) {
      log("Error during TTS preview: $e");
    } finally {
      isSpeaking = false;
      notifyListeners();
    }
  }

  // Text-to-Speech: Speak a response or prompt
  Future<void> readOrPromptResponse() async {
    if (responses.isNotEmpty) {
      String currentAnswer = responses.last['answer'] ?? "No answer available";
      try {
        isSpeaking = true;
        isPaused = false;
        lastSpokenAnswer = currentAnswer;
        notifyListeners();

        await flutterTts.speak(currentAnswer);
      } catch (e) {
        log("Error during TTS: $e");
      } finally {
        isSpeaking = false;
        notifyListeners();
      }
    } else {
      if (!isSpeaking && !isPaused) {
        try {
          isSpeaking = true;
          lastSpokenAnswer = "Please search for a question or request first.";
          notifyListeners();

          await flutterTts.speak(lastSpokenAnswer!);
        } catch (e) {
          log("Error during TTS prompt: $e");
        } finally {
          isSpeaking = false;
          notifyListeners();
        }
      }
    }
  }

  // Stop Text-to-Speech
  void stopSpeaking() async {
    await flutterTts.stop();
    isSpeaking = false;
    isPaused = true;
    notifyListeners();
  }

  // Resume speaking
  void resumeSpeaking() {
    if (!isSpeaking && isPaused) {
      isSpeaking = true;
      isPaused = false;
      flutterTts.speak(lastSpokenAnswer!);
    }
    notifyListeners();
  }

  // Search query using Google Generative AI
  Future<void> searchYourQuery() async {
    responses.clear();
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );

    final prompt = searchFieldController.text.trim();
    if (prompt.isEmpty) return;

    history.add(prompt);
    _saveHistory();

    isLoading = true;
    notifyListeners();

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      log('AI Response: ${response.text}');
      if (response.text != null) {
        responses.add({
          "question": prompt,
          "answer": response.text,
        });
        await readOrPromptResponse();
      } else {
        log('No response text received from AI');
      }
    } catch (e) {
      log("Error during query search: $e");
    }
  }

  // Manage favorites
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

  // Share and copy responses
  void shareResponse({required String response}) =>
      Share.share(response, subject: "Check out this response!");

  void copyToClipboard({required String text, required BuildContext context}) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard!")),
    );
  }

  // Navigation methods
  void openChatSection() => _navigateTo(const ChatSectionPage());
  void openUserSettings() => _navigateTo(const UserSettingsPage());
  void openConnectionRequestPage() =>
      _navigateTo(const ConnectionRequestPage());
  void openPastResponses() => _navigateTo(const PastResponsesPage());
  void openFavoriteResponses() => _navigateTo(const FavouriteResponsesPage());
  void openHowToUsePage() => _navigateTo(const HowToUsePage());
  void openVoiceModelPage() => _navigateTo(const VoiceModificationPage());

  void _navigateTo(Widget page) {
    Flexify.go(
      page,
      animation: FlexifyRouteAnimations.blur,
      animationDuration: Durations.medium1,
    );
  }

  @override
  void dispose() {
    searchFieldController.dispose();
    flutterTts.stop();
    super.dispose();
  }
}
