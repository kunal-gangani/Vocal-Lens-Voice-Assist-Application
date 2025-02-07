import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vocal_lens/Model/feature_model.dart';

class HowToUseProvider extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  int _currentIndex = 0; // Track the index of the feature being spoken

  final List<FeatureModel> _features = [
    FeatureModel(
      featureId: 'install_feature',
      icon: Icons.download,
      title: 'Step 1: Install the App',
      description: 'Download and install the app from the Play Store or App Store.',
    ),
    FeatureModel(
      featureId: 'create_account_feature',
      icon: Icons.account_circle,
      title: 'Step 2: Create an Account',
      description: 'Sign up using your email or Google account to access full features.',
    ),
    FeatureModel(
      featureId: 'search_voice_feature',
      icon: Icons.search,
      title: 'Step 3: Search with Voice',
      description: 'Use voice commands to search and get results instantly.',
    ),
  ];

  HowToUseProvider() {
    _initializeTts();
  }

  void _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
      notifyListeners();
    });
  }

  List<FeatureModel> get features => _features;
  bool get isPlaying => _isPlaying;

  void togglePlayPause() async {
    if (_isPlaying) {
      await _flutterTts.stop();
      _isPlaying = false;
    } else {
      _speakNextFeature();
    }
    notifyListeners();
  }

  void _speakNextFeature() async {
    if (_currentIndex >= _features.length) {
      _isPlaying = false;
      _currentIndex = 0; // Reset index after finishing
      notifyListeners();
      return;
    }

    _isPlaying = true;
    notifyListeners();

    await _flutterTts.speak(
      "${_features[_currentIndex].title}. ${_features[_currentIndex].description}",
    );

    _currentIndex++;
    Future.delayed(const Duration(seconds: 3), _speakNextFeature);
  }

  void speakFeature(int index) async {
    if (index >= 0 && index < _features.length) {
      await _flutterTts.speak(
        "${_features[index].title}. ${_features[index].description}",
      );
    }
  }
}
