class SignUpResponseModel {
  String? status;
  String? message;
  String? token;
  String? appToken;
  String? username;
  String? email;
  String? gmapKey;

  SignUpResponseModel(
      {this.status,
        this.message,
        this.token,
        this.appToken,
        this.username,
        this.email,
        this.gmapKey});

  SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    appToken = json['app_token'];
    username = json['username'];
    email = json['email'];
    gmapKey = json['gmap_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    data['app_token'] = this.appToken;
    data['username'] = this.username;
    data['email'] = this.email;
    data['gmap_key'] = this.gmapKey;
    return data;
  }
}