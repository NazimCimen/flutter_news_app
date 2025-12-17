# Implementation Plan

- [x] 1. Refactor TwitterViewModel with abstract base class





  - In `lib/feature/twitter/view_model/twitter_view_model.dart`, create abstract `TwitterViewModelBase` class
  - Define abstract methods: `fetchNextPage()`, `refresh()`
  - Modify `TwitterViewModel` to extend `TwitterViewModelBase`
  - Implement pagination logic with concurrent request prevention
  - Implement last page detection based on response size
  - Update provider to reference `TwitterViewModelBase` type
  - _Requirements: 1.1, 2.1, 2.2, 2.3, 2.4, 2.5_

- [ ]* 1.1 Write property test for pagination state consistency
  - **Property 1: Pagination state consistency**
  - **Validates: Requirements 2.1**

- [ ]* 1.2 Write property test for refresh resets state
  - **Property 2: Refresh resets state**
  - **Validates: Requirements 2.2**

- [ ]* 1.3 Write property test for last page detection
  - **Property 3: Last page detection**
  - **Validates: Requirements 2.3**

- [ ]* 1.4 Write property test for pagination error handling
  - **Property 4: Pagination error handling**
  - **Validates: Requirements 2.4**

- [ ]* 1.5 Write property test for concurrent request prevention
  - **Property 5: Concurrent request prevention**
  - **Validates: Requirements 2.5**

- [x] 2. Refactor CategoryNewsViewModel with abstract base class





  - In `lib/feature/category_news/view_model/category_news_view_model.dart`, create abstract `CategoryNewsViewModelBase` class
  - Define abstract methods: `fetchNextPage()`, `refresh()`, `toggleSaveButton()`
  - Modify `CategoryNewsViewModel` to extend `CategoryNewsViewModelBase`
  - Implement pagination logic with concurrent request prevention
  - Implement optimistic save/unsave with rollback on failure
  - Keep date formatting logic in concrete implementation
  - Update provider to reference `CategoryNewsViewModelBase` type
  - _Requirements: 1.1, 2.1, 2.2, 2.3, 2.4, 2.5, 4.1, 4.2, 4.3, 4.4, 4.5_

- [ ]* 2.1 Write property test for optimistic update timing
  - **Property 9: Optimistic update timing**
  - **Validates: Requirements 4.1**

- [ ]* 2.2 Write property test for optimistic update rollback
  - **Property 10: Optimistic update rollback**
  - **Validates: Requirements 4.2**

- [ ]* 2.3 Write property test for save success persistence
  - **Property 11: Save success persistence**
  - **Validates: Requirements 4.3**

- [ ]* 2.4 Write property test for targeted item update
  - **Property 12: Targeted item update**
  - **Validates: Requirements 4.4**

- [ ]* 2.5 Write property test for update isolation
  - **Property 13: Update isolation**
  - **Validates: Requirements 4.5**

- [ ] 3. Create date formatting utility functions
  - Create `lib/core/utils/view_model_utils.dart` file
  - Implement `formatNewsDates(List<NewsModel>)` function
  - Implement `formatCategoryNewsDates(List<CategoryWithNewsModel>)` function
  - Handle null and invalid dates gracefully
  - Preserve all non-date properties during formatting
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

- [ ]* 3.1 Write property test for date formatting consistency
  - **Property 14: Date formatting consistency**
  - **Validates: Requirements 5.1**

- [ ]* 3.2 Write property test for complete list formatting
  - **Property 15: Complete list formatting**
  - **Validates: Requirements 5.2**

- [ ]* 3.3 Write property test for nested date formatting
  - **Property 16: Nested date formatting**
  - **Validates: Requirements 5.3**

- [ ]* 3.4 Write property test for date formatting preservation
  - **Property 17: Date formatting preservation**
  - **Validates: Requirements 5.5**

- [x] 4. Refactor HomeViewModel with abstract base class





  - In `lib/feature/home/view_model/home_view_model.dart`, create abstract `HomeViewModelBase` class
  - Define abstract methods: `fetchLastNews()`, `fetchPersonalizedNews()`, `toggleSaveButton()`
  - Modify `HomeViewModel` to extend `HomeViewModelBase`
  - Replace date formatting logic with utility functions from `view_model_utils.dart`
  - Implement optimistic save/unsave with rollback on failure
  - Update provider to reference `HomeViewModelBase` type
  - _Requirements: 1.1, 3.1, 3.2, 3.3, 4.1, 4.2, 4.3, 4.4, 4.5, 5.1, 5.2, 5.3_

- [ ]* 4.1 Write property test for async loading state transition
  - **Property 6: Async loading state transition**
  - **Validates: Requirements 3.1**

- [ ]* 4.2 Write property test for async success state
  - **Property 7: Async success state**
  - **Validates: Requirements 3.2**

- [ ]* 4.3 Write property test for async error state
  - **Property 8: Async error state**
  - **Validates: Requirements 3.3**

- [x] 5. Refactor SelectSourcesViewModel with abstract base class





  - In `lib/feature/sources/view_model/select_sources_view_model.dart`, create abstract `SelectSourcesViewModelBase` class
  - Define abstract methods: `search()`, `toggleFollow()`, `saveSelection()`
  - Modify `SelectSourcesViewModel` to extend `SelectSourcesViewModelBase`
  - Implement async loading patterns with proper error handling
  - Keep search and toggleFollow logic in concrete implementation
  - Update provider to reference `SelectSourcesViewModelBase` type
  - _Requirements: 1.1, 3.1, 3.2, 3.3_

- [ ] 6. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 7. Add documentation comments to all view models
  - Add dartdoc comments to all abstract base classes
  - Document abstract method contracts and expected behavior
  - Add usage examples in comments
  - Document the pattern for future view models
  - _Requirements: 1.1, 1.2, 1.3_
