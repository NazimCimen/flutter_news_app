part of '../view/twitter_tab_view.dart';

/// TAB BUTTON WIDGET (POPULAR / FOR YOU)
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final TabController tabController;
  final bool isPrimary;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.tabController,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.cLargeValue,
          vertical: context.cSmallValue,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isPrimary ? colorScheme.surface : colorScheme.onSurface)
              : Colors.transparent,
          borderRadius: context.cBorderRadiusAllMedium,
          border: isPrimary
              ? Border.all(
                  color: isSelected
                      ? colorScheme.outline.withValues(alpha: 0.3)
                      : Colors.transparent,
                )
              : null,
        ),
        child: Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? (isPrimary ? colorScheme.onSurface : colorScheme.surface)
                : colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
