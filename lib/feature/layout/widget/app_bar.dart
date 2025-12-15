part of '../view/app_layout.dart';

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      titleSpacing: 0,
      title: Row(
        children: [
          SizedBox(width: context.cSmallValue),
          InkWell(child: const Icon(Icons.sort), onTap: () {}),
          SizedBox(width: context.cMediumValue),
          InkWell(child: const Icon(Icons.alarm), onTap: () {}),
        ],
      ),
      actions: [
        Container(
          padding: context.cPaddingSmall * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: InkWell(child: const Icon(Icons.search), onTap: () {}),
        ),
        SizedBox(width: context.cMediumValue),

        Container(
          padding: context.cPaddingSmall * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              InkWell(
                child: const Icon(Icons.notifications_outlined),
                onTap: () {},
              ),
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: context.cSmallValue,
                  height: context.cSmallValue,
                  decoration: const BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: context.cMediumValue),
        const CircleAvatar(
          radius: 18,
          backgroundImage: CachedNetworkImageProvider(
            'https://i.pravatar.cc/150?img=7',
          ),
        ),
        SizedBox(width: context.cSmallValue),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
