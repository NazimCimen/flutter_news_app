import 'package:flutter/material.dart';

/// App constants for the app
@immutable
final class ApiConstants {
  const ApiConstants._();

  static const String loginEndPoint = '/api/v1/users/login';
  static const String signUpEndPoint = '/api/v1/users';
  static const String accessTokenKey = 'accessToken';

  // Categories
  static const String categories = '/api/v1/categories';

  // Sources
  static const String currentSources = '/api/v1/sources';
  static const String searchSources = '/api/v1/sources/search';
  static const String followedSources = '/api/v1/sources/followed';
  static const String followBulkSources = '/api/v1/sources/follow/bulk';

  // News
  static const String news = '/api/v1/news';
}
