import 'package:flutter_news_app/app/data/repository/news_repository.dart';
import 'package:flutter_news_app/app/common/helpers/date_formatter.dart';
import 'package:flutter_news_app/feature/home/view_model/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// HOME VIEW MODEL PROVIDER
final homeViewModelProvider = StateNotifierProvider<HomeViewModelBase, HomeState>((
  ref,
) {
  return HomeViewModel(newsRepository: ref.read(newsRepositoryProvider));
});

/// HOME VIEW MODEL BASE - ABSTRACT CLASS FOR HOME STATE MANAGEMENT
abstract class HomeViewModelBase extends StateNotifier<HomeState> {
  HomeViewModelBase() : super(const HomeState());

  /// FETCH LATEST NEWS
  Future<void> fetchLastNews({bool forceRefresh = false});

  /// FETCH PERSONALIZED NEWS (FOR YOU)
  Future<void> fetchPersonalizedNews({bool forceRefresh = false});

  /// TOGGLE SAVE BUTTON (OPTIMISTIC UI UPDATE && ROLLBACK ON FAILURE)
  Future<void> toogleSaveButton({
    required String newsId,
    required bool currentStatus,
  });
}

/// HOME VIEW MODEL
class HomeViewModel extends HomeViewModelBase {
  final NewsRepository _newsRepository;

  HomeViewModel({required NewsRepository newsRepository})
    : _newsRepository = newsRepository,
      super() {
    fetchLastNews();
    fetchPersonalizedNews();
  }

  @override
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
        final formattedNews = DateFormatter.formatNewsDates(news);
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
            final formattedCategoryNews = DateFormatter.formatCategoryNewsDates(
              categoriesWithNews,
            );
            state = state.copyWith(
              latestTab: state.latestTab.copyWith(
                news: AsyncValue.data(formattedNews),
                categoryNews: AsyncValue.data(formattedCategoryNews),
                
              ),
            );
          },
        );
      },
    );
  }

  @override
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
        final formattedNews = DateFormatter.formatNewsDates(news);

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
            final formattedCategoryNews = DateFormatter.formatCategoryNewsDates(
              categoriesWithNews,
            );

            state = state.copyWith(
              forYouTab: state.forYouTab.copyWith(
                news: AsyncValue.data(formattedNews),
                categoryNews: AsyncValue.data(formattedCategoryNews),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Future<void> toogleSaveButton({
    required String newsId,
    required bool currentStatus,
  }) async {
    // OPTIMISTIC UI UPDATE
    state = state.withUpdatedNewsStatus(newsId, !currentStatus);

    if (currentStatus) {
      final result = await _newsRepository.deleteSavedNews(savedNewsId: newsId);
      result.fold(
        // ROLLBACK ON FAILURE
        (failure) => state = state.withUpdatedNewsStatus(newsId, currentStatus),
        (_) {},
      );
    } else {
      final result = await _newsRepository.saveNews(newsId: newsId);
      result.fold(
        // ROLLBACK ON FAILURE
         (failure) => state = state.withUpdatedNewsStatus(newsId, currentStatus),
        (_) {},
      );
    }
  }
}
