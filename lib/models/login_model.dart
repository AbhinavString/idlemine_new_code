// To parse this JSON data, do
//
//     final loginData = loginDataFromJson(jsonString);

import 'dart:convert';

List<LoginData> loginDataFromJson(String str) => List<LoginData>.from(json.decode(str).map((x) => LoginData.fromJson(x)));

String loginDataToJson(List<LoginData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginData {
  LoginData({
    required this.id,
    required this.email,
    required this.isConfirmed,
    required this.moneyInWallet,
    required this.registerBy,
    required this.token,
  });

  var id;
  var email;
  var isConfirmed;
  var moneyInWallet;
  var registerBy;
  var token;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    id: json["_id"],
    email: json["email"],
    isConfirmed: json["isConfirmed"],
    moneyInWallet: json["moneyInWallet"],
    registerBy: json["registerBy"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "isConfirmed": isConfirmed,
    "moneyInWallet": moneyInWallet,
    "registerBy": registerBy,
    "token": token,
  };
}
