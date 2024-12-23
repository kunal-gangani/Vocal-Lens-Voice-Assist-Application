import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vocal_lens/Controllers/navigation_controller.dart';
import 'package:vocal_lens/Controllers/position_controller.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';
import 'package:vocal_lens/Controllers/youtube_controller.dart';
import 'package:vocal_lens/Views/SplashScreen/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => VoiceToTextController(),
        ),
        ChangeNotifierProvider(
          create: (context) => NavigationController(),
        ),
        ChangeNotifierProvider(
          create: (context) => YoutubeController(),
        ),
        ChangeNotifierProvider(
          create: (context) => PositionController(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(
          size.width,
          size.height,
        ),
        minTextAdapt: true,
        builder: (context, _) {
          return Flexify(
            designWidth: size.width,
            designHeight: size.height,
            app: MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
