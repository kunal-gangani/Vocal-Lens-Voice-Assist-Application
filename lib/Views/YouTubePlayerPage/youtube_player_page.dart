import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerPage extends StatefulWidget {
  final String videoId;

  const YoutubePlayerPage({super.key, required this.videoId});

  @override
  // ignore: library_private_types_in_public_api
  _YoutubePlayerPageState createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        // videoId: widget.videoId, // Video ID passed here
        // autoPlay: true, // Auto-play the video
        showFullscreenButton: true, // Show fullscreen button
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Flexify.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: const Text(
          "YouTube Player",
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      backgroundColor: Colors.blueGrey.shade900,
      body: Column(
        children: [
          // YouTube Player
          // YoutubePlayerIFrame(
          //   controller: _controller,
          //   aspectRatio: 16 / 9, // Standard aspect ratio for videos
          // ),
          SizedBox(
            height: 20.h,
          ),
          // Video Info Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Title
                Text(
                  "Video Title",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                // Channel Name
                Text(
                  "Channel Name",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.thumb_up,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                      "1.2K Likes",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.comment,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                      "500 Comments",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
