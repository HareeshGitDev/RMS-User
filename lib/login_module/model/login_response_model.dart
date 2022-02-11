class LoginResponseModel {
  String? status;
  String? message;
  String? email;
  String? appToken;
  String? username;
  String? isAdmin;
  String? contactNum;
  String? name;
  int? flag;
  String? verifiedPhoneFlag;
  String? team;
  String? id;
  String? pic;
  String? gmapKey;

  LoginResponseModel(
      {this.status,
        this.message,
        this.email,
        this.appToken,
        this.username,
        this.isAdmin,
        this.contactNum,
        this.name,
        this.flag,
        this.verifiedPhoneFlag,
        this.team,
        this.id,
        this.pic,
        this.gmapKey});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    email = json['email'];
    appToken = json['app_token'];
    username = json['username'];
    isAdmin = json['is_admin'];
    contactNum = json['contact_num'];
    name = json['name'];
    flag = json['flag'];
    verifiedPhoneFlag = json['verified_phone_flag'];
    team = json['team'];
    id = json['id'];
    pic = json['pic'];
    gmapKey = json['gmap_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['email'] = this.email;
    data['app_token'] = this.appToken;
    data['username'] = this.username;
    data['is_admin'] = this.isAdmin;
    data['contact_num'] = this.contactNum;
    data['name'] = this.name;
    data['flag'] = this.flag;
    data['verified_phone_flag'] = this.verifiedPhoneFlag;
    data['team'] = this.team;
    data['id'] = this.id;
    data['pic'] = this.pic;
    data['gmap_key'] = this.gmapKey;
    return data;
  }
}
