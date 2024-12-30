import 'package:flutter/material.dart';
import 'package:flexify/flexify.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:vocal_lens/Views/HomePage/home_page.dart';

class ApplicationFeaturesPage extends StatelessWidget {
  const ApplicationFeaturesPage({super.key});

  void _onIntroEnd(BuildContext context) {
    Flexify.goRemove(
      const HomePage(),
      animation: FlexifyRouteAnimations.blur,
      duration: Durations.medium1,
    );
  }

  Widget buildImage(
    String imageUrl, [
    double width = 350,
  ]) {
    return Image.network(
      imageUrl,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 19.0,
      ),
      bodyPadding: EdgeInsets.all(16.0),
      pageColor: Colors.black,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      pages: [
        PageViewModel(
          image: Image.network(
              "https://media.istockphoto.com/id/1357265563/photo/young-woman-using-mobile-phone-for-working-at-home.jpg?s=612x612&w=0&k=20&c=XTQADI7lbzyQLgpLRInVkfKH7c0lQqQbRO2HtbMBDlE="),
          titleWidget: const Text(
            "Welcome to VocalLens",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          bodyWidget: const Text(
            "Learn how to use our application at it's best",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: const Text(
            "Welcome to VocalLens",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          bodyWidget: const Text(
            "Learn how to use our application at it's best",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: const Text(
            "Welcome to VocalLens",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          bodyWidget: const Text(
            "Learn how to use our application at it's best",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text(
        "Skip",
      ),
      next: const Icon(
        Icons.arrow_forward,
      ),
      done: const Text(
        "Done",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(
          22.0,
          10.0,
        ),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
      ),
    );
  }
}
