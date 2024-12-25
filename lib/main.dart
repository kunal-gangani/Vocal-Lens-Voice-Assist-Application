import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vocal_lens/MyApp/my_app.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

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
      child: const MyApp(),
    ),
  );
}
