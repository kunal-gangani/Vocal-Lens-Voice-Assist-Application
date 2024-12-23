import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/navigation_controller.dart';

Widget navigationBar() {
  return Consumer<NavigationController>(builder: (context, value, _) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 12.0,
            color: Colors.white,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: value.selectedIndex,
        onDestinationSelected: (index) {
          value.changeItem(index);
          value.changePageView(index: index);
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            label: "Home",
            icon: Icon(
              CupertinoIcons.square_favorites,
              color: Colors.blueAccent,
            ),
          ),
          NavigationDestination(
            label: "Youtube",
            icon: FaIcon(
              FontAwesomeIcons.youtube,
              color: Colors.red,
            ),
          ),
          NavigationDestination(
            label: "AI Chat",
            icon: Icon(
              Icons.memory,
              color: Colors.orange,
            ),
          ),
        ],
        backgroundColor: Colors.grey.shade800,
        indicatorColor: Colors.grey,
      ),
    );
  });
}
