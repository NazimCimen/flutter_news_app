import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_news_app/data/repository/news_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Provider for CategoryNewsViewModel
final categoryNewsViewModelProvider =
    StateNotifierProvider.family<
      CategoryNewsViewModel,
      PagingState<int, NewsModel>,
      String
    >((ref, categoryId) {
      return CategoryNewsViewModel(
        categoryId: categoryId,
        newsRepository: ref.read(newsRepositoryProvider),
      );
    });

/// ViewModel for Category News with pagination
class CategoryNewsViewModel extends StateNotifier<PagingState<int, NewsModel>> {
  final String categoryId;
  final NewsRepository _newsRepository;

  CategoryNewsViewModel({
    required this.categoryId,
    required NewsRepository newsRepository,
  }) : _newsRepository = newsRepository,
       super(PagingState<int, NewsModel>());

  /// FETCH PAGED NEWS
  Future<void> fetchNextPage() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);
    final newKey = (state.keys?.lastOrNull ?? 0) + 1;
    final result = await _newsRepository.fetchNewsByCategory(
      categoryId: categoryId,
      page: newKey,
      pageSize: 20,
    );

    result.fold(
      (failure) {
        state = state.copyWith(error: failure.errorMessage, isLoading: false);
      },
      (newItems) {
        final isLastPage = newItems.length < 10;
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
    state = PagingState<int, NewsModel>();
    await fetchNextPage();
  }

  /// TOGGLE SAVE BUTTON (Optimistic UI Update)
  Future<void> toogleSaveButton({
    required String newsId,
    required bool currentStatus,
  }) async {
    // 1. Önce UI'ı güncelle (Optimistic Update)
    _updateNewsInState(newsId, !currentStatus);

    // 2. Arka planda API çağrısı yap
    if (currentStatus) {
      final result = await _newsRepository.deleteSavedNews(savedNewsId: newsId);
      result.fold(
        (failure) => _updateNewsInState(newsId, currentStatus),
        (_) {},
      );
    } else {
      final result = await _newsRepository.saveNews(newsId: newsId);
      result.fold(
        (failure) => _updateNewsInState(newsId, currentStatus),
        (_) {},
      );
    }
  }

  /// Update news isSaved status in current state
  void _updateNewsInState(String newsId, bool isSaved) {
    if (state.pages == null || state.pages!.isEmpty) return;

    final updatedPages = state.pages!
        .map((page) => _updatePageNewsSavedStatus(page, newsId, isSaved))
        .toList();

    state = state.copyWith(pages: updatedPages);
  }

  /// Update isSaved status for a single page of news
  List<NewsModel> _updatePageNewsSavedStatus(
    List<NewsModel> page,
    String newsId,
    bool isSaved,
  ) {
    return page
        .map((news) => news.id == newsId ? news.copyWith(isSaved: isSaved) : news)
        .toList();
  }
}
