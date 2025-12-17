import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tweet_model.g.dart';

@JsonSerializable()
class TweetModel extends Equatable {
  final String? id;
  final String? accountId;
  final String? accountName;
  final String? accountImageUrl;
  final String? content;
  final String? createdAt;
  final bool? isPopular;

  const TweetModel({
    this.id,
    this.accountId,
    this.accountName,
    this.accountImageUrl,
    this.content,
    this.createdAt,
    this.isPopular,
  });

  factory TweetModel.fromJson(Map<String, dynamic> json) =>
      _$TweetModelFromJson(json);

  Map<String, dynamic> toJson() => _$TweetModelToJson(this);

  TweetModel copyWith({
    String? id,
    String? accountId,
    String? accountName,
    String? accountImageUrl,
    String? content,
    String? createdAt,
    bool? isPopular,
  }) {
    return TweetModel(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      accountImageUrl: accountImageUrl ?? this.accountImageUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isPopular: isPopular ?? this.isPopular,
    );
  }

  @override
  List<Object?> get props => [
        id,
        accountId,
        accountName,
        accountImageUrl,
        content,
        createdAt,
        isPopular,
      ];
}
