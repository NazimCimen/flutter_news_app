import 'package:flutter/material.dart';
import 'package:flutter_news_app/common/widgets/custom_error_widget.dart';
import 'package:flutter_news_app/common/widgets/custom_progress_indicator.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/config/routes/app_routes.dart';
import 'package:flutter_news_app/config/theme/app_colors.dart';
import 'package:flutter_news_app/core/utils/color_utils.dart';
import 'package:flutter_news_app/data/model/category_model.dart';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_news_app/feature/category_news/widget/category_news_card.dart';
import 'package:flutter_news_app/feature/home/widgets/no_news_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter_news_app/feature/home/viewmodel/home_view_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
part 'category_news_section.dart';
part 'popular_news_section.dart';
part 'populer_news_card.dart';

class NewsTab extends ConsumerStatefulWidget {
  final bool isPopular;

  const NewsTab({required this.isPopular, super.key});

  @override
  ConsumerState<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends ConsumerState<NewsTab> {
  Future<void> _handleBookmarkTap(NewsModel news) async {
    if (news.id == null) return;

    await ref.read(homeViewModelProvider.notifier).toogleSaveButton(
      newsId: news.id!,
      currentStatus: news.isSaved ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final tabState = widget.isPopular
        ? homeState.latestTab
        : homeState.forYouTab;

    return tabState.news.when(
      data: (news) {
        if (news.isEmpty) {
          return const NoNewsItem();
        }
        return RefreshIndicator(
          onRefresh: () async {
            if (widget.isPopular) {
              await ref
                  .read(homeViewModelProvider.notifier)
                  .latestPopularNews();
            } else {
              await ref
                  .read(homeViewModelProvider.notifier)
                  .refreshPersonalizedNews();
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
            ref.read(homeViewModelProvider.notifier).latestPopularNews();
          } else {
            ref.read(homeViewModelProvider.notifier).refreshPersonalizedNews();
          }
        },
      ),
    );
  }
}
