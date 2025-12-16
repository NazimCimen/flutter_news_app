import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/network_info.dart';
import 'package:flutter_news_app/core/utils/time_utils.dart';
import 'package:flutter_news_app/data/data_source/news_service.dart';
import 'package:flutter_news_app/data/model/category_with_news_model.dart';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    newsService: ref.read(newsServiceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

abstract class NewsRepository {
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

  /// FETCH CATEGORIES WITH NEWS
  Future<Either<Failure, List<CategoryWithNewsModel>>> fetchCategoriesWithNews({
    int? page,
    int? pageSize,
    bool? isLatest,
    bool? forYou,
  });

  /// SAVE NEWS
  Future<Either<Failure, Map<String, dynamic>>> saveNews({
    required String newsId,
  });

  /// GET SAVED NEWS LIST
  Future<Either<Failure, List<Map<String, dynamic>>>> getSavedNewsList();

  /// DELETE SAVED NEWS
  Future<Either<Failure, void>> deleteSavedNews({
    required String savedNewsId,
  });
}

class NewsRepositoryImpl implements NewsRepository {
  final NewsService _newsService;
  final INetworkInfo _networkInfo;

  NewsRepositoryImpl({
    required NewsService newsService,
    required INetworkInfo networkInfo,
  }) : _newsService = newsService,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<NewsModel>>> fetchNews({
    bool? isLatest,
    bool? forYou,
  }) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    final result = await _newsService.fetchNews(
      isLatest: isLatest,
      forYou: forYou,
    );

    return result.fold((failure) => Left(failure), (newsList) {
      final formattedNews = newsList.map((news) {
        return news.copyWith(
          publishedAt: TimeUtils.formatNewsDate(news.publishedAt),
        );
      }).toList();
      return Right(formattedNews);
    });
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

    return result.fold((failure) => Left(failure), (newsList) {
      final formattedNews = newsList.map((news) {
        return news.copyWith(
          publishedAt: TimeUtils.formatNewsDate(news.publishedAt),
        );
      }).toList();
      return Right(formattedNews);
    });
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

    return result.fold((failure) => Left(failure), (categoriesWithNews) {
      final formattedCategories = categoriesWithNews.map((categoryWithNews) {
        final formattedNews = categoryWithNews.news.map((news) {
          return news.copyWith(
            publishedAt: TimeUtils.formatNewsDate(news.publishedAt),
          );
        }).toList();

        return CategoryWithNewsModel(
          category: categoryWithNews.category,
          news: formattedNews,
        );
      }).toList();
      return Right(formattedCategories);
    });
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

    return await _newsService.saveNews(newsId: newsId);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getSavedNewsList() async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }

    return await _newsService.getSavedNewsList();
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

    return await _newsService.deleteSavedNews(savedNewsId: savedNewsId);
  }
}
