import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Wallet extends Equatable {
  final String walletId;
  final String userId;
  final dynamic balance;
  final int createdAt;
  final int updatedAt;
  Wallet({
    required this.walletId,
    required this.userId,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props {
    return [
      walletId,
      userId,
      balance,
      createdAt,
      updatedAt,
    ];
  }

  Wallet copyWith({
    String? walletId,
    String? userId,
    dynamic? balance,
    int? createdAt,
    int? updatedAt,
  }) {
    return Wallet(
      walletId: walletId ?? this.walletId,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'walletId': walletId,
      'userId': userId,
      'balance': balance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      walletId: map['walletId'],
      userId: map['userId'],
      balance: map['balance'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Wallet.fromJson(String source) => Wallet.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
