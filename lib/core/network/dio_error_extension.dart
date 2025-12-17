import 'package:dio/dio.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/error/failure.dart';

/// THIS EXTENSION IS USED TO CONVERT DIOS ERROR TO FAILURE.
extension DioErrorExtension on DioException {
  Failure toFailure() {
    final statusCode = response?.statusCode;

    if (statusCode == 409) {
      return ServerFailure(errorMessage: StringConstants.emailAlreadyExist);
    }

    if (statusCode == 401) {
      return ServerFailure(errorMessage: StringConstants.invalidCredentials);
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerFailure(errorMessage: StringConstants.anErrorOccured);
    }

    return ServerFailure(errorMessage: StringConstants.anErrorOccured);
  }
}
