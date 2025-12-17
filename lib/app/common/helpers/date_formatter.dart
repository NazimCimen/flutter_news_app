import 'package:flutter_news_app/app/data/model/category_with_news_model.dart';
import 'package:flutter_news_app/app/data/model/news_model.dart';
import 'package:flutter_news_app/core/utils/time_utils.dart';

/// DATE FORMATTER FOR NEWS DATA
/// Provides utility methods to format dates in news models for presentation
class DateFormatter {
  const DateFormatter._();

  /// FORMAT NEWS DATES FOR PRESENTATION
  /// Takes a list of NewsModel and returns a new list with formatted dates
  static List<NewsModel> formatNewsDates(List<NewsModel> newsList) {
    return newsList.map((news) {
      return news.copyWith(
        publishedAt: TimeUtils.formatNewsDate(news.publishedAt),
      );
    }).toList();
  }

  /// FORMAT CATEGORY NEWS DATES FOR PRESENTATION
  /// Takes a list of CategoryWithNewsModel and returns a new list with formatted dates
  /// for all nested news items
  static List<CategoryWithNewsModel> formatCategoryNewsDates(
    List<CategoryWithNewsModel> categories,
  ) {
    return categories.map((category) {
      return CategoryWithNewsModel(
        category: category.category,
        news: formatNewsDates(category.news),
      );
    }).toList();
  }
}
