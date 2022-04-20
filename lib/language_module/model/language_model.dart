class LanguageModel {
  String? name;
  String? info;

  LanguageModel({this.name, this.info});

  LanguageModel.fromJson(Map<String, dynamic> json) {
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