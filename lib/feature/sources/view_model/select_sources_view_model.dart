import 'package:flutter_news_app/app/data/repository/sources_repository.dart';
import 'package:flutter_news_app/app/data/model/source_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// SELECT SOURCES VIEW MODEL
final selectSourcesViewModelProvider =
    StateNotifierProvider<
      SelectSourcesViewModelBase,
      AsyncValue<List<SourceModel>>
    >((ref) {
      return SelectSourcesViewModel(
        sourcesRepository: ref.read(sourcesRepositoryProvider),
      );
    });

/// ABSTRACT BASE CLASS for SelectSourcesViewModel
abstract class SelectSourcesViewModelBase
    extends StateNotifier<AsyncValue<List<SourceModel>>> {
  SelectSourcesViewModelBase() : super(const AsyncValue.loading());

  /// SEARCH SOURCES BY QUERY STRING
  void search(String query);

  /// TOGGLE FOLLOW STATUS FOR A SOURCE
  void toggleFollow(String sourceId);

  /// SAVE THE CURRENT SELECTION TO THE REPOSITORY
  Future<void> saveSelection();
}

class SelectSourcesViewModel extends SelectSourcesViewModelBase {
  final SourcesRepository _sourcesRepository;

  List<SourceModel> _allSources = [];

  SelectSourcesViewModel({required SourcesRepository sourcesRepository})
    : _sourcesRepository = sourcesRepository {
    _init();
  }

  Future<void> _init() async {
    state = const AsyncValue.loading();

    final sourcesResult = await _sourcesRepository.fetchSources();
    final followedResult = await _sourcesRepository.fetchFollowedSources();

    sourcesResult.fold(
      (failure) {
        state = AsyncValue.error(failure.errorMessage, StackTrace.current);
      },
      (sources) {
        followedResult.fold(
          (failure) {
            state = AsyncValue.error(failure.errorMessage, StackTrace.current);
          },
          (followedSources) {
            final followedIds = followedSources
                .map((e) => e.id)
                .whereType<String>()
                .toSet();

            final mergedSources = sources.map((source) {
              final isFollowed = followedIds.contains(source.id);

              return source.copyWith(isFollowed: isFollowed);
            }).toList();

            _allSources = mergedSources;
            state = AsyncValue.data(mergedSources);
          },
        );
      },
    );
  }

  @override
  void search(String query) {
    if (query.isEmpty) {
      state = AsyncValue.data(_allSources);
      return;
    }
    final filteredSources = _allSources.where((source) {
      final nameLower = source.name?.toLowerCase() ?? '';
      final descriptionLower = source.description?.toLowerCase() ?? '';
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower) ||
          descriptionLower.contains(queryLower);
    }).toList();
    state = AsyncValue.data(filteredSources);
  }

  @override
  void toggleFollow(String sourceId) {
    state.whenData((currentSources) {
      final sourceIndex = currentSources.indexWhere((s) => s.id == sourceId);
      if (sourceIndex == -1) return;

      final source = currentSources[sourceIndex];
      final newStatus = !(source.isFollowed ?? false);

      final updatedSources = List<SourceModel>.from(currentSources);
      updatedSources[sourceIndex] = source.copyWith(isFollowed: newStatus);

      state = AsyncValue.data(updatedSources);

      final cacheIndex = _allSources.indexWhere((s) => s.id == sourceId);
      if (cacheIndex != -1) {
        _allSources[cacheIndex] = _allSources[cacheIndex].copyWith(
          isFollowed: newStatus,
        );
      }
    });
  }

  @override
  Future<void> saveSelection() async {
    final currentSources = state.valueOrNull;
    if (currentSources == null) return;

    final allUpdates = currentSources
        .map((s) => {'sourceId': s.id, 'isFollowed': s.isFollowed ?? false})
        .toList();

    state = const AsyncValue<List<SourceModel>>.loading().copyWithPrevious(
      AsyncData(currentSources),
    );

    final result = await _sourcesRepository.bulkFollow(allUpdates);

    result.fold(
      (failure) {
        state = AsyncValue<List<SourceModel>>.error(
          failure.errorMessage,
          StackTrace.current,
        ).copyWithPrevious(AsyncData(currentSources));
      },
      (_) {
        state = AsyncValue.data(currentSources);
      },
    );
  }
}
