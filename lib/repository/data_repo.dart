import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/model/category.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/model/user_model.dart' as NIUser;
import 'package:ni_trades/model/wallet.dart';

class DataService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<dynamic> getUserInfo({
    required String userId,
  }) async {
    try {
      DocumentSnapshot doc =
          await _firebaseFirestore.collection('users').doc(userId).get();
      return NIUser.User.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      debugPrint('Error:${e.code}');
      return e;
    }
  }

  Future<dynamic> saveUserInfo({
    required NIUser.User user,
  }) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .set(user.toMap());

      // await _firebaseFirestore.collection("wallets")
      return user;
    } on FirebaseException catch (e) {
      debugPrint('Error:${e.code}');
      return e.message;
    }
  }

  Future<void> createUserWallet(String uid) async {
    DocumentReference walletReference =
        _firebaseFirestore.collection("wallets").doc();
    Wallet wallet = Wallet(
        walletId: walletReference.id,
        userId: uid,
        balance: 0.0,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch);

    await walletReference.set(wallet.toMap());
  }

  Future<List<InvestmentPackage>> investmentsPackages(String categoryId) async {
    var iDocs = await _firebaseFirestore
        .collection('user_investments')
        .doc(AuthBloc.uid!)
        .collection('investments')
        .get();
    List<String> ids =
        iDocs.docs.map((e) => Investment.fromMap(e.data()!).packageId).toList();

    QuerySnapshot snapshot;
    if (categoryId.isEmpty) {
      snapshot =
          await _firebaseFirestore.collection("investment_packages").get();
    } else {
      snapshot = await _firebaseFirestore
          .collection("investment_packages")
          .where("categoryId", isEqualTo: categoryId)
          .get();
    }

    var packages = snapshot.docs
        .map((doc) => InvestmentPackage.fromMap(doc.data()!))
        .toList();

    if (ids.isNotEmpty) {
      List<InvestmentPackage> d = [];
      d.addAll(packages);
      packages.forEach((element) {
        if (ids.contains(element.id)) {
          d.remove(element);
        }
      });

      return d;
    }

    return packages;
  }

  Future<dynamic> invest(Investment investment) async {
    try {
      var investRef = _firebaseFirestore
          .collection('user_investments')
          .doc(investment.userId)
          .collection('investments')
          .doc();

      investment.id = investRef.id;
      investRef.set(investment.toMap());

      return investRef.id;
    } on FirebaseException catch (e) {
      return e;
    }
  }

  Stream<Wallet> fetchUserWallet({
    required String userId,
  }) {
    return _firebaseFirestore
        .collection('wallets')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => Wallet.fromMap(snapshot.docs.first.data()!));
  }

  Future<dynamic> fundUserWallet(
      {required String userId, required dynamic amount}) async {
    try {
      QuerySnapshot doc = await _firebaseFirestore
          .collection('wallets')
          .where('userId', isEqualTo: userId)
          .get();
      String id = doc.docs.first.id;

      print('Fetching user wallet ID:$id');
      Wallet wallet = Wallet.fromMap(doc.docs.first.data()!);
      var initialBalance = wallet.balance;
      Wallet w2 = wallet.copyWith(balance: initialBalance + amount);
      await _firebaseFirestore.collection('wallets').doc(id).update(w2.toMap());
      return id;
    } on FirebaseException catch (e) {
      debugPrint('Error:${e.code}');
      return e;
    }
  }

// Fetch the list of user investments
  Stream<List<Investment>> investments(String userId) {
    return _firebaseFirestore
        .collection("user_investments")
        .doc(userId)
        .collection('investments')
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((doc) => Investment.fromMap(doc.data()!))
            .toList());
  }

  Stream<InvestmentPackage> fetchSingleInvestment(String packageId) {
    return _firebaseFirestore
        .collection("investment_packages")
        .doc(packageId)
        .snapshots()
        .map((snapshot) => InvestmentPackage.fromMap(snapshot.data()!));
  }

  Future<dynamic> get categories async {
    try {
      var querySnapshots =
          await _firebaseFirestore.collection('categories').get();
      return querySnapshots.docs
          .map((doc) => Category.fromMap(doc.data()!))
          .toList();
    } on FirebaseException catch (e) {
      return e;
    } on SocketException catch (s) {
      return s;
    }
  }

  Stream<Category> category(String id) {
    return _firebaseFirestore
        .collection('categories')
        .doc(id)
        .snapshots()
        .map((doc) => Category.fromMap(doc.data()!));
  }
}