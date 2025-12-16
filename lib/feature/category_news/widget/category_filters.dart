part of '../view/category_news_view.dart';

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

  void _scrollToSelectedCategory() {
    final categories = ref.read(categoriesCacheProvider);
    final selectedIndex = categories.indexWhere(
      (cat) => cat.id == widget.selectedCategoryId,
    );
    if (selectedIndex != -1 && _scrollController.hasClients) {
      const itemWidth = 100 + 8.0;
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
    final categories = ref.watch(categoriesCacheProvider);

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 100,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == widget.selectedCategoryId;

          return Padding(
            padding: EdgeInsets.only(right: context.cSmallValue),
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
  }
}

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

    // Get category color or use default
    final categoryColor = ColorUtils.getCategorButtonColor(category.colorCode);
    final backgroundColor = isSelected
        ? categoryColor
        : categoryColor.withValues(alpha: .1);
    final textColor = isSelected
        ? ColorUtils.getContrastTextColor(categoryColor)
        : colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(context.cSmallValue),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: categoryColor.withValues(alpha: .3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (category.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: category.imageUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.category,
                      color: textColor.withValues(alpha: 0.3),
                      size: 24,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.category,
                      color: textColor.withValues(alpha: 0.5),
                      size: 24,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.category, color: textColor, size: 24),
              ),
            SizedBox(height: context.cSmallValue * 0.5),
            Text(
              category.name ?? '',
              style: textTheme.bodySmall?.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
