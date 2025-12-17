import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/config/localization/locale_constants.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/config/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: 8),

            _SectionTitle(title: 'Dil', textTheme: textTheme),
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
            _SectionTitle(title: 'Tema', textTheme: textTheme),

            _SelectableTile(
              title: 'Açık',
              leading: const Icon(Icons.light_mode_outlined),
              isSelected: themeState.currentThemeEnum == ThemeEnum.light,
              onTap: () {
                ref
                    .read(themeManagerProvider.notifier)
                    .changeTheme(ThemeEnum.light);
              },
            ),
            _SelectableTile(
              title: 'Koyu',
              leading: const Icon(Icons.dark_mode_outlined),
              isSelected: themeState.currentThemeEnum == ThemeEnum.dark,
              onTap: () {
                ref
                    .read(themeManagerProvider.notifier)
                    .changeTheme(ThemeEnum.dark);
              },
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '© ${DateTime.now().year} ${StringConstants.appName}',
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
