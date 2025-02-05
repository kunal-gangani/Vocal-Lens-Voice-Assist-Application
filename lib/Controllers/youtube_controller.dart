import 'package:flutter/material.dart';
import 'package:vocal_lens/Helper/youtube_api_helper.dart';

class YoutubeController extends ChangeNotifier {
  final YoutubeService _youtubeService = YoutubeService();
  List<Map<String, dynamic>> _videos = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get videos => _videos;
  bool get isLoading => _isLoading;

  Future<void> loadVideos(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _videos = await _youtubeService.searchVideos(query);
    } catch (e) {
      _videos = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
