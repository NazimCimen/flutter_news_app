import 'package:flutter_news_app/data/repository/news_repository.dart';
import 'package:flutter_news_app/feature/home/view_model/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// HOME VIEW MODEL PROVIDER
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((
  ref,
) {
  return HomeViewModel(newsRepository: ref.read(newsRepositoryProvider));
});

/// HOME VIEW MODEL
class HomeViewModel extends StateNotifier<HomeState> {
  final NewsRepository _newsRepository;

  HomeViewModel({required NewsRepository newsRepository})
    : _newsRepository = newsRepository,
      super(const HomeState()) {
    fetchLastNews();
    fetchPersonalizedNews();
  }

  /// FETCH LATEST NEWS
  Future<void> fetchLastNews({bool forceRefresh = false}) async {
    state = state.copyWith(
      latestTab: state.latestTab.copyWith(news: const AsyncValue.loading()),
    );

    final result = await _newsRepository.fetchNews(
      forYou: false,
      isLatest: true,
      forceRefresh: forceRefresh,
    );

    await result.fold(
      (failure) {
        state = state.copyWith(
          latestTab: state.latestTab.copyWith(
            news: AsyncValue.error(failure.errorMessage, StackTrace.current),
          ),
        );
      },
      (news) async {
        final result = await _newsRepository.fetchCategoriesWithNews(
          pageSize: 2,
          isLatest: true,
          forYou: false,
        );
        result.fold(
          (failure) {
            return;
          },
          (categoriesWithNews) {
            state = state.copyWith(
              latestTab: state.latestTab.copyWith(
                news: AsyncValue.data(news),
                categoryNews: AsyncValue.data(categoriesWithNews),
              ),
            );
          },
        );
      },
    );
  }

  /// FETCH PERSONALIZED NEWS (FOR YOU)
  Future<void> fetchPersonalizedNews({bool forceRefresh = false}) async {
    state = state.copyWith(
      forYouTab: state.forYouTab.copyWith(news: const AsyncValue.loading()),
    );

    final result = await _newsRepository.fetchNews(
      forYou: true,
      isLatest: true,
      forceRefresh: forceRefresh,
    );

    await result.fold(
      (failure) {
        state = state.copyWith(
          forYouTab: state.forYouTab.copyWith(
            news: AsyncValue.error(failure.errorMessage, StackTrace.current),
          ),
        );
      },
      (news) async {
        final result = await _newsRepository.fetchCategoriesWithNews(
          pageSize: 2,
          isLatest: true,
          forYou: true,
        );
        result.fold(
          (failure) {
            return;
          },
          (categoriesWithNews) {
            state = state.copyWith(
              forYouTab: state.forYouTab.copyWith(
                news: AsyncValue.data(news),
                categoryNews: AsyncValue.data(categoriesWithNews),
              ),
            );
          },
        );
      },
    );
  }

  /// TOGGLE SAVE BUTTON
  Future<void> toogleSaveButton({
    required String newsId,
    required bool currentStatus,
  }) async {
    state = state.withUpdatedNewsStatus(newsId, !currentStatus);

    if (currentStatus) {
      final result = await _newsRepository.deleteSavedNews(savedNewsId: newsId);
      result.fold(
        (failure) => state = state.withUpdatedNewsStatus(newsId, currentStatus),
        (_) {},
      );
    } else {
      final result = await _newsRepository.saveNews(newsId: newsId);
      result.fold(
        (failure) => state = state.withUpdatedNewsStatus(newsId, currentStatus),
        (_) {},
      );
    }
  }

  Future<void> latestPopularNews() async {
    await fetchLastNews(forceRefresh: true);
  }

  Future<void> refreshPersonalizedNews() async {
    await fetchPersonalizedNews(forceRefresh: true);
  }
}
