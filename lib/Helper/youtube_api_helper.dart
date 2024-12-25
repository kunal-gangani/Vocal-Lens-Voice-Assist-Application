import 'dart:convert';
import 'package:http/http.dart' as http;

class YoutubeApiService {
  final String apiKey = "YOUR_YOUTUBE_API_KEY";
  final String baseUrl = "https://www.googleapis.com/youtube/v3";

  Future<List<dynamic>> searchVideos(String query) async {
    final url = Uri.parse('$baseUrl/search?part=snippet&q=$query&type=video&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items']; 
    } else {
      throw Exception("Failed to fetch videos");
    }
  }
}
