import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/app/data/data_source/remote/news_service.dart';
import 'package:flutter_news_app/app/data/model/category_with_news_model.dart';
import 'package:flutter_news_app/app/data/model/news_model.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'news_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late NewsServiceImpl newsService;

  setUp(() {
    mockDio = MockDio();
    newsService = NewsServiceImpl(dio: mockDio);
  });

  group('NewsService - fetchNews', () {
    test('should return list of NewsModel when API call is successful', () async {
      // Arrange
      final responseData = {
        'result': {
          'items': [
            {
              'id': '1',
              'title': 'Test News',
              'publishedAt': '2024-12-18T10:00:00Z',
            },
          ],
        },
      };
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await newsService.fetchNews(isLatest: true, forYou: false);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (newsList) {
          expect(newsList, isA<List<NewsModel>>());
          expect(newsList.length, 1);
          expect(newsList.first.id, '1');
          expect(newsList.first.title, 'Test News');
        },
      );
    });

    test('should return empty list when result is null', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: {'result': null},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await newsService.fetchNews();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (newsList) => expect(newsList, isEmpty),
      );
    });

    test('should return Failure when DioException occurs', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      // Act
      final result = await newsService.fetchNews();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (newsList) => fail('Should return Left'),
      );
    });
  });

  group('NewsService - fetchNewsByCategory', () {
    test('should return list of NewsModel for specific category', () async {
      // Arrange
      final responseData = {
        'result': {
          'items': [
            {
              'id': '1',
              'title': 'Category News',
              'categoryId': 'tech',
            },
          ],
        },
      };
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await newsService.fetchNewsByCategory(
        categoryId: 'tech',
        page: 1,
        pageSize: 10,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (newsList) {
          expect(newsList.length, 1);
          expect(newsList.first.categoryId, 'tech');
        },
      );
    });
  });

  group('NewsService - fetchCategoriesWithNews', () {
    test('should return list of CategoryWithNewsModel', () async {
      // Arrange
      final responseData = {
        'result': {
          'items': [
            {
              'category': {'id': '1', 'name': 'Technology'},
              'news': [
                {'id': '1', 'title': 'Tech News'},
              ],
            },
          ],
        },
      };
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await newsService.fetchCategoriesWithNews();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (categories) {
          expect(categories, isA<List<CategoryWithNewsModel>>());
          expect(categories.length, 1);
        },
      );
    });
  });

  group('NewsService - saveNews', () {
    test('should return success when news is saved', () async {
      // Arrange
      final responseData = {
        'result': {'id': 'saved-1', 'newsId': 'news-1'},
      };
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await newsService.saveNews(newsId: 'news-1');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (data) => expect(data, isA<Map<String, dynamic>>()),
      );
    });

    test('should return Failure when result is null', () async {
      // Arrange
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: {'result': null},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await newsService.saveNews(newsId: 'news-1');

      // Assert
      expect(result.isLeft(), true);
    });
  });

  group('NewsService - deleteSavedNews', () {
    test('should return success when saved news is deleted', () async {
      // Arrange
      when(mockDio.delete<Map<String, dynamic>>(any)).thenAnswer(
        (_) async => Response(
          data: {},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await newsService.deleteSavedNews(savedNewsId: 'saved-1');

      // Assert
      expect(result.isRight(), true);
    });

    test('should return Failure when DioException occurs', () async {
      // Arrange
      when(mockDio.delete<Map<String, dynamic>>(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act
      final result = await newsService.deleteSavedNews(savedNewsId: 'saved-1');

      // Assert
      expect(result.isLeft(), true);
    });
  });
}
