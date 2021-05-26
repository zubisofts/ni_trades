import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/model/api_response.dart';
import 'package:ni_trades/model/category.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/model/transaction.dart';
import 'package:ni_trades/model/user_model.dart' as NIUser;
import 'package:ni_trades/model/wallet.dart';
import 'package:ni_trades/util/constants.dart';
import 'package:uuid/uuid.dart';

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
        .where('userId', isEqualTo: AuthBloc.uid)
        .get();
    List<String> ids =
        iDocs.docs.map((e) => Investment.fromMap(e.data()!).packageId).toList();

    QuerySnapshot snapshot;
    if (categoryId.isEmpty) {
      snapshot = await _firebaseFirestore
          .collection("investment_packages")
          .where("isOpen", isEqualTo: true)
          .get();
    } else {
      snapshot = await _firebaseFirestore
          .collection("investment_packages")
          .where("isOpen", isEqualTo: true)
          .where("categoryId", isEqualTo: categoryId)
          .get();
    }

    var packages = snapshot.docs
        .map((doc) => InvestmentPackage.fromMap(doc.data()!))
        .toList();

    // if (ids.isNotEmpty) {
    //   List<InvestmentPackage> d = [];
    //   d.addAll(packages);
    //   packages.forEach((element) {
    //     if (ids.contains(element.id)) {
    //       d.remove(element);
    //     }
    //   });

    //   return d;
    // }

    return packages;
  }

  Future<ApiResponse> invest(
      BuildContext context, Investment investment, PaymentCard card) async {
    try {
      var response = await makePayment(context, investment, card);
      if (!response.error) {
        var investRef = _firebaseFirestore.collection('user_investments').doc();

        var package = await getPackageDetails(investment.packageId);
        await logTransaction(NiTransacton(
            id: '',
            title: 'New Investment',
            description: 'You invested in ${package!.title}',
            type: 'Invest',
            transactionId: investment.refId,
            timestamp: DateTime.now().millisecondsSinceEpoch));
        investment.id = investRef.id;
        investRef.set(investment.copyWith(id: investRef.id).toMap());

        return ApiResponse(data: investRef.id, error: false);
      } else {
        return ApiResponse(data: "Unable to complete request!", error: true);
      }
    } on FirebaseException catch (e) {
      return ApiResponse(data: e.message, error: false);
    }
  }

  Future<InvestmentPackage?> getPackageDetails(id) async {
    try {
      var snapshot = await _firebaseFirestore
          .collection('investment_packages')
          .doc(id)
          .get();

      return InvestmentPackage.fromMap(snapshot.data()!);
    } on FirebaseException catch (e) {
      return null;
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
        .where("userId", isEqualTo: userId)
        .where('active', isEqualTo: true)
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
    var time = FieldValue.serverTimestamp().toString();
    print('SERVER TIME IS:$time');
    return _firebaseFirestore
        .collection('categories')
        .doc(id)
        .snapshots()
        .map((doc) => Category.fromMap(doc.data()!));
  }

  Stream<InvestmentPackage> fetchPackageDetails(packageId) => _firebaseFirestore
      .collection('investment_packages')
      .doc(packageId)
      .snapshots()
      .map((doc) => InvestmentPackage.fromMap(doc.data()!));

  Future<void> logTransaction(NiTransacton transaction) async {
    DocumentReference ref = _firebaseFirestore
        .collection('user_transactions')
        .doc(AuthBloc.uid)
        .collection('transactions')
        .doc();
    var newTransaction = transaction.copyWith(id: ref.id);
    ref.set(newTransaction.toMap());
  }

  Future<dynamic> get transactions async {
    try {
      var querySnapshots = await _firebaseFirestore
          .collection('user_transactions')
          .doc(AuthBloc.uid)
          .collection('transactions')
          .get();
      return querySnapshots.docs
          .map((doc) => NiTransacton.fromMap(doc.data()!))
          .toList();
    } on FirebaseException catch (e) {
      return e;
    } on SocketException catch (s) {
      return s;
    }
  }

  Future<ApiResponse> makePayment(
      BuildContext context, Investment investment, PaymentCard card) async {
    PaystackPlugin paystackPlugin = PaystackPlugin();
    await paystackPlugin.initialize(publicKey: Constants.PAYSTACK_PUBLIC_API);
    try {
      Uuid referenceKey = Uuid();
      String ref = referenceKey.v1(options: {
        'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
        'clockSeq': 0x1234,
        'mSecs': new DateTime.now().millisecondsSinceEpoch,
        'nSecs': 5678
      });

      investment = investment.copyWith(refId: ref);
      Charge charge = Charge()
        ..amount = investment.amount * 100
        ..reference = '$ref'
        ..card = card
        ..currency = 'NGN'
        ..putMetaData("name", "NI Trades")
        // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = 'zubitex40@email.com'
        ..putCustomField('Charged From', 'NI Trades');

      // CheckoutResponse response =
      //     await paystackPlugin.chargeCard(context, charge: charge);

      CheckoutResponse response = await paystackPlugin.chargeCard(
        context,
        charge: charge,
      );

      print('Transaction Response: ${response.status}');

      if (response.status) {
        return ApiResponse(data: ref, error: false);
      } else {
        return ApiResponse(data: ref, error: true);
      }
    } catch (ex) {
      return ApiResponse(data: ex, error: true);
    }
  }
}
