import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/app/data/model/response_auth.dart';
import 'package:flutter_news_app/app/data/model/user_model.dart';
import 'package:flutter_news_app/core/network/api_constants.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/dio_error_extension.dart';
import 'package:flutter_news_app/core/network/dio_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AUTH SERVICE PROVIDER
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthServiceImpl(dio: ref.read(dioProvider));
});

abstract class AuthService {
  /// AUTHENTICATE USER WITH EMAIL AND PASSWORD
  Future<Either<Failure, ResponseAuth>> login(String email, String password);

  /// REGISTER NEW USER WITH EMAIL AND PASSWORD
  Future<Either<Failure, void>> signUp(String email, String password);
}

class AuthServiceImpl implements AuthService {
  final Dio _dio;

  AuthServiceImpl({required Dio dio}) : _dio = dio;

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

  @override
  Future<Either<Failure, ResponseAuth>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.loginEndPoint,
        data: {'email': email, 'password': password},
      );

      final result = response.data?['result'];
      final accessToken = result?['accessToken'];
      final userData = result?['user'];

      if (accessToken is! String || accessToken.isEmpty) {
        return Left(
          ServerFailure(errorMessage: StringConstants.anErrorOccured),
        );
      }

      if (userData == null) {
        return Left(
          ServerFailure(errorMessage: StringConstants.anErrorOccured),
        );
      }

      final user = UserModel.fromJson(userData as Map<String, dynamic>);
      final loginResponse = ResponseAuth(accessToken: accessToken, user: user);

      return Right(loginResponse);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }
}
