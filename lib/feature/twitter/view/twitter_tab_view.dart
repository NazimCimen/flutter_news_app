import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/common/widgets/custom_error_widget.dart';
import 'package:flutter_news_app/common/widgets/custom_progress_indicator.dart';
import 'package:flutter_news_app/data/model/tweet_model.dart';
import 'package:flutter_news_app/feature/home/widgets/no_news_item.dart';
import 'package:flutter_news_app/feature/twitter/view_model/twitter_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part '../widgets/tab_button.dart';
part '../widgets/twitter_tab.dart';
part '../widgets/tweet_card.dart';

/// TWITTER TAB VIEW WITH NESTED SCROLL (COLLAPSIBLE TAB BUTTONS)
class TwitterTabView extends StatefulWidget {
  const TwitterTabView({super.key});

  @override
  State<TwitterTabView> createState() => _TwitterTabViewState();
}

class _TwitterTabViewState extends State<TwitterTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            toolbarHeight: 70,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: Padding(
              padding: EdgeInsets.all(context.cMediumValue),
              child: Row(
                children: [
                  _TabButton(
                    label: StringConstants.popular,
                    isSelected: _tabController.index == 0,
                    onTap: () => _tabController.animateTo(0),
                    tabController: _tabController,
                    isPrimary: true,
                  ),
                  SizedBox(width: context.cSmallValue),
                  _TabButton(
                    label: StringConstants.forYou,
                    isSelected: _tabController.index == 1,
                    onTap: () => _tabController.animateTo(1),
                    tabController: _tabController,
                    isPrimary: false,
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      /// TAB CONTENT (POPULAR / FOR YOU)
      body: TabBarView(
        controller: _tabController,
        children: const [
          _TwitterTab(isPopular: true, key: ValueKey('twitter_popular')),
          _TwitterTab(isPopular: false, key: ValueKey('twitter_foryou')),
        ],
      ),
    );
  }
}
