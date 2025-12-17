import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/app/data/data_source/remote/auth_service.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([Dio, FlutterSecureStorage])
void main() {
  late MockDio mockDio;
  late MockFlutterSecureStorage mockSecureStorage;
  late AuthServiceImpl authService;

  setUp(() {
    mockDio = MockDio();
    mockSecureStorage = MockFlutterSecureStorage();
    authService = AuthServiceImpl(
      dio: mockDio,
      secureStorage: mockSecureStorage,
    );
  });

  group('AuthService - signUp', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('should return Right(null) when sign up is successful', () async {
      // Arrange
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: {'result': 'success'},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await authService.signUp(testEmail, testPassword);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (_) {}, // success is void
      );
      verify(mockDio.post<Map<String, dynamic>>(
        any,
        data: {'email': testEmail, 'password': testPassword},
      )).called(1);
    });

    test('should return Failure when DioException occurs', () async {
      // Arrange
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
      ));

      // Act
      final result = await authService.signUp(testEmail, testPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (success) => fail('Should return Left'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      // Arrange
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenThrow(Exception('Unknown error'));

      // Act
      final result = await authService.signUp(testEmail, testPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (success) => fail('Should return Left'),
      );
    });
  });

  group('AuthService - login', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testAccessToken = 'test_access_token_12345';

    test('should save access token and return Right(null) when login is successful',
        () async {
      // Arrange
      final responseData = {
        'result': {
          'accessToken': testAccessToken,
        },
      };
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));
      when(mockSecureStorage.write(
        key: anyNamed('key'),
        value: anyNamed('value'),
      )).thenAnswer((_) async => Future.value());

      // Act
      final result = await authService.login(testEmail, testPassword);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (_) {}, // success is void
      );
      verify(mockSecureStorage.write(
        key: anyNamed('key'),
        value: testAccessToken,
      )).called(1);
    });

    test('should return Failure when response data is null', () async {
      // Arrange
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await authService.login(testEmail, testPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (success) => fail('Should return Left'),
      );
    });

    test('should return Failure when accessToken is empty', () async {
      // Arrange
      final responseData = {
        'result': {
          'accessToken': '',
        },
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
      final result = await authService.login(testEmail, testPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (success) => fail('Should return Left'),
      );
    });

    test('should return Failure when DioException occurs', () async {
      // Arrange
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      // Act
      final result = await authService.login(testEmail, testPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (success) => fail('Should return Left'),
      );
    });
  });
}
