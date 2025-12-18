import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/app/data/model/user_model.dart';
import 'package:flutter_news_app/app/data/repository/user_profile_repository.dart';

/// USER PROFILE PROVIDER - MANAGES GLOBAL USER PROFILE STATE
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserModel?>>((ref) {
      return UserProfileNotifier(ref.read(userProfileRepositoryProvider));
    });

/// USER PROFILE NOTIFIER - MANAGES USER PROFILE STATE THROUGHOUT THE APP
class UserProfileNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final UserProfileRepository _repository;

  UserProfileNotifier(this._repository) : super(const AsyncData(null));

  /// FETCH USER PROFILE FROM API
  Future<void> fetchUserProfile() async {
    state = const AsyncLoading();

    final result = await _repository.fetchUserProfile();

    state = result.fold(
      (failure) => AsyncError(failure.errorMessage, StackTrace.current),
      (user) => AsyncData(user),
    );
  }

  /// UPDATE PROFILE WITH EXISTING USERMODEL (FROM LOGIN)
  void setUserProfile(UserModel user) {
    state = AsyncData(user);
  }

  /// CLEAR PROFILE ON LOGOUT
  void clearProfile() {
    state = const AsyncData(null);
  }
}
