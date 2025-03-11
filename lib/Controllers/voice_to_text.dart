import 'dart:developer';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vocal_lens/Keys/api_keys.dart';
import 'package:vocal_lens/Views/ChatSection/chat_section.dart';
import 'package:vocal_lens/Views/ConnectionsRequestPage/connection_request_page.dart';
import 'package:vocal_lens/Views/FavouritesResponsesPage/favourite_responses_page.dart';
import 'package:vocal_lens/Views/HowToUsePage/how_to_use_page.dart';
import 'package:vocal_lens/Views/PastResponsesPage/past_responses_page.dart';
import 'package:vocal_lens/Views/UserSettingsPage/user_settings_page.dart';
import 'package:vocal_lens/Views/VoiceModificationPage/voice_modification_page.dart';
import 'package:porcupine_flutter/porcupine.dart';

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

  // Keys for persistent storage
  final String voiceKey = 'voice';
  final String pitchKey = 'pitch';
  final String speechRateKey = 'speechRate';

  // Voice settings
  String voice = "en-us";
  double pitch = 1.0;
  double speechRate = 0.5;
  int micDuration = 5;

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
  static const String apiKey = ApiKeys.geminiApiKey;

  // Getters
  List<String> get favoritesList => _favoritesList;

  // Constructor
  VoiceToTextController() {
    flutterTts.setCompletionHandler(() {
      isSpeaking = false;
      isPaused = false;
      notifyListeners();
    });

    flutterTts.setErrorHandler((msg) {
      log("TTS Error: $msg");
      isSpeaking = false;
      isPaused = false;
      notifyListeners();
    });

    // Load saved values from storage
    voice = storage.read<String>(voiceKey) ?? "en-us";
    pitch = storage.read<double>(pitchKey) ?? 1.0;
    speechRate = storage.read<double>(speechRateKey) ?? 0.5;
    loadMicDuration();

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

    // Initialize Porcupine wake word detection
    initializeWakeWord();
  }

  // Porcupine Manager
  PorcupineManager? _porcupineManager;

  // Save settings
  void _saveVoice() => storage.write(voiceKey, voice);
  void _savePitch() => storage.write(pitchKey, pitch);
  void _saveSpeechRate() => storage.write(speechRateKey, speechRate);

  // Load the saved mic duration from GetStorage
  void loadMicDuration() {
    micDuration = storage.read('micDuration') ?? 5;
  }

  // Save the selected mic duration
  void setMicDuration(int seconds) {
    micDuration = seconds;
    storage.write('micDuration', seconds);
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
          msg: 'Permission permanently denied. Enable it in settings.',
        );
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

  // Initialize Porcupine wake word detection
  Future<void> initializeWakeWord() async {
    try {
      _porcupineManager = await PorcupineManager.fromBuiltInKeywords(
        ApiKeys.picoVoiceApiKey,
        [
          BuiltInKeyword.BUMBLEBEE,
          BuiltInKeyword.PORCUPINE,
          BuiltInKeyword.ALEXA,
          BuiltInKeyword.AMERICANO,
          BuiltInKeyword.BLUEBERRY
        ],
        onWakeWordDetected,
      );

      await _porcupineManager?.start();
      log("Wake word detection started...");
    } catch (e) {
      log("Porcupine initialization failed: $e");
    }
  }

  void onWakeWordDetected(int keywordIndex) async {
    log("Wake word detected! Activating Vocal Lens... (Keyword index: $keywordIndex)");
    await flutterTts.speak("Hello User, You can now use Voice Commands!");
    // Start listening for user command
    startListening();
  }

  // Setters for voice settings
  void setVoice(String newVoice) async {
    List<dynamic> availableVoices = await flutterTts.getVoices;
    log("Available voices: $availableVoices");

    if (availableVoices.contains(newVoice)) {
      voice = newVoice;
      await flutterTts.setVoice({"name": newVoice, "locale": "en-US"});
      log("Voice set to: $newVoice");
      _saveVoice();
      notifyListeners();
    } else {
      log("Voice model not found: $newVoice");
    }
  }

  void handleVoiceCommands(String command) {
    String lowerCommand = command.toLowerCase();
    log("Recognized command: $lowerCommand");

    // Default message for unrecognized commands
    String responseMessage = "Command not recognized";

    if (lowerCommand.contains("open chat")) {
      log("Opening Chats");
      openChatSection();
      responseMessage = "Opening chat section.";
    } else if (lowerCommand.contains("settings")) {
      log("Opening Settings");
      openUserSettings();
      responseMessage = "Opening settings.";
    } else if (lowerCommand.contains("go back")) {
      log("Can't go back");
      responseMessage = "Are you sure.This will close the app";
    } else if (lowerCommand.contains("open history")) {
      log("Opening History");
      openPastResponses();
      responseMessage = "Opening history.";
    } else if (lowerCommand.contains("open connections")) {
      log("Opening Connections Request Page");
      openConnectionRequestPage();
      responseMessage = "Opening connections request page.";
    } else if (lowerCommand.contains("how to use")) {
      log("Opening How To Use Page");
      openHowToUsePage();
      responseMessage = "Opening how to use page.";
    } else if (lowerCommand.contains("voice settings")) {
      log("Opening Voice Modification Page");
      openVoiceModelPage();
      responseMessage = "Opening voice modification settings.";
    } else if (lowerCommand.contains("start listening")) {
      log("Started Listening");
      startListening();
      responseMessage = "Started listening.";
    } else if (lowerCommand.contains("stop listening")) {
      log("Stopped Listening");
      stopListening();
      responseMessage = "Stopped listening.";
    } else if (lowerCommand.contains("speak response")) {
      log("Speaking Response");
      readOrPromptResponse();
      responseMessage = "Speaking response.";
    } else if (lowerCommand.contains("stop speaking")) {
      log("Stopped Speaking");
      stopSpeaking();
      responseMessage = "Stopped speaking.";
    } else if (lowerCommand.contains("pause speaking")) {
      log("Paused Speaking");
      pauseSpeaking();
      responseMessage = "Paused speaking.";
    } else if (lowerCommand.contains("resume speaking")) {
      log("Resumed Speaking");
      resumeSpeaking();
      responseMessage = "Resumed speaking.";
    } else if (lowerCommand.contains("delete history")) {
      log("Deleting History");
      deleteAllHistory();
      responseMessage = "History deleted.";
    } else if (lowerCommand.contains("search")) {
      log("Searching");

      RegExp regExp = RegExp(r"search (.*)", caseSensitive: false);
      final match = regExp.firstMatch(command);

      if (match != null) {
        String query = match.group(1)?.trim() ?? '';
        log("Search query: $query");

        searchFieldController.text = query;
        searchYourQuery();
      } else {
        log("No search query found after 'search'.");
      }
    } else {
      log("Command not recognized : $command");
      Fluttertoast.showToast(msg: "Command not recognized: $command");
    }

    // Speak the response message
    flutterTts.speak(responseMessage);
  }

  List<String> voiceModels = [];

  void getAvailableVoices() async {
    List<dynamic> availableVoices = await flutterTts.getVoices;
    voiceModels = availableVoices
        .map<String>((voice) => voice['name'] as String)
        .toList();

    // Ensure the current voice is valid
    if (!voiceModels.contains(voice) && voiceModels.isNotEmpty) {
      voice = voiceModels[0];
    }
    notifyListeners();
  }

  void setPitch(double newPitch) {
    pitch = newPitch;
    flutterTts.setPitch(pitch);
    _savePitch();
    notifyListeners();
  }

  void setSpeechRate(double newSpeechRate) {
    speechRate = newSpeechRate;
    flutterTts.setSpeechRate(speechRate);
    _saveSpeechRate();
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

  // Initialize TTS
  void initializeTts() {
    flutterTts.setLanguage(voice);
    flutterTts.setPitch(pitch);
    flutterTts.setSpeechRate(speechRate);

    flutterTts.setCompletionHandler(() {
      isSpeaking = false;
      notifyListeners();
    });

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
    if (isListening) {
      stopListening();
    } else {
      startListening();
    }
    notifyListeners();
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

            if (result.finalResult) {
              handleVoiceCommands(text);
            }
          },
          listenFor: Duration(seconds: micDuration),
          pauseFor: const Duration(seconds: 2),
          onSoundLevelChange: (level) => log("Sound level: $level"),
        );
      } else {
        text = "Speech recognition is not available.";
        log('Speech recognition unavailable');
        notifyListeners();
      }
    } else {
      log('Microphone permission denied.');
      Fluttertoast.showToast(msg: 'Microphone permission denied.');
    }
  }

