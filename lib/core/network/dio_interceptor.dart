import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);
final dioProvider = Provider<Dio>((ref) {
  final secureStorage = ref.read(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://interview.test.egundem.com/',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final apiKey = dotenv.env['API_KEY'];
        if (apiKey != null && apiKey.isNotEmpty) {
          options.headers['x-api-key'] = apiKey;
        }

        final accessToken = await secureStorage.read(key: 'accessToken');

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
          await secureStorage.delete(key: 'accessToken');
        }

        handler.next(e);
      },
    ),
  );

  return dio;
});
