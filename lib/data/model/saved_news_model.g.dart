// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedNewsModel _$SavedNewsModelFromJson(Map<String, dynamic> json) =>
    SavedNewsModel(
      id: json['id'] as String,
      newsId: json['newsId'] as String,
      savedAt: json['savedAt'] as String,
    );

Map<String, dynamic> _$SavedNewsModelToJson(SavedNewsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'newsId': instance.newsId,
      'savedAt': instance.savedAt,
    };

SavedNewsListItemModel _$SavedNewsListItemModelFromJson(
  Map<String, dynamic> json,
) => SavedNewsListItemModel(
  id: json['id'] as String,
  newsId: json['newsId'] as String,
  savedAt: json['savedAt'] as String,
);

Map<String, dynamic> _$SavedNewsListItemModelToJson(
  SavedNewsListItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'newsId': instance.newsId,
  'savedAt': instance.savedAt,
};
