import 'package:flutter_news_app/app/data/model/tweet_model.dart';
import 'package:flutter_news_app/app/data/repository/twitter_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// TWITTER VIEW MODEL PROVIDER WITH FAMILY (POPULAR/FOR YOU)
final twitterViewModelProvider =
    StateNotifierProvider.family<
      TwitterViewModelBase,
      PagingState<int, TweetModel>,
      bool
    >((ref, isPopular) {
      return TwitterViewModel(
        isPopular: isPopular,
        twitterRepository: ref.read(twitterRepositoryProvider),
      );
    });

/// TWITTER VIEW MODEL BASE - ABSTRACT CLASS FOR PAGINATION
abstract class TwitterViewModelBase extends StateNotifier<PagingState<int, TweetModel>> {
  TwitterViewModelBase() : super(PagingState<int, TweetModel>());

  /// FETCH NEXT PAGE OF TWEETS
  Future<void> fetchNextPage();

  /// REFRESH TWEETS (RESET AND FETCH FIRST PAGE)
  Future<void> refresh();
}

/// TWITTER VIEW MODEL WITH PAGINATION
class TwitterViewModel extends TwitterViewModelBase {
  final bool isPopular;
  final TwitterRepository _twitterRepository;

  TwitterViewModel({
    required this.isPopular,
    required TwitterRepository twitterRepository,
  }) : _twitterRepository = twitterRepository;

  @override
  Future<void> fetchNextPage() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);
    final newKey = (state.keys?.lastOrNull ?? 0) + 1;

    final result = await _twitterRepository.fetchTweets(
      isPopular: isPopular,
      page: newKey,
      pageSize: 20,
    );

    result.fold(
      (failure) {
        state = state.copyWith(error: failure.errorMessage, isLoading: false);
      },
      (newItems) {
        final isLastPage = newItems.length < 20;
        state = state.copyWith(
          pages: [...?state.pages, newItems],
          keys: [...?state.keys, newKey],
          hasNextPage: !isLastPage,
          isLoading: false,
        );
      },
    );
  }

  @override
  Future<void> refresh() async {
    state = PagingState<int, TweetModel>();
    await fetchNextPage();
  }
}
