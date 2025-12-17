import 'package:equatable/equatable.dart';
import 'package:flutter_news_app/data/model/category_with_news_model.dart';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home state class - manages news tabs
class HomeState extends Equatable {
  final NewsTabState latestTab;
  final NewsTabState forYouTab;

  const HomeState({
    this.latestTab = const NewsTabState(),
    this.forYouTab = const NewsTabState(),
  });

  HomeState copyWith({
    NewsTabState? latestTab,
    NewsTabState? forYouTab,
  }) {
    return HomeState(
      latestTab: latestTab ?? this.latestTab,
      forYouTab: forYouTab ?? this.forYouTab,
    );
  }

  @override
  List<Object?> get props => [latestTab, forYouTab];
}

/// News tab state - represents a single tab's data (Latest or For You)
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

/// Extension for updating news saved status in NewsTabState
extension NewsTabStateExtensions on NewsTabState {
  /// Update isSaved status for a specific news in this tab
  NewsTabState withUpdatedNewsStatus(String newsId, bool isSaved) {
    // Update news if it has data
    AsyncValue<List<NewsModel>>? updatedNews;
    news.whenData((newsList) {
      updatedNews = AsyncValue.data(_updateNewsList(newsList, newsId, isSaved));
    });

    // Update categoryNews if it has data
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

  /// Update isSaved status in a news list
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

  /// Update isSaved status in categories with news
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

/// Extension for updating news saved status in HomeState
extension HomeStateExtensions on HomeState {
  /// Update isSaved status for a specific news across both tabs
  HomeState withUpdatedNewsStatus(String newsId, bool isSaved) {
    return copyWith(
      latestTab: latestTab.withUpdatedNewsStatus(newsId, isSaved),
      forYouTab: forYouTab.withUpdatedNewsStatus(newsId, isSaved),
    );
  }
}
