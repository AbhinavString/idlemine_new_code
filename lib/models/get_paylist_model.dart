class PayList {
  int? error;
  String? errorMsg;
  Data? data;

  PayList({this.error, this.errorMsg, this.data});

  PayList.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorMsg = json['error_msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['error_msg'] = this.errorMsg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<PayListData>? docs;

  Data({this.docs});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['docs'] != null) {
      docs = <PayListData>[];
      json['docs'].forEach((v) {
        docs!.add(new PayListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.docs != null) {
      data['docs'] = this.docs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PayListData {
  String? id;
  String? status;
  String? amount;

  PayListData(
      {this.id,
        this.status,
        this.amount,
      });

  PayListData.fromJson(Map<String, dynamic> json) {
    id = json['_id'].toString();
    status = json['status'].toString();
    amount = json['amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['status'] = this.status;
    data['amount'] = this.amount;
    return data;
  }
}