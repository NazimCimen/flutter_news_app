import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/data/data_source/local/news_cache_service.dart';
import 'package:flutter_news_app/app/data/data_source/remote/news_service.dart';
import 'package:flutter_news_app/app/data/model/news_model.dart';
import 'package:flutter_news_app/app/data/repository/news_repository.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'news_repository_test.mocks.dart';

@GenerateMocks([NewsService, INetworkInfo, NewsCacheService])
void main() {
  late NewsRepositoryImpl repository;
  late MockNewsService mockNewsService;
  late MockINetworkInfo mockNetworkInfo;
  late MockNewsCacheService mockCacheService;

  setUp(() {
    mockNewsService = MockNewsService();
    mockNetworkInfo = MockINetworkInfo();
    mockCacheService = MockNewsCacheService();
    repository = NewsRepositoryImpl(
      newsService: mockNewsService,
      networkInfo: mockNetworkInfo,
      cacheService: mockCacheService,
    );
  });

  group('NewsRepository - fetchNews with cache', () {
    final testNews = [
      NewsModel(
        id: '1',
        title: 'Breaking News',
        publishedAt: '2024-12-18T10:00:00Z',
      ),
    ];

    test('should return cached news when cache is valid', () async {
      // Arrange
      when(mockCacheService.getPopularNews())
          .thenAnswer((_) async => testNews);

      // Act
      final result = await repository.fetchNews(
        isLatest: true,
        forYou: false,
        forceRefresh: false,
      );

      // Assert
      expect(result.isRight(), true);
      verify(mockCacheService.getPopularNews()).called(1);
      verifyNever(mockNetworkInfo.currentConnectivityResult);
    });

    test('should fetch from API when forceRefresh is true', () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockNewsService.fetchNews(isLatest: true, forYou: false))
          .thenAnswer((_) async => Right<Failure, List<NewsModel>>(testNews));
      when(mockCacheService.savePopularNews(testNews))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.fetchNews(
        isLatest: true,
        forYou: false,
        forceRefresh: true,
      );

      // Assert
      expect(result.isRight(), true);
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockNewsService.fetchNews(isLatest: true, forYou: false)).called(1);
    });

    test('should return ConnectionFailure when network unavailable', () async {
      // Arrange
      when(mockCacheService.getPopularNews()).thenAnswer((_) async => null);
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.fetchNews(
        isLatest: true,
        forYou: false,
        forceRefresh: false,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ConnectionFailure>());
          expect(failure.errorMessage, StringConstants.noInternetConnection);
        },
        (_) => fail('Should return failure'),
      );
    });
  });

  group('NewsRepository - saveNews', () {
    test('should return success when network is available', () async {
      // Arrange
      const newsId = 'news123';
      final testResponse = {'id': 'saved123', 'newsId': newsId};
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockNewsService.saveNews(newsId: newsId))
          .thenAnswer((_) async => Right<Failure, Map<String, dynamic>>(testResponse));

      // Act
      final result = await repository.saveNews(newsId: newsId);

      // Assert
      expect(result.isRight(), true);
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockNewsService.saveNews(newsId: newsId)).called(1);
    });
  });
}
