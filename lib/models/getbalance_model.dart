// To parse this JSON data, do
//
//     final balanceData = balanceDataFromJson(jsonString);

import 'dart:convert';

List<BalanceData> balanceDataFromJson(String str) => List<BalanceData>.from(json.decode(str).map((x) => BalanceData.fromJson(x)));

String balanceDataToJson(List<BalanceData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BalanceData {
  String walletId;
  String walletId1V1;
  var moneyInWallet1V1;
  var moneyInWallet;
  String id;

  BalanceData({
    required this.walletId,
    required this.walletId1V1,
    required this.moneyInWallet1V1,
    required this.moneyInWallet,
    required this.id,
  });

  factory BalanceData.fromJson(Map<String, dynamic> json) => BalanceData(
    walletId: json["walletID"],
    walletId1V1: json["walletID1v1"],
    moneyInWallet1V1: json["moneyInWallet1v1"],
    moneyInWallet: json["moneyInWallet"]?.toDouble(),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "walletID": walletId,
    "walletID1v1": walletId1V1,
    "moneyInWallet1v1": moneyInWallet1V1,
    "moneyInWallet": moneyInWallet,
    "_id": id,
  };
}
