class AppConstants {
  // App Information
  static const String appName = 'Shop Management System';
  static const String appVersion = '1.0.0';

  // API & Firebase Configuration
  static const String firebaseProjectId = 'your-project-id';
  static const String firebaseStorageBucket = 'your-project.appspot.com';

  // Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String categoriesCollection = 'categories';
  static const String notificationsCollection = 'notifications';
  static const String analyticsCollection = 'analytics';

  // User Roles
  static const String adminRole = 'admin';
  static const String distributorRole = 'distributor';
  static const String customerRole = 'customer';

  // Order Status
  static const String pendingStatus = 'pending';
  static const String inTransitStatus = 'in_transit';
  static const String deliveredStatus = 'delivered';
  static const String cancelledStatus = 'cancelled';

  // Payment Types
  static const String cashPayment = 'cash';
  static const String installmentPayment = 'installment';

  // Product Categories
  static const List<String> defaultCategories = [
    'Electronics',
    'Clothing',
    'Food & Beverages',
    'Furniture',
    'Books',
    'Toys',
    'Sports',
    'Health & Beauty',
    'Other',
  ];

  // UI Constants
  static const double borderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double smallBorderRadius = 8.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Image Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  static const double imageQuality = 0.8;

  // Cache Duration
  static const Duration defaultCacheDuration = Duration(hours: 1);
  static const Duration longCacheDuration = Duration(days: 1);
  static const Duration shortCacheDuration = Duration(minutes: 30);

  // Network Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration longTimeout = Duration(minutes: 2);
  static const Duration shortTimeout = Duration(seconds: 10);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  static const int maxSearchLength = 100;

  // Local Storage Keys
  static const String userKey = 'user_data';
  static const String tokenKey = 'auth_token';
  static const String roleKey = 'user_role';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String firstLaunchKey = 'first_launch';
  static const String lastSyncKey = 'last_sync';

  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your internet connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unauthorizedMessage = 'You are not authorized to perform this action.';
  static const String forbiddenMessage = 'Access denied. You do not have permission to access this resource.';
  static const String notFoundMessage = 'The requested resource was not found.';
  static const String timeoutMessage = 'Request timed out. Please try again.';
  static const String unknownErrorMessage = 'An unknown error occurred. Please try again.';

  // Success Messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String logoutSuccessMessage = 'Logout successful!';
  static const String profileUpdateSuccessMessage = 'Profile updated successfully!';
  static const String productAddSuccessMessage = 'Product added successfully!';
  static const String productUpdateSuccessMessage = 'Product updated successfully!';
  static const String productDeleteSuccessMessage = 'Product deleted successfully!';
  static const String orderCreateSuccessMessage = 'Order created successfully!';
  static const String orderUpdateSuccessMessage = 'Order updated successfully!';

  // Regex Patterns
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[0-9]{10,15}$';
  static const String passwordRegex = r'^(?=.*[a-zA-Z])(?=.*\d).{6,}$';

  // Image Compression
  static const List<int> jpegQualityLevels = [95, 85, 75, 65, 50];
  static const List<int> pngCompressionLevels = [9, 7, 5, 3, 1];

  // Security
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const Duration sessionTimeout = Duration(hours: 24);
  static const int passwordMinStrength = 2; // 0-4 scale

  // Analytics Events
  static const String loginEvent = 'login';
  static const String logoutEvent = 'logout';
  static const String productViewEvent = 'product_view';
  static const String productAddEvent = 'product_add';
  static const String productUpdateEvent = 'product_update';
  static const String productDeleteEvent = 'product_delete';
  static const String orderCreateEvent = 'order_create';
  static const String orderUpdateEvent = 'order_update';
  static const String searchEvent = 'search';
  static const String filterEvent = 'filter';

  // Notification Channels
  static const String orderNotificationChannel = 'order_notifications';
  static const String stockNotificationChannel = 'stock_notifications';
  static const String paymentNotificationChannel = 'payment_notifications';
  static const String systemNotificationChannel = 'system_notifications';

  // Development/Debug
  static const bool enableDebugLogs = true;
  static const bool enableDebugMenu = true;
  static const String mockBaseUrl = 'https://mock-api.example.com';

  // Feature Flags
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = true;
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
}

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String adminDashboard = '/admin/dashboard';
  static const String distributorDashboard = '/distributor/dashboard';
  static const String customerDashboard = '/customer/dashboard';
  static const String products = '/products';
  static const String addProduct = '/products/add';
  static const String editProduct = '/products/edit';
  static const String orders = '/orders';
  static const String orderDetails = '/orders/:id';
  static const String customers = '/customers';
  static const String customerDetails = '/customers/:id';
  static const String distributors = '/distributors';
  static const String distributorDetails = '/distributors/:id';
  static const String analytics = '/analytics';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String search = '/search';
  static const String camera = '/camera';
  static const String imageViewer = '/image-viewer';
}

class CacheKeys {
  static const String productList = 'product_list';
  static const String categoryList = 'category_list';
  static const String orderList = 'order_list';
  static const String customerList = 'customer_list';
  static const String distributorList = 'distributor_list';
  static const String userProfile = 'user_profile';
  static const String appConfig = 'app_config';
  static const String searchHistory = 'search_history';
  static const String recentProducts = 'recent_products';
  static const String favoriteProducts = 'favorite_products';
}

class ImagePaths {
  static const String appLogo = 'assets/images/app_logo.png';
  static const String placeholder = 'assets/images/placeholder.png';
  static const String noData = 'assets/images/no_data.png';
  static const String error = 'assets/images/error.png';
  static const String splash = 'assets/images/splash.png';
}

class AnimationFiles {
  static const String loading = 'assets/animations/loading.json';
  static const String success = 'assets/animations/success.json';
  static const String error = 'assets/animations/error.json';
  static const String empty = 'assets/animations/empty.json';
  static const String noInternet = 'assets/animations/no_internet.json';
}