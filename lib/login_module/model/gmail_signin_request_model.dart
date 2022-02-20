class GmailSignInRequestModel {
  String? name;
  String? picture;
  String? id;
  String? email;

  GmailSignInRequestModel({this.email, this.name, this.id, this.picture});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['picture'] = picture;
    data['name'] = name;
    data['email'] = email;
    data['id'] = id;
    return data;
  }
}
