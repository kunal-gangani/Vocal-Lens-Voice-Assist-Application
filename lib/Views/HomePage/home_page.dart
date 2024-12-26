import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/navigation_controller.dart';
import 'package:vocal_lens/Views/HomePage/Widgets/PageViews/chat_with_ai.dart';
import 'package:vocal_lens/Views/HomePage/Widgets/PageViews/explore_friends_view.dart';
import 'package:vocal_lens/Views/HomePage/Widgets/PageViews/home_page_view.dart';
import 'package:vocal_lens/Views/HomePage/Widgets/PageViews/youtube_page_view.dart';
import 'package:vocal_lens/Views/HomePage/Widgets/appbar.dart';
import 'package:vocal_lens/Views/HomePage/Widgets/drawer.dart';
import 'package:vocal_lens/Views/HomePage/Widgets/fab.dart';
import 'package:vocal_lens/Views/HomePage/Widgets/navigation_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (context, navigationController, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton:
              navigationController.selectedIndex != 3 ? floatingButton() : null,
          bottomNavigationBar: navigationBar(),
          appBar: appBar(context: context),
          drawer: customDrawer(),
          body: PageView(
            controller: navigationController.pageController,
            onPageChanged: (index) {
              navigationController.changeItem(index);
            },
            children: [
              homePageView(),
              youTubePageView(),
              exploreFriendsPageView(),
              chatWithAIPage(),
            ],
          ),
        );
      },
    );
  }
}
