import 'package:equatable/equatable.dart';
import 'package:flutter_news_app/app/data/model/category_with_news_model.dart';
import 'package:flutter_news_app/app/data/model/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// HOME STATE CLASS - MANAGES NEWS TABS
class HomeState extends Equatable {
  final NewsTabState latestTab;
  final NewsTabState forYouTab;

  const HomeState({
    this.latestTab = const NewsTabState(),
    this.forYouTab = const NewsTabState(),
  });

  HomeState copyWith({NewsTabState? latestTab, NewsTabState? forYouTab}) {
    return HomeState(
      latestTab: latestTab ?? this.latestTab,
      forYouTab: forYouTab ?? this.forYouTab,
    );
  }

  @override
  List<Object?> get props => [latestTab, forYouTab];
}

/// NEWS TAB STATE - REPRESENTS A SINGLE TAB'S DATA (LATEST OR FOR YOU)
class NewsTabState extends Equatable {
  final AsyncValue<List<NewsModel>> news;
  final AsyncValue<List<CategoryWithNewsModel>> categoryNews;

  const NewsTabState({
    this.news = const AsyncValue.loading(),
    this.categoryNews = const AsyncValue.loading(),
  });

  NewsTabState copyWith({
    AsyncValue<List<NewsModel>>? news,
    AsyncValue<List<CategoryWithNewsModel>>? categoryNews,
  }) {
    return NewsTabState(
      news: news ?? this.news,
      categoryNews: categoryNews ?? this.categoryNews,
    );
  }

  @override
  List<Object?> get props => [news, categoryNews];
}

/// EXTENSION FOR UPDATING NEWS SAVED STATUS IN NEWSTABSTATE
extension NewsTabStateExtensions on NewsTabState {
  /// UPDATE ISSAVED STATUS FOR A SPECIFIC NEWS IN THIS TAB
  NewsTabState withUpdatedNewsStatus(String newsId, bool isSaved) {
    /// UPDATE NEWS IF IT HAS DATA
    AsyncValue<List<NewsModel>>? updatedNews;
    news.whenData((newsList) {
      updatedNews = AsyncValue.data(_updateNewsList(newsList, newsId, isSaved));
    });

    /// UPDATE CATEGORYNEWS IF IT HAS DATA
    AsyncValue<List<CategoryWithNewsModel>>? updatedCategoryNews;
    categoryNews.whenData((categories) {
      updatedCategoryNews = AsyncValue.data(
        _updateCategoriesList(categories, newsId, isSaved),
      );
    });

    return copyWith(
      news: updatedNews ?? news,
      categoryNews: updatedCategoryNews ?? categoryNews,
    );
  }

  /// UPDATE ISSAVED STATUS IN A NEWS LIST
  List<NewsModel> _updateNewsList(
    List<NewsModel> newsList,
    String newsId,
    bool isSaved,
  ) {
    return newsList
        .map(
          (news) => news.id == newsId ? news.copyWith(isSaved: isSaved) : news,
        )
        .toList();
  }

  /// UPDATE ISSAVED STATUS IN CATEGORIES WITH NEWS
  List<CategoryWithNewsModel> _updateCategoriesList(
    List<CategoryWithNewsModel> categories,
    String newsId,
    bool isSaved,
  ) {
    return categories
        .map(
          (category) => CategoryWithNewsModel(
            category: category.category,
            news: _updateNewsList(category.news, newsId, isSaved),
          ),
        )
        .toList();
  }
}

/// EXTENSION FOR UPDATING NEWS SAVED STATUS IN HOMESTATE
extension HomeStateExtensions on HomeState {
  /// UPDATE ISSAVED STATUS FOR A SPECIFIC NEWS ACROSS BOTH TABS
  HomeState withUpdatedNewsStatus(String newsId, bool isSaved) {
    return copyWith(
      latestTab: latestTab.withUpdatedNewsStatus(newsId, isSaved),
      forYouTab: forYouTab.withUpdatedNewsStatus(newsId, isSaved),
    );
  }
}
