// To parse this JSON data, do
//
//     final referdatamodel = referdatamodelFromJson(jsonString);

import 'dart:convert';

List<Referdatamodel> referdatamodelFromJson(String str) => List<Referdatamodel>.from(json.decode(str).map((x) => Referdatamodel.fromJson(x)));

String referdatamodelToJson(List<Referdatamodel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Referdatamodel {
  Referdatamodel({
    required this.referralCode,
    required this.earnByReferral,
  });

  var referralCode;
  var earnByReferral;

  factory Referdatamodel.fromJson(Map<String, dynamic> json) => Referdatamodel(
    referralCode: json["referralCode"],
    earnByReferral: json["earnByReferral"],
  );

  Map<String, dynamic> toJson() => {
    "referralCode": referralCode,
    "earnByReferral": earnByReferral,
  };
}
