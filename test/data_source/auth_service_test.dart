import 'package:dio/dio.dart';
import 'package:flutter_news_app/app/data/data_source/remote/auth_service.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late AuthServiceImpl authService;

  setUp(() {
    mockDio = MockDio();
    authService = AuthServiceImpl(
      dio: mockDio,
    );
  });

  group('AuthService - signUp', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('should return Right(null) when sign up is successful', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: {'result': 'success'},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await authService.signUp(testEmail, testPassword);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (_) {},
      );
      verify(mockDio.post<Map<String, dynamic>>(
        any,
        data: {'email': testEmail, 'password': testPassword},
      )).called(1);
    });

    test('should return Failure when DioException occurs', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
      ));

      final result = await authService.signUp(testEmail, testPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (success) => fail('Should return Left'),
      );
    });

    test('should return ServerFailure when unknown exception occurs', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenThrow(Exception('Unknown error'));

      final result = await authService.signUp(testEmail, testPassword);

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

    test('should return Right(LoginResponse) when login is successful', () async {
      final responseData = {
        'result': {
          'accessToken': testAccessToken,
          'user': {
            'id': '123',
            'name': 'Test User',
            'email': testEmail,
            'imageUrl': 'https://example.com/image.jpg',
          },
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

      final result = await authService.login(testEmail, testPassword);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return Right'),
        (loginResponse) {
          expect(loginResponse.accessToken, testAccessToken);
          expect(loginResponse.user.email, testEmail);
          expect(loginResponse.user.name, 'Test User');
        },
      );
    });

    test('should return Failure when response data is null', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await authService.login(testEmail, testPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (success) => fail('Should return Left'),
      );
    });

    test('should return Failure when accessToken is empty', () async {
      final responseData = {
        'result': {
          'accessToken': '',
          'user': {
            'id': '123',
            'name': 'Test User',
            'email': testEmail,
          },
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

      final result = await authService.login(testEmail, testPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (success) => fail('Should return Left'),
      );
    });

    test('should return Failure when user data is null', () async {
      final responseData = {
        'result': {
          'accessToken': testAccessToken,
          'user': null,
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

      final result = await authService.login(testEmail, testPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (success) => fail('Should return Left'),
      );
    });

    test('should return Failure when DioException occurs', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      final result = await authService.login(testEmail, testPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (success) => fail('Should return Left'),
      );
    });
  });
}
