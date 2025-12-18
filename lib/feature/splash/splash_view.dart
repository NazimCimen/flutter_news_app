import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/config/routes/app_routes.dart';
import 'package:flutter_news_app/app/data/data_source/local/auth_local_service.dart';
import 'package:flutter_news_app/app/data/model/category_model.dart';
import 'package:flutter_news_app/app/data/repository/category_repository.dart';
import 'package:flutter_news_app/feature/profile/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/core/utils/size/padding_extension.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

/// FETCH CATEGORIES GLOBALLY
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.read(categoriesRepositoryProvider);
  final result = await repository.fetchCategories();

  return result.fold((_) => <CategoryModel>[], (categories) => categories);
});

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initApp();
    });
    super.initState();
  }

  Future<void> _initApp() async {
    await ref.read(categoriesProvider.future);
    if (!mounted) return;
    final authService = ref.read(authLocalServiceProvider);
    final isValid = await authService.isTokenValid();
    if (isValid && mounted) {
      await ref.read(userProfileProvider.notifier).fetchUserProfile();
      if (mounted) context.go(AppRoutes.mainLayout);
    } else {
      if (mounted) context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Padding(
            padding: context.cPaddingxxLarge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: context.cMediumValue),
                Text(
                  StringConstants.appName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
