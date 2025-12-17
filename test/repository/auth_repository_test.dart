import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/data/data_source/remote/auth_service.dart';
import 'package:flutter_news_app/app/data/repository/auth_repository.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthService, INetworkInfo])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthService mockAuthService;
  late MockINetworkInfo mockNetworkInfo;

  setUp(() {
    mockAuthService = MockAuthService();
    mockNetworkInfo = MockINetworkInfo();
    repository = AuthRepositoryImpl(
      authService: mockAuthService,
      networkInfo: mockNetworkInfo,
    );
  });

  group('AuthRepository - login', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('should return success when network is available and login succeeds',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockAuthService.login(testEmail, testPassword))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await repository.login(
        email: testEmail,
        password: testPassword,
      );

      // Assert
      expect(result, const Right(null));
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockAuthService.login(testEmail, testPassword)).called(1);
    });

    test('should return ConnectionFailure when network is not available',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.login(
        email: testEmail,
        password: testPassword,
      );

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
      verifyNever(mockAuthService.login(any, any));
    });

    test('should return ServerFailure when login fails', () async {
      // Arrange
      const errorMessage = 'Invalid credentials';
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockAuthService.login(testEmail, testPassword)).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: errorMessage)),
      );

      // Act
      final result = await repository.login(
        email: testEmail,
        password: testPassword,
      );

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
      verify(mockAuthService.login(testEmail, testPassword)).called(1);
    });
  });

  group('AuthRepository - signup', () {
    const testEmail = 'newuser@example.com';
    const testPassword = 'newpassword123';

    test('should return success when network is available and signup succeeds',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockAuthService.signUp(testEmail, testPassword))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await repository.signup(
        email: testEmail,
        password: testPassword,
      );

      // Assert
      expect(result, const Right(null));
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockAuthService.signUp(testEmail, testPassword)).called(1);
    });

    test('should return ConnectionFailure when network is not available',
        () async {
      // Arrange
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.signup(
        email: testEmail,
        password: testPassword,
      );

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
      verifyNever(mockAuthService.signUp(any, any));
    });

    test('should return ServerFailure when signup fails', () async {
      // Arrange
      const errorMessage = 'Email already exists';
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockAuthService.signUp(testEmail, testPassword)).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: errorMessage)),
      );

      // Act
      final result = await repository.signup(
        email: testEmail,
        password: testPassword,
      );

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
      verify(mockAuthService.signUp(testEmail, testPassword)).called(1);
    });
  });
}
