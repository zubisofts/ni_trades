part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final NIUser.User user;
  final String password;
  SignUpEvent({
    required this.user,
    required this.password,
  });
}

class LoginUserEvent extends AuthEvent {
  final String email;
  final String password;
  LoginUserEvent({
    required this.email,
    required this.password,
  });
}

class AuthStateChangedEvent extends AuthEvent {
  final User? user;

  AuthStateChangedEvent(this.user);

  @override
  List<Object> get props => [user!];
}

class LogoutUserEvent extends AuthEvent {}

class SendOTPEvent extends AuthEvent {
  final String email;

  SendOTPEvent(this.email);

  @override
  List<Object> get props => [email];
}

class VerifyOTPEvent extends AuthEvent {
  final String otp;
  final String email;

  VerifyOTPEvent(this.otp, this.email);

  @override
  List<Object> get props => [otp, email];
}

class ChangePasswordEvent extends AuthEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordEvent({required this.oldPassword, required this.newPassword});

  @override
  List<Object> get props => [oldPassword, newPassword];
}

class SendPasswordResetLink extends AuthEvent {
  final String email;

  SendPasswordResetLink(this.email);

  @override
  List<Object> get props => [email];
}
