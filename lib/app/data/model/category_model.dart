import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? colorCode;
  final String? imageUrl;

  const CategoryModel({
    this.id,
    this.name,
    this.description,
    this.colorCode,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, description, colorCode, imageUrl];
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? colorCode,
    String? imageUrl,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      colorCode: colorCode ?? this.colorCode,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
