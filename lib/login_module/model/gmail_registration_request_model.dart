class GmailRegistrationRequestModel {
  String? city;
  String? mobileNo;
  String? sourceRms;
  String? iam;

  GmailRegistrationRequestModel(
      {this.city, this.mobileNo, this.sourceRms, this.iam});

  GmailRegistrationRequestModel.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    mobileNo = json['mobile_no'];
    sourceRms = json['source_rms'];
    iam = json['iam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['mobile_no'] = this.mobileNo;
    data['source_rms'] = this.sourceRms;
    data['iam'] = this.iam;
    return data;
  }
}