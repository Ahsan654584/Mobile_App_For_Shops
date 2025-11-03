import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'injection_container.config.dart';

// Services
import 'firebase_service.dart';
import 'local_storage_service.dart';
import 'sync_service.dart';
import 'notification_service.dart';
import 'language_service.dart';

// Data repositories
import '../data/repositories/user_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/order_repository.dart';

// Auth repositories
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';

// Network services
import '../core/network/network_info.dart';
import '../core/network/compression_service.dart';

final GetIt sl = GetIt.instance;

@InjectableInit()
Future<void> init() async {
  // Initialize external dependencies
  await _initExternalDependencies();

  // Register core services
  await _registerCoreServices();

  // Register repositories
  await _registerRepositories();

  // Register BLoCs and use cases
  await _registerBlocsAndUseCases();

  // Initialize dependencies
  await sl.allReady();
}

Future<void> _initExternalDependencies() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
}

Future<void> _registerCoreServices() async {
  // Core services
  sl.registerLazySingleton<FirebaseService>(() => FirebaseService());
  sl.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  sl.registerLazySingleton<SyncService>(() => SyncService());
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerLazySingleton<LanguageService>(() => LanguageService());

  // Network services
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<CompressionService>(() => CompressionService());
}

Future<void> _registerRepositories() async {
  // Data repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl());

  // Auth repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
}

Future<void> _registerBlocsAndUseCases() async {
  // This will be implemented when we create BLoCs and use cases
  // For now, we'll leave this placeholder
}

// Clean up resources
Future<void> dispose() async {
  await sl.reset();
}