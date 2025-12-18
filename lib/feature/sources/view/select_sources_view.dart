import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';
import 'package:flutter_news_app/app/config/routes/app_routes.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/core/utils/size/padding_extension.dart';
import 'package:flutter_news_app/app/common/widgets/custom_button.dart';
import 'package:flutter_news_app/feature/sources/view_model/select_sources_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_news_app/app/data/model/source_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter_news_app/app/common/decorations/custom_input_decoration.dart';
import 'package:flutter_news_app/feature/splash/splash_view.dart';
part '../widgets/source_tile.dart';
part '../widgets/sources_list_view.dart';
part '../widgets/sources_search_bar.dart';

class SelectSourcesView extends ConsumerStatefulWidget {
  const SelectSourcesView({super.key});

  @override
  ConsumerState<SelectSourcesView> createState() => _SelectSourcesViewState();
}

class _SelectSourcesViewState extends ConsumerState<SelectSourcesView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    ref.read(selectSourcesViewModelProvider.notifier).search(query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sourcesAsync = ref.watch(selectSourcesViewModelProvider);

    ref.listen(selectSourcesViewModelProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        if (previous == null ||
            !previous.hasError ||
            previous.error != next.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.error.toString())));
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          StringConstants.selectSourcesTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: context.cPaddingMedium,
        child: Column(
          children: [
            /// SEARCH BAR
            _SourcesSearchBar(controller: _searchController),

            SizedBox(height: context.cMediumValue),

            /// CONTENT AREA (LOADING / ERROR / LIST)
            const Expanded(child: _SourcesListView()),

            SizedBox(height: context.cMediumValue),

            /// SAVE BUTTON
            CustomButtonWidget(
              text: StringConstants.saveButton,
              onPressed: () async {
                await ref
                    .read(selectSourcesViewModelProvider.notifier)
                    .saveSelection();
                if (context.mounted &&
                    !ref.read(selectSourcesViewModelProvider).hasError) {
                  context.go(AppRoutes.mainLayout);
                }
              },
              isLoading: sourcesAsync.isLoading,
            ),
            SizedBox(height: context.cMediumValue),
          ],
        ),
      ),
    );
  }
}
