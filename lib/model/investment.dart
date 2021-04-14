import 'dart:convert';

class Investment {
  String id;
  String packageId;
  String userId;
  int amount;
  int startDate;
  Investment({
    required this.id,
    required this.packageId,
    required this.userId,
    required this.amount,
    required this.startDate,
  });


  Investment copyWith({
    String? id,
    String? packageId,
    String? userId,
    int? amount,
    int? startDate,
  }) {
    return Investment(
      id: id ?? this.id,
      packageId: packageId ?? this.packageId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'packageId': packageId,
      'userId': userId,
      'amount': amount,
      'startDate': startDate,
    };
  }

  factory Investment.fromMap(Map<String, dynamic> map) {
    return Investment(
      id: map['id'],
      packageId: map['packageId'],
      userId: map['userId'],
      amount: map['amount'],
      startDate: map['startDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Investment.fromJson(String source) => Investment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Investment(id: $id, packageId: $packageId, userId: $userId, amount: $amount, startDate: $startDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Investment &&
      other.id == id &&
      other.packageId == packageId &&
      other.userId == userId &&
      other.amount == amount &&
      other.startDate == startDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      packageId.hashCode ^
      userId.hashCode ^
      amount.hashCode ^
      startDate.hashCode;
  }
}
