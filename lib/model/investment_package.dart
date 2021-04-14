import 'dart:convert';

import 'package:equatable/equatable.dart';

class InvestmentPackage with EquatableMixin {
  String id;
  String title;
  String description;
  String categoryId;
  int durationInMonths;
  int returns;
  String imageCoverUrl;
  InvestmentPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.durationInMonths,
    required this.returns,
    required this.imageCoverUrl,
  });
  

  InvestmentPackage copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    int? durationInMonths,
    int? returns,
    String? imageCoverUrl,
  }) {
    return InvestmentPackage(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      durationInMonths: durationInMonths ?? this.durationInMonths,
      returns: returns ?? this.returns,
      imageCoverUrl: imageCoverUrl ?? this.imageCoverUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'durationInMonths': durationInMonths,
      'returns': returns,
      'imageCoverUrl': imageCoverUrl,
    };
  }

  factory InvestmentPackage.fromMap(Map<String, dynamic> map) {
    return InvestmentPackage(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      categoryId: map['categoryId'],
      durationInMonths: map['durationInMonths'],
      returns: map['returns'],
      imageCoverUrl: map['imageCoverUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InvestmentPackage.fromJson(String source) => InvestmentPackage.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      categoryId,
      durationInMonths,
      returns,
      imageCoverUrl,
    ];
  }
}
