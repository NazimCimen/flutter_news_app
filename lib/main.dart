import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/config/routes/app_routes.dart';
import 'package:flutter_news_app/config/theme/theme_manager.dart';
import 'package:flutter_news_app/core/init/app_init.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  final appInit = AppInitImpl();
  await appInit.run();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeManagerProvider);
    return MaterialApp.router(
      theme: themeState.currentTheme,
      themeMode: themeState.themeMode,
      title: StringConstants.appName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: AppRoutes.router,
    );
  }
}
