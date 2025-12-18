import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/app/data/model/user_model.dart';
import 'package:flutter_news_app/app/data/repository/auth_repository.dart';
import 'package:flutter_news_app/feature/profile/user_profile_provider.dart';

/// AUTH VIEW MODEL IS USED TO MANAGE AUTHENTICATION LOGIC
final authViewModelProvider =
    StateNotifierProvider<AuthViewModelBase, AsyncValue<UserModel?>>((ref) {
      return AuthViewModel(ref.read(authRepositoryProvider), ref);
    });

/// AUTH VIEW MODEL BASE IS USED TO MANAGE AUTHENTICATION LOGIC
abstract class AuthViewModelBase extends StateNotifier<AsyncValue<UserModel?>> {
  AuthViewModelBase() : super(const AsyncData(null));

  /// LOGIN FUNCTION IS USED TO LOGIN USER
  Future<void> login(String email, String password);

  /// SIGNUP FUNCTION IS USED TO SIGNUP USER
  Future<void> signup(String email, String password, String name);

  /// LOGOUT FUNCTION IS USED TO LOGOUT USER
  Future<void> logout();
}

/// AUTH VIEW MODEL IS USED TO MANAGE AUTHENTICATION LOGIC
class AuthViewModel extends AuthViewModelBase {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthViewModel(this._authRepository, this._ref);

  @override
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    state = result.fold(
      (failure) => AsyncError(failure.errorMessage, StackTrace.current),
      (user) {
        _ref.read(userProfileProvider.notifier).setUserProfile(user);
        return AsyncData(user);
      },
    );
  }

  @override
  Future<void> signup(String email, String password, String name) async {
    state = const AsyncLoading();
    final result = await _authRepository.signup(
      email: email,
      password: password,
    );
    state = result.fold(
      (failure) => AsyncError(failure.errorMessage, StackTrace.current),
      (user) {
        _ref.read(userProfileProvider.notifier).setUserProfile(user);
        return AsyncData(user);
      },
    );
  }

  @override
  Future<void> logout() async {
    _ref.read(userProfileProvider.notifier).clearProfile();
    await _authRepository.logOut();
    state = const AsyncData(null);
  }
}
