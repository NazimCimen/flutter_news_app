import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_news_app/data/repository/news_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// News fetch type enum
enum NewsType { popular, personalized, category }

/// Provider for popular news (Son Haberler)
final popularNewsProvider =
    StateNotifierProvider<NewsViewModel, AsyncValue<List<NewsModel>>>((ref) {
  return NewsViewModel(
    newsRepository: ref.read(newsRepositoryProvider),
    newsType: NewsType.popular,
  );
});

/// Provider for personalized news (Sana Özel)
final personalizedNewsProvider =
    StateNotifierProvider<NewsViewModel, AsyncValue<List<NewsModel>>>((ref) {
  return NewsViewModel(
    newsRepository: ref.read(newsRepositoryProvider),
    newsType: NewsType.personalized,
  );
});

/// Provider family for category news
/// Her kategori için ayrı instance oluşturur
final categoryNewsProvider = StateNotifierProvider.family<NewsViewModel,
    AsyncValue<List<NewsModel>>, String>((ref, categoryId) {
  return NewsViewModel(
    newsRepository: ref.read(newsRepositoryProvider),
    newsType: NewsType.category,
    categoryId: categoryId,
    pageSize: 2, // Kategori preview için sadece 2 haber
  );
});

/// Single unified ViewModel for all news types
/// Tüm haber tipleri için tek ViewModel kullanıyoruz
class NewsViewModel extends StateNotifier<AsyncValue<List<NewsModel>>> {
  final NewsRepository _newsRepository;
  final NewsType _newsType;
  final String? _categoryId;
  final int? _pageSize;

  NewsViewModel({
    required NewsRepository newsRepository,
    required NewsType newsType,
    String? categoryId,
    int? pageSize,
  })  : _newsRepository = newsRepository,
        _newsType = newsType,
        _categoryId = categoryId,
        _pageSize = pageSize,
        super(const AsyncValue.loading()) {
    fetchNews();
  }

  /// Fetch news based on type
  Future<void> fetchNews() async {
    state = const AsyncValue.loading();

    final result = switch (_newsType) {
      NewsType.popular => await _newsRepository.fetchNews(),
      NewsType.personalized => await _newsRepository.fetchNews(forYou: true),
      NewsType.category => await _newsRepository.fetchNewsByCategory(
          categoryId: _categoryId!,
          pageSize: _pageSize,
        ),
    };

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.errorMessage, StackTrace.current);
      },
      (news) {
        state = AsyncValue.data(news);
      },
    );
  }

  /// Refresh news
  Future<void> refresh() async {
    await fetchNews();
  }
}
