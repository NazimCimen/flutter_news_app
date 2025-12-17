import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_news_app/app/config/theme/application_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// THEME ENUM
enum ThemeEnum { dark, light }

/// THEME STATE CLASS
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

/// THEME MANAGER PROVIDER
final themeManagerProvider = StateNotifierProvider<ThemeManager, ThemeState>(
  (ref) => ThemeManager(),
);

/// THEME MANAGER
class ThemeManager extends StateNotifier<ThemeState> {
  static const String _themeKey = 'theme';

  ThemeManager()
    : super(
        ThemeState(
          currentTheme: CustomDarkTheme().themeData,
          currentThemeEnum: ThemeEnum.dark,
          themeMode: ThemeMode.dark,
        ),
      ) {
    loadTheme();
  }

  /// CHANGE APP THEME (LIGHT OR DARK)
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

  /// LOAD APP THEME WHEN APP LAUNCHES
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
        themeMode: themeEnum == ThemeEnum.dark
            ? ThemeMode.dark
            : ThemeMode.light,
      );
    }
  }
}
