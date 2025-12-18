import 'package:dio/dio.dart';
import 'package:flutter_news_app/app/data/data_source/local/auth_local_service.dart';
import 'package:flutter_news_app/core/network/api_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// THIS PROVIDER IS USED TO GET THE DIO.
final dioProvider = Provider<Dio>((ref) {
  final authLocalService = ref.read(authLocalServiceProvider);

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

        final accessToken = await authLocalService.getAccessToken();
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
          await authLocalService.clear();
        }
        handler.next(e);
      },
    ),
  );

  return dio;
});
