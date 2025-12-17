import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/app/data/data_source/remote/category_service.dart';
import 'package:flutter_news_app/app/data/model/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// CATEGORIES REPOSITORY PROVIDER
final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  return CategoriesRepositoryImpl(
    categoryService: ref.read(categoryServiceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

/// CATEGORIES REPOSITORY INTERFACE
abstract class CategoriesRepository {
  /// FETCH ALL CATEGORIES
  Future<Either<Failure, List<CategoryModel>>> fetchCategories();
}

/// CATEGORIES REPOSITORY IMPLEMENTATION
class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoryService _categoryService;
  final INetworkInfo _networkInfo;

  CategoriesRepositoryImpl({
    required CategoryService categoryService,
    required INetworkInfo networkInfo,
  }) : _categoryService = categoryService,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<CategoryModel>>> fetchCategories() async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ServerFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _categoryService.fetchCategories();
  }
}
