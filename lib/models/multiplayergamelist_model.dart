// To parse this JSON data, do
//
//     final multiplayerGamelistModel = multiplayerGamelistModelFromJson(jsonString);

import 'dart:convert';

List<MultiplayerGamelistModel> multiplayerGamelistModelFromJson(String str) => List<MultiplayerGamelistModel>.from(json.decode(str).map((x) => MultiplayerGamelistModel.fromJson(x)));

String multiplayerGamelistModelToJson(List<MultiplayerGamelistModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MultiplayerGamelistModel {
  var status;
  String id;
  var amount;
  var adminearningper;
  String color;
  List<Thumbconfig> thumbconfig;
  DateTime createdAt;
  DateTime updatedAt;
  var v;

  MultiplayerGamelistModel({
    required this.status,
    required this.id,
    required this.amount,
    required this.adminearningper,
    required this.color,
    required this.thumbconfig,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory MultiplayerGamelistModel.fromJson(Map<String, dynamic> json) => MultiplayerGamelistModel(
    status: json["status"],
    id: json["_id"],
    amount: json["amount"],
    adminearningper: json["adminearningper"],
    color: json["color"],
    thumbconfig: List<Thumbconfig>.from(json["thumbconfig"].map((x) => Thumbconfig.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "_id": id,
    "amount": amount,
    "adminearningper": adminearningper,
    "color": color,
    "thumbconfig": List<dynamic>.from(thumbconfig.map((x) => x.toJson())),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class Thumbconfig {
  String id;
  String timechange;
  String skillchecktime;
  String timeforstart;

  Thumbconfig({
    required this.id,
    required this.timechange,
    required this.skillchecktime,
    required this.timeforstart,
  });

  factory Thumbconfig.fromJson(Map<String, dynamic> json) => Thumbconfig(
    id: json["_id"],
    timechange: json["timechange"],
    skillchecktime: json["skillchecktime"],
    timeforstart: json["timeforstart"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "timechange": timechange,
    "skillchecktime": skillchecktime,
    "timeforstart": timeforstart,
  };
}
