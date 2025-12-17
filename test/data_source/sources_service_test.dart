import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/app/data/data_source/remote/sources_service.dart';
import 'package:flutter_news_app/app/data/model/source_model.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sources_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late SourcesServiceImpl sourcesService;

  setUp(() {
    mockDio = MockDio();
    sourcesService = SourcesServiceImpl(dio: mockDio);
  });

  group('SourcesService - fetchSources', () {
    test('should return list of SourceModel when API call is successful',
        () async {
      // Arrange
      final responseData = {
        'result': {
          'sources': [
            {
              'id': '1',
              'name': 'BBC News',
              'description': 'British news source',
            },
            {
              'id': '2',
              'name': 'CNN',
              'description': 'American news source',
            },
          ],
        },
      };
      when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await sourcesService.fetchSources();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (sources) {
          expect(sources, isA<List<SourceModel>>());
          expect(sources.length, 2);
          expect(sources.first.id, '1');
          expect(sources.first.name, 'BBC News');
          expect(sources.last.id, '2');
        },
      );
      verify(mockDio.get<Map<String, dynamic>>(any)).called(1);
    });

    test('should return empty list when sources is null', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
        (_) async => Response(
          data: {
            'result': {'sources': null},
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await sourcesService.fetchSources();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (sources) => expect(sources, isEmpty),
      );
    });

    test('should return Failure when DioException occurs', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      // Act
      final result = await sourcesService.fetchSources();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (sources) => fail('Should return Left'),
      );
    });
  });

  group('SourcesService - fetchFollowedSources', () {
    test('should return list of followed SourceModel when API call is successful',
        () async {
      // Arrange
      final responseData = {
        'result': {
          'sources': [
            {
              'id': '1',
              'name': 'BBC News',
              'isFollowed': true,
            },
          ],
        },
      };
      when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await sourcesService.fetchFollowedSources();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (sources) {
          expect(sources, isA<List<SourceModel>>());
          expect(sources.length, 1);
          expect(sources.first.id, '1');
        },
      );
    });

    test('should return empty list when no followed sources', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
        (_) async => Response(
          data: {
            'result': {'sources': []},
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await sourcesService.fetchFollowedSources();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (sources) => expect(sources, isEmpty),
      );
    });

    test('should return Failure when DioException occurs', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act
      final result = await sourcesService.fetchFollowedSources();

      // Assert
      expect(result.isLeft(), true);
    });
  });

  group('SourcesService - bulkFollow', () {
    test('should return Right(null) when bulk follow is successful', () async {
      // Arrange
      final updates = [
        {'sourceId': '1', 'isFollowed': true},
        {'sourceId': '2', 'isFollowed': false},
      ];
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: {'result': 'success'},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await sourcesService.bulkFollow(updates);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (_) {}, // success is void
      );
      verify(mockDio.post<Map<String, dynamic>>(
        any,
        data: updates,
      )).called(1);
    });

    test('should return Right(null) even when result is null', () async {
      // Arrange
      final updates = [
        {'sourceId': '1', 'isFollowed': true},
      ];
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: {'result': null},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await sourcesService.bulkFollow(updates);

      // Assert
      expect(result.isRight(), true);
    });

    test('should return Failure when DioException occurs', () async {
      // Arrange
      final updates = [
        {'sourceId': '1', 'isFollowed': true},
      ];
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      // Act
      final result = await sourcesService.bulkFollow(updates);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (success) => fail('Should return Left'),
      );
    });

    test('should send empty list when no updates provided', () async {
      // Arrange
      final updates = <Map<String, dynamic>>[];
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: {'result': 'success'},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await sourcesService.bulkFollow(updates);

      // Assert
      expect(result.isRight(), true);
      verify(mockDio.post<Map<String, dynamic>>(
        any,
        data: [],
      )).called(1);
    });
  });
}
