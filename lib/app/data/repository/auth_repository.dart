import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/data/data_source/local/auth_local_service.dart';
import 'package:flutter_news_app/app/data/model/user_model.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/app/data/data_source/remote/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AUTH REPOSITORY PROVIDER
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final service = ref.read(authServiceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final authLocalService = ref.read(authLocalServiceProvider);

  return AuthRepositoryImpl(
    networkInfo: networkInfo,
    authService: service,
    authLocalService: authLocalService,
  );
});

abstract class AuthRepository {
  /// AUTHENTICATE USER WITH EMAIL AND PASSWORD
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  });

  /// REGISTER NEW USER WITH EMAIL AND PASSWORD
  Future<Either<Failure, UserModel>> signup({
    required String email,
    required String password,
  });

  Future<void> logOut();
}

/// AUTH REPOSITORY IMPLEMENTATION
class AuthRepositoryImpl implements AuthRepository {
  final INetworkInfo _networkInfo;
  final AuthService _authService;
  final AuthLocalService _authLocalService;

  AuthRepositoryImpl({
    required INetworkInfo networkInfo,
    required AuthService authService,
    required AuthLocalService authLocalService,
  }) : _networkInfo = networkInfo,
       _authService = authService,
       _authLocalService = authLocalService;

  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }

    final result = await _authService.login(email, password);
    return result.fold(Left.new, (loginResponse) async {
      await _authLocalService.saveAccessToken(loginResponse.accessToken);
      return Right(loginResponse.user);
    });
  }

  @override
  Future<Either<Failure, UserModel>> signup({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    final registerResult = await _authService.signUp(email, password);

    return await registerResult.fold(
      Left.new,
      (_) => login(email: email, password: password),
    );
  }

  @override
  Future<void> logOut() async {
    await _authLocalService.clear();
  }
}
