/// CACHE KEYS FOR STORING DATA IN HIVE BOXES
enum CacheKeyEnum {
  /// KEY FOR CACHED POPULAR NEWS DATA (STORED IN POPULARNEWSBOX)
  popularNewsData,

  /// KEY FOR ACCESS TOKEN (STORED IN POPULARNEWSBOX)
  accessToken,
}

/// CACHE BOXES FOR DIFFERENT CACHE TYPES
enum CacheHiveBoxEnum {
  /// BOX FOR POPULAR NEWS CACHE
  popularNewsCache,
}

/// EXTENSION TO GET STRING KEY NAMES FROM CACHEKEYENUM
extension CacheKeyEnumExtension on CacheKeyEnum {
  String get key {
    switch (this) {
      case CacheKeyEnum.popularNewsData:
        return 'cached_news_data';

      case CacheKeyEnum.accessToken:
        return 'access token';
    }
  }
}

/// EXTENSION TO GET BOX NAMES FROM CACHEHIVEBOXENUM
extension CacheHiveBoxEnumExtension on CacheHiveBoxEnum {
  String get boxName {
    switch (this) {
      case CacheHiveBoxEnum.popularNewsCache:
        return 'popular_news_cache';
    }
  }
}
