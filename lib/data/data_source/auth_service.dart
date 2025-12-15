import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/core/network/api_constants.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/dio_error_extension.dart';
import 'package:flutter_news_app/core/network/dio_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthServiceImpl(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(secureStorageProvider),
  );
});

abstract class AuthService {
  Future<Either<Failure, void>> login(String email, String password);
  Future<Either<Failure, void>> signUp(String email, String password);
}

class AuthServiceImpl implements AuthService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  AuthServiceImpl({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
  }) : _dio = dio,
       _secureStorage = secureStorage;

  // ---------------- LOGIN ----------------
  @override
  Future<Either<Failure, void>> login(String email, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.loginEndPoint,
        data: {'email': email, 'password': password},
      );

      final data = response.data;

      if (data == null) {
        return Left(
          ServerFailure(errorMessage: StringConstants.anErrorOccured),
        );
      }

      final result = data['result'];
      if (result is! Map<String, dynamic>) {
        return Left(
          ServerFailure(errorMessage: StringConstants.anErrorOccured),
        );
      }

      final accessToken = result['accessToken'];

      if (accessToken is! String || accessToken.isEmpty) {
        return Left(
          ServerFailure(errorMessage: StringConstants.anErrorOccured),
        );
      }
      await _secureStorage.write(
        key: ApiConstants.accessTokenKey,
        value: accessToken,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (_) {
      return Left(ServerFailure(errorMessage: StringConstants.anErrorOccured));
    }
  }

  // ---------------- SIGN UP ----------------
  @override
  Future<Either<Failure, void>> signUp(String email, String password) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        ApiConstants.signUpEndPoint,
        data: {'email': email, 'password': password},
      );

      return const Right(null);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (_) {
      return Left(ServerFailure(errorMessage: StringConstants.anErrorOccured));
    }
  }
}
