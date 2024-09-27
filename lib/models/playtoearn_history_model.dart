// To parse this JSON data, do
//
//     final gameHistoryData = gameHistoryDataFromJson(jsonString);

import 'dart:convert';

List<GameHistoryData> gameHistoryDataFromJson(String str) => List<GameHistoryData>.from(json.decode(str).map((x) => GameHistoryData.fromJson(x)));

String gameHistoryDataToJson(List<GameHistoryData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameHistoryData {
  var isWin;
  var gameAmount;
  var winingAmount;
  var id;
  DateTime createdAt;

  GameHistoryData({
    required this.isWin,
    required this.gameAmount,
    required this.winingAmount,
    required this.id,
    required this.createdAt,
  });

  factory GameHistoryData.fromJson(Map<String, dynamic> json) => GameHistoryData(
    isWin: json["is_win"],
    gameAmount: json["gameAmount"],
    winingAmount: json["wining_amount"]?.toDouble(),
    id: json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "is_win": isWin,
    "gameAmount": gameAmount,
    "wining_amount": winingAmount,
    "_id": id,
    "createdAt": createdAt.toIso8601String(),
  };
}
