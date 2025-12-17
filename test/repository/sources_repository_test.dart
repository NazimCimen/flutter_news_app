import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/data/data_source/remote/sources_service.dart';
import 'package:flutter_news_app/app/data/model/source_model.dart';
import 'package:flutter_news_app/app/data/repository/sources_repository.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sources_repository_test.mocks.dart';

@GenerateMocks([SourcesService, INetworkInfo])
void main() {
  late SourcesRepositoryImpl repository;
  late MockSourcesService mockSourcesService;
  late MockINetworkInfo mockNetworkInfo;

  setUp(() {
    mockSourcesService = MockSourcesService();
    mockNetworkInfo = MockINetworkInfo();
    repository = SourcesRepositoryImpl(
      sourcesService: mockSourcesService,
      networkInfo: mockNetworkInfo,
    );
  });

  group('SourcesRepository - fetchSources', () {
    final testSources = <SourceModel>[
      const SourceModel(
        id: '1',
        name: 'BBC News',
        imageUrl: 'https://example.com/bbc.jpg',
        isFollowed: false,
      ),
      const SourceModel(
        id: '2',
        name: 'CNN',
        imageUrl: 'https://example.com/cnn.jpg',
        isFollowed: true,
      ),
    ];

    test('should return sources when network is available and fetch succeeds',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockSourcesService.fetchSources())
          .thenAnswer((_) async => Right(testSources));

      // Act
      final result = await repository.fetchSources();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return sources'),
        (sources) {
          expect(sources, testSources);
          expect(sources.length, 2);
          expect(sources[0].name, 'BBC News');
          expect(sources[1].name, 'CNN');
        },
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockSourcesService.fetchSources()).called(1);
    });

    test('should return empty list when service returns empty list', () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockSourcesService.fetchSources())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await repository.fetchSources();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return empty list'),
        (sources) => expect(sources, isEmpty),
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockSourcesService.fetchSources()).called(1);
    });

    test('should return ConnectionFailure when network is not available',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.fetchSources();

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
      verifyNever(mockSourcesService.fetchSources());
    });

    test('should return ServerFailure when service fails', () async {
      // Arrange
      const errorMessage = 'Failed to fetch sources';
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockSourcesService.fetchSources()).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: errorMessage)),
      );

      // Act
      final result = await repository.fetchSources();

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
      verify(mockSourcesService.fetchSources()).called(1);
    });
  });

  group('SourcesRepository - fetchFollowedSources', () {
    final testFollowedSources = <SourceModel>[
      const SourceModel(
        id: '2',
        name: 'CNN',
        imageUrl: 'https://example.com/cnn.jpg',
        isFollowed: true,
      ),
    ];

    test(
        'should return followed sources when network is available and fetch succeeds',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockSourcesService.fetchFollowedSources())
          .thenAnswer((_) async => Right(testFollowedSources));

      // Act
      final result = await repository.fetchFollowedSources();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return followed sources'),
        (sources) {
          expect(sources, testFollowedSources);
          expect(sources.length, 1);
          expect(sources[0].isFollowed, true);
        },
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockSourcesService.fetchFollowedSources()).called(1);
    });

    test('should return ConnectionFailure when network is not available',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.fetchFollowedSources();

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
      verifyNever(mockSourcesService.fetchFollowedSources());
    });
  });

  group('SourcesRepository - bulkFollow', () {
    final testUpdates = [
      {'sourceId': '1', 'isFollowed': true},
      {'sourceId': '2', 'isFollowed': false},
    ];

    test('should return success when network is available and bulk follow succeeds',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockSourcesService.bulkFollow(testUpdates))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await repository.bulkFollow(testUpdates);

      // Assert
      expect(result, const Right(null));
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockSourcesService.bulkFollow(testUpdates)).called(1);
    });

    test('should return ConnectionFailure when network is not available',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.bulkFollow(testUpdates);

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
      verifyNever(mockSourcesService.bulkFollow(any));
    });

    test('should return ServerFailure when service fails', () async {
      // Arrange
      const errorMessage = 'Failed to update sources';
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockSourcesService.bulkFollow(testUpdates)).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: errorMessage)),
      );

      // Act
      final result = await repository.bulkFollow(testUpdates);

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
      verify(mockSourcesService.bulkFollow(testUpdates)).called(1);
    });
  });
}
