import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/common/widgets/custom_error_widget.dart';
import 'package:flutter_news_app/common/widgets/custom_progress_indicator.dart';
import 'package:flutter_news_app/core/utils/color_utils.dart';
import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter_news_app/feature/category_news/viewmodel/category_news_view_model.dart';
import 'package:flutter_news_app/feature/home/widgets/no_news_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/providers/categories_cache_notifier.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/data/model/category_model.dart';
import 'package:flutter_news_app/data/model/news_model.dart';
import 'package:flutter_news_app/feature/category_news/widget/category_news_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
part '../widget/app_bar.dart';
part '../widget/category_filters.dart';

class CategoryNewsView extends ConsumerStatefulWidget {
  final CategoryModel category;

  const CategoryNewsView({required this.category, super.key});

  @override
  ConsumerState<CategoryNewsView> createState() => _CategoryNewsViewState();
}

class _CategoryNewsViewState extends ConsumerState<CategoryNewsView> {
  late String _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.category.id ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedCategoryId.isNotEmpty) {
        ref
            .read(categoryNewsViewModelProvider(_selectedCategoryId).notifier)
            .fetchNextPage();
      }
    });
  }

  void _onCategoryChanged(String newCategoryId) {
    if (_selectedCategoryId != newCategoryId) {
      setState(() {
        _selectedCategoryId = newCategoryId;
      });
      ref.read(categoryNewsViewModelProvider(newCategoryId).notifier).refresh();
    }
  }

  Future<void> _handleBookmarkTap(NewsModel news) async {
    if (news.id == null) return;

    await ref
        .read(categoryNewsViewModelProvider(_selectedCategoryId).notifier)
        .toogleSaveButton(
          newsId: news.id!,
          currentStatus: news.isSaved ?? false,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final pagingState = _selectedCategoryId.isNotEmpty
        ? ref.watch(categoryNewsViewModelProvider(_selectedCategoryId))
        : PagingState<int, NewsModel>();

    return Scaffold(
      appBar: const _AppBar(),
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (_selectedCategoryId.isNotEmpty) {
              await ref
                  .read(
                    categoryNewsViewModelProvider(_selectedCategoryId).notifier,
                  )
                  .refresh();
            }
          },
          child: CustomScrollView(
            slivers: [
              // Category filters as sliver
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _CategoryFilters(
                      selectedCategoryId: _selectedCategoryId,
                      onCategoryChanged: _onCategoryChanged,
                    ),
                    SizedBox(height: context.cMediumValue),
                  ],
                ),
              ),

              // News list with pagination
              PagedSliverList<int, NewsModel>(
                state: pagingState,
                fetchNextPage: () {
                  if (_selectedCategoryId.isNotEmpty) {
                    ref
                        .read(
                          categoryNewsViewModelProvider(
                            _selectedCategoryId,
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
                        onBookmarkTap: () => _handleBookmarkTap(news),
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
