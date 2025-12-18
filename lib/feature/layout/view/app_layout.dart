import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/common/widgets/app_drawer.dart';
import 'package:flutter_news_app/app/config/theme/app_colors.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/core/utils/size/padding_extension.dart';
import 'package:flutter_news_app/feature/home/view/home_view.dart';
import 'package:flutter_news_app/feature/profile/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/feature/layout/provider/app_layout_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_news_app/app/data/model/user_model.dart';
part '../widgets/app_bar.dart';
part '../widgets/bottom_navbar.dart';

/// APP LAYOUT WIDGET - MAIN SCREEN WITH TAB NAVIGATION
class AppLayout extends ConsumerWidget {
  const AppLayout({super.key});
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appLayoutProvider);
    final pages = [
      const HomePage(),
      Container(color: Colors.blue.shade900),
      Container(color: Colors.orange.shade900),
      Container(color: Colors.green.shade900),
      Container(color: Colors.purple.shade900),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      appBar: const _CustomAppBar(),
      body: pages[currentIndex],
      bottomNavigationBar: _CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onNavTap: (index) {
          ref.read(appLayoutProvider.notifier).changeTab(index);
        },
      ),
    );
  }
}
