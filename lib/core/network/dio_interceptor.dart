import 'package:dio/dio.dart';
import 'package:flutter_news_app/core/network/api_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_news_app/core/utils/enum/cache_enum.dart';

/// THIS PROVIDER IS USED TO GET THE SECURE STORAGE.
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

/// THIS PROVIDER IS USED TO GET THE DIO.
final dioProvider = Provider<Dio>((ref) {
  final secureStorage = ref.read(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// THIS IS USED TO ADD INTERCEPTORS TO THE DIO.
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final apiKey = dotenv.env['API_KEY'];
        if (apiKey != null && apiKey.isNotEmpty) {
          options.headers['x-api-key'] = apiKey;
        }

        final accessToken = await secureStorage.read(
          key: CacheKeyEnum.accessToken.name,
        );
        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        handler.next(options);
      },

      onResponse: (response, handler) {
        handler.next(response);
      },

      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          await secureStorage.delete(key: CacheKeyEnum.accessToken.name);
        }

        handler.next(e);
      },
    ),
  );

  return dio;
});
