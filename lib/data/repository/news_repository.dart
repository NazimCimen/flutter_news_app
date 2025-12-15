import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/network_info.dart';
import 'package:flutter_news_app/data/data_source/news_service.dart';
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
}

class NewsRepositoryImpl implements NewsRepository {
  final NewsService _newsService;
  final INetworkInfo _networkInfo;

  NewsRepositoryImpl({
    required NewsService newsService,
    required INetworkInfo networkInfo,
  })  : _newsService = newsService,
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
    return _newsService.fetchNews(isLatest: isLatest, forYou: forYou);
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
    return _newsService.fetchNewsByCategory(
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
    );
  }
}
