import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_news_model.g.dart';

@JsonSerializable()
class SavedNewsModel {
  final String id;
  final String newsId;
  final String savedAt;

  const SavedNewsModel({
    required this.id,
    required this.newsId,
    required this.savedAt,
  });

  factory SavedNewsModel.fromJson(Map<String, dynamic> json) =>
      _$SavedNewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SavedNewsModelToJson(this);

  SavedNewsModel copyWith({
    String? id,
    String? newsId,
    String? savedAt,
  }) {
    return SavedNewsModel(
      id: id ?? this.id,
      newsId: newsId ?? this.newsId,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}

/// Response model for saved news list
@JsonSerializable()
class SavedNewsListItemModel {
  final String id;
  final String newsId;
  final String savedAt;

  const SavedNewsListItemModel({
    required this.id,
    required this.newsId,
    required this.savedAt,
  });

  factory SavedNewsListItemModel.fromJson(Map<String, dynamic> json) =>
      _$SavedNewsListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SavedNewsListItemModelToJson(this);
}
