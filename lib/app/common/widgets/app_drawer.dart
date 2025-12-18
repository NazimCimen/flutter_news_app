import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/config/localization/locale_constants.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/config/routes/app_routes.dart';
import 'package:flutter_news_app/app/config/theme/theme_manager.dart';
import 'package:flutter_news_app/app/data/model/user_model.dart';
import 'package:flutter_news_app/feature/auth/view_model/auth_view_model.dart';
import 'package:flutter_news_app/feature/profile/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// APP DRAWER
@immutable
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final currentLocale = context.locale;
    final themeState = ref.watch(themeManagerProvider);
    final userProfileAsync = ref.watch(userProfileProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _UserProfileHeader(userProfileAsync: userProfileAsync),
            const SizedBox(height: 8),
            const _Header(),
            const SizedBox(height: 8),

            _SectionTitle(
              title: StringConstants.language,
              textTheme: textTheme,
            ),
            ...LocaleConstants.languageList.map(
              (lang) => _SelectableTile(
                title: lang.name,
                leading: Image.asset(lang.flagName, width: 28),
                isSelected: currentLocale == lang.locale,
                onTap: () async {
                  await context.setLocale(lang.locale);
                },
              ),
            ),

            const SizedBox(height: 16),
            _SectionTitle(title: StringConstants.theme, textTheme: textTheme),

            _SelectableTile(
              title: StringConstants.lightTheme,
              leading: const Icon(Icons.light_mode_outlined),
              isSelected: themeState.currentThemeEnum == ThemeEnum.light,
              onTap: () {
                ref
                    .read(themeManagerProvider.notifier)
                    .changeTheme(ThemeEnum.light);
              },
            ),
            _SelectableTile(
              title: StringConstants.darkTheme,
              leading: const Icon(Icons.dark_mode_outlined),
              isSelected: themeState.currentThemeEnum == ThemeEnum.dark,
              onTap: () {
                ref
                    .read(themeManagerProvider.notifier)
                    .changeTheme(ThemeEnum.dark);
              },
            ),

            const Spacer(),

            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Icon(Icons.logout, color: colors.error),
                title: Text(
                  StringConstants.logout,
                  style: textTheme.bodyMedium?.copyWith(color: colors.error),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await ref.read(authViewModelProvider.notifier).logout();
                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${StringConstants.copyright} ${DateTime.now().year} ${StringConstants.appName}',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  static String appName = StringConstants.appName;
  static String version = StringConstants.version;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appName, style: textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'v$version',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.textTheme});

  final String title;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(title, style: textTheme.labelLarge),
    );
  }
}

class _SelectableTile extends StatelessWidget {
  const _SelectableTile({
    required this.title,
    required this.leading,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final Widget leading;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: leading,
      title: Text(title, style: textTheme.bodyMedium),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colors.primary)
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class _UserProfileHeader extends StatelessWidget {
  const _UserProfileHeader({required this.userProfileAsync});

  final AsyncValue<UserModel?> userProfileAsync;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return userProfileAsync.when(
      data: (user) {
        return _buildUserProfile(context, colors, textTheme, user);
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }

  Widget _buildUserProfile(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
    UserModel? user,
  ) {
    if (user == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: .3),
        border: Border(
          bottom: BorderSide(color: colors.outlineVariant, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildAvatar(user, colors),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? StringConstants.guestUser,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  user.email ?? '',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(UserModel? user, ColorScheme colors) {
    if (user == null) return const SizedBox.shrink();
    final hasAvatar = user.imageUrl != null && user.imageUrl!.isNotEmpty;

    if (hasAvatar) {
      return CircleAvatar(
        radius: 28,
        backgroundColor: colors.surfaceContainerHighest,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: user.imageUrl!,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: CircleAvatar(
                radius: 28,
                backgroundColor: colors.surfaceContainerHighest,
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
            errorWidget: (context, url, error) =>
                Icon(Icons.person, size: 32, color: colors.onSurfaceVariant),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 28,
      backgroundColor: colors.surfaceContainerHighest,
      child: Icon(Icons.person, size: 32, color: colors.onSurfaceVariant),
    );
  }
}
