# Mobile App For Shops

A Flutter mobile application designed for shop/retail management with offline-first capabilities and cloud synchronization.

## Features

- **Cross-Platform Support**: iOS 11.0+ and Android 5.0+ (API 21+)
- **Offline-First Architecture**: Works seamlessly offline with local SQLite database
- **Cloud Sync**: Automatic synchronization with Firebase Firestore when online
- **Real-Time Updates**: Real-time data synchronization powered by Firebase
- **Authentication**: Email/password authentication via Firebase Auth
- **State Management**: Provider-based state management for clean architecture

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── config/                            # Configuration files
│   ├── app_config.dart               # App-wide configuration
│   ├── firebase_config.dart          # Firebase initialization
│   └── routes.dart                   # Navigation routes
├── models/                            # Data models
│   ├── base_model.dart               # Base model class
│   ├── user.dart                     # User model
│   └── shop.dart                     # Shop model
├── services/                          # Business logic services
│   ├── auth_service.dart             # Authentication service
│   ├── firestore_service.dart        # Firestore operations
│   ├── sqlite_service.dart           # SQLite operations
│   ├── sync_service.dart             # Data synchronization
│   └── connectivity_service.dart     # Network monitoring
├── providers/                         # State management (Provider)
│   ├── auth_provider.dart            # Auth state
│   ├── connectivity_provider.dart    # Connectivity state
│   ├── data_provider.dart            # Shared data state
│   └── sync_provider.dart            # Sync status state
├── views/                             # UI layer
│   ├── screens/                      # Screen widgets
│   │   ├── splash_screen.dart        # Splash/initialization screen
│   │   ├── login_screen.dart         # Login screen
│   │   ├── signup_screen.dart        # Sign-up screen
│   │   ├── home_screen.dart          # Home/dashboard screen
│   │   └── settings_screen.dart      # Settings screen
│   └── widgets/                      # Reusable components
│       ├── custom_button.dart        # Custom button widget
│       ├── custom_text_field.dart    # Custom text input widget
│       ├── error_dialog.dart         # Error dialog widget
│       └── loading_widget.dart       # Loading indicator widget
├── utils/                             # Utility functions
│   ├── constants.dart                # App constants
│   ├── validators.dart               # Input validators
│   ├── logger.dart                   # Logging utility
│   └── extensions.dart               # Dart extension methods
└── exceptions/                        # Custom exception classes
    ├── auth_exception.dart           # Auth-related exceptions
    ├── db_exception.dart             # Database exceptions
    └── sync_exception.dart           # Sync-related exceptions
```

## Setup Instructions

### Prerequisites

- Flutter SDK >= 3.13.0
- Dart SDK >= 3.0.0
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Mobile_App_For_Shops
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project in Firebase Console
   - Register iOS app (bundle ID: `com.shops.mobile_app`)
   - Register Android app (package name: `com.shops.mobile_app`)
   - Download `GoogleService-Info.plist` and place in `ios/Runner/`
   - Download `google-services.json` and place in `android/app/`
   - Enable Firebase Authentication (Email/Password)
   - Create Firestore database with appropriate security rules

4. **Environment Setup**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Database Strategy

### Offline-First Approach
- **SQLite**: Local database for offline data storage
- **Firestore**: Cloud database for real-time sync and multi-device support
- **Sync Service**: Automatically syncs data when connectivity is available

### Collections in Firestore
- `users/` - User profiles
- `shops/` - Shop/store information
- `items/` - Products/inventory
- `orders/` - Order records

## Authentication

Email/password authentication via Firebase Authentication:
- User sign-up with email validation
- Secure password storage
- Password reset functionality
- Persistent session management

## State Management

Using the Provider package for clean separation of concerns:
- `AuthProvider`: Manages user authentication state
- `ConnectivityProvider`: Monitors network connectivity
- `DataProvider`: Manages shared application data
- `SyncProvider`: Tracks synchronization status

## Development

### Running Tests
```bash
flutter test
```

### Building Release
```bash
flutter build apk        # Android
flutter build ios        # iOS
```

### Linting
```bash
flutter analyze
dart fix --apply
```

## Configuration

See `.env.example` for environment variable configuration.

## Next Steps

1. Implement Firebase authentication logic in `auth_service.dart`
2. Implement Firestore CRUD operations in `firestore_service.dart`
3. Implement SQLite sync strategies in `sync_service.dart`
4. Design and implement home/dashboard screen
5. Add comprehensive error handling
6. Add unit and widget tests
7. Polish UI/UX
8. Prepare for production deployment

## License

MIT License

## Support

For issues or questions, please open an issue in the repository.
