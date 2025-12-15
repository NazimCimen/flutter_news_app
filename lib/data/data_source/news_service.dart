import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/api_constants.dart';
import 'package:flutter_news_app/core/network/dio_interceptor.dart';
import 'package:flutter_news_app/core/network/dio_error_extension.dart';
import 'package:flutter_news_app/core/utils/json_utils.dart';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsServiceImpl(dio: ref.read(dioProvider));
});

abstract class NewsService {
  /// FETCH NEWS
  Future<Either<Failure, List<NewsModel>>> fetchNews({
    bool? isLatest,
    bool? forYou,
  });

  /// FETCH NEWS BY CATEGORY
  Future<Either<Failure, List<NewsModel>>> fetchNewsByCategory({
    required String categoryId,
    int? page,
    int? pageSize,
  });
}

class NewsServiceImpl implements NewsService {
  final Dio _dio;

  NewsServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Either<Failure, List<NewsModel>>> fetchNews({
    bool? isLatest,
    bool? forYou,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (isLatest != null) {
        queryParameters['isLatest'] = isLatest;
      }

      if (forYou != null) {
        queryParameters['forYou'] = forYou;
      }

      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.news,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      final data = response.data;
      if (data == null ||
          data['result'] == null ||
          data['result']['items'] == null) {
        return const Right([]);
      }

      final news = (data['result']['items'] as List)
          .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(news);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<NewsModel>>> fetchNewsByCategory({
    required String categoryId,
    int? page,
    int? pageSize,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (page != null) {
        queryParameters['page'] = page;
      }

      if (pageSize != null) {
        queryParameters['pageSize'] = pageSize;
      }

      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.news}/category/$categoryId',
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      final data = response.data;
      if (data == null ||
          data['result'] == null ||
          data['result']['items'] == null) {
        return const Right([]);
      }

      final news = (data['result']['items'] as List)
          .map(
            (e) => NewsModel.fromJson(
              JsonUtils.removeUnderscores(e as Map<String, dynamic>),
            ),
          )
          .toList();

      return Right(news);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }
}
