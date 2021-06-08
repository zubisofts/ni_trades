import 'dart:convert';

import 'package:equatable/equatable.dart';

class InvestmentWithdrawRequest extends Equatable {
  final String id;
  final String accountName;
  final dynamic amount;
  final String accountNumber;
  final String bankCode;
  final String userId;
  final String investmentId;
  final String destination;
  final WithdrawalStatus status;
  final int timestamp;
  InvestmentWithdrawRequest({
    required this.id,
    required this.accountName,
    required this.amount,
    required this.accountNumber,
    required this.bankCode,
    required this.userId,
    required this.destination,
    required this.investmentId,
    required this.status,
    required this.timestamp,
  });

  InvestmentWithdrawRequest copyWith({
    String? id,
    String? accountName,
    String? amount,
    String? accountNumber,
    String? bankCode,
    String? userId,
    String? destination,
    String? investmentId,
    WithdrawalStatus? status,
    int? timestamp,
  }) {
    return InvestmentWithdrawRequest(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      amount: amount ?? this.amount,
      accountNumber: accountNumber ?? this.accountNumber,
      bankCode: bankCode ?? this.bankCode,
      userId: userId ?? this.userId,
      destination: destination ?? this.destination,
      investmentId: investmentId ?? this.investmentId,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountName': accountName,
      'amount': amount,
      'accountNumber': accountNumber,
      'bankCode': bankCode,
      'userId': userId,
      'destination': destination,
      'investmentId': investmentId,
      'status': typeValues.reverse[status],
      'timestamp': timestamp,
    };
  }

  factory InvestmentWithdrawRequest.fromMap(Map<String, dynamic> map) {
    return InvestmentWithdrawRequest(
      id: map['id'],
      accountName: map['accountName'],
      amount: map['amount'],
      accountNumber: map['accountNumber'],
      bankCode: map['bankCode'],
      userId: map['userId'],
      destination: map['destination'],
      investmentId: map['investmentId'],
      status: typeValues.map[map["status"]]!,
      timestamp: map['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InvestmentWithdrawRequest.fromJson(String source) =>
      InvestmentWithdrawRequest.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      accountName,
      amount,
      accountNumber,
      bankCode,
      userId,
      destination,
      investmentId,
      status,
      timestamp,
    ];
  }
}

enum WithdrawalStatus { Completed, Pending, Aborted }

final typeValues = EnumValues({
  "completed": WithdrawalStatus.Completed,
  "pending": WithdrawalStatus.Pending,
  "aborted": WithdrawalStatus.Aborted,
});

class EnumValues<T> {
  late Map<String, T> map;
  Map<T, String> reverseMap = {};

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => new MapEntry(v, k));
    return reverseMap;
  }
}
