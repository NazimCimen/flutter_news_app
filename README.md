# Flutter News Application

> Mytech Case Study - News App

## 🔧 Demo

**[Ekran Kaydı İzle](https://www.youtube.com/watch?v=BY_4ADRsGyI)**

https://www.youtube.com/watch?v=BY_4ADRsGyI

## Proje Hakkında

Bu proje, Mytech Teknoloji Yazılım Anonim Şirketi
 iş başvurusu kapsamında geliştirilmiştir,

### 🔧 Temel Özellikler

**Kimlik Doğrulama Sistemi**
- JWT tabanlı güvenli authentication
- Email validasyonu ve şifre güvenlik kontrolleri
- Secure storage ile token yönetimi

**Kaynak Yönetimi**
- Dinamik kaynak arama ve filtreleme
- Çoklu kaynak seçimi
- Kalıcı kullanıcı tercihleri

**Haber Akışı**
- Kategori bazlı haber listeleme
- Haber Favorileme
- "Son Haberler" ve "Sana Özel" filtreleri

**Kategori Detay Sayfası**
- Infinite scroll pagination implementasyonu
- Kategori bazlı filtreleme
- Liste render optimizasyonu

**Twitter Entegrasyonu**
- Popüler tweet akışı
- Kişiselleştirilmiş tweet önerileri
- Infinite scroll pagination

**Cache Mekanizması**
- 1 saatlik Hive cache implementasyonu


### 🔧 Bonus Özellikler

Case kapsamında istenen temel gereksinimlere ek olarak aşağıdaki özellik eklemeleri yapılmıştır:

**Tema Sistemi**
- Material Design 3 implementasyonu
- Light/Dark mode desteği
- Dinamik renk şemaları
- Kalıcı tema tercihi

**Çoklu Dil Desteği (i18n)**
- İngilizce ve Türkçe dil desteği
- easy_localization ile runtime dil değiştirme

**Unit Testing**
- Mockito ile mock-based testing

**CI Pipeline**
- GitHub Actions workflow
- Otomatik test execution


### 🔧 Ek Teknik Tercihler ve Yaklaşımlar

Case kapsamında belirtilen mimari ve teknik gereksinimler birebir uygulanmıştır. Bununla birlikte, uygulamanın performansı, sürdürülebilirliği ve kod kalitesini artırmak amacıyla aşağıdaki teknik tercihler yapılmıştır:

**Kod Kalitesi & Statik Analiz**
- Proje genelinde `very_good_analysis` kuralları uygulanarak okunabilirlik, maintainability ve best practice uyumu sağlanmıştır.

**Görsel Performans**
- Haber görsellerinde `cached_network_image` kullanılarak:
  - Tekrarlı network istekleri azaltılmış
  - Scroll performansı iyileştirilmiş
  - Image loading kaynaklı jank riskleri minimize edilmiştir

**Pagination & UI Optimizasyonu**
- Infinite scroll kullanılan ekranlarda:
  - Liste render optimizasyonlarına dikkat edilmiştir
  - Gereksiz rebuild’ler önlenmiştir
  - Scroll sırasında jank ve FPS düşüşlerini engellemeye yönelik yapılar tercih edilmiştir

**Source Arama ve Takip Yönetimi**
- Source verileri uygulama başlangıcında belleğe alındığı için:
  - Arama işlemleri lokal bellek üzerinden gerçekleştirilmiştir
  - Bu nedenle source search endpoint’i bilinçli olarak kullanılmamıştır
- Source follow / unfollow işlemlerinde:
  - Tekil endpoint’ler yerine bulk endpoint tercih edilmiştir
  - Network çağrı sayısı azaltılarak daha verimli bir veri akışı sağlanmıştır

**Kategori Verilerinin Yönetimi**
- Kategoriler uygulama başlangıcında yüklenmiş ve uygulama lifecycle’ı boyunca bellekte tutulmuştur.
- Bu tercih:
  - Source–Category eşleşmeleri
  - Kategori bazlı haber listeleme  
  senaryolarında tekrar eden API çağrılarını önlemek amacıyla yapılmıştır.

**Authentication & Token Yönetimi**
- JWT tabanlı authentication sürecinde:
  - Token güvenli şekilde saklanmış
  - Geçerlilik süresi kontrol edilmiştir
  - Dio interceptor üzerinden token yönetimi sağlanarak kullanıcıya yansıtılmadan güvenli ve şeffaf bir auth akışı oluşturulmuştur


## Ekran Görüntüleri

### Dark Mode
<table>
  <tr>
    <td><img src="assets/screenshots/dark_1.png" width="200"/></td>
    <td><img src="assets/screenshots/dark_2.png" width="200"/></td>
    <td><img src="assets/screenshots/dark_3.png" width="200"/></td>
    <td><img src="assets/screenshots/dark_4.png" width="200"/></td>
  </tr>
  <tr>
    <td align="center">Giriş</td>
    <td align="center">Kayıt</td>
    <td align="center">Kaynak Seçimi</td>
    <td align="center">Ana Sayfa</td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="assets/screenshots/dark_5.png" width="200"/></td>
    <td><img src="assets/screenshots/dark_6.png" width="200"/></td>
    <td><img src="assets/screenshots/dark_7.png" width="200"/></td>
  </tr>
  <tr>
    <td align="center">Kategori Detay</td>
    <td align="center">Twitter Akışı</td>
    <td align="center">Drawer</td>
  </tr>
</table>
### Light Mode
<table>
  <tr>
    <td><img src="assets/screenshots/light_1.png" width="200"/></td>
    <td><img src="assets/screenshots/light_2.png" width="200"/></td>
    <td><img src="assets/screenshots/light_3.png" width="200"/></td>
    <td><img src="assets/screenshots/light_4.png" width="200"/></td>
  </tr>
  <tr>
    <td align="center">Giriş</td>
    <td align="center">Kayıt</td>
    <td align="center">Kaynak Seçimi</td>
    <td align="center">Ana Sayfa</td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="assets/screenshots/light_5.png" width="200"/></td>
    <td><img src="assets/screenshots/light_6.png" width="200"/></td>
    <td><img src="assets/screenshots/light_7.png" width="200"/></td>
  </tr>
  <tr>
    <td align="center">Kategori Detay</td>
    <td align="center">Twitter Akışı</td>
    <td align="center">Drawer</td>
  </tr>
</table>




## 🔧 Mimari Yapı

### MVVM Pattern Implementation

Proje, MVVM (Model-View-ViewModel) VE Repository pattern mimarisi üzerine kurulmuştur.Separation of concerns prensipleri uygulanarak test edilebilir bir altyapı oluşturulmuştur.

```
lib/
├── app/
│   ├── common/              # Proje genelinde ortak kullanılan ui bileşenleri
│   │   ├── components/      # Snackbar, dialog gibi UI componentleri
│   │   ├── decorations/     # Input decoration'lar
│   │   ├── helpers/         # Date formatter, utility fonksiyonlar
│   │   └── widgets/         # Custom button, error widget, progress indicator
│   ├── config/
│   │   ├── localization/    # Dil dosyaları ve string constant'ları
│   │   ├── routes/          # GoRouter konfigürasyonu
│   │   └── theme/           # Tema yönetimi ve renk şemaları
│   └── data/
│       ├── data_source/
│       │   ├── local/       # Hive cache, secure storage
│       │   └── remote/      # API service implementasyonları
│       ├── model/           # JSON serializable data modeller
│       ├── repository/      # Repository pattern implementasyonları
├── core/
│   ├── connection/          # Network connectivity checker
│   ├── error/               # Custom exception ve failure sınıfları
│   ├── init/                # App initialization logic
│   ├── network/             # Dio configuration, interceptor'lar
│   └── utils/               # Validator'lar, extension'lar, enum'lar
└── feature/
    ├── auth/                # Authentication feature module
    │   ├── mixin/           # Login/Signup mixin'leri
    │   ├── view/            # UI screens
    │   ├── view_model/      # Auth state management
    │   └── widgets/         # Feature-specific widget'lar
    ├── category_news/       # Kategori detay feature
    ├── home/                # Ana sayfa feature
    ├── layout/              # App layout ve bottom navigation
    ├── profile/             # Kullanıcı profil yönetimi
    ├── sources/             # Kaynak seçimi feature
    ├── splash/              # Splash screen
    └── twitter/             # Twitter feed feature
```

### Katman Ayrımı ve Data Flow

```
┌─────────────────────────────────────────────────────────┐
│                 Presentation Layer                      │
│                  (Views & Widgets)                      │
│  - ConsumerWidget/StatefulWidget                        │
│  - UI rendering ve user interaction                     │
└────────────────────┬────────────────────────────────────┘
                     │ ref.watch() / ref.read()
                     ▼
┌─────────────────────────────────────────────────────────┐
│                   ViewModel Layer                       │
│              (Riverpod StateNotifiers)                  │
│  - State management                                     │
│  - Business logic orchestration                         │
│  - UI state transformation                              │
└────────────────────┬────────────────────────────────────┘
                     │ Repository calls
                     ▼
┌─────────────────────────────────────────────────────────┐
│                   Repository Layer                      │
│  - Business logic implementation                        │
│  - Data source coordination                             │
│  - Error handling ve transformation                     │
│  - Either<Failure, Success> pattern                     │
└────────────────────┬────────────────────────────────────┘
                     │ Service calls
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  Data Source Layer                      │
│  - API communication (Dio)                              │
│  - Local storage (Hive, SharedPreferences)              │
│  - Secure storage (FlutterSecureStorage)                │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  External Services                      │
│  - REST API                                             │
│  - Local Database                                       │
│  - Cache Storage                                        │
└─────────────────────────────────────────────────────────┘
```


## Kurulum ve Çalıştırma

**1. Repository'yi klonlayın**
```bash
git clone https://github.com/YOUR_USERNAME/flutter_news_app.git
cd flutter_news_app
```

**2. Bağımlılıkları yükleyin**
```bash
flutter pub get
```

**3. Code generation çalıştırın**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**4. Environment variables ayarlayın**

Proje root dizininde `.env` dosyası oluşturun:
```env
API_KEY=test-api-key
```

**5. Uygulamayı çalıştırın**
```bash
flutter run
```

### Test Çalıştırma

```bash
# Tüm testleri çalıştır
flutter test
```





