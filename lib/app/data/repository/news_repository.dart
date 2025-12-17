import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/data/data_source/local/news_cache_service.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/app/data/data_source/remote/news_service.dart';
import 'package:flutter_news_app/app/data/model/category_with_news_model.dart';
import 'package:flutter_news_app/app/data/model/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// NEWS REPOSITORY PROVIDER
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    newsService: ref.read(newsServiceProvider),
    networkInfo: ref.read(networkInfoProvider),
    cacheService: ref.read(popularNewsCacheServiceProvider),
  );
});

/// NEWS REPOSITORY INTERFACE
abstract class NewsRepository {
  /// FETCH NEWS WITH OPTIONAL FILTERS AND CACHE SUPPORT
  Future<Either<Failure, List<NewsModel>>> fetchNews({
    bool? isLatest,
    bool? forYou,
    bool forceRefresh = false,
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

/// NEWS REPOSITORY IMPLEMENTATION
class NewsRepositoryImpl implements NewsRepository {
  final NewsService _newsService;
  final INetworkInfo _networkInfo;
  final NewsCacheService _cacheService;

  NewsRepositoryImpl({
    required NewsService newsService,
    required INetworkInfo networkInfo,
    required NewsCacheService cacheService,
  }) : _newsService = newsService,
       _networkInfo = networkInfo,
       _cacheService = cacheService;

  @override
  Future<Either<Failure, List<NewsModel>>> fetchNews({
    bool? isLatest,
    bool? forYou,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cacheResult = await _cacheService.getPopularNews();
      if (cacheResult != null && cacheResult.isNotEmpty) {
        return Right(cacheResult);
      }
    }
    if (!await _networkInfo.currentConnectivityResult) {
      final cacheResult = await _cacheService.getPopularNews();
      if (cacheResult != null && cacheResult.isNotEmpty) {
        return Right(cacheResult);
      }
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    final result = await _newsService.fetchNews(
      isLatest: isLatest,
      forYou: forYou,
    );
    return result.fold(
      (failure) async {
        final cacheResult = await _cacheService.getPopularNews();
        if (cacheResult != null && cacheResult.isNotEmpty) {
          return Right(cacheResult);
        }
        return Left(failure);
      },
      (newsList) async {
        if (newsList.isNotEmpty) {
          await _cacheService.savePopularNews(newsList);
        }

        return Right(newsList);
      },
    );
  }

  @override
  Future<Either<Failure, List<NewsModel>>> fetchNewsByCategory({
    required String categoryId,
    int? page,
    int? pageSize,
  }) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    final result = await _newsService.fetchNewsByCategory(
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
    );
    return result.fold(
      (failure) => Left(failure),
      (newsList) => Right(newsList),
    );
  }

  @override
  Future<Either<Failure, List<CategoryWithNewsModel>>> fetchCategoriesWithNews({
    int? page,
    int? pageSize,
    bool? isLatest,
    bool? forYou,
  }) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    final result = await _newsService.fetchCategoriesWithNews(
      page: page,
      pageSize: pageSize,
      isLatest: isLatest,
      forYou: forYou,
    );
    return result.fold(
      (failure) => Left(failure),
      (categoriesWithNews) => Right(categoriesWithNews),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> saveNews({
    required String newsId,
  }) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _newsService.saveNews(newsId: newsId);
  }

  @override
  Future<Either<Failure, void>> deleteSavedNews({
    required String savedNewsId,
  }) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _newsService.deleteSavedNews(savedNewsId: savedNewsId);
  }
}
