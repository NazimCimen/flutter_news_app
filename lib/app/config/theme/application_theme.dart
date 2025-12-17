import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/config/theme/custom_color_sheme.dart';
import 'package:flutter/services.dart';

/// APPLICATION THEME FOR THE APP
abstract class ApplicationTheme {
  ThemeData get themeData;
  ColorScheme get colorScheme;
}

/// CUSTOM LIGHT THEME FOR THE APP
final class CustomLightTheme implements ApplicationTheme {
  @override
  ColorScheme get colorScheme => CustomColorScheme.lightScheme;
  @override
  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: CustomColorScheme.lightScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    sliderTheme: SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: Colors.grey.shade300,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withValues(alpha: 0.2),
      trackHeight: 4,
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
  );
}

/// CUSTOM DARK THEME FOR THE APP
final class CustomDarkTheme implements ApplicationTheme {
  @override
  ColorScheme get colorScheme => CustomColorScheme.darkScheme;
  @override
  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: CustomColorScheme.darkScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    sliderTheme: SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: Colors.grey.shade300,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withValues(alpha: 0.2),
      trackHeight: 4,
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    ),
    appBarTheme: AppBarTheme(backgroundColor: colorScheme.surface),
  );
}
