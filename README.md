# 🛍️ Qodera Demo App

A professional Flutter e-commerce application demonstrating clean architecture principles, BLoC state management, and modern UI/UX design patterns.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 📱 Screenshots

| Home Screen | Search | Product  |
|-------------|--------|-----------------|
| ![Home](screenshots/home.png) | ![Search](screenshots/search.png) | ![Details](screenshots/details.png) |


## ✨ Features

### 🎯 Core Features
- **Product Browsing** - View all products with rich details
- **Smart Search** - Real-time API-based product search with debouncing
- **Categories** - Browse products by categories
- **Image Carousel** - Auto-playing featured products slider


### 🏗️ Technical Features
- **Clean Architecture** - Separation of concerns with 3 layers
- **BLoC Pattern** - Predictable state management
- **Dependency Injection** - Using GetIt for loose coupling
- **API Integration** - Retrofit + Dio for type-safe networking
- **Offline Support** - Cached network images
- **Pull to Refresh** - Manual data refresh capability
- **Error Handling** - Comprehensive error states with retry mechanism
- **Responsive Design** - Adaptive UI for different screen sizes

## 🏛️ Architecture

This project follows **Clean Architecture** principles with three distinct layers:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (BLoC, Widgets, Pages)                │
├─────────────────────────────────────────┤
│         Domain Layer                    │
│  (Entities, Use Cases, Repositories)   │
├─────────────────────────────────────────┤
│         Data Layer                      │
│  (Models, Data Sources, API)           │
└─────────────────────────────────────────┘
```

### 📁 Project Structure

```
lib/
├── core/
│   ├── constants/          # API endpoints and app constants
│   ├── di/                 # Dependency injection setup
│   ├── error/              # Error handling and failures
│   └── theme/              # App colors and themes
├── data/
│   ├── datasources/        # Remote data sources (API clients)
│   ├── models/             # Data models with JSON serialization
│   └── repositories/       # Repository implementations
├── domain/
│   ├── entities/           # Business logic entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
├── presentation/
│   ├── bloc/               # BLoC state management
│   ├── pages/              # App screens
│   └── widgets/            # Reusable UI components
└── main.dart               # App entry point

test/
├── unit/                   # Unit tests for business logic
├── widget/                 # Widget tests for UI components
└── integration/            # Integration tests for full flows
```


## 🧪 Testing

The project includes comprehensive testing:

### Run All Tests
```bash
flutter test
```

### Run Specific Test Suites
```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test integration_test/
```



### Test Breakdown
- ✅ **3 Unit Tests** - Repository, Use Cases, BLoC logic
- ✅ **1 Widget Test** - Search bar with debouncing
- ✅ **1 Integration Test** - Full user flow

## 📡 API Integration

This app uses the **DummyJSON API** for demo purposes:

### Endpoints Used
- `GET /products` - Fetch all products
- `GET /products/search?q={query}` - Search products
- `GET /products/categories` - Get all categories

### API Base URL
```
https://dummyjson.com
```


## 🔧 Configuration

### API Configuration
Edit `lib/core/constants/api_constants.dart`:
```dart
class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  static const String products = '/products';
  static const String search = '/products/search';
  static const String categories = '/products/categories';
}
```






</div>
