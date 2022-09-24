class AmenitiesCheckModel {
  String? msg;
  Data? data;

  AmenitiesCheckModel({this.msg, this.data});

  AmenitiesCheckModel.fromJson(Map<String, dynamic> json) {
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
  List<AmenityList>? amenityList;

  Data({this.amenityList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['amenityList'] != null) {
      amenityList = <AmenityList>[];
      json['amenityList'].forEach((v) {
        amenityList!.add(new AmenityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.amenityList != null) {
      data['amenityList'] = this.amenityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AmenityList {
  String? key;
  String? title;
  String? value;

  AmenityList({this.key, this.title, this.value});

  AmenityList.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['title'] = this.title;
    data['value'] = this.value;
    return data;
  }
}
