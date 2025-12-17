import 'dart:convert';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:hive/hive.dart';

part 'cached_news_data.g.dart';

@HiveType(typeId: 0)
class CachedNewsData extends HiveObject {
  @HiveField(0)
  final List<String> newsJsonList;

  @HiveField(1)
  final int timestamp;

  CachedNewsData({required this.newsJsonList, required this.timestamp});

  /// Convert NewsModel list to CachedNewsData
  factory CachedNewsData.fromNewsList(List<NewsModel> newsList) {
    return CachedNewsData(
      newsJsonList: newsList.map((n) => jsonEncode(n.toJson())).toList(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Convert CachedNewsData to NewsModel list
  /// Throws FormatException if JSON is invalid
  /// Throws TypeError if data structure is incorrect
  List<NewsModel> toNewsList() {
    final result = <NewsModel>[];

    for (final jsonString in newsJsonList) {
      try {
        final decoded = jsonDecode(jsonString);
        if (decoded is! Map<String, dynamic>) {
          throw TypeError();
        }
        result.add(NewsModel.fromJson(decoded));
      } catch (e) {
        // Re-throw to be caught by cache service
        rethrow;
      }
    }

    return result;
  }

  /// Check if cache is expired (> 1 hour)
  bool isExpired() {
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(cacheTime) > const Duration(hours: 1);
  }

  /// Get cache age in minutes
  int getAgeInMinutes() {
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(cacheTime).inMinutes;
  }
}
