import 'package:equatable/equatable.dart';
import 'package:flutter_news_app/app/data/model/category_model.dart';
import 'package:flutter_news_app/app/data/model/news_model.dart';

/// Wrapper model for categories with their news
/// Used for /api/v1/categories/with-news endpoint
class CategoryWithNewsModel extends Equatable {
  final CategoryModel category;
  final List<NewsModel> news;

  const CategoryWithNewsModel({required this.category, required this.news});

  factory CategoryWithNewsModel.fromJson(Map<String, dynamic> json) {
    return CategoryWithNewsModel(
      category: CategoryModel.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      news: (json['news'] as List)
          .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [category, news];
}
