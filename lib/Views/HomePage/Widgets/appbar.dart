import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';
import 'package:vocal_lens/Controllers/position_controller.dart';

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
        onPressed: Provider.of<VoiceToTextController>(context, listen: false)
            .openChatSection,
        color: Colors.white,
      ),
      IconButton(
        icon: const Icon(
          Icons.refresh,
        ),
        onPressed: () {
          Provider.of<PositionController>(context, listen: false)
              .resetPosition(context);
        },
        color: Colors.white,
      ),
    ],
  );
}
