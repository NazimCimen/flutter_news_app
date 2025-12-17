import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/app/data/data_source/remote/category_service.dart';
import 'package:flutter_news_app/app/data/model/category_model.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'category_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late CategoryServiceImpl categoryService;

  setUp(() {
    mockDio = MockDio();
    categoryService = CategoryServiceImpl(dio: mockDio);
  });

  group('CategoryService - fetchCategories', () {
    test('should return list of CategoryModel when API call is successful',
        () async {
      // Arrange
      final responseData = {
        'result': [
          {
            'id': '1',
            'name': 'Technology',
            'color': '#FF5733',
          },
          {
            'id': '2',
            'name': 'Sports',
            'color': '#33FF57',
          },
        ],
      };
      when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await categoryService.fetchCategories();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (categories) {
          expect(categories, isA<List<CategoryModel>>());
          expect(categories.length, 2);
          expect(categories.first.id, '1');
          expect(categories.first.name, 'Technology');
          expect(categories.last.id, '2');
          expect(categories.last.name, 'Sports');
        },
      );
      verify(mockDio.get<Map<String, dynamic>>(any)).called(1);
    });

    test('should return empty list when result is null', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
        (_) async => Response(
          data: {'result': null},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await categoryService.fetchCategories();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (categories) => expect(categories, isEmpty),
      );
    });

    test('should return empty list when data is null', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = await categoryService.fetchCategories();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (categories) => expect(categories, isEmpty),
      );
    });

    test('should return Failure when DioException occurs', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // Act
      final result = await categoryService.fetchCategories();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (categories) => fail('Should return Left'),
      );
    });

    test('should return Failure when network error occurs', () async {
      // Arrange
      when(mockDio.get<Map<String, dynamic>>(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      // Act
      final result = await categoryService.fetchCategories();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (categories) => fail('Should return Left'),
      );
    });
  });
}
