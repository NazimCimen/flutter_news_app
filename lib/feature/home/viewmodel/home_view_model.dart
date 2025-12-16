import 'package:flutter_news_app/data/repository/news_repository.dart';
import 'package:flutter_news_app/feature/home/viewmodel/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Main home provider
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((
  ref,
) {
  return HomeViewModel(newsRepository: ref.read(newsRepositoryProvider));
});

/// Home ViewModel
class HomeViewModel extends StateNotifier<HomeState> {
  final NewsRepository _newsRepository;

  HomeViewModel({required NewsRepository newsRepository})
      : _newsRepository = newsRepository,
        super(const HomeState()) {
    fetchLastNews();
    fetchPersonalizedNews();
  }

  /// Fetch latest news
  Future<void> fetchLastNews() async {
    state = state.copyWith(
      latestTab: state.latestTab.copyWith(news: const AsyncValue.loading()),
    );

    final result = await _newsRepository.fetchNews(
      forYou: false,
      isLatest: true,
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

  /// Fetch personalized news (For You)
  Future<void> fetchPersonalizedNews() async {
    state = state.copyWith(
      forYouTab: state.forYouTab.copyWith(news: const AsyncValue.loading()),
    );

    final result = await _newsRepository.fetchNews(
      forYou: true,
      isLatest: true,
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

  /// Refresh popular news
  Future<void> latestPopularNews() async {
    await fetchLastNews();
  }

  /// Refresh personalized news
  Future<void> refreshPersonalizedNews() async {
    await fetchPersonalizedNews();
  }
}
