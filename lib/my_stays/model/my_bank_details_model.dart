class MyBankDetailsModel {
  String? msg;
  Data? data;

  MyBankDetailsModel({this.msg, this.data});

  MyBankDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? bankdetails;
  String? accHolder;
  String? accNo;
  String? bankName;
  String? ifscCode;
  String? rating;
  String? buildingRating;
  String? frndRecomd;
  String? email;

  Data(
      {this.bankdetails,
        this.accHolder,
        this.accNo,
        this.bankName,
        this.ifscCode,
        this.rating,
        this.buildingRating,
        this.frndRecomd,
        this.email});

  Data.fromJson(Map<String, dynamic> json) {
    bankdetails = json['bankdetails'];
    accHolder = json['acc_holder'];
    accNo = json['acc_no'];
    bankName = json['bank_name'];
    ifscCode = json['ifsc_code'];
    rating = json['rating'];
    buildingRating = json['building_rating'];
    frndRecomd = json['frnd_recomd'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankdetails'] = this.bankdetails;
    data['acc_holder'] = this.accHolder;
    data['acc_no'] = this.accNo;
    data['bank_name'] = this.bankName;
    data['ifsc_code'] = this.ifscCode;
    data['rating'] = this.rating;
    data['building_rating'] = this.buildingRating;
    data['frnd_recomd'] = this.frndRecomd;
    data['email'] = this.email;
    return data;
  }
}
