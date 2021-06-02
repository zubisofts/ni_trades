// To parse this JSON data, do
//
//     final bankList = bankListFromJson(jsonString);

import 'dart:convert';

BankList bankListFromJson(String str) => BankList.fromJson(json.decode(str));

String bankListToJson(BankList data) => json.encode(data.toJson());

class BankList {
  BankList({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Bank> data;

  factory BankList.fromJson(Map<String, dynamic> json) => BankList(
        status: json["status"],
        message: json["message"],
        data: List<Bank>.from(json["data"].map((x) => Bank.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Bank {
  Bank({
    required this.name,
    required this.slug,
    required this.code,
    required this.longcode,
    required this.gateway,
    required this.payWithBank,
    required this.active,
    required this.isDeleted,
    required this.country,
    required this.currency,
    required this.type,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  String name;
  String slug;
  String code;
  String longcode;
  Gateway? gateway;
  bool payWithBank;
  bool active;
  dynamic isDeleted;
  Country? country;
  Currency? currency;
  Type? type;
  int id;
  DateTime createdAt;
  DateTime updatedAt;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        name: json["name"],
        slug: json["slug"],
        code: json["code"],
        longcode: json["longcode"],
        gateway:
            json["gateway"] == null ? null : gatewayValues.map[json["gateway"]],
        payWithBank: json["pay_with_bank"],
        active: json["active"],
        isDeleted: json["is_deleted"] == null ? null : json["is_deleted"],
        country: countryValues.map[json["country"]],
        currency: currencyValues.map[json["currency"]],
        type: typeValues.map[json["type"]],
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "code": code,
        "longcode": longcode,
        "gateway": gateway == null ? null : gatewayValues.reverse[gateway],
        "pay_with_bank": payWithBank,
        "active": active,
        // ignore: unnecessary_null_comparison
        "is_deleted": isDeleted == null ? null : isDeleted,
        "country": countryValues.reverse[country],
        "currency": currencyValues.reverse[currency],
        "type": typeValues.reverse[type],
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

enum Country { NIGERIA }

final countryValues = EnumValues({"Nigeria": Country.NIGERIA});

enum Currency { NGN }

final currencyValues = EnumValues({"NGN": Currency.NGN});

enum Gateway { EMANDATE, IBANK, DIGITALBANKMANDATE }

final gatewayValues = EnumValues({
  "digitalbankmandate": Gateway.DIGITALBANKMANDATE,
  "emandate": Gateway.EMANDATE,
  "ibank": Gateway.IBANK
});

enum Type { NUBAN }

final typeValues = EnumValues({"nuban": Type.NUBAN});

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
