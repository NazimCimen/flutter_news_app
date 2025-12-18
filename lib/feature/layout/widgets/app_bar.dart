part of '../view/app_layout.dart';

/// CUSTOM APP BAR WIDGET - USED IN APP LAYOUT
class _CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return AppBar(
      forceMaterialTransparency: true,
      titleSpacing: 0,
      title: InkWell(child: const Icon(Icons.alarm), onTap: () {}),
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
        _buildUserAvatar(context, userProfileAsync),
        SizedBox(width: context.cSmallValue),
      ],
    );
  }

  Widget _buildUserAvatar(
    BuildContext context,
    AsyncValue<UserModel?> userProfileAsync,
  ) {
    final theme = Theme.of(context);

    return userProfileAsync.maybeWhen(
      data: (user) {
        final imageUrl = user?.imageUrl;

        if (imageUrl != null && imageUrl.isNotEmpty) {
          return CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
                placeholder: (_, __) => const SizedBox.shrink(),
                errorWidget: (_, __, ___) => _defaultAvatar(theme),
              ),
            ),
          );
        }

        return _defaultAvatar(theme);
      },
      orElse: () => _defaultAvatar(theme),
    );
  }

  Widget _defaultAvatar(ThemeData theme) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person,
        size: 20,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
