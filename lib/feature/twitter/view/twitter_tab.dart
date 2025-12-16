import 'package:flutter/material.dart';
import 'package:flutter_news_app/common/widgets/custom_error_widget.dart';
import 'package:flutter_news_app/common/widgets/custom_progress_indicator.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/data/model/tweet_model.dart';
import 'package:flutter_news_app/feature/home/widgets/no_news_item.dart';
import 'package:flutter_news_app/feature/twitter/viewmodel/twitter_view_model.dart';
import 'package:flutter_news_app/feature/twitter/widgets/tweet_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class TwitterTab extends ConsumerStatefulWidget {
  final bool isPopular;

  const TwitterTab({required this.isPopular, super.key});

  @override
  ConsumerState<TwitterTab> createState() => _TwitterTabState();
}

class _TwitterTabState extends ConsumerState<TwitterTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(twitterViewModelProvider(widget.isPopular).notifier).fetchNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagingState = ref.watch(twitterViewModelProvider(widget.isPopular));

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(twitterViewModelProvider(widget.isPopular).notifier)
            .refresh();
      },
      child: CustomScrollView(
        slivers: [
          PagedSliverList<int, TweetModel>(
            state: pagingState,
            fetchNextPage: () {
              ref
                  .read(twitterViewModelProvider(widget.isPopular).notifier)
                  .fetchNextPage();
            },
            builderDelegate: PagedChildBuilderDelegate<TweetModel>(
              itemBuilder: (context, tweet, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.cMediumValue,
                    vertical: context.cSmallValue,
                  ),
                  child: TweetCard(tweet: tweet),
                );
              },
              firstPageProgressIndicatorBuilder: (context) =>
                  const Center(child: CustomProgressIndicator()),
              newPageProgressIndicatorBuilder: (context) =>
                  const Center(child: CustomProgressIndicator()),
              noItemsFoundIndicatorBuilder: (context) => const NoNewsItem(),
              firstPageErrorIndicatorBuilder: (context) => Padding(
                padding: EdgeInsets.all(context.cMediumValue),
                child: CustomErrorWidget(
                  errorMsg: pagingState.error?.toString() ??
                      StringConstants.errorOccurred,
                  refreshOnPressed: () {
                    ref
                        .read(twitterViewModelProvider(widget.isPopular).notifier)
                        .refresh();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
