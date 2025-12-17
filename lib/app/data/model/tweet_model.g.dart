// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TweetModel _$TweetModelFromJson(Map<String, dynamic> json) => TweetModel(
      id: json['id'] as String?,
      accountId: json['accountId'] as String?,
      accountName: json['accountName'] as String?,
      accountImageUrl: json['accountImageUrl'] as String?,
      content: json['content'] as String?,
      createdAt: json['createdAt'] as String?,
      isPopular: json['isPopular'] as bool?,
    );

Map<String, dynamic> _$TweetModelToJson(TweetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'accountImageUrl': instance.accountImageUrl,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'isPopular': instance.isPopular,
    };
