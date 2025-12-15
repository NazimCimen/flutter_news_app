import 'package:flutter_news_app/data/model/category_model.dart';
import 'package:flutter_news_app/data/repository/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesCacheProvider =
    StateNotifierProvider<CategoriesCacheNotifier, List<CategoryModel>>(
      (ref) => CategoriesCacheNotifier(
        repository: ref.read(categoriesRepositoryProvider),
      ),
    );

class CategoriesCacheNotifier extends StateNotifier<List<CategoryModel>> {
  final CategoriesRepository _repository;

  CategoriesCacheNotifier({required CategoriesRepository repository})
    : _repository = repository,
      super(const []);

  bool get isInitialized => state.isNotEmpty;

  Future<void> init() async {
    if (state.isNotEmpty) return;

    final result = await _repository.fetchCategories();

    result.fold((_) {}, (categories) {
      state = categories;
    });
  }

  Map<String, String> get categoryNameById => {
    for (final c in state) c.id!: c.name!,
  };
}
