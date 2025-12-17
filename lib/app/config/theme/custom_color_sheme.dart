import 'package:flutter_news_app/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// CUSTOM COLOR SCHEME FOR THE APP
@immutable
final class CustomColorScheme {
  const CustomColorScheme._();

  /// LIGHT COLOR SCHEME
  static ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryColor,
    onPrimary: Colors.white,
    secondary: AppColors.secondaryColor,
    onSecondary: Colors.white,
    surface: const Color(0xfff4f4f4),
    onSurface: Colors.black,
    primaryContainer: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    outline: AppColors.greyShade200,
    outlineVariant: AppColors.grey600,
  );

  /// DARK COLOR SCHEME
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
