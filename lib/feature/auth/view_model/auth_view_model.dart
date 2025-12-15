import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/data/repository/auth_repository.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>((ref) {
      return AuthViewModel(ref.read(authRepositoryProvider));
    });

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository) : super(const AsyncData(null));

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
