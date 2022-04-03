class ReferAndEarnModel {
  String? msg;
  Data? data;

  ReferAndEarnModel({this.msg, this.data});

  ReferAndEarnModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? refferalCode;
  String? refferalText;
  String? redirectUrl;
  String? refferalMoney;

  Data(
      {this.refferalCode,
        this.refferalText,
        this.redirectUrl,
        this.refferalMoney});

  Data.fromJson(Map<String, dynamic> json) {
    refferalCode = json['refferal_code'];
    refferalText = json['refferal_text'];
    redirectUrl = json['redirect_url'];
    refferalMoney = json['refferal_money'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refferal_code'] = this.refferalCode;
    data['refferal_text'] = this.refferalText;
    data['redirect_url'] = this.redirectUrl;
    data['refferal_money'] = this.refferalMoney;
    return data;
  }
}