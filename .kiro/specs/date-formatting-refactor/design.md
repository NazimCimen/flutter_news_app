# Design Document

## Overview

Bu tasarım, tarih formatlama işleminin Repository katmanından ViewModel katmanına taşınmasını ele alır. Mevcut implementasyonda, `NewsRepository` ham API verisini aldıktan sonra `TimeUtils.formatNewsDate()` kullanarak tarihleri formatlar ve bu formatlanmış veriyi cache'e kaydeder. Bu yaklaşım, presentation logic'in data layer'a sızmasına neden olur.

Yeni tasarımda:
- Repository katmanı ham tarihleri döndürecek ve cache'leyecek
- ViewModel katmanı tarihleri UI için formatlayacak
- Her ViewModel kendi presentation ihtiyaçlarına göre formatlama yapabilecek

## Architecture

### Current Architecture (Before)
```
API → NewsService → NewsRepository (formats dates) → Cache (formatted dates) → ViewModel → UI
```

### New Architecture (After)
```
API → NewsService → NewsRepository (raw dates) → Cache (raw dates) → ViewModel (formats dates) → UI
```

### Key Changes

1. **Repository Layer**: Sadece veri erişimi ve caching sorumluluğu
2. **ViewModel Layer**: Presentation logic ve date formatting sorumluluğu
3. **Cache Layer**: Ham tarihleri saklar, formatlanmış veri saklamaz

## Components and Interfaces

### 1. NewsRepository (Modified)

**Responsibility**: Veri erişimi ve caching

```dart
class NewsRepositoryImpl implements NewsRepository {
  @override
  Future<Either<Failure, List<NewsModel>>> fetchNews({
    bool? isLatest,
    bool? forYou,
    bool forceRefresh = false,
  }) async {
    // Check cache first (if not force refresh)
    // Fetch from API if needed
    // Cache raw data
    // Return raw NewsModel list (NO formatting)
  }
  
  @override
  Future<Either<Failure, List<NewsModel>>> fetchNewsByCategory({
    required String categoryId,
    int? page,
    int? pageSize,
  }) async {
    // Fetch from API
    // Return raw NewsModel list (NO formatting)
  }
  
  @override
  Future<Either<Failure, List<CategoryWithNewsModel>>> fetchCategoriesWithNews({
    int? page,
    int? pageSize,
    bool? isLatest,
    bool? forYou,
  }) async {
    // Fetch from API
    // Return raw CategoryWithNewsModel list (NO formatting)
  }
}
```

### 2. HomeViewModel (Modified)

**Responsibility**: State management ve presentation logic

```dart
class HomeViewModel extends StateNotifier<HomeState> {
  Future<void> fetchLastNews({bool forceRefresh = false}) async {
    // Fetch raw news from repository
    // Format dates using TimeUtils
    // Update state with formatted news
  }
  
  Future<void> fetchPersonalizedNews({bool forceRefresh = false}) async {
    // Fetch raw news from repository
    // Format dates using TimeUtils
    // Update state with formatted news
  }
  
  // Helper method for formatting
  List<NewsModel> _formatNewsDates(List<NewsModel> newsList) {
    return newsList.map((news) {
      return news.copyWith(
        publishedAt: TimeUtils.formatNewsDate(news.publishedAt),
      );
    }).toList();
  }
  
  List<CategoryWithNewsModel> _formatCategoryNewsDates(
    List<CategoryWithNewsModel> categories
  ) {
    return categories.map((category) {
      return CategoryWithNewsModel(
        category: category.category,
        news: _formatNewsDates(category.news),
      );
    }).toList();
  }
}
```

### 3. CategoryNewsViewModel (Modified)

**Responsibility**: Pagination ve presentation logic

```dart
class CategoryNewsViewModel extends StateNotifier<PagingState<int, NewsModel>> {
  Future<void> fetchNextPage() async {
    // Fetch raw news from repository
    // Format dates using TimeUtils
    // Update state with formatted news
  }
  
  // Helper method for formatting
  List<NewsModel> _formatNewsDates(List<NewsModel> newsList) {
    return newsList.map((news) {
      return news.copyWith(
        publishedAt: TimeUtils.formatNewsDate(news.publishedAt),
      );
    }).toList();
  }
}
```

### 4. NewsCacheService (No Changes)

Cache servisi değişmeyecek çünkü `NewsModel` zaten `publishedAt` field'ını string olarak tutuyor. Sadece formatlanmış değil, ham değerleri cache'leyeceğiz.

## Data Models

### NewsModel (No Changes)

```dart
class NewsModel {
  final String? publishedAt; // Raw ISO 8601 date string from API
  // ... other fields
}
```

Model değişmeyecek. `publishedAt` field'ı hem ham hem de formatlanmış değerleri tutabilir.

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property Reflection

After analyzing the acceptance criteria, several redundancies were identified:
- Properties 1.1 and 2.2 both test that Repository returns raw dates (consolidated into Property 1)
- Properties 1.2, 3.1, and 3.3 all test that ViewModel formats dates (consolidated into Property 2)
- Properties 1.4 and 3.4 are duplicates about multiple ViewModels (kept as example)
- Property 4.2 about cache functionality is covered by Property 3 (cache stores raw data)

### Core Properties

Property 1: Repository returns raw dates
*For any* news fetch operation (fetchNews, fetchNewsByCategory, fetchCategoriesWithNews), the Repository should return NewsModel instances where publishedAt contains raw ISO 8601 date strings without formatting applied
**Validates: Requirements 1.1, 2.2**

Property 2: ViewModel formats dates for presentation
*For any* news data received from Repository, the ViewModel should transform the raw publishedAt dates using TimeUtils.formatNewsDate before updating state
**Validates: Requirements 1.2, 3.1, 3.2, 3.3**

