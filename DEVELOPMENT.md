# 🛠️ Development Guide

## 📋 Development Setup

### **1. Environment Setup**

#### **Prerequisites**
```bash
# Flutter SDK (3.24.5+)
flutter doctor -v

# Firebase CLI
firebase --version

# Git
git --version
```

#### **IDE Setup**
- **VS Code**: Install Flutter extension
- **Android Studio**: Install Flutter and Dart plugins

### **2. Project Structure**

```
lib/
├── core/                      # Core functionalities
│   ├── error/                # Exception handling
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/              # Network services
│   │   ├── network_info.dart
│   │   ├── sync_service.dart
│   │   └── compression_service.dart
│   ├── theme/                # Material 3 theming
│   │   ├── app_theme.dart
│   │   ├── dark_theme.dart
│   │   ├── light_theme.dart
│   │   └── theme_constants.dart
│   ├── utils/                # Utility functions
│   │   ├── constants.dart
│   │   ├── helpers.dart
│   │   └── validators.dart
│   ├── usecases/             # Use cases
│   │   └── usecase.dart
│   └── widgets/              # Shared widgets
│       ├── custom_app_bar.dart
│       ├── loading_widget.dart
│       └── error_widget.dart
├── features/                 # Feature modules
│   ├── auth/                 # Authentication
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── firebase_auth_datasource.dart
│   │   │   │   └── local_auth_datasource.dart
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       └── check_auth_status_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── splash_page.dart
│   │       └── widgets/
│   ├── admin/                # Admin features
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── admin_dashboard_page.dart
│   │       └── widgets/
│   │           ├── admin_dashboard_card.dart
│   │           ├── admin_stats_widget.dart
│   │           └── admin_recent_orders_widget.dart
│   ├── distributor/          # Distributor features
│   │   └── presentation/
│   │       └── pages/
│   │           └── distributor_dashboard_page.dart
│   ├── customer/             # Customer features
│   │   └── presentation/
│   │       └── pages/
│   │           └── customer_dashboard_page.dart
│   └── products/             # Product management
├── services/                 # External services
│   ├── firebase_service.dart
│   ├── local_storage_service.dart
│   ├── sync_service.dart
│   ├── notification_service.dart
│   ├── language_service.dart
│   └── injection_container.dart
├── data/                     # Local data management
│   ├── models/               # Hive data models
│   ├── adapters/             # Hive type adapters
│   └── repositories/         # Local data repositories
│       ├── user_repository.dart
│       ├── product_repository.dart
│       └── order_repository.dart
├── routes/                   # Navigation configuration
│   └── app_router.dart
├── l10n/                     # Internationalization
│   ├── app_en.arb
│   ├── app_ur.arb
│   ├── l10n.yaml
│   └── generated/
└── main.dart                 # Entry point
```

### **3. Development Commands**

#### **Setup & Dependencies**
```bash
# Get dependencies
flutter pub get

# Clean and rebuild
flutter clean
flutter pub get

# Generate code (if needed)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Generate localization
flutter gen-l10n
```

#### **Running the App**
```bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in release mode (for testing)
flutter run --release
```

#### **Testing**
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/auth_test.dart

# Run integration tests
flutter test integration_test/
```

#### **Building**
```bash
# Build APK for Android
flutter build apk --debug
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release

# Build for iOS
flutter build ios --debug
flutter build ios --release
```

---

## 🎯 Development Workflow

### **1. Feature Development**

#### **Create New Feature**
1. **Create Feature Structure**
```bash
# Create directory structure
mkdir -p lib/features/feature_name/{data,domain,presentation}
mkdir -p lib/features/feature_name/data/{datasources,models,repositories}
mkdir -p lib/features/feature_name/domain/{entities,repositories,usecases}
mkdir -p lib/features/feature_name/presentation/{bloc,pages,widgets}
```

2. **Implement Domain Layer**
```dart
// lib/features/feature_name/domain/entities/entity.dart
class Entity {
  final String id;
  final String name;

  const Entity({
    required this.id,
    required this.name,
  });
}
```

3. **Implement Use Cases**
```dart
// lib/features/feature_name/domain/usecases/usecase.dart
class UseCase {
  final Repository repository;

  UseCase(this.repository);

