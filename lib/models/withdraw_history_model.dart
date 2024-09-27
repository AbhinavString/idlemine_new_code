import 'dart:convert';

List<WithdrawHistoryData> withdrawHistoryDataFromJson(String str) => List<WithdrawHistoryData>.from(json.decode(str).map((x) => WithdrawHistoryData.fromJson(x)));

String withdrawHistoryDataToJson(List<WithdrawHistoryData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WithdrawHistoryData {
  WithdrawHistoryData({
    required this.requestAmount,
    required this.requestAddress,
    required this.status,
    required this.charge,
    required this.receivable,
    required this.id,
    required this.createdAt,
  });

  var requestAmount;
  var requestAddress;
  var status;
  var charge;
  var receivable;
  var id;
  DateTime createdAt;

  factory WithdrawHistoryData.fromJson(Map<String, dynamic> json) => WithdrawHistoryData(
    requestAmount: json["requestAmount"],
    requestAddress: json["requestAddress"],
    status: json["status"],
    charge: json["charge"],
    receivable: json["receivable"],
    id: json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "requestAmount": requestAmount,
    "requestAddress": requestAddress,
    "status": status,
    "charge": charge,
    "receivable": receivable,
    "_id": id,
    "createdAt": createdAt.toIso8601String(),
  };
}
