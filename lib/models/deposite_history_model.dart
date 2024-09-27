import 'dart:convert';

List<DepositeHistoryData> depositeHistoryDataFromJson(String str) => List<DepositeHistoryData>.from(json.decode(str).map((x) => DepositeHistoryData.fromJson(x)));

String depositeHistoryDataToJson(List<DepositeHistoryData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DepositeHistoryData {
  DepositeHistoryData({
    required this.id,
    required this.valuinusdt,
    required this.symbol,
    required this.createdAt,
  });

  String id;
  String valuinusdt;
  String symbol;
  DateTime createdAt;

  factory DepositeHistoryData.fromJson(Map<String, dynamic> json) => DepositeHistoryData(
    id: json["_id"],
    valuinusdt: json["valuinusdt"],
    symbol: json["symbol"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "valuinusdt": valuinusdt,
    "symbol": symbol,
    "createdAt": createdAt.toIso8601String(),
  };
}
