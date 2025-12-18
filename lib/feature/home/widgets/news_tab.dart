import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/common/widgets/custom_error_widget.dart';
import 'package:flutter_news_app/app/common/widgets/custom_progress_indicator.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/config/routes/app_routes.dart';
import 'package:flutter_news_app/app/config/theme/app_colors.dart';
import 'package:flutter_news_app/core/utils/color_utils.dart';
import 'package:flutter_news_app/app/data/model/category_model.dart';
import 'package:flutter_news_app/app/data/model/news_model.dart';
import 'package:flutter_news_app/feature/category_news/widgets/category_news_card.dart';
import 'package:flutter_news_app/feature/home/widgets/no_news_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter_news_app/feature/home/view_model/home_view_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
part 'category_news_section.dart';
part 'popular_news_section.dart';
part 'populer_news_card.dart';

/// NEWS TAB WIDGET - DISPLAYS NEWS CONTENT FOR LATEST OR FOR YOU TAB
class NewsTab extends ConsumerStatefulWidget {
  final bool isPopular;

  const NewsTab({
    required this.isPopular,
    super.key,
  }) : super();

  @override
  ConsumerState<NewsTab> createState() => _NewsTabState();
}

/// NEWS TAB STATE - MANAGES NEWS DISPLAY AND BOOKMARK INTERACTIONS
class _NewsTabState extends ConsumerState<NewsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// HANDLE BOOKMARK TAP - TOGGLE SAVE STATUS FOR NEWS ITEM
  Future<void> _handleBookmarkTap(NewsModel news) async {
    if (news.id == null) return;

    await ref
        .read(homeViewModelProvider.notifier)
        .toogleSaveButton(
          newsId: news.id!,
          currentStatus: news.isSaved ?? false,
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    /// SELECTIVE WATCHING - ONLY WATCH RELEVANT TAB STATE TO MINIMIZE REBUILDS
    final tabState = ref.watch(
      homeViewModelProvider.select((state) => 
        widget.isPopular ? state.latestTab : state.forYouTab
      ),
    );

    /// HANDLE DIFFERENT ASYNC STATES: DATA, LOADING, ERROR
    return tabState.news.when(
      data: (news) {
        if (news.isEmpty) {
          return const NoNewsItem();
        }
        /// REFRESH INDICATOR - PULL TO REFRESH FUNCTIONALITY
        return RefreshIndicator(
          onRefresh: () async {
            if (widget.isPopular) {
              await ref
                  .read(homeViewModelProvider.notifier)
                  .fetchLastNews(forceRefresh: true);
            } else {
              await ref
                  .read(homeViewModelProvider.notifier)
                  .fetchPersonalizedNews(forceRefresh: true);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: context.cMediumValue),
                _PopularNewsSection(
                  news: news,
                  onBookmarkTap: _handleBookmarkTap,
                ),
                SizedBox(height: context.cLargeValue),
                _CategoryNewsSection(isPopular: widget.isPopular),
                SizedBox(height: context.cMediumValue),
              ],
            ),
          ),
        );
      },
      loading: () => const CustomProgressIndicator(),
      error: (error, stack) => CustomErrorWidget(
        errorMsg: error.toString(),
        refreshOnPressed: () {
          if (widget.isPopular) {
            ref.read(homeViewModelProvider.notifier).fetchLastNews(forceRefresh: true);
          } else {
            ref.read(homeViewModelProvider.notifier).fetchPersonalizedNews(forceRefresh: true);
          }
        },
      ),
    );
  }
}
