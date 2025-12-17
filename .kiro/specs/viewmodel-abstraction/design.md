# Design Document: ViewModel Abstraction

## Overview

This design introduces abstract base classes for view models in the Flutter news application using the Riverpod state management library. The abstraction layer will reduce code duplication across SelectSourcesViewModel, CategoryNewsViewModel, HomeViewModel, and TwitterViewModel by extracting common patterns into reusable base classes.

The design follows the StateNotifier pattern from Riverpod and introduces two primary abstract classes:
- `BasePaginatedViewModel<T>` for view models handling infinite scroll pagination
- `BaseAsyncViewModel<T>` for view models handling async data with loading states

## Architecture

### Class Hierarchy

Each view model file will contain both the abstract base class and concrete implementation in the same file, following the pattern used in `auth_view_model.dart`:

```
// In category_news_view_model.dart
CategoryNewsViewModelBase (abstract) extends StateNotifier<PagingState<int, NewsModel>>
    └── CategoryNewsViewModel (concrete)

// In twitter_view_model.dart  
TwitterViewModelBase (abstract) extends StateNotifier<PagingState<int, TweetModel>>
    └── TwitterViewModel (concrete)

// In select_sources_view_model.dart
SelectSourcesViewModelBase (abstract) extends StateNotifier<AsyncValue<List<SourceModel>>>
    └── SelectSourcesViewModel (concrete)

// In home_view_model.dart
HomeViewModelBase (abstract) extends StateNotifier<HomeState>
    └── HomeViewModel (concrete)
```

### Component Responsibilities

**Paginated ViewModel Base Classes** (CategoryNewsViewModelBase, TwitterViewModelBase)
- Define abstract methods for pagination: `fetchNextPage()`, `refresh()`
- Concrete implementations provide common pagination logic
- Manage PagingState with pages, keys, loading status, and errors
- Handle page key management, last page detection, and concurrent request prevention

**Async ViewModel Base Classes** (SelectSourcesViewModelBase, HomeViewModelBase)
- Define abstract methods for data loading and state management
- Concrete implementations handle AsyncValue state transitions
- Provide patterns for loading, error, and data states
- Support refresh and optimistic update patterns

**Common Patterns**
- Each base class defines the contract (abstract methods)
- Concrete implementation provides the business logic
- Providers reference the base class type for better abstraction
- All view models follow consistent error handling and state management

## Components and Interfaces

### CategoryNewsViewModel Pattern

```dart
// Abstract base class defining the contract
abstract class CategoryNewsViewModelBase extends StateNotifier<PagingState<int, NewsModel>> {
  CategoryNewsViewModelBase() : super(PagingState<int, NewsModel>());
  
  Future<void> fetchNextPage();
  Future<void> refresh();
  Future<void> toggleSaveButton({required String newsId, required bool currentStatus});
}

// Concrete implementation with business logic
class CategoryNewsViewModel extends CategoryNewsViewModelBase {
  final String categoryId;
  final NewsRepository _newsRepository;
  
  // Implementation of abstract methods with common patterns
}
```

### TwitterViewModel Pattern

```dart
// Abstract base class defining the contract
abstract class TwitterViewModelBase extends StateNotifier<PagingState<int, TweetModel>> {
  TwitterViewModelBase() : super(PagingState<int, TweetModel>());
  
  Future<void> fetchNextPage();
  Future<void> refresh();
}

// Concrete implementation with business logic
class TwitterViewModel extends TwitterViewModelBase {
  final bool isPopular;
  final TwitterRepository _twitterRepository;
  
  // Implementation with pagination logic
}
```

### SelectSourcesViewModel Pattern

```dart
// Abstract base class defining the contract
abstract class SelectSourcesViewModelBase extends StateNotifier<AsyncValue<List<SourceModel>>> {
  SelectSourcesViewModelBase() : super(const AsyncValue.loading());
  
  void search(String query);
  void toggleFollow(String sourceId);
  Future<void> saveSelection();
}

// Concrete implementation with business logic
class SelectSourcesViewModel extends SelectSourcesViewModelBase {
  final SourcesRepository _sourcesRepository;
  List<SourceModel> _allSources = [];
  
  // Implementation with async patterns
}
```

### HomeViewModel Pattern

```dart
// Abstract base class defining the contract
abstract class HomeViewModelBase extends StateNotifier<HomeState> {
  HomeViewModelBase() : super(const HomeState());
  
  Future<void> fetchLastNews({bool forceRefresh = false});
  Future<void> fetchPersonalizedNews({bool forceRefresh = false});
  Future<void> toggleSaveButton({required String newsId, required bool currentStatus});
}

// Concrete implementation with business logic
class HomeViewModel extends HomeViewModelBase {
  final NewsRepository _newsRepository;
  
  // Implementation with state management
}
```

## Data Models

### PagingState

The existing `PagingState<K, T>` class will be used as-is:

```dart
class PagingState<K, T> {
  final List<List<T>>? pages;
  final List<K>? keys;
  final bool hasNextPage;
  final bool isLoading;
  final String? error;
}
```

