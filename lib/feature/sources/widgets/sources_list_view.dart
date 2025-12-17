import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/app/data/model/source_model.dart';
import 'package:flutter_news_app/feature/sources/view_model/select_sources_view_model.dart';
import 'package:flutter_news_app/feature/sources/widgets/source_tile.dart';
import 'package:flutter_news_app/feature/splash/splash_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SourcesListView extends ConsumerWidget {
  const SourcesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sourcesAsync = ref.watch(selectSourcesViewModelProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    final categoryMap =
        categoriesAsync.valueOrNull?.fold<Map<String, String>>(
          {},
          (map, category) =>
              map..putIfAbsent(category.id!, () => category.name!),
        ) ??
        {};

    return sourcesAsync.when(
      data: (sources) {
        if (sources.isEmpty) {
          return Center(
            child: Text(
              StringConstants.noSource,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          );
        }

        final groupedSources = groupBy(
          sources,
          (SourceModel s) => s.sourceCategoryId,
        );

        return ListView.builder(
          itemCount: groupedSources.keys.length,
          itemBuilder: (context, index) {
            final categoryId = groupedSources.keys.elementAt(index);
            final categorySources = groupedSources[categoryId]!;
            final categoryName =
                categoryMap[categoryId] ?? StringConstants.unknownCategory;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    categoryName.toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...categorySources.map((source) => SourceTile(source: source)),
                SizedBox(height: context.cSmallValue),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    );
  }
}
