class SignUpRequestModel {
  String? fname;
  String? lname;
  String? email;
  String? password;
  String? city;
  String? budget;
  String? imei;
  String? phonenumber;
  String? iam;
  String? sourceRms;
  String? referal;
  String? uid;

  SignUpRequestModel(
      {this.fname,
        this.lname,
        this.email,
        this.password,
        this.city,
        this.budget,
        this.imei,
        this.phonenumber,
        this.iam,
        this.sourceRms,
        this.uid,
        this.referal});

  SignUpRequestModel.fromJson(Map<String, dynamic> json) {
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    password = json['password'];
    city = json['city'];
    budget = json['budget'];
    imei = json['imei'];
    phonenumber = json['phonenumber'];
    iam = json['iam'];
    uid = json['uid'];
    sourceRms = json['source_rms'];
    referal = json['referal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fname'] = this.fname;
    data['lname'] = lname;
    data['email'] = email;
    data['password'] = password;
    data['city'] = city;
    data['budget'] = this.budget;
    data['imei'] = imei;
    data['phonenumber'] = this.phonenumber;
    data['iam'] = iam;
    data['source_rms'] = sourceRms;
    data['uid']=uid;
    data['referal'] = referal;
    return data;
  }
}