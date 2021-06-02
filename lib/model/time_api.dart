// To parse this JSON data, do
//
//     final timeApi = timeApiFromJson(jsonString);

import 'dart:convert';

TimeApi timeApiFromJson(String str) => TimeApi.fromJson(json.decode(str));

String timeApiToJson(TimeApi data) => json.encode(data.toJson());

class TimeApi {
  TimeApi({
    required this.currentDateTime,
    required this.utcOffset,
    required this.isDayLightSavingsTime,
    required this.dayOfTheWeek,
    required this.timeZoneName,
    required this.currentFileTime,
    required this.ordinalDate,
    this.serviceResponse,
  });

  String currentDateTime;
  String utcOffset;
  bool isDayLightSavingsTime;
  String dayOfTheWeek;
  String timeZoneName;
  double currentFileTime;
  String ordinalDate;
  dynamic serviceResponse;

  factory TimeApi.fromJson(Map<String, dynamic> json) => TimeApi(
        currentDateTime: json["currentDateTime"],
        utcOffset: json["utcOffset"],
        isDayLightSavingsTime: json["isDayLightSavingsTime"],
        dayOfTheWeek: json["dayOfTheWeek"],
        timeZoneName: json["timeZoneName"],
        currentFileTime: json["currentFileTime"].toDouble(),
        ordinalDate: json["ordinalDate"],
        serviceResponse: json["serviceResponse"],
      );

  Map<String, dynamic> toJson() => {
        "currentDateTime": currentDateTime,
        "utcOffset": utcOffset,
        "isDayLightSavingsTime": isDayLightSavingsTime,
        "dayOfTheWeek": dayOfTheWeek,
        "timeZoneName": timeZoneName,
        "currentFileTime": currentFileTime,
        "ordinalDate": ordinalDate,
        "serviceResponse": serviceResponse,
      };
}
