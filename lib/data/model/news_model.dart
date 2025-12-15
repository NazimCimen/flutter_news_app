import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_model.g.dart';

@JsonSerializable()
class NewsModel extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? content;
  final String? imageUrl;
  final String? categoryId;
  final String? sourceId;
  final String? sourceProfilePictureUrl;
  final String? sourceTitle;
  final String? publishedAt;
  final bool? isLatest;
  final bool? isLiked;
  final bool? isSaved;
  final String? userName;
  final String? categoryName;

  const NewsModel({
    this.id,
    this.title,
    this.description,
    this.content,
    this.imageUrl,
    this.categoryId,
    this.sourceId,
    this.sourceProfilePictureUrl,
    this.sourceTitle,
    this.publishedAt,
    this.isLatest,
    this.isLiked,
    this.isSaved,
    this.userName,
    this.categoryName,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsModelToJson(this);

  NewsModel copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? imageUrl,
    String? categoryId,
    String? sourceId,
    String? sourceProfilePictureUrl,
    String? sourceTitle,
    String? publishedAt,
    bool? isLatest,
    bool? isLiked,
    bool? isSaved,
    String? userName,
    String? categoryName,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      sourceId: sourceId ?? this.sourceId,
      sourceProfilePictureUrl:
          sourceProfilePictureUrl ?? this.sourceProfilePictureUrl,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      publishedAt: publishedAt ?? this.publishedAt,
      isLatest: isLatest ?? this.isLatest,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      userName: userName ?? this.userName,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        imageUrl,
        categoryId,
        sourceId,
        sourceProfilePictureUrl,
        sourceTitle,
        publishedAt,
        isLatest,
        isLiked,
        isSaved,
        userName,
        categoryName,
      ];
}
