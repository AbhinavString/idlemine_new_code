class GetDeposit {
  int? error;
  String? errorMsg;
  Data? data;

  GetDeposit({this.error, this.errorMsg, this.data});

  GetDeposit.fromJson(Map<String, dynamic> json) {
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
  List<GetDepositData>? data;

  Data({this.data});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GetDepositData>[];
      json['data'].forEach((v) {
        data!.add(new GetDepositData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetDepositData {
  String? id;
  String? cgst;
  String? igst;
  String? referralLimit;
  String? rewardAmount;
  String? sgst;
  String? tds;
  String? status;

  GetDepositData(
      {this.id,
        this.cgst,
        this.igst,
        this.referralLimit,
        this.rewardAmount,
        this.sgst,
        this.tds,
        this.status,
      });

  GetDepositData.fromJson(Map<String, dynamic> json) {
    id = json['_id'].toString();
    cgst = json['cgst'].toString();
    igst = json['igst'].toString();
    referralLimit = json['referralLimit'].toString();
    rewardAmount = json['rewardAmount'].toString();
    sgst = json['sgst'].toString();
    tds = json['tds'].toString();
    status = json['status'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['cgst'] = this.cgst;
    data['igst'] = this.igst;
    data['referralLimit'] = this.referralLimit;
    data['rewardAmount'] = this.rewardAmount;
    data['sgst'] = this.sgst;
    data['tds'] = this.tds;
    data['status'] = this.status;
    return data;
  }
}