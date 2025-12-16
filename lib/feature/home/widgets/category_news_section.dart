part of 'news_tab.dart';

/// Widget to display all category news sections
class _CategoryNewsSection extends ConsumerWidget {
  final bool isPopular;

  const _CategoryNewsSection({required this.isPopular});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final tabState = isPopular
        ? homeState.latestTab
        : homeState.forYouTab;

    return tabState.categoryNews.when(
      data: (categoriesWithNews) {
        if (categoriesWithNews.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            for (int i = 0; i < categoriesWithNews.length; i++) ...[
              _CategoryNews(
                category: categoriesWithNews[i].category,
                news: categoriesWithNews[i].news,
                onSeeMore: () {
                  context.push(
                    AppRoutes.categoryNews,
                    extra: categoriesWithNews[i].category,
                  );
                },
              ),
              if (i < categoriesWithNews.length - 1)
                SizedBox(height: context.cLargeValue),
            ],
          ],
        );
      },
      loading: () => const CustomProgressIndicator(),
      error: (error, stack) => CustomErrorWidget(errorMsg: error.toString()),
    );
  }
}

class _CategoryNews extends ConsumerWidget {
  final CategoryModel category;
  final List<NewsModel> news;
  final VoidCallback onSeeMore;

  const _CategoryNews({
    required this.category,
    required this.news,
    required this.onSeeMore,
  });

  Future<void> _handleBookmarkTap(
    BuildContext context,
    WidgetRef ref,
    NewsModel news,
  ) async {
    if (news.id == null) return;

    await ref.read(homeViewModelProvider.notifier).toogleSaveButton(
      newsId: news.id!,
      currentStatus: news.isSaved ?? false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonColor = ColorUtils.getCategorButtonColor(category.colorCode);
    final textColor = ColorUtils.getContrastTextColor(buttonColor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 22,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: context.cSmallValue),

              Expanded(
                child: Text(
                  category.name ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),

              TextButton(
                onPressed: onSeeMore,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  StringConstants.showMore,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: context.cMediumValue),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
          child: Column(
            children: [
              for (int i = 0; i < news.length; i++) ...[
                CategoryNewsCard(
                  news: news[i],
                  onBookmarkTap: () =>
                      _handleBookmarkTap(context, ref, news[i]),
                ),
                if (i < news.length - 1) SizedBox(height: context.cMediumValue),
              ],
            ],
          ),
        ),

        SizedBox(height: context.cMediumValue),

        Center(
          child: ElevatedButton(
            onPressed: onSeeMore,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: textColor,
              padding: EdgeInsets.symmetric(
                horizontal: context.cLargeValue,
                vertical: context.cSmallValue * 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: Text(
              StringConstants.showMore,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
