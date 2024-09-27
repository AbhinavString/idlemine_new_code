class tnxhistory {
  int? error;
  String? errorMsg;
  Data? data;

  tnxhistory({this.error, this.errorMsg, this.data});

  tnxhistory.fromJson(Map<String, dynamic> json) {
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
  List<tnxhistoryData>? docs;

  Data({this.docs});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['docs'] != null) {
      docs = <tnxhistoryData>[];
      json['docs'].forEach((v) {
        docs!.add(new tnxhistoryData.fromJson(v));
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

class tnxhistoryData {
  String? tnxType;
  String? tnxId;
  String? amount;
  String? createdAt;
  String? tnxStatus;
  String? tnxFor;

  tnxhistoryData(
      {this.tnxType,
        this.tnxId,
        this.amount,
        this.createdAt,
        this.tnxStatus,
        this.tnxFor,
      });

  tnxhistoryData.fromJson(Map<String, dynamic> json) {
    tnxType = json['tnxType'].toString();
    tnxId = json['tnxId'].toString();
    amount = json['amount'].toString();
    createdAt = json['createdAt'].toString();
    tnxStatus = json['tnxStatus'].toString();
    tnxFor = json['tnxFor'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tnxType'] = this.tnxType;
    data['tnxId'] = this.tnxId;
    data['amount'] = this.amount;
    data['createdAt'] = this.createdAt;
    data['tnxStatus'] = this.tnxStatus;
    data['tnxFor'] = this.tnxFor;
    return data;
  }
}