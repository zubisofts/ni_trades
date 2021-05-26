// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:ni_trades/model/api_response.dart';
import 'package:ni_trades/model/user_model.dart' as NIUser;
import 'package:ni_trades/model/wallet.dart';
import 'package:ni_trades/repository/data_repo.dart';
import 'package:ni_trades/util/auth_error_handler.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<ApiResponse<NIUser.User, String>> signUpUser({
    required NIUser.User user,
    required String password,
  }) async {
    try {
      var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      NIUser.User mUser = await DataService()
          .saveUserInfo(user: user.copyWith(id: userCredential.user!.uid));
      await DataService().createUserWallet(userCredential.user!.uid);
      return ApiResponse(data: mUser, error: null);
    } on FirebaseAuthException catch (ex) {
      return ApiResponse(
          data: null,
          error: ExceptionHandler.generateExceptionMessage(
              ExceptionHandler.handleException(ex)));
    }
  }

  Future<void> logoutUser() async {
    try {
      _firebaseAuth.signOut();
    } on FirebaseException catch (e) {}
  }

  Stream<User?> get authUser {
    return _firebaseAuth.authStateChanges();
  }

  Future<ApiResponse<NIUser.User, String>> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      NIUser.User user=await DataService().getUserInfo(userId: userCredential.user!.uid);
      return ApiResponse(data: user, error: null);
    } on FirebaseException catch (ex) {
      debugPrint('Login Error:${ex.code}');
      return ApiResponse(
          data: null,
          error: ExceptionHandler.generateExceptionMessage(
              ExceptionHandler.handleException(ex)));
    }
  }
}
