// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => NewsModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String?,
      categoryId: json['categoryId'] as String?,
      sourceId: json['sourceId'] as String?,
      sourceProfilePictureUrl: json['sourceProfilePictureUrl'] as String?,
      sourceTitle: json['sourceTitle'] as String?,
      publishedAt: json['publishedAt'] as String?,
      isLatest: json['isLatest'] as bool?,
      isLiked: json['isLiked'] as bool?,
      isSaved: json['isSaved'] as bool?,
      userName: json['userName'] as String?,
      categoryName: json['categoryName'] as String?,
    );

Map<String, dynamic> _$NewsModelToJson(NewsModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'categoryId': instance.categoryId,
      'sourceId': instance.sourceId,
      'sourceProfilePictureUrl': instance.sourceProfilePictureUrl,
      'sourceTitle': instance.sourceTitle,
      'publishedAt': instance.publishedAt,
      'isLatest': instance.isLatest,
      'isLiked': instance.isLiked,
      'isSaved': instance.isSaved,
      'userName': instance.userName,
      'categoryName': instance.categoryName,
    };
