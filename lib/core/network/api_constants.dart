import 'package:flutter/material.dart';

/// API CONSTANTS
@immutable
final class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://interview.test.egundem.com/';

  /// AUTH
  static const String loginEndPoint = '/api/v1/users/login';
  static const String signUpEndPoint = '/api/v1/users';
  static const String userProfile = '/api/v1/users/profile';

  /// CATEGORIES
  static const String categories = '/api/v1/categories';
  static const String categoriesWithNews = '/api/v1/categories/with-news';

  /// SOURCES
  static const String currentSources = '/api/v1/sources';
  static const String searchSources = '/api/v1/sources/search';
  static const String followedSources = '/api/v1/sources/followed';
  static const String followBulkSources = '/api/v1/sources/follow/bulk';

  /// NEWS
  static const String news = '/api/v1/news';
  static const String newsByCategory = '/api/v1/news/category';

  /// SAVED NEWS
  static const String savedNews = '/api/v1/saved-news';

  /// TWITTER
  static const String tweets = '/api/v1/twitter/tweets';
}
