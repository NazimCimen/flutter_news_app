import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/app/data/data_source/remote/twitter_service.dart';
import 'package:flutter_news_app/app/data/model/tweet_model.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'twitter_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late TwitterServiceImpl twitterService;

  setUp(() {
    mockDio = MockDio();
    twitterService = TwitterServiceImpl(dio: mockDio);
  });

  group('TwitterService - fetchTweets', () {
    test('should return list of TweetModel when API call is successful',
        () async {
      // Arrange
      final responseData = {
        'result': {
          'items': [
            {
              'id': '1',
              'content': 'Test tweet content',
              'author': 'Test Author',
              'createdAt': '2024-12-18T10:00:00Z',
            },
            {
              'id': '2',
              'content': 'Another tweet',
              'author': 'Another Author',
              'createdAt': '2024-12-18T11:00:00Z',
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
      final result = await twitterService.fetchTweets(
        page: 1,
        pageSize: 10,
        isPopular: true,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (tweets) {
          expect(tweets, isA<List<TweetModel>>());
          expect(tweets.length, 2);
          expect(tweets.first.id, '1');
          expect(tweets.first.content, 'Test tweet content');
          expect(tweets.last.id, '2');
        },
      );
      verify(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).called(1);
    });

    test('should return empty list when result items is null', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: {
              'result': {'items': null},
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await twitterService.fetchTweets();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (tweets) => expect(tweets, isEmpty),
      );
    });

    test('should return empty list when data is null', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await twitterService.fetchTweets();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (tweets) => expect(tweets, isEmpty),
      );
    });

    test('should send correct query parameters when provided', () async {
      // Arrange
      final responseData = {
        'result': {'items': []},
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
      await twitterService.fetchTweets(
        page: 2,
        pageSize: 20,
        isPopular: false,
      );

      // Assert
      verify(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: {
          'page': 2,
          'pageSize': 20,
          'isPopular': false,
        },
      )).called(1);
    });

    test('should not send null query parameters', () async {
      // Arrange
      final responseData = {
        'result': {'items': []},
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
      await twitterService.fetchTweets(page: 1);

      // Assert
      verify(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: {'page': 1},
      )).called(1);
    });

    test('should return Failure when DioException occurs', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
      ));

      // Act
      final result = await twitterService.fetchTweets();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (tweets) => fail('Should return Left'),
      );
    });

    test('should return Failure when connection timeout occurs', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      // Act
      final result = await twitterService.fetchTweets();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (tweets) => fail('Should return Left'),
      );
    });
  });
}
