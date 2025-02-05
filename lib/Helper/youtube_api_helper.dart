import 'dart:convert';
import 'package:http/http.dart' as http;

class YoutubeService {
  static const String apiKey = "AIzaSyB5afyDgR9WOZqE7jga7P-KeyNlzQ00g00";
  static const String baseUrl = "https://www.googleapis.com/youtube/v3";

  Future<List<Map<String, dynamic>>> searchVideos(String query) async {
    final url = Uri.parse(
      "$baseUrl/search?part=snippet&q=$query&type=video&maxResults=10&key=$apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['items'] as List).map((video) {
        return {
          "videoId": video["id"]["videoId"],
          "title": video["snippet"]["title"],
          "channelTitle": video["snippet"]["channelTitle"],
          "thumbnails": video["snippet"]["thumbnails"],
        };
      }).toList();
    } else {
      throw Exception("Failed to fetch videos");
    }
  }
}
