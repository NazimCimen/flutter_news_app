import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/feature/twitter/view/twitter_tab.dart';

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Rounded Button Style Tab Selector
        Padding(
          padding: EdgeInsets.all(context.cMediumValue),
          child: Row(
            children: [
              // Popüler Button
              GestureDetector(
                onTap: () => _tabController.animateTo(0),
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    final isSelected = _tabController.index == 0;
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.cLargeValue,
                        vertical: context.cSmallValue,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.surface
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.outline.withValues(alpha: 0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        StringConstants.popular,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? colorScheme.onSurface
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(width: context.cSmallValue),

              // Sana Özel Button
              GestureDetector(
                onTap: () => _tabController.animateTo(1),
                child: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    final isSelected = _tabController.index == 1;
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.cLargeValue,
                        vertical: context.cSmallValue,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.onSurface
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        StringConstants.forYou,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? colorScheme.surface
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // TabBarView for Twitter sub-tabs
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              TwitterTab(isPopular: true, key: ValueKey('twitter_popular')),
              TwitterTab(isPopular: false, key: ValueKey('twitter_foryou')),
            ],
          ),
        ),
      ],
    );
  }
}
