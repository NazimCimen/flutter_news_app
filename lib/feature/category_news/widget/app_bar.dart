part of '../view/category_news_view.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      forceMaterialTransparency: true,

      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.cSmallValue / 2),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: context.cMediumValue,
          ),
        ),
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: context.cBorderRadiusAllMedium,
            side: BorderSide(color: colorScheme.onSurface),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