  Future<Result> call(Params params) async {
    // Implementation
  }
}
```

4. **Implement Data Layer**
```dart
// lib/features/feature_name/data/repositories/repository_impl.dart
class RepositoryImpl implements Repository {
  @override
  Future<Result> execute(Params params) async {
    // Implementation
  }
}
```

5. **Implement Presentation Layer**
```dart
// lib/features/feature_name/presentation/bloc/bloc.dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  FeatureBloc() : super(InitialState()) {
    on<FeatureEvent>(_onEvent);
  }
}
```

### **2. Code Generation**

#### **BLoC Generation**
```bash
# Install BLoC extension in VS Code
# Use commands:
#   - Bloc: New Bloc
#   - Bloc: New Event
#   - Bloc: New State
```

#### **Dependency Injection**
```bash
# Generate injection configuration
flutter packages pub run build_runner build
```

### **3. Testing Strategy**

#### **Unit Tests**
```dart
// test/features/feature_name/domain/usecases/usecase_test.dart
void main() {
  group('UseCase', () {
    late UseCase useCase;
    late MockRepository mockRepository;

    setUp(() {
      mockRepository = MockRepository();
      useCase = UseCase(mockRepository);
    });

    test('should return result when repository succeeds', () async {
      // Arrange
      when(mockRepository.execute(any))
          .thenAnswer((_) async => Right(Result()));

      // Act
      final result = await useCase(Params());

      // Assert
      expect(result, Right(Result()));
    });
  });
}
```

#### **Widget Tests**
```dart
// test/features/feature_name/presentation/widgets/widget_test.dart
void main() {
  testWidgets('Widget renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Widget(),
      ),
    );

    expect(find.byType(Widget), findsOneWidget);
  });
}
```

#### **Integration Tests**
```dart
// integration_test/app_test.dart
void main() {
  integrationTestWidgetTest('App flows correctly', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Test login flow
    await tester.tap(find.byType(LoginButton));
    await tester.pumpAndSettle();

    expect(find.byType(Dashboard), findsOneWidget);
  });
}
```

---

## 🔧 Development Tools

### **1. VS Code Extensions**

#### **Recommended Extensions**
- Flutter
- Dart
- BLoC
- Flutter Widget Snippets
- GitLens
- Bracket Pair Colorizer
- Prettier
- ESLint

#### **VS Code Settings**
```json
{
  "dart.flutterSdkPath": "flutter_sdk_path",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "dart.debugExternalLibraries": false,
  "dart.debugSdkLibraries": false
}
```

### **2. Flutter DevTools**

#### **Install and Use**
```bash
# Install dev tools
flutter pub global activate devtools

# Run dev tools
flutter pub global run devtools
```

#### **Features**
- Performance profiling
- Memory analysis
- Widget inspector
- Network inspector
- Logging

### **3. Debugging**

#### **Common Debugging Commands**
```dart
// Print statements
debugPrint('Debug message: $variable');

// Assertion debugging
assert(condition, 'Error message');

// Flutter Inspector
// Use in VS Code: Flutter: Open Flutter Inspector

// Logging
import 'package:logger/logger.dart';
final logger = Logger();
logger.d('Debug message');
```

---

## 📏 Code Standards

### **1. Dart Style Guide**

#### **Naming Conventions**
```dart
// Classes: PascalCase
class UserManager {}

// Variables and methods: camelCase
final String userName = 'john';
void getUserInfo() {}

// Constants: SCREAMING_SNAKE_CASE
const String API_URL = 'https://api.example.com';

// Private members: prefix with underscore
String _privateVariable;
void _privateMethod() {}
```

#### **File Organization**
```dart
// Imports: group and sort
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/custom_widget.dart';
import '../services/api_service.dart';
```

### **2. BLoC Pattern Guidelines**

#### **Event Naming**
```dart
// Use descriptive event names
class LoadUsersEvent {}
class AddUserEvent {
  final User user;
  AddUserEvent(this.user);
}
```

#### **State Management**
```dart
// Use immutable states
abstract class UserState extends Equatable {}

