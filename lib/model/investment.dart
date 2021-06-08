import 'dart:convert';

import 'package:equatable/equatable.dart';

class Investment with EquatableMixin {
  final String id;
  final String packageId;
  final String userId;
  final String refId;
  final int amount;
  final int startDate;
  final int duration;
  final int returns;
  final InvestmentStatus status;
  final bool isDue;
  Investment({
    required this.id,
    required this.packageId,
    required this.userId,
    required this.refId,
    required this.amount,
    required this.duration,
    required this.returns,
    required this.startDate,
    required this.status,
    required this.isDue,
  });

  Investment copyWith({
    String? id,
    String? packageId,
    String? userId,
    String? refId,
    int? amount,
    int? startDate,
    int? duration,
    int? returns,
    InvestmentStatus? status,
    bool? isDue,
  }) {
    return Investment(
      id: id ?? this.id,
      packageId: packageId ?? this.packageId,
      userId: userId ?? this.userId,
      refId: refId ?? this.refId,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      duration: duration ?? this.duration,
      returns: returns ?? this.returns,
      status: status ?? this.status,
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
      'duration': duration,
      'status': typeValues.reverse[status],
      'returns': returns,
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
      duration: map['duration'],
      returns: map['returns'],
      status: typeValues.map[map["status"]]!,
      isDue: map['isDue'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Investment.fromJson(String source) =>
      Investment.fromMap(json.decode(source));

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
      duration,
      returns,
      status,
      isDue,
    ];
  }
}

enum InvestmentStatus { Completed, Processing, Pending, Aborted }

final typeValues = EnumValues({
  "completed": InvestmentStatus.Completed,
  "pending": InvestmentStatus.Pending,
  "processing": InvestmentStatus.Processing,
  "aborted": InvestmentStatus.Aborted,
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
