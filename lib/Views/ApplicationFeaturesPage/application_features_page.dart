import 'package:flutter/material.dart';
import 'package:flexify/flexify.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
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
      bodyPadding: EdgeInsets.symmetric(horizontal: 16.0),
      pageColor: Colors.black,
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
      child: Scaffold(
        body: IntroductionScreen(
          globalBackgroundColor: Colors.black,
          pages: [
            PageViewModel(
              image: Lottie.asset(
                "lib/Views/ApplicationFeaturesPage/Assets/loader_1.json",
                height: 200,
              ),
              titleWidget: const Center(
                child: Text(
                  "Welcome to VocalLens",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
              bodyWidget: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Discover how to make the most of our app",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              image: Lottie.asset(
                "lib/Views/ApplicationFeaturesPage/Assets/ai_loader.json",
                height: 600,
              ),
              titleWidget: const Center(
                child: Text(
                  "Chat and Interact with AI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
              bodyWidget: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Engage in seamless conversations with AI,",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "and receive spoken responses instantly.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              image: Lottie.asset(
                "lib/Views/ApplicationFeaturesPage/Assets/youtube_loader.json",
                height: 200,
              ),
              titleWidget: const Center(
                child: Text(
                  "Seamless Video Streaming",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
              bodyWidget: const Column(
                children: [
                  Text(
                    "Discover how to watch your favorite",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Youtube videos directly on VocalLens!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              image: Lottie.asset(
                "lib/Views/ApplicationFeaturesPage/Assets/loader_3.json",
                height: 200,
              ),
              titleWidget: const Center(
                child: Text(
                  "Explore New Friends",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
              bodyWidget: const Column(
                children: [
                  Text(
                    "Discover and connect with new friends on",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "VocalLens, just like on social media!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              image: Lottie.asset(
                "lib/Views/ApplicationFeaturesPage/Assets/voice_loader.json",
                height: 200,
              ),
              titleWidget: const Center(
                child: Text(
                  "Voice Commands",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
              bodyWidget: const Column(
                children: [
                  Text(
                    "Control the app effortlessly with minimal",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "touch interaction, using only voice",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "commands.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              image: Lottie.asset(
                "lib/Views/ApplicationFeaturesPage/Assets/final_loader.json",
                height: 200,
              ),
              titleWidget: const Center(
                child: Text(
                  "Enjoy the Experience",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
              bodyWidget: const Column(
                children: [
                  Text(
                    "You're all set! While this is the final slide,",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "VocalLens offers many more exciting",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "features waiting for you to explore. Enjoy",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "the journey!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              decoration: pageDecoration,
            ),
          ],
          onDone: () => _onIntroEnd(context),
          showSkipButton: false,
          showNextButton: false,
          showDoneButton: false,
          globalFooter: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _onIntroEnd(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _onIntroEnd(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
