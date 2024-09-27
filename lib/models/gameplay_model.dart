import 'dart:convert';

List<GamePlayModel> gamePlayModelFromJson(String str) => List<GamePlayModel>.from(json.decode(str).map((x) => GamePlayModel.fromJson(x)));

String gamePlayModelToJson(List<GamePlayModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GamePlayModel {
  GamePlayModel({
    required this.isWin,
    required this.spendTime,
    required this.gameAmount,
    required this.winingAmount,
    required this.id,
    required this.userId,
    required this.gameId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  var isWin;
  var spendTime;
  var gameAmount;
  var winingAmount;
  var id;
  var userId;
  var gameId;
  DateTime createdAt;
  DateTime updatedAt;
  var v;

  factory GamePlayModel.fromJson(Map<String, dynamic> json) => GamePlayModel(
    isWin: json["is_win"],
    spendTime: json["spendTime"],
    gameAmount: json["gameAmount"],
    winingAmount: json["wining_amount"],
    id: json["_id"],
    userId: json["userId"],
    gameId: json["gameId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "is_win": isWin,
    "spendTime": spendTime,
    "gameAmount": gameAmount,
    "wining_amount": winingAmount,
    "_id": id,
    "userId": userId,
    "gameId": gameId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
