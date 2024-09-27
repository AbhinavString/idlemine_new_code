// To parse this JSON data, do
//
//     final lastWeekRankData = lastWeekRankDataFromJson(jsonString);

import 'dart:convert';

List<LastWeekRankData> lastWeekRankDataFromJson(String str) => List<LastWeekRankData>.from(json.decode(str).map((x) => LastWeekRankData.fromJson(x)));

String lastWeekRankDataToJson(List<LastWeekRankData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LastWeekRankData {
  String id;
  var totalplay;
  DateTime startDate;
  DateTime endDate;
  List<User> user;
  var reward;
  var rank;

  LastWeekRankData({
    required this.id,
    required this.totalplay,
    required this.startDate,
    required this.endDate,
    required this.user,
    required this.reward,
    required this.rank,
  });

  factory LastWeekRankData.fromJson(Map<String, dynamic> json) => LastWeekRankData(
    id: json["_id"],
    totalplay: json["totalplay"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
    reward: json["reward"],
    rank: json["rank"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "totalplay": totalplay,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "reward": reward,
    "rank": rank,
  };
}

class User {
  String id;
  String walletId;
  String email;

  User({
    required this.id,
    required this.walletId,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    walletId: json["walletID"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "walletID": walletId,
    "email": email,
  };
}
