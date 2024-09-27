import 'dart:convert';

class KlingPrize {
  var current_price = "";
  var price_change_percentage_24h = "";

  void dictToObject(json2) {
    var json = jsonDecode(json2);

    current_price = json[0]["current_price"].toString();
    price_change_percentage_24h =
        json[0]["price_change_percentage_24h"].toString();
  }
}

class KlingChart {
  List<String> price = [];
  List<String> xAxis = [];

  void dictToObject(json2) {
    var json = jsonDecode(json2);
    print(json);
    print(json["prices"].length);

    for (var i = 0; i < json["prices"].length; i++) {
      price.add(json["prices"][i][1].toString());
      xAxis.add(json["prices"][i][0].toString());
    }
  }
}
