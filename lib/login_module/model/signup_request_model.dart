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
    sourceRms = json['source_rms'];
    referal = json['referal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['password'] = this.password;
    data['city'] = this.city;
    data['budget'] = this.budget;
    data['imei'] = this.imei;
    data['phonenumber'] = this.phonenumber;
    data['iam'] = this.iam;
    data['source_rms'] = this.sourceRms;
    data['referal'] = this.referal;
    return data;
  }
}