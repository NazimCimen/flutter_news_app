import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/network_info.dart';
import 'package:flutter_news_app/data/data_source/category_service.dart';
import 'package:flutter_news_app/data/model/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  return CategoriesRepositoryImpl(
    categoryService: ref.read(categoryServiceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

abstract class CategoriesRepository {
  Future<Either<Failure, List<CategoryModel>>> fetchCategories();
}

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
    if (await _networkInfo.currentConnectivityResult) {
      return _categoryService.fetchCategories();
    } else {
      return Left(
        ServerFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
  }
}
