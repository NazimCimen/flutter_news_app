import 'package:flutter_news_app/core/utils/enum/cache_enum.dart';
import 'package:flutter_news_app/app/data/model/cached_news_data.dart';
import 'package:flutter_news_app/app/data/model/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// PROVIDER FOR POPULAR NEWS CACHE SERVICE
final popularNewsCacheServiceProvider = Provider<NewsCacheService>((ref) {
  return NewsCacheServiceImpl();
});

abstract class NewsCacheService {
  /// INITIALIZE CACHE SERVICE
  Future<void> init();

  /// SAVE POPULAR NEWS TO CACHE
  Future<void> savePopularNews(List<NewsModel> news);

  /// RETRIEVE POPULAR NEWS FROM CACHE
  Future<List<NewsModel>?> getPopularNews();

  /// CLEAR ALL CACHED DATA
  Future<void> clearCache();

  /// CHECK IF CACHED DATA IS STILL VALID
  Future<bool> isCacheValid();

  /// GET AGE OF CACHED DATA IN MINUTES
  Future<int?> getCacheAgeInMinutes();

  /// CLOSE CACHE SERVICE AND RELEASE RESOURCES
  Future<void> close();
}

class NewsCacheServiceImpl implements NewsCacheService {
  static final String _cacheKey = CacheKeyEnum.popularNewsData.key;

  Box<CachedNewsData>? _box;

  @override
  Future<void> init() async {
    try {
      _box = await Hive.openBox<CachedNewsData>(
        CacheHiveBoxEnum.popularNewsCache.boxName,
      );
    } catch (_) {
      _box = null;
    }
  }

  @override
  Future<void> savePopularNews(List<NewsModel> news) async {
    if (news.isEmpty) return;

    try {
      _box ??= await Hive.openBox<CachedNewsData>(
        CacheHiveBoxEnum.popularNewsCache.boxName,
      );

      final cachedData = CachedNewsData.fromNewsList(news);
      await _box!.put(_cacheKey, cachedData);
    } catch (_) {
      await _clearCacheQuietly();
    }
  }

  @override
  Future<List<NewsModel>?> getPopularNews() async {
    try {
      _box ??= await Hive.openBox<CachedNewsData>(
        CacheHiveBoxEnum.popularNewsCache.boxName,
      );

      final cachedData = _box!.get(_cacheKey);
      if (cachedData == null) return null;
      if (cachedData.newsJsonList.isEmpty) return null;
      if (cachedData.isExpired()) return null;

      return cachedData.toNewsList();
    } catch (_) {
      await _clearCacheQuietly();
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box?.delete(_cacheKey);
    } catch (_) {}
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      _box ??= await Hive.openBox<CachedNewsData>(
        CacheHiveBoxEnum.popularNewsCache.boxName,
      );

      final cachedData = _box!.get(_cacheKey);
      if (cachedData == null) return false;
      if (cachedData.newsJsonList.isEmpty) return false;

      return !cachedData.isExpired();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<int?> getCacheAgeInMinutes() async {
    try {
      final cachedData = _box?.get(_cacheKey);
      return cachedData?.getAgeInMinutes();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> close() async {
    try {
      await _box?.close();
      _box = null;
    } catch (_) {}
  }

  Future<void> _clearCacheQuietly() async {
    try {
      await clearCache();
    } catch (_) {}
  }
}
