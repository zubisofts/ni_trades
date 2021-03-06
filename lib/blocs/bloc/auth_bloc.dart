import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/api_response.dart';
import 'package:ni_trades/model/user_model.dart' as NIUser;
import 'package:ni_trades/repository/auth_repo.dart';
import 'package:ni_trades/repository/data_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    _userSubscription = authService.authUser.listen(
      (firebaseUser) => add(AuthStateChangedEvent(firebaseUser)),
    );
  }

  late StreamSubscription _userSubscription;
  static String? uid;

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is SignUpEvent) {
      yield* _mapSignUpEventToState(event.user, event.password);
    }

    if (event is AuthStateChangedEvent) {
      yield* _mapAuthStateChangedEventToState(event.user);
    }

    if (event is LoginUserEvent) {
      yield* _mapLoginUserEventToState(event.email, event.password);
    }

    if (event is LogoutUserEvent) {
      await authService.logoutUser();
    }

    if (event is SendOTPEvent) {
      yield* _mapSendOTPEventToState(event.email);
    }

    if (event is VerifyOTPEvent) {
      yield* _mapVerifyOTPEventToState(event.otp, event.email);
    }

    if (event is SendPasswordResetLink) {
      yield* _mapSendPasswordResetLinkToState(event.email);
    }
  }

  Stream<AuthState> _mapSignUpEventToState(
      NIUser.User userModel, String password) async* {
    yield SignUpLoadingState();
    var res = await authService.signUpUser(user: userModel, password: password);
    if (res.error == null) {
      uid = res.data!.id;
      yield UserSignedUpState(res.data!);
    } else {
      yield SignupUserErrorState(res.error!);
    }
  }

  Stream<AuthState> _mapLoginUserEventToState(
      String email, String password) async* {
    yield LoginUserLoadingState();
    var res = await authService.loginUserWithEmailAndPassword(email, password);
    if (res.error == null) {
      uid = res.data!.id;
      yield UserLoggedInState(res.data!);
    } else {
      yield LoginUserErrorState(res.error!);
    }
  }

  Stream<AuthState> _mapAuthStateChangedEventToState(User? user) async* {
    yield AuthUserChangedState(
        user != null
            ? AuthenticationStatus.authenticated
            : AuthenticationStatus.unauthenticated,
        user);
    if (user != null) {
      uid = user.uid;
    }
  }

  Stream<AuthState> _mapSendOTPEventToState(String email) async* {
    yield SendOTPLoadingState();
    ApiResponse response = await AuthService().sendOTP(email);
    if (response.error) {
      yield SendOTPErrorState(response.data);
    } else {
      yield OTPSentState(response.data);
    }
  }

  Stream<AuthState> _mapVerifyOTPEventToState(String otp, String email) async* {
    yield VerifyOTPLoadingState();
    ApiResponse response = await AuthService().verifyOTP(otp, email);
    if (response.error) {
      yield VerifyOTPErrorState(response.data);
    } else {
      yield OTPVerifiedState(response.data);
    }
  }

  Stream<AuthState> _mapSendPasswordResetLinkToState(String email) async*{
     yield SendPasswordResetLinkLoadingState();
    ApiResponse response = await AuthService().sendPasswordResetLink(email);
    if (response.error) {
      yield SendPasswordResetLinkFailureState(response.data);
    } else {
      yield PasswordResetLinkSentState();
    }
  }
}
