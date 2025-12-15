import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'source_model.g.dart';

@JsonSerializable()
class SourceModel extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? sourceCategoryId;
  final bool? isFollowed;

  const SourceModel({
    this.id,
    this.name,
    this.sourceCategoryId,
    this.description,
    this.imageUrl,
    this.isFollowed,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      _$SourceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SourceModelToJson(this);

  SourceModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? sourceCategoryId,
    bool? isFollowed,
  }) {
    return SourceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      sourceCategoryId: sourceCategoryId ?? this.sourceCategoryId,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    sourceCategoryId,
    isFollowed,
  ];
}
