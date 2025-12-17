import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/data/repository/auth_repository.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModelBase, AsyncValue<void>>((ref) {
  return AuthViewModel(ref.read(authRepositoryProvider));
});

    abstract class AuthViewModelBase
    extends StateNotifier<AsyncValue<void>> {
  AuthViewModelBase() : super(const AsyncData(null));

  Future<void> login(String email, String password);

  Future<void> signup(String email, String password, String name);
}

class AuthViewModel extends AuthViewModelBase {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository) ;
  @override

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    state = result.fold(
      (failure) => AsyncError(failure.errorMessage, StackTrace.current),
      (_) => const AsyncData(null),
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
      (_) => const AsyncData(null),
    );
  }
}
