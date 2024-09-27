// To parse this JSON data, do
//
//     final oneVOneModel = oneVOneModelFromJson(jsonString);

import 'dart:convert';

List<OneVOneModel> oneVOneModelFromJson(String str) => List<OneVOneModel>.from(json.decode(str).map((x) => OneVOneModel.fromJson(x)));

String oneVOneModelToJson(List<OneVOneModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OneVOneModel {
  String gamestatus;
  var gameamount;
  DateTime datetime;
  String firstuseremail;
  String seconduseremail;

  OneVOneModel({
    required this.gamestatus,
    required this.gameamount,
    required this.datetime,
    required this.firstuseremail,
    required this.seconduseremail,
  });

  factory OneVOneModel.fromJson(Map<String, dynamic> json) => OneVOneModel(
    gamestatus: json["gamestatus"],
    gameamount: json["gameamount"]?.toDouble(),
    datetime: DateTime.parse(json["datetime"]),
    firstuseremail: json["firstuseremail"],
    seconduseremail: json["seconduseremail"],
  );

  Map<String, dynamic> toJson() => {
    "gamestatus": gamestatus,
    "gameamount": gameamount,
    "datetime": datetime.toIso8601String(),
    "firstuseremail": firstuseremail,
    "seconduseremail": seconduseremail,
  };
}
