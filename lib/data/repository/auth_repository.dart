import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/data/data_source/remote/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final service = ref.read(authServiceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepositoryImpl(networkInfo: networkInfo, authService: service);
});

abstract class AuthRepository {
  /// AUTHENTICATE USER WITH EMAIL AND PASSWORD
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });
  
  /// REGISTER NEW USER WITH EMAIL AND PASSWORD
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final INetworkInfo _networkInfo;
  final AuthService _authService;

  AuthRepositoryImpl({
    required INetworkInfo networkInfo,
    required AuthService authService,
  }) : _networkInfo = networkInfo,
       _authService = authService;

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _authService.login(email, password);
  }

  @override
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _authService.signUp(email, password);
  }
}
