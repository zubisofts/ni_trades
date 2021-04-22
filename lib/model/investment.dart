import 'dart:convert';

import 'package:equatable/equatable.dart';

class Investment with EquatableMixin {
  String id;
  String packageId;
  String userId;
  String refId;
  int amount;
  int startDate;
  bool active;
  bool isDue;
  Investment({
    required this.id,
    required this.packageId,
    required this.userId,
    required this.refId,
    required this.amount,
    required this.startDate,
    required this.active,
    required this.isDue,
  });


  Investment copyWith({
    String? id,
    String? packageId,
    String? userId,
    String? refId,
    int? amount,
    int? startDate,
    bool? active,
    bool? isDue,
  }) {
    return Investment(
      id: id ?? this.id,
      packageId: packageId ?? this.packageId,
      userId: userId ?? this.userId,
      refId: refId ?? this.refId,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      active: active ?? this.active,
      isDue: isDue ?? this.isDue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'packageId': packageId,
      'userId': userId,
      'refId': refId,
      'amount': amount,
      'startDate': startDate,
      'active': active,
      'isDue': isDue,
    };
  }

  factory Investment.fromMap(Map<String, dynamic> map) {
    return Investment(
      id: map['id'],
      packageId: map['packageId'],
      userId: map['userId'],
      refId: map['refId'],
      amount: map['amount'],
      startDate: map['startDate'],
      active: map['active'],
      isDue: map['isDue'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Investment.fromJson(String source) => Investment.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      packageId,
      userId,
      refId,
      amount,
      startDate,
      active,
      isDue,
    ];
  }
}
