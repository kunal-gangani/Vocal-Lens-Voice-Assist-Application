import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/navigation_controller.dart';
import 'package:vocal_lens/Views/HomePage/Widgets/navigation_destination.dart';

Widget navigationBar() {
  return Consumer<NavigationController>(builder: (context, value, _) {
    return NavigationBar(
      selectedIndex: value.selectedIndex,
      onDestinationSelected: value.changeItem,
      destinations: [
        navigationDestination(
          label: "Home",
          icon: const Icon(
            CupertinoIcons.square_favorites,
            color: Colors.blueAccent,
          ),
        ),
        navigationDestination(
          label: "Youtube",
          icon: const FaIcon(
            FontAwesomeIcons.youtube,
            color: Colors.red,
          ),
        ),
        navigationDestination(
          label: "AI Chat",
          icon: const Icon(
            Icons.memory,
            color: Colors.orange,
          ),
        ),
      ],
      backgroundColor: Colors.grey.shade800,
      indicatorColor: Colors.grey,
    );
  });
}
