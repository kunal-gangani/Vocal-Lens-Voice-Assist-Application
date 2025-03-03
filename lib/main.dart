import 'package:easy_localization/easy_localization.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vocal_lens/Config/api_keys.dart';
import 'package:vocal_lens/MyApp/my_app.dart';
import 'package:vocal_lens/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: "keys.env");
  await ApiKeys.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 500));
  await GetStorage.init();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('de', 'DE'),
        Locale('hi', 'IN'),
        Locale('nl', 'NL'),
      ],
      path: 'lib/Assets',
      fallbackLocale: const Locale('en', 'US'),
      child: FeatureDiscovery(
        child: const MyApp(),
      ),
    ),
  );
}
