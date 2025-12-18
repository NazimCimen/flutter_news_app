import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/api_constants.dart';
import 'package:flutter_news_app/core/network/dio_interceptor.dart';
import 'package:flutter_news_app/core/network/dio_error_extension.dart';
import 'package:flutter_news_app/core/utils/json_utils.dart';
import 'package:flutter_news_app/app/data/model/category_with_news_model.dart';
import 'package:flutter_news_app/app/data/model/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// NEWS SERVICE PROVIDER
final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsServiceImpl(dio: ref.read(dioProvider));
});

abstract class NewsService {
  /// FETCH NEWS WITH OPTIONAL FILTERS
  Future<Either<Failure, List<NewsModel>>> fetchNews({
    bool? isLatest,
    bool? forYou,
  });

  /// FETCH NEWS FILTERED BY CATEGORY WITH PAGINATION
  Future<Either<Failure, List<NewsModel>>> fetchNewsByCategory({
    required String categoryId,
    int? page,
    int? pageSize,
  });

  /// FETCH CATEGORIES WITH THEIR ASSOCIATED NEWS
  Future<Either<Failure, List<CategoryWithNewsModel>>> fetchCategoriesWithNews({
    int? page,
    int? pageSize,
    bool? isLatest,
    bool? forYou,
  });

  /// SAVE NEWS ARTICLE TO USER'S SAVED LIST
  Future<Either<Failure, Map<String, dynamic>>> saveNews({
    required String newsId,
  });

  /// REMOVE NEWS ARTICLE FROM USER'S SAVED LIST
  Future<Either<Failure, void>> deleteSavedNews({required String savedNewsId});
}

/// NEWS SERVICE IMPLEMENTATION
class NewsServiceImpl implements NewsService {
  final Dio _dio;

  NewsServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Either<Failure, List<NewsModel>>> fetchNews({
    bool? isLatest,
    bool? forYou,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'isLatest': isLatest,
        'forYou': forYou,
      }..removeWhere((_, value) => value == null);

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
      final queryParameters = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      }..removeWhere((_, value) => value == null);

      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.newsByCategory}/$categoryId',
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      final data = response.data;
      if (data == null ||
          data['result'] == null ||
          data['result']['items'] == null) {
        return const Right([]);
      }

      final news = (data['result']['items'] as List).map((e) {
        final jsonData = JsonUtils.removeUnderscores(e as Map<String, dynamic>);
        return NewsModel.fromJson(jsonData);
      }).toList();

      return Right(news);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryWithNewsModel>>> fetchCategoriesWithNews({
    int? page,
    int? pageSize,
    bool? isLatest,
    bool? forYou,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
        'isLatest': isLatest,
        'forYou': forYou,
      }..removeWhere((_, value) => value == null);

      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.categoriesWithNews,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      final data = response.data;
      if (data == null ||
          data['result'] == null ||
          data['result']['items'] == null) {
        return const Right([]);
      }

      final categoriesWithNews = (data['result']['items'] as List).map((item) {
        final categoryData = item['category'] as Map<String, dynamic>;
        final newsList = item['news'] as List;

        return CategoryWithNewsModel.fromJson({
          'category': categoryData,
          'news': newsList,
        });
      }).toList();

      return Right(categoriesWithNews);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> saveNews({
    required String newsId,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.savedNews,
        data: {'newsId': newsId},
      );

      final data = response.data;
      if (data == null || data['result'] == null) {
        return Left(
          ServerFailure(errorMessage: 'Invalid response from server'),
        );
      }

      return Right(data['result'] as Map<String, dynamic>);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavedNews({
    required String savedNewsId,
  }) async {
    try {
      await _dio.delete<void>(
        '${ApiConstants.savedNews}/$savedNewsId',
      );

      return const Right(null);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }
}
