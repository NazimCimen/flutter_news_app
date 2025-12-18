import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// STRING CONSTANTS FOR THE APP
@immutable
final class StringConstants {
  const StringConstants._();

  static String get appName => 'NEWS APP'.tr();
  static String get version => '1.0.0'.tr();
  // ============================================================================
  // COMMON ERROR MESSAGES
  // ============================================================================
  static String get noInternetConnection => 'no_internet_connection'.tr();
  static String get anErrorOccured => 'an_error_occured'.tr();
  static String get invalidCredentials => 'invalid_credentials'.tr();
  static String get emailAlreadyExist => 'email_already_exist'.tr();
  static String get validationEmailRequired => 'validation_email_required'.tr();
  static String get validationEmailInvalid => 'validation_email_invalid'.tr();
  static String get validationPasswordRequired => 'validation_password_required'.tr();
  static String get validationPasswordMinLength =>
      'validation_password_min_length'.tr();

  // ============================================================================
  // SOURCES FEATURE
  // ============================================================================
  static String get selectSourcesTitle => 'select_sources_title'.tr();
  static String get searchSourceHint => 'search_source_hint'.tr();
  static String get saveButton => 'save_button'.tr();
  static String get noSource => 'no_source'.tr();
  static String get unknownCategory => 'unknown_category'.tr();

  // ============================================================================
  // AUTH FEATURE
  // ============================================================================
  static String get loginTitle => 'login_title'.tr();
  static String get loginSubtitle => 'login_subtitle'.tr();
  static String get emailLabel => 'email_label'.tr();
  static String get emailHint => 'email_hint'.tr();
  static String get passwordLabel => 'password_label'.tr();
  static String get passwordHint => 'password_hint'.tr();
  static String get confirmPasswordLabel => 'confirm_password_label'.tr();
  static String get signInButton => 'sign_in_button'.tr();
  static String get signUpButton => 'sign_up_button'.tr();
  static String get signUpTitle => 'sign_up_title'.tr();
  static String get signUpSubtitle => 'sign_up_subtitle'.tr();
  static String get createAccount => 'create_account'.tr();
  static String get forgetPassword => 'forget_password'.tr();
  static String get allreadyHaveAccount => 'allready_have_account'.tr();
  static String get authTermsText => 'auth_terms_text'.tr();
  static String get byCreatingAccount => 'by_creating_account'.tr();
  static String get termsOfService => 'terms_of_service'.tr();
  static String get and => 'and'.tr();
  static String get privacyPolicy => 'privacy_policy'.tr();
  
  // ============================================================================
  // NAVIGATION
  // ============================================================================
  static String get navHome => 'nav_home'.tr();
  static String get navAgenda => 'nav_agenda'.tr();
  static String get navAlerts => 'nav_alerts'.tr();
  static String get navSaved => 'nav_saved'.tr();
  static String get navLocal => 'nav_local'.tr();

  // ============================================================================
  // HOME FEATURE
  // ============================================================================
  static String get tabLatestNews => 'tab_latest_news'.tr();
  static String get tabForYou => 'tab_for_you'.tr();
  static String get tabTwitter => 'tab_twitter'.tr();
  static String get tabYouTube => 'tab_youtube'.tr();
  static String get popular => 'popular'.tr();
  static String get forYou => 'for_you'.tr();
  static String get popularNews => 'popular_news'.tr();
  static String get noNewsYet => 'no_news_yet'.tr();
  static String get errorOccurred => 'error_occurred'.tr();
  static String get tryAgain => 'try_again'.tr();
  static String get noTitle => 'no_title'.tr();
  static String get unknownSource => 'unknown_source'.tr();
  static String get general => 'general'.tr();
  static String get comingSoon => 'coming_soon'.tr();
  static String get contentPlaceholder => 'content_placeholder'.tr();
  static String get showMore => 'show_more'.tr();
  static String get minutesAgo => 'minutes_ago'.tr();
  static String get hoursAgo => 'hours_ago'.tr();
  static String get daysAgo => 'days_ago'.tr();

  // ============================================================================
  // SAVED NEWS FEATURE
  // ============================================================================
  static String get savedNews => 'saved_news'.tr();
  static String get noSavedNews => 'no_saved_news'.tr();
  static String get saveNewsToSeeHere => 'save_news_to_see_here'.tr();
  static String get deleteSavedNews => 'delete_saved_news'.tr();
  static String get deleteSavedNewsConfirmation =>
      'delete_saved_news_confirmation'.tr();
  static String get cancel => 'cancel'.tr();
  static String get delete => 'delete'.tr();
  static String get newsDeletedSuccessfully => 'news_deleted_successfully'.tr();
  static String get failedToDeleteNews => 'failed_to_delete_news'.tr();
  static String get newsSavedSuccessfully => 'news_saved_successfully'.tr();
  static String get failedToSaveNews => 'failed_to_save_news'.tr();

  // ============================================================================
  // APP DRAWER
  // ============================================================================
  static String get language => 'language'.tr();
  static String get theme => 'theme'.tr();
  static String get lightTheme => 'light_theme'.tr();
  static String get darkTheme => 'dark_theme'.tr();
  static String get copyright => 'copyright'.tr();


  // ============================================================================
  // DATE & TIME
  // ============================================================================
  static List<String> get weekDays => 'week_days'.tr().split(',');

  static List<String> get months => 'months'.tr().split(',');
}
