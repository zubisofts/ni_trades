// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:ni_trades/model/user_model.dart' as NIUser;
import 'package:ni_trades/model/wallet.dart';
import 'package:ni_trades/repository/data_repo.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<dynamic> signUpUser({
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
      return mUser;
    } on FirebaseException catch (e) {
      return e.message;
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

  Future<dynamic> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login Error:${e.code}');
      return e.message;
    }
  }
}
