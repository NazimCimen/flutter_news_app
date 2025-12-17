// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceModel _$SourceModelFromJson(Map<String, dynamic> json) => SourceModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      sourceCategoryId: json['sourceCategoryId'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isFollowed: json['isFollowed'] as bool?,
    );

Map<String, dynamic> _$SourceModelToJson(SourceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'sourceCategoryId': instance.sourceCategoryId,
      'isFollowed': instance.isFollowed,
    };
