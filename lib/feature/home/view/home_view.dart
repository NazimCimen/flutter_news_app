import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/feature/home/widgets/news_tab.dart';
import 'package:flutter_news_app/feature/twitter/view/twitter_tab_view.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TabBar
          TabBar(
            padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
            controller: _tabController,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelColor: Theme.of(context).colorScheme.secondary,
            labelStyle: Theme.of(context).textTheme.bodySmall,
            unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
            dividerColor: Colors.transparent,
            labelPadding: EdgeInsets.zero,
            tabs: [
              Tab(text: StringConstants.tabLatestNews),
              Tab(text: StringConstants.tabForYou),
              Tab(text: StringConstants.tabTwitter),
              Tab(text: StringConstants.tabYouTube),
            ],
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const NewsTab(isPopular: true),
                const NewsTab(isPopular: false),
                const TwitterTabView(), 
                Container(), 
              ],
            ),
          ),
        ],
      ),
    );
  }
}
