class TenantLeadsModel {
  String? msg;
  List<Data>? data;

  TenantLeadsModel({this.msg, this.data});

  TenantLeadsModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? propertyName;
  String? contactDetails;
  String? emailId;
  String? siteVisitDate;

  Data(
      {this.propertyName,
        this.contactDetails,
        this.emailId,
        this.siteVisitDate});

  Data.fromJson(Map<String, dynamic> json) {
    propertyName = json['property_name'];
    contactDetails = json['contact_details'];
    emailId = json['email_id'];
    siteVisitDate = json['site_visit_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_name'] = this.propertyName;
    data['contact_details'] = this.contactDetails;
    data['email_id'] = this.emailId;
    data['site_visit_date'] = this.siteVisitDate;
    return data;
  }
}