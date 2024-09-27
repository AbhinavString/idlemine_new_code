import 'dart:convert';

List<BannerData> bannerDataFromJson(String str) => List<BannerData>.from(json.decode(str).map((x) => BannerData.fromJson(x)));

String bannerDataToJson(List<BannerData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannerData {
  BannerData({
    required this.id,
    required this.title,
    required this.link,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  var id;
  var title;
  var link;
  var image;
  bool status;
  DateTime createdAt;
  DateTime updatedAt;
  var v;

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
    id: json["_id"],
    title: json["title"],
    link: json["link"],
    image: json["image"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "link": link,
    "image": image,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
