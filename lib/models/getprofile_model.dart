// To parse this JSON data, do
//
//     final getProfileModel = getProfileModelFromJson(jsonString);

import 'dart:convert';

List<GetProfileModel> getProfileModelFromJson(String str) => List<GetProfileModel>.from(json.decode(str).map((x) => GetProfileModel.fromJson(x)));

String getProfileModelToJson(List<GetProfileModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetProfileModel {
  GetProfileModel({
    required this.profile,
    required this.email,
    required this.walletId,
    required this.referralCode,
    required this.freegameearn,
    required this.paidgameearn,
    required this.globalrankfree,
    required this.globalrankpaid,
  });

  var profile;
  var email;
  var walletId;
  var referralCode;
  var freegameearn;
  var paidgameearn;
  var globalrankfree;
  var globalrankpaid;

  factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
    profile: json["profile"],
    email: json["email"],
    walletId: json["walletID"],
    referralCode: json["referralCode"],
    freegameearn: json["freegameearn"],
    paidgameearn: json["paidgameearn"],
    globalrankfree: json["globalrankfree"],
    globalrankpaid: json["globalrankpaid"],
  );

  Map<String, dynamic> toJson() => {
    "profile": profile,
    "email": email,
    "walletID": walletId,
    "referralCode": referralCode,
    "freegameearn": freegameearn,
    "paidgameearn": paidgameearn,
    "globalrankfree": globalrankfree,
    "globalrankpaid": globalrankpaid,
  };
}