class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final List<User> users;
  UserLoaded(this.users);
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
}
```

### **3. Widget Guidelines**

#### **Widget Structure**
```dart
class CustomWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CustomWidget({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
```

#### **Responsive Design**
```dart
// Use flutter_screenutil
Container(
  padding: EdgeInsets.all(16.w),
  child: Text(
    'Responsive Text',
    style: TextStyle(fontSize: 16.sp),
  ),
)
```

---

## 🔄 Git Workflow

### **1. Branching Strategy**

#### **Main Branches**
- `main`: Production-ready code
- `develop`: Integration branch
- `feature/feature-name`: Feature development
- `hotfix/bug-fix`: Emergency fixes

#### **Commit Messages**
```bash
# Format: type(scope): description
feat(auth): add user login functionality
fix(products): resolve image upload issue
docs(readme): update installation instructions
style(ui): improve button styling
refactor(bloc): optimize state management
test(auth): add unit tests for login
```

### **2. Pull Request Process**

#### **PR Checklist**
- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] Documentation updated
- [ ] No sensitive data committed
- [ ] Feature is complete and tested

#### **PR Template**
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project guidelines
- [ ] Self-review completed
- [ ] Documentation updated
```

---

## 🚀 Performance Optimization

### **1. Widget Performance**

#### **Use Const Constructors**
```dart
const MyApp({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return const Text('Hello'); // Use const when possible
}
```

#### **Optimize Rebuilds**
```dart
// Use const widgets
const Icon(Icons.add);

// Use proper keys
ListView.builder(
  key: const ValueKey('product_list'),
  itemBuilder: (context, index) {
    return ProductItem(
      key: ValueKey(products[index].id),
      product: products[index],
    );
  },
);
```

### **2. Firebase Optimization**

#### **Efficient Queries**
```dart
// Good: Limited queries
FirebaseFirestore.instance
  .collection('products')
  .where('category', isEqualTo: 'Electronics')
  .limit(20)
  .get();

// Bad: Query entire collection
FirebaseFirestore.instance
  .collection('products')
  .get();
```

#### **Caching Strategy**
```dart
// Cache frequently accessed data
await _localStorageService.cacheData(
  'products',
  products,
  expiration: Duration(hours: 1),
);
```

### **3. Image Optimization**

#### **Image Compression**
```dart
final compressedImage = await flutter_image_compress.compressFile(
  imageFile.path,
  minWidth: 800,
  minHeight: 600,
  quality: 85,
);
```

---

## 🔍 Debugging & Troubleshooting

### **1. Common Issues**

#### **Authentication Issues**
```dart
// Check auth state
final user = FirebaseAuth.instance.currentUser;
if (user == null) {
  debugPrint('User not authenticated');
}

// Check custom claims
final idTokenResult = await user.getIdTokenResult();
final role = idTokenResult.claims?['role'];
```

#### **Network Issues**
```dart
// Check connectivity
var connectivityResult = await Connectivity().checkConnectivity();
if (connectivityResult == ConnectivityResult.none) {
  debugPrint('No internet connection');
}
```

#### **State Management Issues**
```dart
// Log BLoC states
BlocProvider(
  create: (context) => MyBloc()..add(LoadDataEvent()),
  child: BlocBuilder<MyBloc, MyState>(
    builder: (context, state) {
      debugPrint('Current state: $state');
      return YourWidget(state);
    },
  ),
);
```

### **2. Debugging Tools**

#### **Flutter Inspector**
```bash
# Open inspector
flutter run --debug
# Then in VS Code: Flutter: Open Flutter Inspector
```

#### **Console Debugging**
```dart
// Enable debug mode
bool debugMode = !kReleaseMode;

if (debugMode) {
  print('Debug info: $variable');
}
```

---

## 📚 Learning Resources

### **Official Documentation**
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language](https://dart.dev/guides)
- [Firebase Flutter](https://firebase.flutter.dev/)

### **Best Practices**
- [Flutter Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [BLoC Library](https://bloclibrary.dev/)
- [Material 3](https://m3.material.io/)

### **Community**
- [Flutter Discord](https://discord.gg/flutter)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Reddit r/FlutterDev](https://www.reddit.com/r/FlutterDev/)

---

## 🔄 Continuous Integration

### **1. GitHub Actions**

#### **Example Workflow**
```yaml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.5'

    - name: Install dependencies
      run: flutter pub get

    - name: Run tests
      run: flutter test

    - name: Build APK
      run: flutter build apk --debug
```

### **2. Code Quality**

#### **Linting**
```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    prefer_single_quotes: true
    sort_constructors_first: true
    sort_unnamed_constructors_first: true
```

---

## 📝 Development Checklist

### **Before Committing**
- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] No debug prints left in code
- [ ] Sensitive data removed
- [ ] Documentation updated
- [ ] Performance considerations addressed

### **Before Release**
- [ ] All features tested
- [ ] UI responsive on different devices
- [ ] Performance optimized
- [ ] Security reviewed
- [ ] Documentation complete
- [ ] Error handling robust

---

**Happy Development! 🚀**