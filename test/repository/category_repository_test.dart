import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/data/data_source/remote/category_service.dart';
import 'package:flutter_news_app/app/data/model/category_model.dart';
import 'package:flutter_news_app/app/data/repository/category_repository.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'category_repository_test.mocks.dart';

@GenerateMocks([CategoryService, INetworkInfo])
void main() {
  late CategoriesRepositoryImpl repository;
  late MockCategoryService mockCategoryService;
  late MockINetworkInfo mockNetworkInfo;

  setUp(() {
    mockCategoryService = MockCategoryService();
    mockNetworkInfo = MockINetworkInfo();
    repository = CategoriesRepositoryImpl(
      categoryService: mockCategoryService,
      networkInfo: mockNetworkInfo,
    );
  });

  group('CategoriesRepository - fetchCategories', () {
    final testCategories = [
      const CategoryModel(
        id: '1',
        name: 'Technology',
        imageUrl: 'https://example.com/tech.jpg',
      ),
      const CategoryModel(
        id: '2',
        name: 'Sports',
        imageUrl: 'https://example.com/sports.jpg',
      ),
    ];

    test('should return categories when network is available and fetch succeeds',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockCategoryService.fetchCategories())
          .thenAnswer((_) async => Right(testCategories));

      // Act
      final result = await repository.fetchCategories();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return categories'),
        (categories) {
          expect(categories, testCategories);
          expect(categories.length, 2);
          expect(categories[0].name, 'Technology');
          expect(categories[1].name, 'Sports');
        },
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockCategoryService.fetchCategories()).called(1);
    });

    test('should return empty list when service returns empty list', () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockCategoryService.fetchCategories())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await repository.fetchCategories();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return empty list'),
        (categories) {
          expect(categories, isEmpty);
        },
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockCategoryService.fetchCategories()).called(1);
    });

    test('should return ServerFailure when network is not available', () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.fetchCategories();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(
            failure.errorMessage,
            StringConstants.noInternetConnection,
          );
        },
        (_) => fail('Should return failure'),
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verifyNever(mockCategoryService.fetchCategories());
    });

    test('should return ServerFailure when service fails', () async {
      // Arrange
      const errorMessage = 'Failed to fetch categories';
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockCategoryService.fetchCategories()).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: errorMessage)),
      );

      // Act
      final result = await repository.fetchCategories();

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
      verify(mockCategoryService.fetchCategories()).called(1);
    });
  });
}
