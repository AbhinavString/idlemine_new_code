// To parse this JSON data, do
//
//     final referralHistoryData = referralHistoryDataFromJson(jsonString);

import 'dart:convert';

List<ReferralHistoryData> referralHistoryDataFromJson(String str) => List<ReferralHistoryData>.from(json.decode(str).map((x) => ReferralHistoryData.fromJson(x)));

String referralHistoryDataToJson(List<ReferralHistoryData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReferralHistoryData {
  ReferralHistoryData({
    required this.amount,
    required this.id,
    required this.userId,
    required this.createdAt,
  });

  var amount;
  var id;
  UserId userId;
  DateTime createdAt;

  factory ReferralHistoryData.fromJson(Map<String, dynamic> json) => ReferralHistoryData(
    amount: json["amount"],
    id: json["_id"],
    userId: UserId.fromJson(json["userId"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "_id": id,
    "userId": userId.toJson(),
    "createdAt": createdAt.toIso8601String(),
  };
}

class UserId {
  UserId({
    required this.id,
    required this.email,
  });

  var id;
  var email;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
  };
}
