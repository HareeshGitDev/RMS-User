class GmailSignInResponseModel {
  String? pic;
  String? userId;
  String? status;
  int? flag;
  String? contactNum;
  String? appToken;
  String? message;
  String? gmapKey;

  GmailSignInResponseModel(
      {this.pic,
      this.userId,
      this.status,
      this.flag,
      this.contactNum,
      this.appToken,
      this.message,
      this.gmapKey});

  GmailSignInResponseModel.fromJson(Map<String, dynamic> json) {
    pic = json['pic'];
    userId = json['user_id'];
    status = json['status'];
    flag = json['flag'];
    contactNum = json['contact_num'];
    appToken = json['app_token'];
    message = json['message'];
    gmapKey = json['gmap_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pic'] = this.pic;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['flag'] = this.flag;
    data['contact_num'] = this.contactNum;
    data['app_token'] = this.appToken;
    data['message'] = this.message;
    data['gmap_key'] = this.gmapKey;
    return data;
  }
}
