import 'package:flutter_news_app/app/data/repository/sources_repository.dart';
import 'package:flutter_news_app/app/data/model/source_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectSourcesViewModelProvider =
    StateNotifierProvider<
      SelectSourcesViewModelBase,
      AsyncValue<List<SourceModel>>
    >((ref) {
      return SelectSourcesViewModel(
        sourcesRepository: ref.read(sourcesRepositoryProvider),
      );
    });

/// Abstract base class for SelectSourcesViewModel
/// Defines the contract for managing source selection with async loading patterns
abstract class SelectSourcesViewModelBase
    extends StateNotifier<AsyncValue<List<SourceModel>>> {
  SelectSourcesViewModelBase() : super(const AsyncValue.loading());

  /// Search sources by query string
  void search(String query);

  /// Toggle follow status for a source
  void toggleFollow(String sourceId);

  /// Save the current selection to the repository
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
    // Set loading state before async operation
    state = const AsyncValue.loading();
    
    final sourcesResult = await _sourcesRepository.fetchSources();
    final followedResult = await _sourcesRepository.fetchFollowedSources();
    
    sourcesResult.fold(
      (failure) {
        // Update state with error on failure
        state = AsyncValue.error(failure.errorMessage, StackTrace.current);
      },
      (sources) {
        followedResult.fold(
          (failure) {
            // Update state with error on failure
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
            // Update state with data on success
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

    // Set loading state while preserving previous data
    state = const AsyncValue<List<SourceModel>>.loading().copyWithPrevious(
      AsyncData(currentSources),
    );

    final result = await _sourcesRepository.bulkFollow(allUpdates);

    result.fold(
      (failure) {
        // Update state with error on failure, preserving previous data
        state = AsyncValue<List<SourceModel>>.error(
          failure.errorMessage,
          StackTrace.current,
        ).copyWithPrevious(AsyncData(currentSources));
      },
      (_) {
        // Update state with data on success
        state = AsyncValue.data(currentSources);
      },
    );
  }
}
