import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/data/model/news_model.dart';
import 'package:flutter_news_app/feature/category_news/view/category_news_view.dart';
import 'package:flutter_news_app/feature/category_news/view_model/category_news_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// CATEGORY NEWS MIXIN
mixin CategoryNewsMixin on ConsumerState<CategoryNewsView> {
  late String selectedCategoryId;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.category.id ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedCategoryId.isNotEmpty) {
        ref
            .read(categoryNewsViewModelProvider(selectedCategoryId).notifier)
            .fetchNextPage();
      }
    });
  }

  /// HANDLE CATEGORY CHANGE
  void onCategoryChanged(String newCategoryId) {
    if (selectedCategoryId == newCategoryId) return;

    setState(() => selectedCategoryId = newCategoryId);

    /// FETCH ONLY IF DATA NOT LOADED
    final currentState = ref.read(categoryNewsViewModelProvider(newCategoryId));
    if (currentState.pages == null || currentState.pages!.isEmpty) {
      ref
          .read(categoryNewsViewModelProvider(newCategoryId).notifier)
          .fetchNextPage();
    }
  }

  /// HANDLE BOOKMARK TAP
  Future<void> handleBookmarkTap(NewsModel news) async {
    if (news.id == null) return;

    await ref
        .read(categoryNewsViewModelProvider(selectedCategoryId).notifier)
        .toogleSaveButton(
          newsId: news.id!,
          currentStatus: news.isSaved ?? false,
        );
  }
}