// Stop listening
  void stopListening() {
    isListening = false;
    speechToText.stop();
    notifyListeners();

    if (text.trim().isNotEmpty) {
      handleVoiceCommands(text.trim());
    } else {
      log("No valid speech detected.");
    }
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

  // Stop speaking
  void stopSpeaking() {
    isSpeaking = false;
    flutterTts.stop();
    notifyListeners();
  }

  // Pause speaking
  void pauseSpeaking() {
    log("Before Pause - isSpeaking: $isSpeaking, isPaused: $isPaused");
    if (isSpeaking) {
      isSpeaking = false;
      isPaused = true;
      flutterTts.stop();
      log("Speech paused - isSpeaking: $isSpeaking, isPaused: $isPaused");
    }
    notifyListeners();
  }

  // Resume speaking
  void resumeSpeaking() {
    log("Before Resume - isSpeaking: $isSpeaking, isPaused: $isPaused");
    if (!isSpeaking && isPaused) {
      isSpeaking = true;
      isPaused = false;
      flutterTts.speak(lastSpokenAnswer ?? "");
      log("Speech resumed - isSpeaking: $isSpeaking, isPaused: $isPaused");
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
  void openChatSection() => _navigateTo(
        const ChatSectionPage(),
      );
  void openUserSettings() => _navigateTo(
        const UserSettingsPage(),
      );
  void openConnectionRequestPage() =>
      _navigateTo(const ConnectionRequestPage());
  void openPastResponses() => _navigateTo(
        const PastResponsesPage(),
      );
  void openFavoriteResponses() => _navigateTo(
        const FavouriteResponsesPage(),
      );
  void openHowToUsePage() => _navigateTo(
        const HowToUsePage(),
      );
  void openVoiceModelPage() => _navigateTo(
        const VoiceModificationPage(),
      );

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
