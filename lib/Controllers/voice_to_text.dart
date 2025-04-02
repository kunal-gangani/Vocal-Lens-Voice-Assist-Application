import 'dart:async';
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

class VoiceToTextController extends ChangeNotifier {
  // Constants
  static const int _dailySearchLimit = 3;
  static const String _lastSearchDateKey = 'lastSearchDate';
  static const String _searchCountKey = 'searchCount';
  static const String _apiKey = ApiKeys.geminiApiKey;
  static const int dailySearchLimit = 3;

  // Speech services
  late stt.SpeechToText speechToText;
  final FlutterTts flutterTts = FlutterTts();
  PorcupineManager? _porcupineManager;

  // State variables
  bool _isListening = false;
  bool _isLoading = false;
  bool _isSpeaking = false;
  bool _isPaused = false;
  bool _isWakeWordActive = true;
  String _text = "Press the mic to start speaking...";
  String? _lastSpokenAnswer;

  // Voice settings
  String _voice = "en-us";
  double _pitch = 1.0;
  double _speechRate = 0.5;
  int _micDuration = 5;
  List<String> _voiceModels = [];

  List<String> get voiceModels => _voiceModels;

  // Data storage
  final GetStorage _storage = GetStorage();
  final List<String> _history = [];
  final List<String> _favoritesList = [];
  final List<String> _pinnedList = [];
  final List<Map<String, dynamic>> _responses = [];
  final TextEditingController _searchFieldController = TextEditingController();

  // Getters
  bool get isListening => _isListening;
  bool get isLoading => _isLoading;
  bool get isSpeaking => _isSpeaking;
  bool get isPaused => _isPaused;
  bool get isWakeWordActive => _isWakeWordActive;
  String get text => _text;
  String? get lastSpokenAnswer => _lastSpokenAnswer;
  String get voice => _voice;
  double get pitch => _pitch;
  double get speechRate => _speechRate;
  int get micDuration => _micDuration;
  List<String> get history => _history;
  List<String> get favoritesList => _favoritesList;
  List<String> get pinnedList => _pinnedList;
  List<Map<String, dynamic>> get responses => _responses;
  TextEditingController get searchFieldController => _searchFieldController;
  bool get isButtonEnabled => _searchFieldController.text.isNotEmpty;

  // Timer for mic duration
  Timer? _listeningTimer;

  VoiceToTextController() {
    _initializeServices();
    _loadPreferences();
    _setupListeners();
    _initializeWakeWord();
    speechToText = stt.SpeechToText();
  }

  Future<void> _initializeServices() async {
    await _initializeTts();
    await _initializeSpeechToText();
    await _initializeWakeWord();
  }

  int get remainingSearchesToday {
    final lastSearchDate = _storage.read<String>(_lastSearchDateKey);
    final currentDate = DateTime.now().toIso8601String().substring(0, 10);

    if (lastSearchDate != currentDate) {
      // New day, reset counter
      return dailySearchLimit;
    }

    final searchCount = _storage.read<int>(_searchCountKey) ?? 0;
    return dailySearchLimit - searchCount;
  }

