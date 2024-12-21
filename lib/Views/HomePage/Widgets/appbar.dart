import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';

PreferredSizeWidget appBar({required BuildContext context}) {
  return AppBar(
    foregroundColor: Colors.white,
    title: const Text(
      "VocalLens",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.black,
    actions: [
      IconButton(
        icon: const FaIcon(FontAwesomeIcons.commentDots),
        onPressed: Provider.of<VoiceToTextController>(context).openChatSection,
        color: Colors.white,
      ),
    ],
  );
}
