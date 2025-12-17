import 'package:flutter/material.dart';
import 'package:flutter_news_app/common/widgets/app_drawer.dart';
import 'package:flutter_news_app/config/theme/app_colors.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/core/utils/size/padding_extension.dart';
import 'package:flutter_news_app/feature/home/view/home_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/feature/layout/provider/app_layout_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
part '../widgets/app_bar.dart';
part '../widgets/bottom_navbar.dart';

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
      appBar: _CustomAppBar(
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
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
