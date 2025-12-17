import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/api_constants.dart';
import 'package:flutter_news_app/core/network/dio_error_extension.dart';
import 'package:flutter_news_app/core/network/dio_interceptor.dart';
import 'package:flutter_news_app/data/model/tweet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TWITTER SERVICE PROVIDER
final twitterServiceProvider = Provider<TwitterService>((ref) {
  return TwitterServiceImpl(dio: ref.read(dioProvider));
});

/// TWITTER SERVICE INTERFACE
abstract class TwitterService {

  /// FETCH PAGINATED TWEETS
  Future<Either<Failure, List<TweetModel>>> fetchTweets({
    int? page,
    int? pageSize,
    bool? isPopular,
  });
}

/// TWITTER SERVICE IMPLEMENTATION
class TwitterServiceImpl implements TwitterService {
  final Dio _dio;

  TwitterServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Either<Failure, List<TweetModel>>> fetchTweets({
    int? page,
    int? pageSize,
    bool? isPopular,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (page != null) queryParameters['page'] = page;
      if (pageSize != null) queryParameters['pageSize'] = pageSize;
      if (isPopular != null) queryParameters['isPopular'] = isPopular;

      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.tweets,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      final data = response.data;
      if (data == null ||
          data['result'] == null ||
          data['result']['items'] == null) {
        return const Right([]);
      }

      final tweets = (data['result']['items'] as List)
          .map((e) => TweetModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(tweets);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }
}
