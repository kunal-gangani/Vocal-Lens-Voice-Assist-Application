import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';

Widget customDrawer() {
  return Consumer<VoiceToTextController>(builder: (context, value, _) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900,
            ),
            child: const Center(
              child: Text(
                "VocalLens Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.history,
              color: Colors.orange,
            ),
            title: const Text(
              "Past Responses",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: value.openPastResponses,
          ),
          ListTile(
            leading: const Icon(
              Icons.star,
              color: Colors.purple,
            ),
            title: const Text(
              "Favorite Responses",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: value.openFavoriteResponses,
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.green,
            ),
            title: const Text(
              "Settings",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  });
}
