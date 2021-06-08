import 'dart:convert';

import 'package:equatable/equatable.dart';

class WithdrawRequest extends Equatable {
  final String id;
  final String accountName;
  final String amount;
  final String accountNumber;
  final String bankCode;
  final String userId;
  final WithdrawalStatus status;
  final int timestamp;
  WithdrawRequest({
    required this.id,
    required this.accountName,
    required this.amount,
    required this.accountNumber,
    required this.bankCode,
    required this.userId,
    required this.status,
    required this.timestamp,
  });

  WithdrawRequest copyWith({
    String? id,
    String? accountName,
    String? amount,
    String? accountNumber,
    String? bankCode,
    String? userId,
    WithdrawalStatus? status,
    int? timestamp,
  }) {
    return WithdrawRequest(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      amount: amount ?? this.amount,
      accountNumber: accountNumber ?? this.accountNumber,
      bankCode: bankCode ?? this.bankCode,
      userId: userId ?? this.userId,
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
      'status': typeValues.reverse[status],
      'timestamp': timestamp,
    };
  }

  factory WithdrawRequest.fromMap(Map<String, dynamic> map) {
    return WithdrawRequest(
      id: map['id'],
      accountName: map['accountName'],
      amount: map['amount'],
      accountNumber: map['accountNumber'],
      bankCode: map['bankCode'],
      userId: map['userId'],
      status: typeValues.map[map["status"]]!,
      timestamp: map['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WithdrawRequest.fromJson(String source) =>
      WithdrawRequest.fromMap(json.decode(source));

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
