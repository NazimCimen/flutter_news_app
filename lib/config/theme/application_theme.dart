import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/theme/custom_color_sheme.dart';
import 'package:flutter/services.dart';

/// Application theme for the app
abstract class ApplicationTheme {
  ThemeData get themeData;
  ColorScheme get colorScheme;
}

/// Custom light theme for project design
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

/// Custom Dark theme for project design
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
