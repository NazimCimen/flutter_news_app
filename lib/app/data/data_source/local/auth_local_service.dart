import 'package:flutter_news_app/core/utils/enum/cache_enum.dart';
import 'package:flutter_news_app/core/utils/jwt_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// AUTH LOCAL SERVICE PROVIDER
final authLocalServiceProvider = Provider<AuthLocalService>((ref) {
  final secureStorage = ref.read(secureStorageProvider);
  return AuthLocalServiceImpl(secureStorage);
});

/// THIS PROVIDER IS USED TO GET THE SECURE STORAGE.
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

abstract class AuthLocalService {
  /// SAVE ACCESS TOKEN SECURELY
  Future<void> saveAccessToken(String token);

  /// GET STORED ACCESS TOKEN
  Future<String?> getAccessToken();

  /// CHECK IF TOKEN IS VALID
  Future<bool> isTokenValid();

  /// CLEAR ALL AUTH RELATED DATA
  Future<void> clear();
}

class AuthLocalServiceImpl implements AuthLocalService {
  final FlutterSecureStorage _storage;

  AuthLocalServiceImpl(this._storage);

  @override
  Future<void> saveAccessToken(String token) {
    return _storage.write(key: CacheKeyEnum.accessToken.name, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: CacheKeyEnum.accessToken.name);
    if (token != null && !JwtUtils.isTokenExpired(token)) {
      return token;
    }
    await clear();
    return null;
  }

  @override
  Future<bool> isTokenValid() async {
    final token = await getAccessToken();
    return token != null;
  }

  @override
  Future<void> clear() {
    return _storage.delete(key: CacheKeyEnum.accessToken.name);
  }
}
