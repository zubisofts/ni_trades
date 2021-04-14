part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class SignUpLoadingState extends AuthState {}

class UserSignedUpState extends AuthState {}

class SignupUserErrorState extends AuthState {
  final String error;

  SignupUserErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class AuthUserChangedState extends AuthState {
  final User? user;
  final AuthenticationStatus status;

  AuthUserChangedState(this.status, this.user);

  @override
  List<Object> get props => [status];
}

class LoginUserLoadingState extends AuthState {}

class LoginUserErrorState extends AuthState {
  final String error;

  LoginUserErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class UserLoggedInState extends AuthState {
  final User user;

  UserLoggedInState(this.user);

  @override
  List<Object> get props => [user];
}
