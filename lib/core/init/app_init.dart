import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_news_app/core/di/di_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/main.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/config/localization/locale_constants.dart';

/// App init for the app
abstract class AppInit {
  /// Initialize the app
  Future<void> initialize();

  /// Run the app
  Future<void> run();

  /// Get the app
  Widget getApp();
}

class AppInitImpl extends AppInit {
  @override
  Widget getApp() {
    return EasyLocalization(
      supportedLocales: const [
        LocaleConstants.enLocale,
        LocaleConstants.trLocale,
      ],
      path: LocaleConstants.localePath,
      fallbackLocale: LocaleConstants.enLocale,
      child: ProviderScope(
        child: DevicePreview(
          enabled: false,
          builder: (context) => const MyApp(),
        ),
      ),
    );
  }

  @override
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await EasyLocalization.ensureInitialized();
    await Hive.initFlutter();

    setupDI();
  }

  @override
  Future<void> run() async {
    await initialize();
    runApp(getApp());
  }
}
