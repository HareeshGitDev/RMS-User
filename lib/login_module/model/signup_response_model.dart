class SignUpResponseModel {
  String? status;
  String? message;
  String? appToken;
  String? username;
  String? email;
  String? contactNum;
  String? name;
  String? pic;
  String? isAdmin;
  String? team;
  String? gmapKey;

  SignUpResponseModel(
      {this.status,
        this.message,
        this.appToken,
        this.username,
        this.email,
        this.contactNum,
        this.name,
        this.pic,
        this.isAdmin,
        this.team,
        this.gmapKey});

  SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    data['status'] = this.status;
    data['message'] = this.message;
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