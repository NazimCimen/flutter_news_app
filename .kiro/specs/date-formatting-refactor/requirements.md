# Requirements Document

## Introduction

Bu özellik, haber uygulamasındaki tarih formatlama işleminin mimari katmanlar arasında yeniden konumlandırılmasını ele alır. Şu anda tarih formatlama işlemi Repository katmanında gerçekleştirilmektedir, ancak bu işlemin ViewModel katmanına taşınması presentation logic olarak daha uygun olabilir.

## Glossary

- **Repository**: Veri kaynaklarını (API, cache) yöneten ve ham veriyi sağlayan katman
- **ViewModel**: UI state'ini yöneten ve presentation logic'i içeren katman
- **TimeUtils**: Tarih formatlama yardımcı sınıfı
- **NewsModel**: Haber verisi için data model
- **Presentation Logic**: UI'a özgü veri dönüşüm ve formatlama mantığı
- **Business Logic**: Uygulamanın temel iş kuralları ve veri işleme mantığı

## Requirements

### Requirement 1

**User Story:** Bir geliştirici olarak, tarih formatlama işleminin doğru mimari katmanda yapılmasını istiyorum, böylece kod daha sürdürülebilir ve test edilebilir olur.

#### Acceptance Criteria

1. WHEN the Repository fetches news data THEN the Repository SHALL return raw date strings without formatting
2. WHEN the ViewModel receives news data THEN the ViewModel SHALL apply date formatting using TimeUtils
3. WHEN cached news is retrieved THEN the system SHALL store raw dates and format them in the ViewModel
4. WHEN multiple ViewModels use news data THEN each ViewModel SHALL independently format dates according to its presentation needs
5. WHEN date formatting logic changes THEN the system SHALL only require changes in the presentation layer

### Requirement 2

**User Story:** Bir geliştirici olarak, Repository'nin sadece veri erişimi sorumluluğuna sahip olmasını istiyorum, böylece Single Responsibility Principle'a uygun olur.

#### Acceptance Criteria

1. WHEN the Repository fetches news THEN the Repository SHALL only handle data retrieval and caching
2. WHEN the Repository returns data THEN the Repository SHALL return domain models without presentation transformations
3. WHEN the Repository caches data THEN the Repository SHALL cache raw data without formatting
4. WHEN the Repository encounters errors THEN the Repository SHALL handle only data-layer errors

### Requirement 3

**User Story:** Bir geliştirici olarak, ViewModel'in presentation logic'i içermesini istiyorum, böylece UI'a özgü dönüşümler doğru yerde yapılır.

#### Acceptance Criteria

1. WHEN the ViewModel receives news data THEN the ViewModel SHALL transform data for UI presentation
2. WHEN the ViewModel formats dates THEN the ViewModel SHALL use TimeUtils.formatNewsDate
3. WHEN the ViewModel updates state THEN the ViewModel SHALL provide formatted data to the UI
4. WHEN different views need different date formats THEN each ViewModel SHALL apply appropriate formatting

### Requirement 4

**User Story:** Bir geliştirici olarak, mevcut işlevselliğin korunmasını istiyorum, böylece kullanıcı deneyimi etkilenmez.

#### Acceptance Criteria

1. WHEN news is displayed THEN the system SHALL show the same formatted dates as before
2. WHEN news is cached THEN the system SHALL maintain cache functionality
3. WHEN network is unavailable THEN the system SHALL still display cached news with formatted dates
4. WHEN users refresh news THEN the system SHALL fetch and format dates correctly
5. WHEN the refactoring is complete THEN all existing tests SHALL pass
