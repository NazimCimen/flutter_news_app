import 'package:flutter/material.dart';

/// String constants for the app
@immutable
final class StringConstants {
  const StringConstants._();

  /// App name
  static String get appName => 'NEWS APP';

  // ============================================================================
  // COMMON ERROR MESSAGES
  // ============================================================================
  static String get noInternetConnection => 'No internet connection';
  static String get anErrorOccured => 'An error occurred';
  static String get invalidCredentials => 'Invalid email or password.';
  static String get emailAlreadyExist => 'Email already exists.';
  static String get validationEmailRequired => 'Email is required';
  static String get validationEmailInvalid => 'Email is invalid';
  static String get validationPasswordRequired => 'Password is required';
  static String get validationPasswordMinLength =>
      'Password must be at least 6 characters long';

  // ============================================================================
  // SOURCES FEATURE
  // ============================================================================
  static String get selectSourcesTitle => 'Select News Sources';
  static String get searchSourceHint => 'Search for a source...';
  static String get saveButton => 'Save';
  static String get noSource => 'No sources found..';
  static String get unknownCategory=> 'Unknown Category';

  // ============================================================================
  // AUTH FEATURE
  // ============================================================================
  static String get loginTitle => 'Welcome';
  static String get loginSubtitle => 'Sign in or create an account to continue';
  static String get emailLabel => 'Email Address';
  static String get emailHint => 'Enter your email';
  static String get passwordLabel => 'Password';
  static String get passwordHint => 'Enter your password';
  static String get confirmPasswordLabel => 'Confirm Password';
  static String get signInButton => 'Sign In';
  static String get signUpButton => 'Sign Up';
  static String get signUpTitle => 'Create an account';
  static String get signUpSubtitle => 'Join us to get the latest news updates';
  static String get createAccount => 'Create account';
  static String get forgetPassword => 'Forgot Password';
  static String get allreadyHaveAccount => 'Allready have an account?';
  static String get authTermsText =>
      'By creating an account, you agree to our {terms} and {privacy}.';

  // ============================================================================
  // NAVIGATION
  // ============================================================================
  static String get navHome => 'Anasayfa';
  static String get navAgenda => 'e-gündem';
  static String get navAlerts => 'Alarmlar';
  static String get navSaved => 'Kaydedilenler';
  static String get navLocal => 'Yerel';
}