### AsyncValue

Using Riverpod's built-in `AsyncValue<T>` which handles:
- `AsyncValue.loading()` - Loading state
- `AsyncValue.data(T value)` - Success state with data
- `AsyncValue.error(Object error, StackTrace stackTrace)` - Error state

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Pagination state consistency

*For any* paginated view model, after fetching a page successfully, the number of pages in state should equal the number of keys in state
**Validates: Requirements 2.1**

### Property 2: Refresh resets state

*For any* paginated view model, calling refresh should reset pages and keys to empty lists before fetching the first page
**Validates: Requirements 2.2**

### Property 3: Last page detection

*For any* paginated view model and page size, when a fetched page contains fewer items than the page size, hasNextPage should be set to false
**Validates: Requirements 2.3**

### Property 4: Pagination error handling

*For any* paginated view model, when a fetch operation fails, the error message should be stored in state and isLoading should be false
**Validates: Requirements 2.4**

### Property 5: Concurrent request prevention

*For any* paginated view model, when fetchNextPage is called while isLoading is true, the state should remain unchanged
**Validates: Requirements 2.5**

### Property 6: Async loading state transition

*For any* async view model, when loadData is called, the state should be in loading state before the async operation completes
**Validates: Requirements 3.1**

### Property 7: Async success state

*For any* async view model, when data fetch succeeds, the state should be AsyncValue.data containing the fetched data
**Validates: Requirements 3.2**

### Property 8: Async error state

*For any* async view model, when data fetch fails, the state should be AsyncValue.error containing the error message
**Validates: Requirements 3.3**

### Property 9: Optimistic update timing

*For any* saveable news item, when toggleSave is called, the UI state should update before the API call completes
**Validates: Requirements 4.1**

### Property 10: Optimistic update rollback

*For any* saveable news item, when toggleSave fails, the item's isSaved status should revert to its original value
**Validates: Requirements 4.2**

### Property 11: Save success persistence

*For any* saveable news item, when toggleSave succeeds, the item's isSaved status should remain in the updated state
**Validates: Requirements 4.3**

### Property 12: Targeted item update

*For any* news ID and collection of news items, when updating save status, only the item with matching ID should be modified
**Validates: Requirements 4.4**

### Property 13: Update isolation

*For any* collection of news items, when updating save status for one item, all other items should remain unchanged
**Validates: Requirements 4.5**

### Property 14: Date formatting consistency

*For any* date string, formatting it multiple times should always produce the same result
**Validates: Requirements 5.1**

### Property 15: Complete list formatting

*For any* list of news items, after formatting dates, all items in the list should have formatted dates
**Validates: Requirements 5.2**

### Property 16: Nested date formatting

*For any* list of category news, after formatting, all nested news items should have formatted dates
**Validates: Requirements 5.3**

### Property 17: Date formatting preservation

*For any* news model, formatting dates should preserve all non-date properties unchanged
**Validates: Requirements 5.5**

## Error Handling

### Pagination Errors
- Network failures: Store error message in PagingState.error, set isLoading to false
- Empty responses: Treat as last page, set hasNextPage to false
- Concurrent requests: Silently ignore subsequent requests while loading

### Async Data Errors
- Network failures: Update state to AsyncValue.error with failure message
- Repository errors: Propagate error through Either<Failure, T> pattern
- Null data: Handle gracefully with null-safe operators

### Save/Unsave Errors
- API failures: Revert optimistic UI update to original state
- Network timeouts: Show error but maintain UI consistency
- Invalid news IDs: Log error, no state change

## Testing Strategy

### Unit Testing

Unit tests will verify specific examples and edge cases:

- Empty page responses set hasNextPage to false
- Null or invalid news IDs in toggleSave are handled gracefully
- Error messages are properly stored in state
- State transitions follow expected patterns (loading → data/error)

### Property-Based Testing

Property-based tests will verify universal properties using the `test` package with custom generators. Each test will run a minimum of 100 iterations.

**Testing Framework**: Dart's built-in `test` package with custom property-based testing utilities

**Property Test Implementation**:
- Create generators for: PagingState, AsyncValue, NewsModel, page responses
- Each property test will be tagged with its corresponding design property number
- Tests will use random data generation to verify properties hold across all inputs
- Minimum 100 iterations per property test to ensure statistical confidence

**Test Organization**:
- Property tests in `test/view_model/base_view_model_properties_test.dart`
- Unit tests in `test/view_model/base_view_model_test.dart`
- Integration tests for concrete implementations in respective feature test files

## Implementation Notes

### Migration Strategy

1. Create abstract base classes without modifying existing view models
2. Migrate one view model at a time (start with TwitterViewModel as it's simplest)
3. Run existing tests after each migration to ensure no regressions
4. Update remaining view models once pattern is validated

### Backward Compatibility

- Existing view model providers remain unchanged
- Public APIs of view models stay the same
- Only internal implementation changes to extend base classes

### Performance Considerations

- No additional overhead from abstraction (compile-time polymorphism)
- Reduced code size from eliminated duplication
- Improved maintainability without runtime cost
