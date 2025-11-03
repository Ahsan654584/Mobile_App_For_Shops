part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthenticatedState extends AuthState {
  final User user;

  const AuthenticatedState(this.user);

  @override
  List<Object> get props => [user];
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileUpdatedState extends AuthState {
  final User user;

  const ProfileUpdatedState(this.user);

  @override
  List<Object> get props => [user];
}

class PasswordChangedState extends AuthState {
  const PasswordChangedState();
}

class PasswordResetEmailSentState extends AuthState {
  final String email;

  const PasswordResetEmailSentState(this.email);

  @override
  List<Object> get props => [email];
}

class RegistrationSuccessState extends AuthState {
  final User user;

  const RegistrationSuccessState(this.user);

  @override
  List<Object> get props => [user];
}