import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/data/data_source/local/auth_local_service.dart';
import 'package:flutter_news_app/app/data/data_source/remote/auth_service.dart';
import 'package:flutter_news_app/app/data/model/response_auth.dart';
import 'package:flutter_news_app/app/data/model/user_model.dart';
import 'package:flutter_news_app/app/data/repository/auth_repository.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthService, INetworkInfo, AuthLocalService])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthService mockAuthService;
  late MockINetworkInfo mockNetworkInfo;
  late MockAuthLocalService mockAuthLocalService;

  setUp(() {
    mockAuthService = MockAuthService();
    mockNetworkInfo = MockINetworkInfo();
    mockAuthLocalService = MockAuthLocalService();
    repository = AuthRepositoryImpl(
      authService: mockAuthService,
      networkInfo: mockNetworkInfo,
      authLocalService: mockAuthLocalService,
    );
  });

  group('AuthRepository - login', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testAccessToken = 'test_access_token_12345';
    const testUser = UserModel(
      id: '123',
      name: 'Test User',
      email: testEmail,
      imageUrl: 'https://example.com/image.jpg',
    );

    test('should save token and return user when network is available and login succeeds',
        () async {
      // Arrange
      final loginResponse = ResponseAuth(
        accessToken: testAccessToken,
        user: testUser,
      );
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockAuthService.login(testEmail, testPassword))
          .thenAnswer((_) async => Right(loginResponse));
      when(mockAuthLocalService.saveAccessToken(testAccessToken))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.login(
        email: testEmail,
        password: testPassword,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user.email, testEmail);
          expect(user.name, 'Test User');
        },
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(1);
      verify(mockAuthService.login(testEmail, testPassword)).called(1);
      verify(mockAuthLocalService.saveAccessToken(testAccessToken)).called(1);
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
    const testAccessToken = 'test_access_token_12345';
    const testUser = UserModel(
      id: '456',
      name: 'New User',
      email: testEmail,
      imageUrl: 'https://example.com/new-image.jpg',
    );

    test('should call login after successful signup and return user',
        () async {
      // Arrange
      final loginResponse = ResponseAuth(
        accessToken: testAccessToken,
        user: testUser,
      );
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockAuthService.signUp(testEmail, testPassword))
          .thenAnswer((_) async => const Right<Failure, void>(null));
      when(mockAuthService.login(testEmail, testPassword))
          .thenAnswer((_) async => Right(loginResponse));
      when(mockAuthLocalService.saveAccessToken(testAccessToken))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.signup(
        email: testEmail,
        password: testPassword,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (user) {
          expect(user.email, testEmail);
          expect(user.name, 'New User');
        },
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(2); // Called twice: once for signup, once for login
      verify(mockAuthService.signUp(testEmail, testPassword)).called(1);
      verify(mockAuthService.login(testEmail, testPassword)).called(1);
      verify(mockAuthLocalService.saveAccessToken(testAccessToken)).called(1);
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
      verifyNever(mockAuthService.login(any, any));
    });

    test('should return Failure when signup succeeds but login fails', () async {
      // Arrange
      const errorMessage = 'Login failed after signup';
      when(mockNetworkInfo.currentConnectivityResult)
          .thenAnswer((_) async => true);
      when(mockAuthService.signUp(testEmail, testPassword))
          .thenAnswer((_) async => const Right<Failure, void>(null));
      when(mockAuthService.login(testEmail, testPassword)).thenAnswer(
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
        (user) => fail('Should return failure'),
      );
      verify(mockNetworkInfo.currentConnectivityResult).called(2); // Called twice: once for signup, once for login
      verify(mockAuthService.signUp(testEmail, testPassword)).called(1);
      verify(mockAuthService.login(testEmail, testPassword)).called(1);
    });
  });
}
