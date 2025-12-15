import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/core/providers/categories_cache_notifier.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_news_app/feature/home/widgets/category_news_section.dart';
import 'package:flutter_news_app/feature/home/widgets/popular_news_section.dart';
import 'package:flutter_news_app/feature/home/viewmodel/home_view_model.dart';

class NewsTab extends ConsumerWidget {
  final StateNotifierProvider<NewsViewModel, AsyncValue<List<NewsModel>>>
      provider;

  const NewsTab({required this.provider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(provider);

    return newsAsync.when(
      data: (news) {
        if (news.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: context.cMediumValue),
                Text(
                  'Henüz haber yok',
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(provider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: context.cMediumValue),
                PopularNewsSection(news: news),
                SizedBox(height: context.cLargeValue),
                
                // Category News Sections
                _CategoryNewsList(),
                
                SizedBox(height: context.cMediumValue),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF5252)),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            SizedBox(height: context.cMediumValue),
            Text(
              'Bir hata oluştu',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            SizedBox(height: context.cSmallValue),
            Text(
              error.toString(),
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.cMediumValue),
            ElevatedButton(
              onPressed: () {
                ref.read(provider.notifier).refresh();
              },
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display all category news sections
class _CategoryNewsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesCacheProvider);

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (int i = 0; i < categories.length; i++) ...[
          _CategoryNewsItem(
            categoryId: categories[i].id!,
            categoryName: categories[i].name!,
          ),
          if (i < categories.length - 1) SizedBox(height: context.cLargeValue),
        ],
      ],
    );
  }
}

/// Widget for a single category news section
class _CategoryNewsItem extends ConsumerWidget {
  final String categoryId;
  final String categoryName;

  const _CategoryNewsItem({
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryNewsAsync = ref.watch(categoryNewsProvider(categoryId));

    return categoryNewsAsync.when(
      data: (news) {
        if (news.isEmpty) {
          return const SizedBox.shrink();
        }

        return CategoryNewsSection(
          categoryName: categoryName,
          news: news,
          onSeeMore: () {
            // TODO: Navigate to category detail page
            debugPrint('See more for category: $categoryName');
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
