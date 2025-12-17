import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/main.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/app/config/localization/locale_constants.dart';
import 'package:flutter_news_app/app/data/model/cached_news_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// INITIALIZATION OPERATIONS
abstract class AppInit {
  /// INITIALIZE THE APP
  /// DOTENV , EASYLOCALIZATION , DEVICEPREVIEW , HIVE ,
  Future<void> initialize();

  /// RUN THE APP
  Future<void> run();

  /// GET THE APP
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

    await dotenv.load();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await EasyLocalization.ensureInitialized();

    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CachedNewsDataAdapter());
    }
  }

  @override
  Future<void> run() async {
    await initialize();
    runApp(getApp());
  }
}
