import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/data/data_source/remote/user_profile_service.dart';
import 'package:flutter_news_app/app/data/model/user_model.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// USER PROFILE REPOSITORY PROVIDER
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepositoryImpl(
    networkInfo: ref.read(networkInfoProvider),
    userProfileService: ref.read(userProfileServiceProvider),
  );
});

abstract class UserProfileRepository {
  /// FETCH USER PROFILE WITH NETWORK CONNECTIVITY CHECK
  Future<Either<Failure, UserModel>> fetchUserProfile();
}

/// USER PROFILE REPOSITORY IMPLEMENTATION
class UserProfileRepositoryImpl implements UserProfileRepository {
  final INetworkInfo _networkInfo;
  final UserProfileService _userProfileService;

  UserProfileRepositoryImpl({
    required INetworkInfo networkInfo,
    required UserProfileService userProfileService,
  })  : _networkInfo = networkInfo,
        _userProfileService = userProfileService;

  @override
  Future<Either<Failure, UserModel>> fetchUserProfile() async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }

    return _userProfileService.getUserProfile();
  }
}
