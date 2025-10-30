# Mobile App For Shops - Complete Setup Guide

This is a fully functional Flutter mobile application for shop management with offline-first capabilities and cloud synchronization.

## Features Implemented

- ✅ **User Authentication** - Firebase Auth with email/password
- ✅ **Shop Management** - Create, read, update, delete shops
- ✅ **Inventory Management** - Full product/item management
- ✅ **Order Management** - Create and manage orders with status tracking
- ✅ **Offline-First Architecture** - SQLite for local storage
- ✅ **Cloud Sync** - Automatic sync with Firestore when online
- ✅ **Real-Time Connectivity** - Automatic detection and handling
- ✅ **Provider State Management** - Clean architecture with Provider
- ✅ **Material Design 3** - Modern UI with Material Design principles
- ✅ **Complete Error Handling** - Comprehensive error messages and dialogs
- ✅ **Data Validation** - Input validation for all forms
- ✅ **Responsive UI** - Works on phones and tablets

## Prerequisites

Before you start, make sure you have:

1. **Flutter SDK** - Version 3.13.0 or higher
   - [Install Flutter](https://flutter.dev/docs/get-started/install)

2. **Dart SDK** - Version 3.0.0 or higher
   - Included with Flutter

3. **Firebase Project**
   - Create one at [Firebase Console](https://console.firebase.google.com)

4. **Development Tools**
   - For Android: Android Studio or Android SDK
   - For iOS: Xcode (Mac only)
   - Code editor: VS Code, Android Studio, or IntelliJ

## Step 1: Firebase Setup

### 1.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Enter your project name
4. Enable Google Analytics (optional)
5. Click "Create project"

### 1.2 Register Apps

#### Android App

1. In Firebase Console, click the Android icon
2. Enter package name: `com.shops.mobile_app`
3. (Optional) Enter SHA-1 certificate fingerprint
4. Click "Register app"
5. Download `google-services.json`
6. Place it in: `android/app/google-services.json`

#### iOS App

1. In Firebase Console, click the iOS icon
2. Enter bundle ID: `com.shops.mobile_app`
3. Click "Register app"
4. Download `GoogleService-Info.plist`
5. Place it in: `ios/Runner/GoogleService-Info.plist`

### 1.3 Enable Firebase Services

#### Authentication

1. In Firebase Console, go to Authentication
2. Click "Get Started"
3. Click "Email/Password"
4. Enable both "Email/Password" and "Email link (passwordless sign-in)"
5. Save

#### Firestore Database

1. In Firebase Console, go to Firestore Database
2. Click "Create database"
3. Select "Start in production mode"
4. Choose your region
5. Click "Create"

#### Update Security Rules

1. In Firestore, go to "Rules"
2. Replace with:

```rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 1.4 Create Firestore Collections

Create these collections in Firestore:
- `users` - User profiles
- `shops` - Shop/store data
- `items` - Products/inventory
- `orders` - Order records

Each collection can start empty; documents are created by the app.

## Step 2: Local Setup

### 2.1 Clone Repository

```bash
git clone <repository-url>
cd Mobile_App_For_Shops
```

### 2.2 Install Dependencies

```bash
flutter pub get
```

### 2.3 Configure Environment

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` and add your Firebase credentials:
- `FIREBASE_PROJECT_ID` - From Firebase Project Settings
- `FIREBASE_API_KEY` - From Firebase Project Settings

### 2.4 Platform-Specific Configuration

#### Android

Edit `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 33  // or higher

    defaultConfig {
        targetSdkVersion 33  // or higher
        minSdkVersion 21
    }
}
```

#### iOS

Edit `ios/Podfile`:

Uncomment this line:
```ruby
platform :ios, '11.0'
```

Run:
```bash
cd ios
pod install
cd ..
```

## Step 3: Run the App

### Development

```bash
# Run on connected device
flutter run

# Run on Android emulator
flutter run -d emulator-5554

# Run on iOS simulator
flutter run -d iPhone-14
```

### Build for Release

#### Android

```bash
flutter build apk --release
```

Output: `build/app/outputs/apk/release/app-release.apk`

#### iOS

```bash
flutter build ios --release
```

## Step 4: Using the App

### Authentication

1. **Sign Up**
   - Launch app → Tap "Sign Up"
   - Enter email and password (minimum 8 characters with uppercase, lowercase, numbers)
   - Confirm password
   - Accept terms and conditions
   - Tap "Create Account"

2. **Login**
   - Enter registered email and password
   - Tap "Log In"

3. **Password Reset**
   - Tap "Forgot Password?" on login screen
   - Enter your email
   - Check email for reset link

### Shop Management

1. **View Shops**
   - From home, tap "My Shops"
   - See all your shops

2. **Create Shop**
   - Tap the "+" button
   - Fill in shop details (name, address, city)
   - Tap "Add"

3. **Edit Shop**
   - Tap shop in list
   - Tap menu (three dots) → "Edit"
   - Update details
   - Tap "Save"

4. **Delete Shop**
   - Tap shop in list
   - Tap menu (three dots) → "Delete"
   - Confirm deletion

### Inventory Management

1. **View Inventory**
   - From home, tap "Inventory"
   - Select a shop first if needed
   - See all products

2. **Add Product**
   - Tap the "+" button
   - Fill in product details:
     - Item Name
     - Price
     - Quantity
     - Description (optional)
   - Tap "Add"

3. **Edit Product**
   - Tap product in list
   - Tap menu (three dots) → "Edit"
   - Update details
   - Tap "Save"

4. **Delete Product**
   - Tap product in list
   - Tap menu (three dots) → "Delete"
   - Confirm deletion

### Order Management

1. **View Orders**
   - From home, tap "Orders"
   - Select a shop first if needed
   - See all orders sorted by newest first

2. **View Order Details**
   - Tap order in list
   - Tap menu (three dots) → "View"
   - See all items, total, and customer info

3. **Update Order Status**
   - Tap order in list
   - Tap menu (three dots) → "Update Status"
   - Select new status:
     - Pending
     - Confirmed
     - Processing
     - Shipped
     - Delivered

4. **Order Statuses**
   - **Pending** - Order received
   - **Confirmed** - Order confirmed
   - **Processing** - Being prepared
   - **Shipped** - In transit
   - **Delivered** - Delivered to customer

### Profile Management

1. **View Profile**
   - From home, tap profile icon (person)
   - See your account information

2. **Change Password**
   - Tap "Change Password"
   - Enter your email
   - Click "Send"
   - Check email for reset link

3. **Log Out**
   - Tap "Log Out"
   - Confirm logout

## Offline & Sync Features

### How Offline Works

1. All data is automatically saved locally on your device using SQLite
2. When you're offline (no internet):
   - You can still view all previously downloaded data
   - You can still create and edit data locally
   - Changes are queued for sync when back online
3. When you come back online:
   - App automatically syncs changes
   - See notification at the top (cloud icon)
4. Look at connectivity indicator at top of home screen:
   - Green cloud = Connected
   - Red cloud = Offline

### Testing Offline Mode

1. **Toggle Airplane Mode**
   - Android: Swipe down, tap airplane mode
   - iOS: Control Center → Airplane mode
   - App continues to work with cached data

2. **Make Changes Offline**
   - Create a shop
   - Add products
   - All changes saved locally

3. **Turn Internet Back On**
   - App automatically syncs
   - Green cloud indicator confirms sync

## Troubleshooting

### App Won't Start

1. **Check Flutter installation**
   ```bash
   flutter doctor
   ```

2. **Rebuild the app**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Firebase Connection Issues

1. **Verify Firebase config files**
   - Android: `android/app/google-services.json` exists
   - iOS: `ios/Runner/GoogleService-Info.plist` exists

2. **Check Firebase rules**
   - Go to Firestore → Rules
   - Ensure rules allow authenticated reads/writes

3. **Verify API keys**
   - Firebase Console → Project Settings
   - Copy correct API key to `.env`

### Login Problems

1. **User not found**
   - Sign up for new account first
   - Ensure email is correct

2. **Wrong password**
   - Use "Forgot Password" to reset
   - Check for caps lock

3. **Too many login attempts**
   - Wait a few minutes
   - Try again

### Data Not Syncing

1. **Check connectivity**
   - Make sure you're online
   - Check green cloud indicator

2. **Restart app**
   ```bash
   flutter run
   ```

3. **Check Firestore**
   - Go to Firebase Console → Firestore
   - Manually add test data to verify connection

### Database Issues

1. **Clear local database**
   ```bash
   adb shell "rm -r /data/data/com.shops.mobile_app/databases" # Android
   # iOS: Settings → App Settings → Mobile App For Shops → Clear Data
   ```

2. **Rebuild database**
   - Restart app
   - Data will sync from Firestore

## Development

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── config/                   # Configuration
├── models/                   # Data models
├── services/                 # Business logic
├── providers/                # State management
├── views/                    # UI screens and widgets
└── utils/                    # Utilities
```

### Adding New Features

1. **Create Model** → `lib/models/`
2. **Create Service** → `lib/services/`
3. **Create Provider** → `lib/providers/`
4. **Create Screen** → `lib/views/screens/`
5. **Add Routes** → `lib/main.dart`

### Testing Changes

```bash
# Run with hot reload
flutter run

# Run specific device
flutter run -d <device-id>

# List available devices
flutter devices

# Run with verbose logging
flutter run -v
```

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
dart format lib/

# Fix issues
dart fix --apply

# Run tests
flutter test
```

## Build & Deployment

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/apk/release/app-release.apk`

### iOS

```bash
flutter build ios --release
```

Requires Apple Developer account for distribution.

### Play Store

1. Create Google Play Developer account
2. Configure app signing
3. Build app bundle: `flutter build appbundle --release`
4. Upload to Play Store Console

### App Store

1. Create Apple Developer account
2. Configure provisioning profiles
3. Build: `flutter build ios --release`
4. Use Xcode or Transporter to upload

## Performance Tips

1. **Reduce Firestore reads**
   - Use offline mode when possible
   - Batch operations

2. **Optimize database**
   - Delete old completed orders periodically
   - Archive old data

3. **Monitor sync**
   - Check sync indicator
   - View pending changes

4. **Manage storage**
   - Clear old data if storage is low
   - Use sync before clearing

## Security Notes

1. **Never commit**
   - Firebase config files
   - API keys in code
   - `.env` file with real credentials

2. **Firestore Rules**
   - Current rules allow all authenticated users to read/write
   - For production, implement proper access control

3. **Data Validation**
   - All inputs are validated
   - Passwords stored securely by Firebase

## Support & Issues

For issues or questions:

1. Check troubleshooting section above
2. Review Firebase Console for errors
3. Check app logs:
   ```bash
   flutter run -v
   ```
4. Check Firestore:
   - Go to Firebase Console
   - Review collection data
   - Check security rules

## License

MIT License - See LICENSE file

## Next Steps

After getting the app running:

1. Customize branding (colors, app name, icon)
2. Add more product categories
3. Implement payment integration
4. Add reporting/analytics
5. Expand to more platforms (web, desktop)

Happy selling! 🚀