  void _setupListeners() {
    _searchFieldController.addListener(() {
      notifyListeners();
    });

    flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _isPaused = false;
      notifyListeners();
    });

    flutterTts.setErrorHandler((msg) {
      log("TTS Error: $msg");
      _isSpeaking = false;
      _isPaused = false;
      notifyListeners();
    });
  }

  Future<void> _loadPreferences() async {
    _voice = _storage.read<String>('voice') ?? "en-us";
    _pitch = _storage.read<double>('pitch') ?? 1.0;
    _speechRate = _storage.read<double>('speechRate') ?? 0.5;
    _micDuration = _storage.read<int>('micDuration') ?? 5;

    _history
        .addAll((_storage.read<List<dynamic>>('history') ?? []).cast<String>());
    _favoritesList.addAll(
        (_storage.read<List<dynamic>>('favorites') ?? []).cast<String>());
    _pinnedList
        .addAll((_storage.read<List<dynamic>>('pinned') ?? []).cast<String>());

    // Initialize TTS with loaded preferences
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(_pitch);
    await flutterTts.setSpeechRate(_speechRate);
  }

  // ========== Usage Limit Management ==========
  bool _checkDailyLimit() {
    final lastSearchDate = _storage.read<String>(_lastSearchDateKey);
    final currentDate = DateTime.now().toIso8601String().substring(0, 10);

    if (lastSearchDate != currentDate) {
      // New day, reset counter
      _storage.write(_lastSearchDateKey, currentDate);
      _storage.write(_searchCountKey, 0);
      return true;
    }

    final searchCount = _storage.read<int>(_searchCountKey) ?? 0;
    return searchCount < _dailySearchLimit;
  }

  void _incrementSearchCount() {
    final currentCount = _storage.read<int>(_searchCountKey) ?? 0;
    _storage.write(_searchCountKey, currentCount + 1);
  }

  // ========== Speech-to-Text Methods ==========
  Future<void> _initializeSpeechToText() async {
    if (!speechToText.isAvailable) {
      await speechToText.initialize(
        onError: (error) => log('SpeechToText Error: $error'),
        onStatus: (status) => log('SpeechToText Status: $status'),
      );
    }
  }

  Future<void> requestMicrophonePermission() async {
    final status = await Permission.microphone.status;

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.microphone.request();

      if (result.isGranted) {
        log('Microphone permission granted!');
        Fluttertoast.showToast(msg: 'Microphone permission granted!');
      } else if (result.isPermanentlyDenied) {
        log('Microphone permission permanently denied');
        Fluttertoast.showToast(
          msg: 'Permission permanently denied. Enable it in settings.',
        );
        openAppSettings();
      }
    } else if (status.isGranted) {
      log('Microphone permission already granted.');
    }
  }

  Future<void> startListening() async {
    if (!await Permission.microphone.isGranted) {
      await requestMicrophonePermission();
      return;
    }

    if (!await speechToText.initialize()) {
      _text = "Speech recognition is not available.";
      notifyListeners();
      return;
    }

    _isListening = true;
    notifyListeners();

    // Set timer for automatic stop
    _listeningTimer?.cancel();
    _listeningTimer = Timer(Duration(seconds: _micDuration), () {
      if (_isListening) {
        stopListening();
      }
    });

    speechToText.listen(
      onResult: (result) {
        _text = result.recognizedWords;
        notifyListeners();

        if (result.finalResult) {
          handleVoiceCommands(_text);
        }
      },
      listenFor: const Duration(seconds: 35),
      pauseFor: const Duration(seconds: 5),
    );
  }

  void stopListening() {
    _isListening = false;
    _listeningTimer?.cancel();
    speechToText.stop();
    notifyListeners();

    if (_text.trim().isNotEmpty) {
      handleVoiceCommands(_text.trim());
    }
  }

  void toggleListening() {
    _isListening ? stopListening() : startListening();
  }

  // ========== Text-to-Speech Methods ==========
  Future<void> _initializeTts() async {
    await flutterTts.awaitSpeakCompletion(true);
    await getAvailableVoices();
  }

  Future<void> getAvailableVoices() async {
    final availableVoices = await flutterTts.getVoices;
    final voiceModels = availableVoices
        .map<String>((voice) => voice['name'] as String)
        .toList();

    if (voiceModels.isNotEmpty && !voiceModels.contains(_voice)) {
      _voice = voiceModels[0];
      _saveVoice();
    }
  }

  Future<void> setVoice(String newVoice) async {
    final availableVoices = await flutterTts.getVoices;
    if (availableVoices.any((v) => v['name'] == newVoice)) {
      _voice = newVoice;
      await flutterTts.setVoice({"name": newVoice, "locale": "en-US"});
      _saveVoice();
      notifyListeners();
    }
  }

  void setPitch(double newPitch) {
    _pitch = newPitch;
    flutterTts.setPitch(_pitch);
    _savePitch();
    notifyListeners();
  }

  void setSpeechRate(double newSpeechRate) {
    _speechRate = newSpeechRate;
    flutterTts.setSpeechRate(_speechRate);
    _saveSpeechRate();
    notifyListeners();
  }

  Future<void> previewVoice() async {
    if (_isSpeaking) return;

    _isSpeaking = true;
    notifyListeners();

    try {
      await flutterTts.speak("Hello! This is how your selected voice sounds.");
    } catch (e) {
      log("Error during TTS preview: $e");
    } finally {
      _isSpeaking = false;
      notifyListeners();
    }
  }

  Future<void> readOrPromptResponse() async {
    if (_responses.isEmpty) {
      await _speak("Please search for a question or request first.");
      return;
    }

    final currentAnswer = _responses.last['answer'] ?? "No answer available";
    await _speak(currentAnswer);
  }

  Future<void> _speak(String text) async {
    if (_isSpeaking) return;

    _isSpeaking = true;
    _lastSpokenAnswer = text;
    notifyListeners();

    try {
      await flutterTts.speak(text);
    } catch (e) {
      log("Error during TTS: $e");
    }
  }

  void stopSpeaking() {
    _isSpeaking = false;
    flutterTts.stop();
    notifyListeners();
  }

  void pauseSpeaking() {
    if (_isSpeaking) {
      _isSpeaking = false;
      _isPaused = true;
      flutterTts.stop();
      notifyListeners();
    }
  }

  void resumeSpeaking() {
    if (!_isSpeaking && _isPaused && _lastSpokenAnswer != null) {
      _isSpeaking = true;
      _isPaused = false;
      flutterTts.speak(_lastSpokenAnswer!);
      notifyListeners();
    }
  }

  // ========== Wake Word Detection ==========
  Future<void> _initializeWakeWord() async {
    try {
      await _initializeWithApiKey(ApiKeys.picoVoiceApiKey);
    } catch (e) {
      log("Primary API key failed: $e. Trying secondary key...");
      try {
        await _initializeWithApiKey(ApiKeys.picoVoiceApiKey2);
      } catch (e) {
        log("Both API keys failed: $e. Wake word detection disabled.");
      }
    }
  }

  Future<void> _initializeWithApiKey(String apiKey) async {
    _porcupineManager = await PorcupineManager.fromKeywordPaths(
      apiKey,
      ["Assets/Vocal_en_android_v3_0_0.ppn"],
      _onWakeWordDetected,
    );
    await _porcupineManager?.start();
  }

  void _onWakeWordDetected(int keywordIndex) async {
    log("Wake word detected!");
    await _speak("Hello User, You can now use Voice Commands!");
    startListening();
  }

  void toggleWakeWordDetection() async {
    if (_isWakeWordActive) {
      await _porcupineManager?.stop();
    } else {
      await _porcupineManager?.start();
    }
    _isWakeWordActive = !_isWakeWordActive;
    notifyListeners();
  }

  // ========== AI Search Methods ==========
  Future<void> searchYourQuery() async {
    if (!_checkDailyLimit()) {
      await _speak(
          "You've reached your daily search limit. Try again tomorrow.");
      return;
    }

    final prompt = _searchFieldController.text.trim();
    if (prompt.isEmpty) return;

    _responses.clear();
    _history.add(prompt);
    _saveHistory();
    _incrementSearchCount();

    _isLoading = true;
    notifyListeners();

    try {
      final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: _apiKey);
      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        _responses.add({
          "question": prompt,
          "answer": response.text,
        });
        await readOrPromptResponse();
      }
    } catch (e) {
      log("Error during query search: $e");
      await _speak("Sorry, there was an error processing your request.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ========== Data Management ==========
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

  void togglePin(String response) {
    if (_pinnedList.contains(response)) {
      _pinnedList.remove(response);
    } else {
      _pinnedList.add(response);
    }
    _savePinned();
    notifyListeners();
  }

  void deleteHistory(String item) {
    _history.remove(item);
    _saveHistory();
    notifyListeners();
  }

  void deleteAllHistory() {
    _history.clear();
    _saveHistory();
    notifyListeners();
  }

  // ========== Storage Methods ==========
  void _saveVoice() => _storage.write('voice', _voice);
  void _savePitch() => _storage.write('pitch', _pitch);
  void _saveSpeechRate() => _storage.write('speechRate', _speechRate);
  void _saveHistory() => _storage.write('history', _history);
  void _saveFavorites() => _storage.write('favorites', _favoritesList);
  void _savePinned() => _storage.write('pinned', _pinnedList);

  void setMicDuration(int seconds) {
    _micDuration = seconds;
    _storage.write('micDuration', seconds);
  }

  // ========== Sharing Methods ==========
  void shareResponse({required String response}) {
    Share.share(response, subject: "Check out this response!");
  }

  void copyToClipboard({required String text, required BuildContext context}) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard!")),
    );
  }

  // ========== Navigation Methods ==========
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

  // ========== Voice Command Handling ==========
  void handleVoiceCommands(String command) {
    final lowerCommand = command.trim().toLowerCase();
    log("Recognized command: $lowerCommand");

    String responseMessage = "Command not recognized";

    if (lowerCommand.contains("settings")) {
      openUserSettings();
      responseMessage = "Opening settings.";
    } else if (lowerCommand.contains("go back")) {
      responseMessage = "Are you sure? This will close the app.";
    } else if (lowerCommand.contains("open history")) {
      openPastResponses();
      responseMessage = "Opening history.";
    } else if (lowerCommand.contains("how to use")) {
      openHowToUsePage();
      responseMessage = "Opening how to use page.";
    } else if (lowerCommand.contains("voice settings")) {
      openVoiceModelPage();
      responseMessage = "Opening voice modification settings.";
    } else if (lowerCommand.contains("start listening")) {
      startListening();
      responseMessage = "Started listening.";
    } else if (lowerCommand.contains("stop listening")) {
      stopListening();
      responseMessage = "Stopped listening.";
    } else if (lowerCommand.contains("speak response")) {
      readOrPromptResponse();
      responseMessage = "Speaking response.";
    } else if (lowerCommand.contains("stop speaking")) {
      stopSpeaking();
      responseMessage = "Stopped speaking.";
    } else if (lowerCommand.contains("pause speaking")) {
      pauseSpeaking();
      responseMessage = "Paused speaking.";
    } else if (lowerCommand.contains("resume speaking")) {
      resumeSpeaking();
      responseMessage = "Resumed speaking.";
    } else if (lowerCommand.contains("delete history")) {
      deleteAllHistory();
      responseMessage = "History deleted.";
    } else if (lowerCommand.startsWith("search ")) {
      final query = lowerCommand.replaceFirst("search ", "").trim();
      if (query.isNotEmpty) {
        _searchFieldController.text = query;
        searchYourQuery();
        responseMessage = "Searching for: $query";
      }
    } else if (lowerCommand.contains("remaining searches")) {
      responseMessage =
          "You have ${remainingSearchesToday} searches left today.";
    }

    _speak(responseMessage);
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    _listeningTimer?.cancel();
    _porcupineManager?.stop();
    flutterTts.stop();
    super.dispose();
  }
}
