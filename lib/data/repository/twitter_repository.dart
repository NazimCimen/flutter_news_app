import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/core/utils/time_utils.dart';
import 'package:flutter_news_app/data/data_source/remote/twitter_service.dart';
import 'package:flutter_news_app/data/model/tweet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TWITTER REPOSITORY PROVIDER
final twitterRepositoryProvider = Provider<TwitterRepository>((ref) {
  return TwitterRepositoryImpl(
    twitterService: ref.read(twitterServiceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

/// TWITTER REPOSITORY INTERFACE
abstract class TwitterRepository {

  /// FETCH PAGINATED TWEETS
  Future<Either<Failure, List<TweetModel>>> fetchTweets({
    int? page,
    int? pageSize,
    bool? isPopular,
  });
}

/// TWITTER REPOSITORY IMPLEMENTATION
class TwitterRepositoryImpl implements TwitterRepository {
  final TwitterService _twitterService;
  final INetworkInfo _networkInfo;

  TwitterRepositoryImpl({
    required TwitterService twitterService,
    required INetworkInfo networkInfo,
  })  : _twitterService = twitterService,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<TweetModel>>> fetchTweets({
    int? page,
    int? pageSize,
    bool? isPopular,
  }) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    final result = await _twitterService.fetchTweets(
      page: page,
      pageSize: pageSize,
      isPopular: isPopular,
    );
    return result.fold(
      (failure) => Left(failure),
      (tweets) {
        final formattedTweets = tweets
            .map((tweet) => tweet.copyWith(
                  createdAt: TimeUtils.formatTimeAgo(tweet.createdAt),
                ))
            .toList();
        return Right(formattedTweets);
      },
    );
  }
}
