import 'dart:convert';

List<GameListModel> gameListModelFromJson(String str) => List<GameListModel>.from(json.decode(str).map((x) => GameListModel.fromJson(x)));

String gameListModelToJson(List<GameListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameListModel {
  GameListModel({
    required this.status,
    required this.id,
    required this.gameDuration,
    required this.thumbDuration,
    required this.earningPercentage,
    required this.gameAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  var status;
  var id;
  var gameDuration;
  var thumbDuration;
  var earningPercentage;
  var gameAmount;
  DateTime createdAt;
  DateTime updatedAt;
  var v;

  factory GameListModel.fromJson(Map<String, dynamic> json) => GameListModel(
    status: json["status"],
    id: json["_id"],
    gameDuration: json["gameDuration"],
    thumbDuration: json["thumbDuration"],
    earningPercentage: json["earningPercentage"],
    gameAmount: json["gameAmount"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "_id": id,
    "gameDuration": gameDuration,
    "thumbDuration": thumbDuration,
    "earningPercentage": earningPercentage,
    "gameAmount": gameAmount,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
