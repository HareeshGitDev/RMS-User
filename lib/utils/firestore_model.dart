class FirestoreModel {
  String? name;
  String? info;

  FirestoreModel({this.name, this.info});

  FirestoreModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['info'] = this.info;
    return data;
  }
}