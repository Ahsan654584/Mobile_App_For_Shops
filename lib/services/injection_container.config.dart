// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_types_named

import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';

import 'package:mobile_app_for_shops/services/firebase_service.dart';
import 'package:mobile_app_for_shops/services/local_storage_service.dart';
import 'package:mobile_app_for_shops/services/sync_service.dart';
import 'package:mobile_app_for_shops/services/notification_service.dart';
import 'package:mobile_app_for_shops/services/language_service.dart';
import 'package:mobile_app_for_shops/core/network/network_info.dart';
import 'package:mobile_app_for_shops/core/network/compression_service.dart';

import 'package:mobile_app_for_shops/data/repositories/user_repository.dart';
import 'package:mobile_app_for_shops/data/repositories/product_repository.dart';
import 'package:mobile_app_for_shops/data/repositories/order_repository.dart';

import 'package:mobile_app_for_shops/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile_app_for_shops/features/auth/domain/repositories/auth_repository.dart';

import 'package:mobile_app_for_shops/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobile_app_for_shops/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mobile_app_for_shops/features/auth/domain/usecases/check_auth_status_usecase.dart';

import 'package:mobile_app_for_shops/features/auth/presentation/bloc/auth_bloc.dart';

final GetIt sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  sl
    ..registerSingleton<FirebaseService>(FirebaseService())
    ..registerSingleton<LocalStorageService>(LocalStorageService())
    ..registerSingleton<SyncService>(SyncService(sl()))
    ..registerSingleton<NotificationService>(NotificationService(sl()))
    ..registerSingleton<LanguageService>(LanguageService())
    ..registerSingleton<NetworkInfo>(NetworkInfoImpl(sl(), sl()))
    ..registerSingleton<CompressionService>(CompressionService())
    ..registerSingleton<UserRepository>(UserRepositoryImpl(sl(), sl()))
    ..registerSingleton<ProductRepository>(ProductRepositoryImpl(sl(), sl()))
    ..registerSingleton<OrderRepository>(OrderRepositoryImpl(sl(), sl()))
    ..registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()))
    ..registerSingleton<LoginUseCase>(LoginUseCase(sl()))
    ..registerSingleton<LogoutUseCase>(LogoutUseCase(sl()))
    ..registerSingleton<CheckAuthStatusUseCase>(CheckAuthStatusUseCase(sl()))
    ..registerFactory<AuthBloc>(() => AuthBloc(
          loginUseCase: sl(),
          logoutUseCase: sl(),
          checkAuthStatusUseCase: sl(),
        ));
}