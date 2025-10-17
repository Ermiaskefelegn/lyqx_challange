# Fake Store App

A Flutter e-commerce application built with Clean Architecture, BLoC state management, and Dependency Injection.

## Features

- **Authentication**: Login with Fake Store API credentials
- **Product Listing**: Browse products with lazy loading pagination
- **Product Details**: View detailed product information
- **Cart Management**: Add/remove products, update quantities
- **Wishlist**: Save favorite products locally
- **Navigation**: Smooth navigation with GoRouter

## Architecture

This project follows **Clean Architecture** principles with three main layers:

### Domain Layer
- Entities: Core business objects (Product, User, CartItem)
- Repositories: Abstract interfaces for data operations
- Use Cases: Business logic encapsulation

### Data Layer
- Models: Data transfer objects
- Data Sources: Remote (API) and Local (SharedPreferences)
- Repository Implementations: Concrete implementations of domain repositories

### Presentation Layer
- BLoC: State management for each feature
- Screens: UI pages
- Widgets: Reusable UI components

## Tech Stack

- **Flutter**: UI framework
- **BLoC**: State management
- **Injectable & Get_it**: Dependency injection
- **Dio**: HTTP client for API calls
- **GoRouter**: Declarative routing
- **SharedPreferences**: Local storage
- **Cached Network Image**: Image caching

## API

This app uses the [Fake Store API](https://fakestoreapi.com/).

### Test Credentials

- **Username**: johnd
- **Password**: m38rmF$

## Setup Instructions

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extension

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate dependency injection code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App and API constants
│   ├── di/             # Dependency injection setup
│   ├── network/        # Dio client configuration
│   ├── router/         # GoRouter configuration
│   └── utils/          # Utilities and helpers
├── data/
│   ├── datasources/    # Remote and local data sources
│   ├── models/         # Data models
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Business use cases
└── presentation/
    ├── auth/           # Authentication feature
    ├── products/       # Product listing feature
    ├── product_details/# Product details feature
    ├── cart/           # Shopping cart feature
    └── wishlist/       # Wishlist feature
```

## Features Implemented

### 1. Authentication
- Login with username and password validation
- Show/hide password functionality
- Persistent authentication with SharedPreferences
- Auto-logout functionality

### 2. Product Listing
- Fetch products from Fake Store API
- Display product name, image, price, and rating
- Lazy loading with infinite scroll
- Pull-to-refresh functionality
- Add products to wishlist from listing

### 3. Product Details
- Full product description
- Category information
- Rating and review count
- Add to cart functionality
- Wishlist toggle

### 4. Cart Management
- Add/remove products
- Update product quantity
- Calculate total price
- Persistent cart storage
- Visual feedback for actions

### 5. Wishlist (Optional)
- Add/remove products from wishlist
- View all wishlist items
- Add wishlist items to cart
- Persistent storage with SharedPreferences

## State Management

Each feature has its own BLoC for state management:

- **AuthBloc**: Authentication state
- **ProductsBloc**: Product listing with pagination
- **CartBloc**: Shopping cart operations
- **WishlistBloc**: Wishlist management

## Design

The app follows a modern, clean design with:
- Neutral color scheme (primary: #1E232C)
- Consistent spacing and typography
- Smooth transitions
- Responsive layout
- Material Design principles

## Testing

Run tests:
```bash
flutter test
```

## Building

Build APK:
```bash
flutter build apk --release
```

Build iOS:
```bash
flutter build ios --release
```
