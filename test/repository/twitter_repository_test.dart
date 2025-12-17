import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/data/data_source/remote/twitter_service.dart';
import 'package:flutter_news_app/app/data/model/tweet_model.dart';
import 'package:flutter_news_app/app/data/repository/twitter_repository.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'twitter_repository_test.mocks.dart';

@GenerateMocks([TwitterService, INetworkInfo])
void main() {
  late TwitterRepositoryImpl repository;
  late MockTwitterService mockTwitterService;
  late MockINetworkInfo mockNetworkInfo;

  setUp(() {
    mockTwitterService = MockTwitterService();
    mockNetworkInfo = MockINetworkInfo();
    repository = TwitterRepositoryImpl(
      twitterService: mockTwitterService,
      networkInfo: mockNetworkInfo,
    );
  });

  group('TwitterRepository - fetchTweets', () {
    final testTweets = <TweetModel>[
      const TweetModel(
        id: '1',
        content: 'Breaking news about technology',
        accountName: 'TechNews',
        accountImageUrl: 'https://example.com/tech.jpg',
        createdAt: '2024-12-18T10:00:00Z',
        isPopular: true,
      ),
      const TweetModel(
        id: '2',
        content: 'Sports update',
        accountName: 'SportsDaily',
        accountImageUrl: 'https://example.com/sports.jpg',
        createdAt: '2024-12-18T09:00:00Z',
        isPopular: false,
      ),
    ];

    test('should return formatted tweets when network is available and fetch succeeds',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockTwitterService.fetchTweets(
        page: 1,
        pageSize: 10,
        isPopular: true,
      )).thenAnswer((_) async => Right(testTweets));

      // Act
      final result = await repository.fetchTweets(
        page: 1,
        pageSize: 10,
        isPopular: true,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return tweets'),
        (tweets) {
          expect(tweets.length, 2);
          expect(tweets[0].content, 'Breaking news about technology');
          expect(tweets[1].content, 'Sports update');
          // Dates should be formatted (not ISO format anymore)
          expect(tweets[0].createdAt, isNot('2024-12-18T10:00:00Z'));
          expect(tweets[1].createdAt, isNot('2024-12-18T09:00:00Z'));
        },
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockTwitterService.fetchTweets(
        page: 1,
        pageSize: 10,
        isPopular: true,
      )).called(1);
    });

    test('should return empty list when service returns empty list', () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockTwitterService.fetchTweets())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await repository.fetchTweets();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return empty list'),
        (tweets) => expect(tweets, isEmpty),
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockTwitterService.fetchTweets()).called(1);
    });

    test('should fetch tweets with default parameters', () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockTwitterService.fetchTweets())
          .thenAnswer((_) async => Right(testTweets));

      // Act
      final result = await repository.fetchTweets();

      // Assert
      expect(result.isRight(), true);
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockTwitterService.fetchTweets()).called(1);
    });

    test('should return ConnectionFailure when network is not available',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.fetchTweets();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ConnectionFailure>());
          expect(
            failure.errorMessage,
            StringConstants.noInternetConnection,
          );
        },
        (_) => fail('Should return failure'),
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verifyNever(mockTwitterService.fetchTweets());
    });

    test('should return ServerFailure when service fails', () async {
      // Arrange
      const errorMessage = 'Failed to fetch tweets';
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockTwitterService.fetchTweets()).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: errorMessage)),
      );

      // Act
      final result = await repository.fetchTweets();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.errorMessage, errorMessage);
        },
        (_) => fail('Should return failure'),
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockTwitterService.fetchTweets()).called(1);
    });

    test('should format tweet dates using TimeUtils', () async {
      // Arrange
      final tweetWithRecentDate = <TweetModel>[
        const TweetModel(
          id: '1',
          content: 'Recent tweet',
          accountName: 'User',
          createdAt: '2024-12-18T10:00:00Z',
          isPopular: false,
        ),
      ];

      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockTwitterService.fetchTweets())
          .thenAnswer((_) async => Right(tweetWithRecentDate));

      // Act
      final result = await repository.fetchTweets();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return tweets'),
        (tweets) {
          expect(tweets.length, 1);
          // Date should be formatted (e.g., "2 hours ago", "1 day ago")
          expect(tweets[0].createdAt, isNot(contains('T')));
          expect(tweets[0].createdAt, isNot(contains('Z')));
        },
      );
    });
  });
}
