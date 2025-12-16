import 'package:flutter_news_app/data/model/tweet_model.dart';
import 'package:flutter_news_app/data/repository/twitter_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Provider for TwitterViewModel
final twitterViewModelProvider = StateNotifierProvider.family<
    TwitterViewModel,
    PagingState<int, TweetModel>,
    bool>((ref, isPopular) {
  return TwitterViewModel(
    isPopular: isPopular,
    twitterRepository: ref.read(twitterRepositoryProvider),
  );
});

/// ViewModel for Twitter with pagination
class TwitterViewModel extends StateNotifier<PagingState<int, TweetModel>> {
  final bool isPopular;
  final TwitterRepository _twitterRepository;

  TwitterViewModel({
    required this.isPopular,
    required TwitterRepository twitterRepository,
  })  : _twitterRepository = twitterRepository,
        super(PagingState<int, TweetModel>());

  /// FETCH PAGED TWEETS
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

  /// REFRESH PAGE
  Future<void> refresh() async {
    state = PagingState<int, TweetModel>();
    await fetchNextPage();
  }
}
