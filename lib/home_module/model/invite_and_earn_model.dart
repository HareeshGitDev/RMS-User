class InviteModel {
  String? refferalMoney;
  String? refferalCode;
  String? status;
  String? email;
  String? refferalText;
  String? redirectUrl;

  InviteModel(
      {this.refferalMoney,
        this.refferalCode,
        this.status,
        this.email,
        this.refferalText,
        this.redirectUrl});

  InviteModel.fromJson(Map<String, dynamic> json) {
    refferalMoney = json['refferal_money'];
    refferalCode = json['refferal_code'];
    status = json['status'];
    email  = json['email'];
    refferalText = json['refferal_text'];
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refferal_money'] = this.refferalMoney;
    data['refferal_code'] = this.refferalCode;
    data['status'] = this.status;
    data['email'] = this.email;
    data['refferal_text'] = this.refferalText;
    data['redirect_url'] = this.redirectUrl;
    return data;
  }
}