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
  static String get unknownCategory => 'Unknown Category';

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
  static String get navHome => 'Home';
  static String get navAgenda => 'Agenda';
  static String get navAlerts => 'Alerts';
  static String get navSaved => 'Saved';
  static String get navLocal => 'Local';

  // ============================================================================
  // HOME FEATURE
  // ============================================================================
  static String get tabLatestNews => 'Latest News';
  static String get tabForYou => 'For You';
  static String get tabTwitter => 'Twitter';
  static String get tabYouTube => 'YouTube';
  static String get popular => 'Popular';
  static String get forYou => 'For You';
  static String get popularNews => 'Popular News';
  static String get noNewsYet => 'No news yet';
  static String get errorOccurred => 'An error occurred';
  static String get tryAgain => 'Try Again';
  static String get noTitle => 'No Title';
  static String get unknownSource => 'Unknown Source';
  static String get general => 'General';
  static String get comingSoon => 'Coming Soon';
  static String get contentPlaceholder => 'content';
  static String get showMore => 'Show More';
  static String get minutesAgo => 'Minutes Ago';
  static String get hoursAgo => 'Hours Ago';
  static String get daysAgo => 'Days Ago';

  // ============================================================================
  // SAVED NEWS FEATURE
  // ============================================================================
  static String get savedNews => 'Saved News';
  static String get noSavedNews => 'No saved news yet';
  static String get saveNewsToSeeHere => 'Save news articles to see them here';
  static String get deleteSavedNews => 'Delete Saved News';
  static String get deleteSavedNewsConfirmation =>
      'Are you sure you want to delete this saved news?';
  static String get cancel => 'Cancel';
  static String get delete => 'Delete';
  static String get newsDeletedSuccessfully => 'News deleted successfully';
  static String get failedToDeleteNews => 'Failed to delete news';
  static String get newsSavedSuccessfully => 'News saved successfully';
  static String get failedToSaveNews => 'Failed to save news';

  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
}
