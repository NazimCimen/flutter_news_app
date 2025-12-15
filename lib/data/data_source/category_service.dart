import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/api_constants.dart';
import 'package:flutter_news_app/core/network/dio_error_extension.dart';
import 'package:flutter_news_app/core/network/dio_interceptor.dart';
import 'package:flutter_news_app/data/model/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryServiceProvider = Provider<CategoryService>((ref) {
  return CategoryServiceImpl(dio: ref.read(dioProvider));
});

abstract class CategoryService {
  Future<Either<Failure, List<CategoryModel>>> fetchCategories();
}

class CategoryServiceImpl implements CategoryService {
  final Dio _dio;

  CategoryServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Either<Failure, List<CategoryModel>>> fetchCategories() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.categories,
      );

      final data = response.data;
      if (data == null || data['result'] == null) {
        return const Right([]);
      }

      final categories = (data['result'] as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(categories);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }
}
