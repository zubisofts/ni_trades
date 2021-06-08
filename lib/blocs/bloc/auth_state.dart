part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class SignUpLoadingState extends AuthState {}

class UserSignedUpState extends AuthState {
  final NIUser.User user;

  UserSignedUpState(this.user);

  @override
  List<Object> get props => [user];
}

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
  final NIUser.User user;

  UserLoggedInState(this.user);

  @override
  List<Object> get props => [user];
}

class SendOTPLoadingState extends AuthState {}

class SendOTPErrorState extends AuthState {
  final String error;

  SendOTPErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class OTPSentState extends AuthState {
  final String message;

  OTPSentState(this.message);

  @override
  List<Object> get props => [message];
}

class VerifyOTPLoadingState extends AuthState {}

class VerifyOTPErrorState extends AuthState {
  final String error;

  VerifyOTPErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class OTPVerifiedState extends AuthState {
  final String message;

  OTPVerifiedState(this.message);

  @override
  List<Object> get props => [message];
}

class ChangePasswordLoadingState extends AuthState {}

class PasswordChangeErrorState extends AuthState {
  final String error;

  PasswordChangeErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class PasswordChangedState extends AuthState {}

class SendPasswordResetLinkLoadingState extends AuthState {}

class SendPasswordResetLinkFailureState extends AuthState {
  final String error;

  SendPasswordResetLinkFailureState(this.error);
}

class PasswordResetLinkSentState extends AuthState {}
