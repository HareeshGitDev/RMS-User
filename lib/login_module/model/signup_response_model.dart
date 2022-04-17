class SignUpResponseModel {
  String? msg;
  Data? data;

  SignUpResponseModel({this.msg, this.data});

  SignUpResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? status;
  String? appToken;
  String? username;
  String? email;
  String? contactNum;
  String? name;
  String? pic;
  String? isAdmin;
  String? team;
  String? gmapKey;

  Data(
      {this.id,
        this.status,
        this.appToken,
        this.username,
        this.email,
        this.contactNum,
        this.name,
        this.pic,
        this.isAdmin,
        this.team,
        this.gmapKey});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    appToken = json['app_token'];
    username = json['username'];
    email = json['email'];
    contactNum = json['contactNum'];
    name = json['name'];
    pic = json['pic'];
    isAdmin = json['is_admin'];
    team = json['team'];
    gmapKey = json['gmap_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['app_token'] = this.appToken;
    data['username'] = this.username;
    data['email'] = this.email;
    data['contactNum'] = this.contactNum;
    data['name'] = this.name;
    data['pic'] = this.pic;
    data['is_admin'] = this.isAdmin;
    data['team'] = this.team;
    data['gmap_key'] = this.gmapKey;
    return data;
  }
}