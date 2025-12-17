part of '../view/app_layout.dart';

/// CUSTOM BOTTOM NAVIGATION BAR WIDGET - USED IN APP LAYOUT
class _CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onNavTap;

  const _CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItemWidget(
                index: 0,
                icon: Icons.article_outlined,
                label: StringConstants.navHome,
                isSelected: currentIndex == 0,
                selectedColor: AppColors.red,
                unselectedColor: AppColors.grey600,
                onTap: () => onNavTap(0),
              ),
              _NavItemWidget(
                index: 1,
                icon: Icons.explore_outlined,
                label: StringConstants.navAgenda,
                isSelected: currentIndex == 1,
                selectedColor: AppColors.red,
                unselectedColor: AppColors.grey600,
                onTap: () => onNavTap(1),
              ),
              _CenterAlarmButton(onTap: () => onNavTap(2)),
              _NavItemWidget(
                index: 3,
                icon: Icons.bookmark_outline,
                label: StringConstants.navSaved,
                isSelected: currentIndex == 3,
                selectedColor: AppColors.red,
                unselectedColor: AppColors.grey600,
                onTap: () => onNavTap(3),
              ),
              _NavItemWidget(
                index: 4,
                icon: Icons.location_on_outlined,
                label: StringConstants.navLocal,
                isSelected: currentIndex == 4,
                selectedColor: AppColors.red,
                unselectedColor: AppColors.grey600,
                onTap: () => onNavTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterAlarmButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterAlarmButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.red.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.alarm, color: Colors.white, size: 28),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.index,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
