import 'dart:convert';

import 'package:equatable/equatable.dart';

class NiTransacton with EquatableMixin {
  final String id;
  final String title;
  final String description;
  final String type;
  final String transactionId;
  final int timestamp;
  NiTransacton({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.transactionId,
    required this.timestamp,
  });

  NiTransacton copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? transactionId,
    int? timestamp,
  }) {
    return NiTransacton(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      transactionId: transactionId ?? this.transactionId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'transactionId': transactionId,
      'timestamp': timestamp,
    };
  }

  factory NiTransacton.fromMap(Map<String, dynamic> map) {
    return NiTransacton(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      transactionId: map['transactionId'],
      timestamp: map['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NiTransacton.fromJson(String source) => NiTransacton.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      type,
      transactionId,
      timestamp,
    ];
  }
}
