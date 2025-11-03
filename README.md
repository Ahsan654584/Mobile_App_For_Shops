# Shop Management System

A modern full-stack Flutter mobile application with Firebase integration for multi-user shop management, supporting three user roles (Admin, Distributor, Customer) with role-based access control.

## Features

### 👨‍💼 Admin Features
- **Dashboard**: Overview of total products, distributors, customers, and active orders
- **Product Management**: Add, update, or delete product details with images
- **Distributor Management**: Add/remove distributors, assign regions, track sales
- **Customer Management**: View all registered customers and purchase history
- **Transaction Overview**: Track sales, pending payments, and completed transactions
- **Analytics**: Simple graphical view of product sales and stock reports
- **Notifications**: Real-time updates for low stock, new orders, and payments

### 🏪 Distributor Features
- **Dashboard**: Personalized overview of assigned products and orders
- **Product Catalog**: View available products from inventory
- **Order Management**: Place and manage customer orders
- **Order History**: Track past and active orders with status updates
- **Stock Management**: View stock levels and receive low stock alerts
- **Profile Management**: Update distributor profile and contact information

### 👥 Customer Features
- **Product Browsing**: Browse products with details, pricing, and images
- **Shopping Experience**: Add products to cart and checkout
- **Order Tracking**: Track delivery status in real-time
- **Purchase Options**: Buy products in cash or request installment-based plans
- **Profile Management**: Update profile, address, and contact information
- **Order History**: View all past and current orders

## Technical Architecture

### 🏗️ Clean Architecture
- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Repositories, data sources, and models
- **Presentation Layer**: UI components, BLoCs, and pages

### 🔥 Firebase Integration
- **Authentication**: Secure login with role-based access control
- **Firestore**: Real-time database for multi-user data
- **Storage**: Optimized image storage with compression
- **Security**: Role-based security rules and data isolation

### 🎨 Modern UI/UX
- **Material 3**: Latest Material Design system
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Dark/Light Themes**: Persistent theme switching
- **Animations**: Smooth transitions and micro-interactions
- **Multi-language**: English and Urdu support

### 📱 Cross-Platform
- **Flutter**: Latest stable SDK for iOS and Android
- **State Management**: BLoC pattern for predictable state
- **Navigation**: Go Router for type-safe navigation
- **Localization**: Built-in internationalization support

## Project Structure

```
lib/
├── core/                      # Core functionalities
│   ├── error/                # Exception handling
│   ├── network/              # Network services
│   ├── theme/                # Material 3 theming
│   ├── utils/                # Utility functions
│   └── widgets/              # Shared widgets
├── features/                 # Feature modules
│   ├── auth/                 # Authentication
│   ├── admin/                # Admin features
│   ├── distributor/          # Distributor features
│   ├── customer/             # Customer features
│   └── products/             # Product management
├── services/                 # External services
├── data/                     # Local data management
├── routes/                   # Navigation configuration
└── l10n/                     # Internationalization
```

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase account and project
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mobile_app_for_shops
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android and iOS apps to your Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place config files in appropriate directories
   - Enable Authentication, Firestore, and Storage

4. **Update Firebase Configuration**
   - Update `firebase_options.dart` with your Firebase project details
   - Configure authentication providers (Email/Password)

5. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

### Environment Variables
Update the following files with your configuration:
- `firebase_options.dart` - Firebase project settings
- `lib/core/utils/constants.dart` - App constants and settings

### User Roles
The system supports three roles:
- **admin**: Full access to all features
- **distributor**: Limited to assigned products and orders
- **customer**: Can browse products and place orders

## Development

### Code Generation
Run code generation for:
- BLoC files: `flutter packages pub run build_runner build --delete-conflicting-outputs`
- Dependency injection: `flutter packages pub run build_runner build`
- Localization: `flutter gen-l10n`

### Testing
Run tests with:
```bash
flutter test                    # Unit tests
flutter test integration/       # Integration tests
```

### Build
Build for production:
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Performance Optimizations

### Firebase Free Tier Optimization
- Efficient queries with limits and pagination
- Selective real-time listeners
- Local caching for frequently accessed data
- Image compression before upload
- Data compression for large documents

## License

This project is licensed under the MIT License.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for the backend services
- Material Design team for the design system
- The open-source community for the libraries and tools