Property 3: Cache stores and retrieves raw dates
*For any* news list cached by Repository, when retrieved from cache, the publishedAt field should contain raw ISO 8601 date strings identical to what was received from the API
**Validates: Requirements 1.3, 2.3, 4.2**

### Edge Cases & Examples

Example 1: Consistent formatting after refactoring
Given a specific ISO date "2024-12-17T10:30:00Z", after the refactoring, the UI should display the same formatted string as before the refactoring
**Validates: Requirements 4.1**

Example 2: Offline cache with formatting
When network is unavailable and news is loaded from cache, the ViewModel should still format the raw cached dates correctly for display
**Validates: Requirements 4.3**

Example 3: Refresh maintains functionality
When user triggers a refresh, the system should fetch new data, cache raw dates, format in ViewModel, and display correctly
**Validates: Requirements 4.4**



## Error Handling

### Repository Layer
- Network errors: Return `ConnectionFailure` when network unavailable
- API errors: Return appropriate `Failure` types from service layer
- Cache errors: Silently handle cache failures, attempt to fetch from network
- No presentation-layer error handling

### ViewModel Layer
- Handle `Failure` types from Repository
- Convert failures to appropriate UI states (AsyncValue.error)
- Date formatting errors: If `TimeUtils.formatNewsDate` receives invalid date, return empty string (existing behavior)
- State management errors: Ensure state updates are atomic

### Backward Compatibility
- Existing error handling behavior remains unchanged
- Cache fallback mechanism preserved
- Network error messages unchanged

## Testing Strategy

### Unit Tests

**Repository Tests**:
- Test that `fetchNews` returns raw ISO dates
- Test that `fetchNewsByCategory` returns raw ISO dates
- Test that `fetchCategoriesWithNews` returns raw ISO dates
- Test cache stores raw dates
- Test cache retrieval returns raw dates
- Test that Repository does NOT call `TimeUtils.formatNewsDate`

**ViewModel Tests**:
- Test `HomeViewModel.fetchLastNews` formats dates
- Test `HomeViewModel.fetchPersonalizedNews` formats dates
- Test `CategoryNewsViewModel.fetchNextPage` formats dates
- Test formatting helper methods work correctly
- Test state contains formatted dates after fetch

**Integration Tests**:
- Test end-to-end flow: API → Repository → ViewModel → State
- Test cache flow: API → Repository → Cache → Repository → ViewModel
- Test offline scenario: Cache → Repository → ViewModel

### Property-Based Tests

We will use the `test` package with custom property testing utilities for Dart/Flutter.

**Property Test Configuration**:
- Minimum 100 iterations per property test
- Each property test tagged with format: `Feature: date-formatting-refactor, Property {number}: {property_text}`

**Property 1: Repository returns raw dates**
- Generate random news data with various ISO date formats
- Call Repository methods
- Verify all returned dates match ISO 8601 pattern (not formatted pattern)

**Property 2: ViewModel formats dates**
- Generate random raw news data
- Mock Repository to return raw data
- Call ViewModel fetch methods
- Verify state contains formatted dates (matches expected format pattern)

**Property 3: Cache round-trip preserves raw dates**
- Generate random news data with raw dates
- Save to cache via Repository
- Retrieve from cache
- Verify dates are identical (no formatting applied)

### Regression Tests
- All existing tests must pass after refactoring
- UI tests should show identical date formatting
- Performance tests should show no degradation

## Migration Strategy

### Phase 1: Preparation
1. Add helper methods to ViewModels for date formatting
2. Add tests for new ViewModel formatting behavior
3. Ensure all tests are passing before changes

### Phase 2: Repository Refactoring
1. Remove `TimeUtils.formatNewsDate` calls from `NewsRepositoryImpl.fetchNews`
2. Remove `TimeUtils.formatNewsDate` calls from `NewsRepositoryImpl.fetchNewsByCategory`
3. Remove `TimeUtils.formatNewsDate` calls from `NewsRepositoryImpl.fetchCategoriesWithNews`
4. Update Repository tests to verify raw dates

### Phase 3: ViewModel Updates
1. Add date formatting to `HomeViewModel.fetchLastNews`
2. Add date formatting to `HomeViewModel.fetchPersonalizedNews`
3. Add date formatting to `CategoryNewsViewModel.fetchNextPage`
4. Update ViewModel tests

### Phase 4: Verification
1. Run all unit tests
2. Run all property-based tests
3. Run integration tests
4. Manual UI testing to verify date display
5. Test offline/cache scenarios

### Rollback Plan
If issues are discovered:
1. Revert ViewModel changes
2. Revert Repository changes
3. All code returns to previous working state
4. Git revert commits in reverse order

## Performance Considerations

### Potential Impact
- **Positive**: Cache stores raw data (potentially smaller size)
- **Neutral**: Date formatting moved from Repository to ViewModel (same number of operations)
- **Neutral**: Formatting happens on UI thread but is lightweight operation

### Optimization Opportunities
- If performance issues arise, consider memoization of formatted dates
- Consider formatting dates lazily in UI layer instead of ViewModel
- Monitor memory usage of state with formatted vs raw dates

## Benefits of This Design

1. **Separation of Concerns**: Repository handles data, ViewModel handles presentation
2. **Testability**: Easier to test Repository without UI concerns
3. **Flexibility**: Different ViewModels can format dates differently if needed
4. **Cache Integrity**: Cache stores raw data, not presentation-specific data
5. **Single Responsibility**: Each layer has clear, focused responsibility
6. **Maintainability**: Date formatting logic changes only affect presentation layer
