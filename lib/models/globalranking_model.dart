// To parse this JSON data, do
//
//     final globalrankingData = globalrankingDataFromJson(jsonString);

import 'dart:convert';

List<GlobalrankingData> globalrankingDataFromJson(String str) => List<GlobalrankingData>.from(json.decode(str).map((x) => GlobalrankingData.fromJson(x)));

String globalrankingDataToJson(List<GlobalrankingData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GlobalrankingData {
  GlobalrankingData({
    required this.id,
    required this.sum,
    required this.user,
    required this.reward,
    required this.rank,
    required this.startDate,
    required this.endDate,
  });

  String id;
  int sum;
  List<User> user;
  int reward;
  int rank;
  DateTime startDate;
  DateTime endDate;

  factory GlobalrankingData.fromJson(Map<String, dynamic> json) => GlobalrankingData(
    id: json["_id"],
    sum: json["sum"],
    user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
    reward: json["reward"],
    rank: json["rank"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "sum": sum,
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "reward": reward,
    "rank": rank,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
  };
}

class User {
  User({
    required this.walletId,
    required this.email,
  });

  String walletId;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
    walletId: json["walletID"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "walletID": walletId,
    "email": email,
  };
}
