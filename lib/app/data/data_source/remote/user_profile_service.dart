import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/app/data/model/user_model.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/api_constants.dart';
import 'package:flutter_news_app/core/network/dio_error_extension.dart';
import 'package:flutter_news_app/core/network/dio_interceptor.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// USER PROFILE SERVICE PROVIDER
final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileServiceImpl(dio: ref.read(dioProvider));
});

abstract class UserProfileService {
  /// FETCH AUTHENTICATED USER'S PROFILE FROM API
  Future<Either<Failure, UserModel>> getUserProfile();
}

class UserProfileServiceImpl implements UserProfileService {
  final Dio _dio;

  UserProfileServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Either<Failure, UserModel>> getUserProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.userProfile,
      );

      final data = response.data;
      if (data == null || data['result'] == null) {
        return Left(
          ServerFailure(errorMessage: StringConstants.anErrorOccured),
        );
      }

      final user = UserModel.fromJson(data['result'] as Map<String, dynamic>);
      return Right(user);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (_) {
      return Left(ServerFailure(errorMessage: StringConstants.anErrorOccured));
    }
  }
}
