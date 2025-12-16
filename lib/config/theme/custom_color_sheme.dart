import 'package:flutter_news_app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Custom color scheme for the app
@immutable
final class CustomColorScheme {
  const CustomColorScheme._();

  /// Light color scheme
  static ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryColor,
    onPrimary: Colors.white,
    secondary: AppColors.secondaryColor,
    onSecondary: Colors.white,
    surface: AppColors.white,
    onSurface: Colors.black,

    // primaryContainer: const Color(0xFF1c2127),
    error: Colors.red,
    onError: Colors.white,
    outline: AppColors.greyShade200,
    outlineVariant: AppColors.grey600,
  );

  /// Dark color scheme
  static ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryColor,
    onPrimary: Colors.white,
    secondary: AppColors.secondaryColor,
    onSecondary: Colors.white,
    surface: const Color(0xFF181e25),
    onSurface: Colors.white,
    primaryContainer: const Color(0xFF1c2127),
    error: Colors.red,
    onError: Colors.white,
    outline: AppColors.grey600,
    outlineVariant: AppColors.greyShade200,
  );
}
