part of '../view/twitter_tab_view.dart';

/// TWITTER TAB CONTENT (POPULAR OR FOR YOU)
class _TwitterTab extends ConsumerStatefulWidget {
  final bool isPopular;

  const _TwitterTab({required this.isPopular, super.key});

  @override
  ConsumerState<_TwitterTab> createState() => _TwitterTabState();
}

class _TwitterTabState extends ConsumerState<_TwitterTab> {
  @override
  void initState() {
    super.initState();
    /// FETCH FIRST PAGE ONLY IF DATA NOT LOADED YET
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState =
          ref.read(twitterViewModelProvider(widget.isPopular));
      if (currentState.pages == null || currentState.pages!.isEmpty) {
        ref
            .read(twitterViewModelProvider(widget.isPopular).notifier)
            .fetchNextPage();
      }
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
      child: PagedListView<int, TweetModel>(
        state: pagingState,
        fetchNextPage: () {
          ref
              .read(twitterViewModelProvider(widget.isPopular).notifier)
              .fetchNextPage();
        },
        builderDelegate: PagedChildBuilderDelegate<TweetModel>(
          /// TWEET CARD ITEM
          itemBuilder: (context, tweet, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.cMediumValue,
                vertical: context.cSmallValue,
              ),
              child: _TweetCard(tweet: tweet),
            );
          },

          /// LOADING INDICATORS
          firstPageProgressIndicatorBuilder: (context) =>
              const Center(child: CustomProgressIndicator()),
          newPageProgressIndicatorBuilder: (context) =>
              const Center(child: CustomProgressIndicator()),

          /// EMPTY STATE
          noItemsFoundIndicatorBuilder: (context) => const NoNewsItem(),

          /// ERROR STATE
          firstPageErrorIndicatorBuilder: (context) => Padding(
            padding: EdgeInsets.all(context.cMediumValue),
            child: CustomErrorWidget(
              errorMsg:
                  pagingState.error?.toString() ??
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
    );
  }
}
