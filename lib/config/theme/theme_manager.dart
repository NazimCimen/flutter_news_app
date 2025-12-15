import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_news_app/config/theme/application_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme enum for the app
enum ThemeEnum { dark, light }

/// Theme state class
class ThemeState {
  final ThemeData currentTheme;
  final ThemeEnum currentThemeEnum;
  final ThemeMode themeMode;
  final bool isLoading;

  const ThemeState({
    required this.currentTheme,
    required this.currentThemeEnum,
    required this.themeMode,
    this.isLoading = false,
  });

  ThemeState copyWith({
    ThemeData? currentTheme,
    ThemeEnum? currentThemeEnum,
    ThemeMode? themeMode,
    bool? isLoading,
  }) {
    return ThemeState(
      currentTheme: currentTheme ?? this.currentTheme,
      currentThemeEnum: currentThemeEnum ?? this.currentThemeEnum,
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Theme manager provider
final themeManagerProvider =
    StateNotifierProvider<ThemeManager, ThemeState>((ref) {
  return ThemeManager();
});

/// Theme manager for the app
class ThemeManager extends StateNotifier<ThemeState> {
  static const String _themeKey = 'theme';

  ThemeManager()
      : super(ThemeState(
          currentTheme: CustomDarkTheme().themeData,
          currentThemeEnum: ThemeEnum.dark,
          themeMode: ThemeMode.dark,
        )) {
    loadTheme();
  }

  /// Change app theme (light or dark)
  Future<void> changeTheme(ThemeEnum theme) async {
    state = state.copyWith(isLoading: true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme.name);

    state = ThemeState(
      currentThemeEnum: theme,
      currentTheme: theme == ThemeEnum.dark
          ? CustomDarkTheme().themeData
          : CustomLightTheme().themeData,
      themeMode: theme == ThemeEnum.dark ? ThemeMode.dark : ThemeMode.light,
      isLoading: false,
    );
  }

  /// Load app theme when app launches
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themeKey);

    if (themeName != null) {
      final themeEnum = ThemeEnum.values.firstWhere(
        (e) => e.name == themeName,
        orElse: () => ThemeEnum.dark,
      );

      state = ThemeState(
        currentThemeEnum: themeEnum,
        currentTheme: themeEnum == ThemeEnum.dark
            ? CustomDarkTheme().themeData
            : CustomLightTheme().themeData,
        themeMode: themeEnum == ThemeEnum.dark ? ThemeMode.dark : ThemeMode.light,
      );
    }
  }
}
