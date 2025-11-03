import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _checkAuthStatusUseCase = checkAuthStatusUseCase,
        super(AuthInitialState()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<RefreshTokenEvent>(_onRefreshToken);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      final result = await _loginUseCase.call(
        LoginParams(
          email: event.email,
          password: event.password,
          rememberMe: event.rememberMe,
        ),
      );

      result.fold(
        (failure) => emit(AuthErrorState(failure.message)),
        (user) => emit(AuthenticatedState(user)),
      );
    } catch (e) {
      emit(AuthErrorState('An unexpected error occurred during login'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      final result = await _logoutUseCase.call(const NoParams());

      result.fold(
        (failure) => emit(AuthErrorState(failure.message)),
        (_) => emit(UnauthenticatedState()),
      );
    } catch (e) {
      emit(AuthErrorState('An unexpected error occurred during logout'));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      final result = await _checkAuthStatusUseCase.call(const NoParams());

      result.fold(
        (failure) => emit(UnauthenticatedState()),
        (user) => emit(AuthenticatedState(user)),
      );
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // This would typically involve calling a token refresh use case
      // For now, we'll just check auth status again
      add(CheckAuthStatusEvent());
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }
}