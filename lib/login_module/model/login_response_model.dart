class LoginResponseModel {
  String? msg;
  Data? data;

  LoginResponseModel({this.msg, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? appToken;
  String? username;
  String? isAdmin;
  String? contactNum;
  String? name;
  String? active;
  int? flag;
  String? verifiedPhoneFlag;
  String? team;
  dynamic id;
  String? pic;
  String? gmapKey;

  Data(
      {this.email,
        this.appToken,
        this.username,
        this.isAdmin,
        this.contactNum,
        this.name,
        this.flag,
        this.active,
        this.verifiedPhoneFlag,
        this.team,
        this.id,
        this.pic,
        this.gmapKey});

  Data.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    appToken = json['app_token'];
    username = json['username'];
    isAdmin = json['is_admin'];
    contactNum = json['contact_num'];
    name = json['name'];
    flag = json['flag'];
    active = json['active'];
    verifiedPhoneFlag = json['verified_phone_flag'];
    team = json['team'];
    id = json['id'];
    pic = json['pic'];
    gmapKey = json['gmap_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['app_token'] = this.appToken;
    data['username'] = this.username;
    data['is_admin'] = this.isAdmin;
    data['contact_num'] = this.contactNum;
    data['name'] = this.name;
    data['flag'] = this.flag;
    data['verified_phone_flag'] = this.verifiedPhoneFlag;
    data['team'] = this.team;
    data['active'] = this.active;
    data['id'] = this.id;
    data['pic'] = this.pic;
    data['gmap_key'] = this.gmapKey;
    return data;
  }
}