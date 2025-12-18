import 'package:flutter_news_app/app/data/data_source/local/news_cache_service.dart';
import 'package:flutter_news_app/app/data/model/news_data_cache.dart';
import 'package:flutter_news_app/app/data/model/news_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late NewsCacheServiceImpl cacheService;

  setUpAll(() async {
    // Initialize Hive for testing
    Hive.init('./test/hive_test_db');
    Hive.registerAdapter(CachedNewsDataAdapter());
  });

  setUp(() async {
    cacheService = NewsCacheServiceImpl();
    await cacheService.init();
  });

  tearDown(() async {
    await cacheService.clearCache();
    await cacheService.close();
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  group('NewsCacheService - savePopularNews', () {
    test('should save news to cache when news list is not empty', () async {
      // Arrange
      final newsList = [
        const NewsModel(
          id: '1',
          title: 'Test News',
          publishedAt: '2024-12-18T10:00:00Z',
        ),
      ];

      // Act
      await cacheService.savePopularNews(newsList);
      final result = await cacheService.getPopularNews();

      // Assert
      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result.first.id, '1');
      expect(result.first.title, 'Test News');
    });

    test('should not save when news list is empty', () async {
      // Arrange
      final newsList = <NewsModel>[];

      // Act
      await cacheService.savePopularNews(newsList);
      final result = await cacheService.getPopularNews();

      // Assert
      expect(result, null);
    });
  });

  group('NewsCacheService - getPopularNews', () {
    test('should return null when cache is empty', () async {
      // Arrange - cache is already empty from setUp

      // Act
      final result = await cacheService.getPopularNews();

      // Assert
      expect(result, null);
    });

    test('should return valid news when cache is not expired', () async {
      // Arrange
      final newsList = [
        const NewsModel(
          id: '1',
          title: 'Fresh News',
          publishedAt: '2024-12-18T10:00:00Z',
        ),
      ];
      await cacheService.savePopularNews(newsList);

      // Act
      final result = await cacheService.getPopularNews();

      // Assert
      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result.first.id, '1');
      expect(result.first.title, 'Fresh News');
    });
  });

  group('NewsCacheService - clearCache', () {
    test('should delete cache data', () async {
      // Arrange
      final newsList = [
        const NewsModel(id: '1', title: 'Test'),
      ];
      await cacheService.savePopularNews(newsList);

      // Act
      await cacheService.clearCache();
      final result = await cacheService.getPopularNews();

      // Assert
      expect(result, null);
    });
  });

  group('NewsCacheService - isCacheValid', () {
    test('should return false when cache is empty', () async {
      // Arrange - cache is empty

      // Act
      final result = await cacheService.isCacheValid();

      // Assert
      expect(result, false);
    });

    test('should return true when cache has valid data', () async {
      // Arrange
      final newsList = [
        const NewsModel(id: '1', title: 'News'),
      ];
      await cacheService.savePopularNews(newsList);

      // Act
      final result = await cacheService.isCacheValid();

      // Assert
      expect(result, true);
    });
  });

  group('NewsCacheService - getCacheAgeInMinutes', () {
    test('should return null when cache is empty', () async {
      // Arrange - cache is empty

      // Act
      final result = await cacheService.getCacheAgeInMinutes();

      // Assert
      expect(result, null);
    });

    test('should return 0 when cache was just created', () async {
      // Arrange
      final newsList = [
        const NewsModel(id: '1', title: 'News'),
      ];
      await cacheService.savePopularNews(newsList);

      // Act
      final result = await cacheService.getCacheAgeInMinutes();

      // Assert
      expect(result, isNotNull);
      expect(result, lessThanOrEqualTo(1)); // Should be 0 or 1 minute
    });
  });

  group('NewsCacheService - close', () {
    test('should close the box without errors', () async {
      // Arrange - service is initialized

      // Act & Assert
      expect(() => cacheService.close(), returnsNormally);
    });
  });
}
