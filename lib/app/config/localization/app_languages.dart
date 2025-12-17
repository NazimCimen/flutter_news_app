import 'package:flutter/material.dart';

/// APP LANGUAGES FOR THE APP
@immutable
final class AppLanguages {
  final String name;
  final String flagName;
  final Locale locale;

  const AppLanguages({
    required this.name,
    required this.flagName,
    required this.locale,
  });
}
