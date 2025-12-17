import 'package:flutter/material.dart';
import 'package:flutter_news_app/common/widgets/custom_error_widget.dart';
import 'package:flutter_news_app/common/widgets/custom_progress_indicator.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/utils/color_utils.dart';
import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/data/model/category_model.dart';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_news_app/feature/category_news/mixin/category_news_mixin.dart';
import 'package:flutter_news_app/feature/category_news/view_model/category_news_view_model.dart';
import 'package:flutter_news_app/feature/category_news/widgets/category_news_card.dart';
import 'package:flutter_news_app/feature/home/widgets/no_news_item.dart';
import 'package:flutter_news_app/feature/splash/splash_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part '../widgets/app_bar.dart';
part '../widgets/category_filters.dart';

/// CATEGORY NEWS VIEW
class CategoryNewsView extends ConsumerStatefulWidget {
  final CategoryModel category;

  const CategoryNewsView({required this.category, super.key});

  @override
  ConsumerState<CategoryNewsView> createState() => _CategoryNewsViewState();
}

class _CategoryNewsViewState extends ConsumerState<CategoryNewsView>
    with CategoryNewsMixin {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pagingState = selectedCategoryId.isNotEmpty
        ? ref.watch(categoryNewsViewModelProvider(selectedCategoryId))
        : PagingState<int, NewsModel>();

    return Scaffold(
      appBar: const _AppBar(),
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (selectedCategoryId.isNotEmpty) {
              await ref
                  .read(
                    categoryNewsViewModelProvider(selectedCategoryId).notifier,
                  )
                  .refresh();
            }
          },
          child: CustomScrollView(
            slivers: [
              /// CATEGORY FILTERS
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _CategoryFilters(
                      selectedCategoryId: selectedCategoryId,
                      onCategoryChanged: onCategoryChanged,
                    ),
                    SizedBox(height: context.cMediumValue),
                  ],
                ),
              ),

              /// NEWS LIST WITH PAGINATION
              PagedSliverList<int, NewsModel>(
                state: pagingState,
                fetchNextPage: () {
                  if (selectedCategoryId.isNotEmpty) {
                    ref
                        .read(
                          categoryNewsViewModelProvider(
                            selectedCategoryId,
                          ).notifier,
                        )
                        .fetchNextPage();
                  }
                },
                builderDelegate: PagedChildBuilderDelegate<NewsModel>(
                  itemBuilder: (context, news, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.cMediumValue,
                        vertical: context.cSmallValue,
                      ),
                      child: CategoryNewsCard(
                        news: news,
                        onBookmarkTap: () => handleBookmarkTap(news),
                      ),
                    );
                  },
                  firstPageProgressIndicatorBuilder: (context) =>
                      const CustomProgressIndicator(),
                  newPageProgressIndicatorBuilder: (context) =>
                      const CustomProgressIndicator(),
                  noItemsFoundIndicatorBuilder: (context) => const NoNewsItem(),
                  firstPageErrorIndicatorBuilder: (context) => Padding(
                    padding: EdgeInsets.all(context.cMediumValue),
                    child: CustomErrorWidget(
                      errorMsg:
                          pagingState.error?.toString() ??
                          StringConstants.errorOccurred,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
