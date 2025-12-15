import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_news_app/config/localization/app_languages.dart';
import 'package:flutter_news_app/core/utils/enum/image_enum.dart';

/// Locale constants for the app
@immutable
final class LocaleConstants {
  const LocaleConstants._();
  static const trLocale = Locale('tr', 'TR');
  static const enLocale = Locale('en', 'US');
  static const localePath = 'assets/lang';

  static final List<AppLanguages> languageList = [
    AppLanguages(
      name: 'Türkçe',
      locale: trLocale,
      flagName: ImageEnums.flag_turkiye.toPathPng,
    ),
    AppLanguages(
      name: 'English',
      locale: enLocale,
      flagName: ImageEnums.flag_usa.toPathPng,
    ),
  ];
}
