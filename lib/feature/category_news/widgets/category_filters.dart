part of '../view/category_news_view.dart';

/// CATEGORY FILTERS WIDGET
class _CategoryFilters extends ConsumerStatefulWidget {
  final String selectedCategoryId;
  final void Function(String) onCategoryChanged;

  const _CategoryFilters({
    required this.selectedCategoryId,
    required this.onCategoryChanged,
  });

  @override
  ConsumerState<_CategoryFilters> createState() => _CategoryFiltersState();
}

class _CategoryFiltersState extends ConsumerState<_CategoryFilters> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedCategory();
    });
  }

  @override
  void didUpdateWidget(_CategoryFilters oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategoryId != widget.selectedCategoryId) {
      _scrollToSelectedCategory();
    }
  }

  /// AUTO SCROLL TO SELECTED CATEGORY
  void _scrollToSelectedCategory() {
    final categoriesAsync = ref.read(categoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? [];
    final selectedIndex = categories.indexWhere(
      (cat) => cat.id == widget.selectedCategoryId,
    );
    if (selectedIndex != -1 && _scrollController.hasClients) {
      const itemWidth = 110 + 12.0;
      final targetOffset = selectedIndex * itemWidth;
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 48,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category.id == widget.selectedCategoryId;

              return Padding(
                padding: EdgeInsets.only(right: context.cSmallValue * 1.5),
                child: _CategoryFilterChip(
                  category: category,
                  isSelected: isSelected,
                  onTap: () {
                    if (category.id != null &&
                        category.id != widget.selectedCategoryId) {
                      widget.onCategoryChanged(category.id!);
                    }
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// CATEGORY FILTER CHIP
class _CategoryFilterChip extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryFilterChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final categoryColor = isSelected
        ? ColorUtils.getCategorButtonColor(category.colorCode)
        : Colors.transparent;

    final textColor = isSelected
        ? ColorUtils.getCategorButtonColor(category.colorCode)
        : colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: context.cMediumValue,
          vertical: context.cSmallValue,
        ),
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.08),
          borderRadius: context.cBorderRadiusAllMedium,
          border: isSelected
              ? Border.all(
                  color: categoryColor.withValues(alpha: 0.3),
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// INDICATOR BAR
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(right: context.cSmallValue * 0.5),
                child: Container(
                  width: 8,
                  height: 22,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

            /// CATEGORY NAME
            Text(
              category.name ?? '',
              style: textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
