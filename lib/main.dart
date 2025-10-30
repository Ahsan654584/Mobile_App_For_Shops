import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/firebase_config.dart';
import 'config/routes.dart';
import 'config/app_config.dart';
import 'providers/auth_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/data_provider.dart';
import 'providers/sync_provider.dart';
import 'services/auth_service.dart';
import 'services/connectivity_service.dart';
import 'services/firestore_service.dart';
import 'services/sqlite_service.dart';
import 'services/sync_service.dart';
import 'utils/constants.dart';
import 'views/screens/splash_screen.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/signup_screen.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/settings_screen.dart';
import 'views/screens/profile_screen.dart';
import 'views/screens/shops_screen.dart';
import 'views/screens/inventory_screen.dart';
import 'views/screens/orders_screen.dart';
import 'views/screens/shop_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseConfig.initialize();

  // Initialize services
  final sqliteService = SQLiteService();
  await sqliteService.initialize();

  final firestoreService = FirestoreService();
  firestoreService.initialize();

  final authService = AuthService();
  authService.initialize();

  final connectivityService = ConnectivityService();
  connectivityService.initialize();

  final syncService = SyncService();
  syncService.initialize(
    connectivityService: connectivityService,
    sqliteService: sqliteService,
    firestoreService: firestoreService,
  );
  syncService.startSyncListener();

  runApp(
    MultiProvider(
      providers: [
        // Services
        Provider<AuthService>(create: (_) => authService),
        Provider<SQLiteService>(create: (_) => sqliteService),
        Provider<FirestoreService>(create: (_) => firestoreService),
        Provider<ConnectivityService>(create: (_) => connectivityService),
        Provider<SyncService>(create: (_) => syncService),
        // Providers
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider(
            connectivityService: connectivityService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DataProvider(
            firestoreService: firestoreService,
            sqliteService: sqliteService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SyncProvider(
            syncService: syncService,
            connectivityService: connectivityService,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: _buildLightTheme(),
      home: const SplashScreen(),
      routes: {
        Routes.splash: (_) => const SplashScreen(),
        Routes.login: (_) => const LoginScreen(),
        Routes.signup: (_) => const SignupScreen(),
        Routes.home: (_) => const HomeScreen(),
        Routes.settings: (_) => const SettingsScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/shops': (_) => const ShopsScreen(),
        '/inventory': (_) => const InventoryScreen(),
        '/orders': (_) => const OrdersScreen(),
        '/shop-detail': (_) => const ShopDetailScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }

  /// Build light theme
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppConstants.textTertiaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppConstants.textTertiaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppConstants.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(
            color: AppConstants.errorColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: AppTextStyles.bodyMedium,
        hintStyle: AppTextStyles.bodySmall,
        errorStyle: AppTextStyles.bodySmall.copyWith(
          color: AppConstants.errorColor,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
        ),
      ),
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      cardColor: AppConstants.surfaceColor,
      dividerColor: AppConstants.backgroundColor,
    );
  }
}
