import 'dart:convert';

import 'package:equatable/equatable.dart';

class InvestmentPackage with EquatableMixin {
  String id;
  String title;
  String description;
  String category;
  int durationInMonths;
  int returns;
  String imageCoverUrl;
  bool isOpen;
  int maxCount;
  int bgColor;
  InvestmentPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationInMonths,
    required this.returns,
    required this.imageCoverUrl,
    required this.isOpen,
    required this.maxCount,
    required this.bgColor,
  });

  InvestmentPackage copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? durationInMonths,
    int? returns,
    String? imageCoverUrl,
    bool? isOpen,
    int? maxCount,
    int? bgColor,
  }) {
    return InvestmentPackage(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      durationInMonths: durationInMonths ?? this.durationInMonths,
      returns: returns ?? this.returns,
      imageCoverUrl: imageCoverUrl ?? this.imageCoverUrl,
      isOpen: isOpen ?? this.isOpen,
      maxCount: maxCount ?? this.maxCount,
      bgColor: bgColor ?? this.bgColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'durationInMonths': durationInMonths,
      'returns': returns,
      'imageCoverUrl': imageCoverUrl,
      'isOpen': isOpen,
      'maxCount': maxCount,
      'bgColor': bgColor,
    };
  }

  factory InvestmentPackage.fromMap(Map<String, dynamic> map) {
    return InvestmentPackage(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      durationInMonths: map['durationInMonths'],
      returns: map['returns'],
      imageCoverUrl: map['imageCoverUrl'],
      isOpen: map['isOpen'],
      maxCount: map['maxCount'],
      bgColor: map['bgColor'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InvestmentPackage.fromJson(String source) =>
      InvestmentPackage.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      category,
      durationInMonths,
      returns,
      imageCoverUrl,
      isOpen,
      maxCount,
      bgColor,
    ];
  }
}
