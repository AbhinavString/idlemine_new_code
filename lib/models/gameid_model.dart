// To parse this JSON data, do
//
//     final gameIdModel = gameIdModelFromJson(jsonString);

import 'dart:convert';

List<GameIdModel> gameIdModelFromJson(String str) => List<GameIdModel>.from(json.decode(str).map((x) => GameIdModel.fromJson(x)));

String gameIdModelToJson(List<GameIdModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameIdModel {
  String gameId;

  GameIdModel({
    required this.gameId,
  });

  factory GameIdModel.fromJson(Map<String, dynamic> json) => GameIdModel(
    gameId: json["gameId"],
  );

  Map<String, dynamic> toJson() => {
    "gameId": gameId,
  };
}
