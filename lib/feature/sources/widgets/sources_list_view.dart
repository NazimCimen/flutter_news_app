part of '../view/select_sources_view.dart';

/// SOURCES LIST VIEW
class _SourcesListView extends ConsumerWidget {
  const _SourcesListView();

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
                ...categorySources.map((source) => _SourceTile(source: source)),
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
