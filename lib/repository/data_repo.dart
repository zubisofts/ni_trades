import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/model/api_response.dart';
import 'package:ni_trades/model/category.dart';
import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/model/investment_package.dart';
import 'package:ni_trades/model/investment_withdraw_request.dart';
import 'package:ni_trades/model/time_api.dart';
import 'package:ni_trades/model/transaction.dart';
import 'package:ni_trades/model/user_model.dart' as NIUser;
import 'package:ni_trades/model/wallet.dart';
import 'package:ni_trades/repository/payment_repository.dart';
import 'package:ni_trades/util/constants.dart';
import 'package:ni_trades/util/my_utils.dart';

class DataService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<NIUser.User> get user => _firebaseFirestore
      .collection('users')
      .doc(AuthBloc.uid)
      .snapshots()
      .map((doc) => NIUser.User.fromMap(doc.data()!));

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

  Future<dynamic> updateUserPhoto({
    required NIUser.User user,
    required File photo,
  }) async {
    try {
      ApiResponse res = await saveUserPhoto(user.id, photo);
      if (res.error) {
        return ApiResponse(data: res.data, error: true);
      }

      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .update({"photo": res.data});

      // await _firebaseFirestore.collection("wallets")
      return ApiResponse(
          data: "Profile photo successfully updated", error: false);
    } on FirebaseException catch (e) {
      debugPrint('Error:${e.code}');
      return ApiResponse(data: e.message, error: true);
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
        iDocs.docs.map((e) => Investment.fromMap(e.data()).packageId).toList();

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
        .map((doc) => InvestmentPackage.fromMap(doc.data()))
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

  Future<ApiResponse> invest(
      BuildContext context, Investment investment, PaymentCard card) async {
    try {
      var response = await pay(investment.amount, context, card);
      if (!response.error) {
        var investRef = _firebaseFirestore.collection('user_investments').doc();

        var package = await getPackageDetails(investment.packageId);
        await logTransaction(NiTransacton(
            id: '',
            title: 'Package Investment',
            description: 'You invested in ${package!.title}',
            type: 'Invest',
            transactionId: investment.refId,
            timestamp: DateTime.now().millisecondsSinceEpoch));
        investRef.set(investment
            .copyWith(id: investRef.id, refId: response.data)
            .toMap());

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

  Stream<Wallet> userWallet({
    required String userId,
  }) {
    return _firebaseFirestore
        .collection('wallets')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => Wallet.fromMap(e.data())).toList().last);
  }

  Future<ApiResponse> fetchUserWallet({
    required String userId,
  }) async {
    try {
      var snapshot = await _firebaseFirestore
          .collection('wallets')
          .where('userId', isEqualTo: userId)
          .get();
      Wallet wallet = Wallet.fromMap(snapshot.docs.first.data());
      return ApiResponse(data: wallet, error: false);
    } on FirebaseException catch (e) {
      return ApiResponse(data: e.message, error: true);
    }
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
      Wallet wallet = Wallet.fromMap(doc.docs.first.data());
      print("Wallet ID:" + wallet.walletId);
      var initialBalance = wallet.balance;
      Wallet w2 = wallet.copyWith(balance: initialBalance + amount);
      await _firebaseFirestore
          .collection('wallets')
          .doc(wallet.walletId)
          .update(w2.toMap());
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
        .where('status', isEqualTo: "pending")
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((doc) => Investment.fromMap(doc.data()))
            .toList());
  }

  Future<ApiResponse> getFutureInvestmentCountDown(
      int startDate, int months) async {
    var apiResponse = await PaymentRepository().getCurrentTime;
    if (apiResponse.error) {
      return ApiResponse(data: apiResponse.data, error: true);
    }

    int time =
        DateTime.parse(apiResponse.data.currentDateTime).millisecondsSinceEpoch;

    var advanceDaysInMillis = (31 * months) * 8.64e+7;
    var advanceDate = startDate + advanceDaysInMillis;
    var d = advanceDate - (time);

    var difference = (d / 8.64e+7).round();
    return ApiResponse(data: difference, error: false);
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
          .map((doc) => Category.fromMap(doc.data()))
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
          .orderBy("timestamp", descending: true)
          .get();
      return querySnapshots.docs
          .map((doc) => NiTransacton.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      return e;
    } on SocketException catch (s) {
      return s;
    }
  }

  Future<ApiResponse> fundWallet(
      int amount, BuildContext context, PaymentCard card) async {
    try {
      var response = await pay(amount, context, card);
      await logTransaction(NiTransacton(
          id: '',
          title: 'Funded Wallet',
          description:
              'You funded your wallet with the amount of ${NumberFormat.currency(name: '₦', decimalDigits: 0).format(amount)}',
          type: 'Fund',
          transactionId: response.data,
          timestamp: DateTime.now().millisecondsSinceEpoch));
      var updateResult;
      if (!response.error) {
        updateResult =
            await _firebaseFirestore.runTransaction<bool>((transaction) async {
          QuerySnapshot doc = await _firebaseFirestore
              .collection('wallets')
              .where('userId', isEqualTo: AuthBloc.uid)
              .get();
          String id = doc.docs.first.id;

          var snapshot = await transaction
              .get(_firebaseFirestore.collection("wallets").doc(id));
          // if (snapshot.exists) {
          Wallet wallet = Wallet.fromMap(snapshot.data()!);

          var totalAmount = wallet.balance + amount;

          transaction.update(_firebaseFirestore.collection("wallets").doc(id),
              Map.from({"balance": totalAmount}));
          // } else {
          //   var documentReference =
          //       _firebaseFirestore.collection("wallets").doc(AuthBloc.uid!);
          //   transaction.set(
          //       documentReference,
          //       Wallet(
          //               walletId: documentReference.id,
          //               userId: AuthBloc.uid!,
          //               balance: amount,
          //               createdAt: DateTime.now().millisecondsSinceEpoch,
          //               updatedAt: DateTime.now().millisecondsSinceEpoch)
          //           .toMap());
          // }

          return true;
        });
      }
      if (updateResult) {
        return ApiResponse(data: true, error: false);
      } else {
        return ApiResponse(data: "Unable to process your request", error: true);
      }
    } on FirebaseException catch (ex) {
      return ApiResponse(data: ex.message, error: true);
    }
  }

  Future<ApiResponse> pay(
      int amount, BuildContext context, PaymentCard card) async {
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

      Charge charge = Charge()
        ..amount = amount * 100
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

  Future<ApiResponse> investViaWallet(Investment investment) async {
    try {
      var walletResponse = await fetchUserWallet(userId: AuthBloc.uid!);

      var package = await getPackageDetails(investment.packageId);
      if (!walletResponse.error) {
        Wallet wallet = walletResponse.data;
        if (investment.amount > wallet.balance) {
          return ApiResponse(
              data:
                  'Sorry you do not have enough money in your wallet to complete this transaction.',
              error: true);
        }
        var investRef = _firebaseFirestore.collection('user_investments').doc();

        await logTransaction(NiTransacton(
            id: '',
            title: 'Package Investment',
            description:
                'You invested in ${package!.title} with the amount of ${NumberFormat.currency(name: '₦', decimalDigits: 0).format(investment.amount)}',
            type: 'Invest',
            transactionId: investment.refId,
            timestamp: DateTime.now().millisecondsSinceEpoch));
        investRef.set(investment
            .copyWith(id: investRef.id, refId: wallet.walletId)
            .toMap());

        await _firebaseFirestore
            .collection("wallets")
            .doc(wallet.walletId)
            .update({"balance": wallet.balance - investment.amount});

        return ApiResponse(data: investRef.id, error: false);
      } else {
        return ApiResponse(data: "Unable to complete request!", error: true);
      }
    } on FirebaseException catch (e) {
      //   await logTransaction(NiTransacton(
      // id: '',
      // title: 'Failed Investment',
      // description:
      //     'Your investment for ${package.title} with the amount of ${investment.amount}',
      // type: 'Invest',
      // transactionId: investment.refId,
      // timestamp: DateTime.now().millisecondsSinceEpoch));
      return ApiResponse(data: e.message, error: false);
    }
  }

  Future<ApiResponse> saveUserPhoto(String id, File photo) async {
    try {
      var task = await FirebaseStorage.instance
          .ref()
          .child('user_photos')
          .child('$id')
          .putFile(photo);

      var url = await task.ref.getDownloadURL();
      // await file.delete();
      return ApiResponse(data: url, error: false);
    } on FirebaseException catch (e) {
      debugPrint('Error:${e.code}');
      return ApiResponse(data: e.message, error: true);
    }
  }

  Future<ApiResponse> sendInvestmentWithdrawRequest(
      InvestmentWithdrawRequest request) async {
    try {
      var timeResponse = await PaymentRepository().getCurrentTime;
      if (timeResponse.error) {
        return timeResponse;
      }

      TimeApi t = timeResponse.data;
      var time = DateTime.parse(t.currentDateTime).millisecondsSinceEpoch;
      var doc =
          _firebaseFirestore.collection("investment_withdraw_requests").doc();
      await _firebaseFirestore
          .collection("user_investments")
          .doc(request.investmentId)
          .update({"status": "processing"});
      await doc.set(request.copyWith(id: doc.id, timestamp: time).toMap());
      return ApiResponse(data: 'Your request has been sent', error: false);
    } on FirebaseException catch (_) {
      return ApiResponse(
          data: 'Your request failed, please try again!', error: true);
    }
  }
}

class Message {
  final String id;
  final String senderId;
  final String text;
  Message({
    required this.id,
    required this.senderId,
    required this.text,
  });
  final bool read = false;

  Message copyWith({
    String? id,
    String? senderId,
    String? text,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['senderId'],
      text: map['text'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() => 'Message(id: $id, senderId: $senderId, text: $text)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.id == id &&
        other.senderId == senderId &&
        other.text == text;
  }

  @override
  int get hashCode => id.hashCode ^ senderId.hashCode ^ text.hashCode;
}
