import 'package:flutter_news_app/app/data/model/news_model.dart';
import 'package:flutter_news_app/app/data/repository/news_repository.dart';
import 'package:flutter_news_app/app/common/helpers/date_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// PROVIDER FOR CATEGORY NEWS VIEW MODEL
final categoryNewsViewModelProvider =
    StateNotifierProvider.family<
      CategoryNewsViewModelBase,
      PagingState<int, NewsModel>,
      String
    >((ref, categoryId) {
      return CategoryNewsViewModel(
        categoryId: categoryId,
        newsRepository: ref.read(newsRepositoryProvider),
      );
    });

/// CATEGORY NEWS VIEW MODEL BASE - ABSTRACT CLASS FOR PAGINATION
abstract class CategoryNewsViewModelBase extends StateNotifier<PagingState<int, NewsModel>> {
  CategoryNewsViewModelBase() : super(PagingState<int, NewsModel>());

  /// FETCH NEXT PAGE OF NEWS
  Future<void> fetchNextPage();

  /// REFRESH NEWS (RESET AND FETCH FIRST PAGE)
  Future<void> refresh();

  /// TOGGLE SAVE BUTTON (OPTIMISTIC UI UPDATE)
  Future<void> toogleSaveButton({
    required String newsId,
    required bool currentStatus,
  });
}

/// VIEWMODEL FOR CATEGORY NEWS WITH PAGINATION
class CategoryNewsViewModel extends CategoryNewsViewModelBase {
  final String categoryId;
  final NewsRepository _newsRepository;

  CategoryNewsViewModel({
    required this.categoryId,
    required NewsRepository newsRepository,
  }) : _newsRepository = newsRepository;

  @override
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
        final formattedItems = DateFormatter.formatNewsDates(newItems);
        final isLastPage = formattedItems.length < 10;
        state = state.copyWith(
          pages: [...?state.pages, formattedItems],
          keys: [...?state.keys, newKey],
          hasNextPage: !isLastPage,
          isLoading: false,
        );
      },
    );
  }

  @override
  Future<void> refresh() async {
    state = PagingState<int, NewsModel>();
    await fetchNextPage();
  }

  @override
  Future<void> toogleSaveButton({
    required String newsId,
    required bool currentStatus,
  }) async {
    _updateNewsInState(newsId, !currentStatus);
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

  /// UPDATE NEWS IN STATE
  void _updateNewsInState(String newsId, bool isSaved) {
    if (state.pages == null || state.pages!.isEmpty) return;
    final updatedPages = state.pages!
        .map((page) => _updatePageNewsSavedStatus(page, newsId, isSaved))
        .toList();

    state = state.copyWith(pages: updatedPages);
  }

  /// UPDATE IS SAVED STATUS FOR A SINGLE PAGE OF NEWS
  List<NewsModel> _updatePageNewsSavedStatus(
    List<NewsModel> page,
    String newsId,
    bool isSaved,
  ) {
    return page
        .map(
          (news) => news.id == newsId ? news.copyWith(isSaved: isSaved) : news,
        )
        .toList();
  }
}
