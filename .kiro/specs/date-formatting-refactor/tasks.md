# Implementation Plan

- [x] 1. Prepare ViewModels with date formatting helpers





  - Add `_formatNewsDates` helper method to HomeViewModel
  - Add `_formatCategoryNewsDates` helper method to HomeViewModel
  - Add `_formatNewsDates` helper method to CategoryNewsViewModel
  - These methods will use `TimeUtils.formatNewsDate` to transform raw dates
  - _Requirements: 1.2, 3.1, 3.2_

- [ ]* 1.1 Write property test for ViewModel date formatting
  - **Property 2: ViewModel formats dates for presentation**
  - **Validates: Requirements 1.2, 3.1, 3.2, 3.3**

- [x] 2. Refactor NewsRepository to return raw dates





  - Remove `TimeUtils.formatNewsDate` call from `fetchNews` method
  - Remove date formatting from `fetchNewsByCategory` method
  - Remove date formatting from `fetchCategoriesWithNews` method
  - Repository should now return NewsModel with raw ISO 8601 dates
  - _Requirements: 1.1, 2.1, 2.2, 2.3_

- [ ]* 2.1 Write property test for Repository raw dates
  - **Property 1: Repository returns raw dates**
  - **Validates: Requirements 1.1, 2.2**

- [ ]* 2.2 Write unit tests for Repository raw date behavior
  - Test `fetchNews` returns raw ISO dates
  - Test `fetchNewsByCategory` returns raw ISO dates
  - Test `fetchCategoriesWithNews` returns raw ISO dates
  - Verify Repository does NOT call `TimeUtils.formatNewsDate`
  - _Requirements: 1.1, 2.2_

- [x] 3. Update HomeViewModel to format dates





  - Integrate `_formatNewsDates` into `fetchLastNews` method
  - Integrate `_formatCategoryNewsDates` into `fetchLastNews` method
  - Integrate `_formatNewsDates` into `fetchPersonalizedNews` method
  - Integrate `_formatCategoryNewsDates` into `fetchPersonalizedNews` method
  - Format dates before updating state with AsyncValue.data
  - _Requirements: 1.2, 3.1, 3.2, 3.3_

- [ ]* 3.1 Write unit tests for HomeViewModel formatting
  - Test `fetchLastNews` formats dates correctly
  - Test `fetchPersonalizedNews` formats dates correctly
  - Test state contains formatted dates after fetch
  - Mock Repository to return raw dates
  - _Requirements: 1.2, 3.2, 3.3_

- [x] 4. Update CategoryNewsViewModel to format dates




  - Integrate `_formatNewsDates` into `fetchNextPage` method
  - Format dates before updating pagination state
  - Ensure formatted dates are added to pages list
  - _Requirements: 1.2, 3.1, 3.2, 3.3_

- [ ]* 4.1 Write unit tests for CategoryNewsViewModel formatting
  - Test `fetchNextPage` formats dates correctly
  - Test pagination state contains formatted dates
  - Mock Repository to return raw dates
  - _Requirements: 1.2, 3.2, 3.3_

- [x] 5. Verify cache stores raw dates




  - Review NewsCacheService to ensure it stores raw NewsModel data
  - Verify cache retrieval returns raw dates (no changes needed, just verification)
  - _Requirements: 1.3, 2.3_

- [ ]* 5.1 Write property test for cache raw date storage
  - **Property 3: Cache stores and retrieves raw dates**
  - **Validates: Requirements 1.3, 2.3, 4.2**

- [ ]* 5.2 Write integration tests for cache flow
  - Test API → Repository → Cache → Repository → ViewModel flow
  - Test offline scenario: Cache → Repository → ViewModel
  - Verify dates are raw in cache, formatted in ViewModel state
  - _Requirements: 1.3, 4.3_

- [ ] 6. Checkpoint - Ensure all tests pass




  - Ensure all tests pass, ask the user if questions arise.

- [ ]* 7. Regression testing
  - Run all existing tests to ensure no breaking changes
  - Verify UI displays dates in same format as before
  - Test refresh functionality works correctly
  - Test offline/cache scenarios work correctly
  - _Requirements: 4.1, 4.3, 4.4, 4.5_
