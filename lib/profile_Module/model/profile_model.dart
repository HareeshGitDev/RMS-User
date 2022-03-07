class ProfileModel {
  String? status;
  List<Result>? result;
  ProfileCompletion? profileCompletion;

  ProfileModel({this.status, this.result, this.profileCompletion});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    profileCompletion = json['profile_completion'] != null
        ? new ProfileCompletion.fromJson(json['profile_completion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    if (profileCompletion != null) {
      data['profile_completion'] = profileCompletion!.toJson();
    }
    return data;
  }
}

class Result {
  String? userId;
  String? username;
  String? email;
  String? contactNo;
  String? isAdmin;
  String? team;
  String? org;
  String? appToken;
  String? status;
  String? type;
  String? otpVerified;
  String? firstname;
  String? lastname;
  String? contactNum;
  String? picture;
  String? refferalMoney;
  String? userVerifiedStatus;
  String? userVerifiedDetails;
  String? verifiedBy;
  String? agreementStatus;
  String? androidOtpVerify;
  String? bookingId;
  String? tenantName;
  String? tenantEmail;
  String? contactNumber;
  String? permanentAddress;
  String? sex;
  String? dob;
  String? panNum;
  String? employmentStatus;
  String? purpose;
  String? companyName;
  String? companyMailId;
  String? companyAddress;
  String? workLoc;
  List<Pic>? pic;

  Result(
      {this.userId,
        this.username,
        this.email,
        this.contactNo,
        this.isAdmin,
        this.team,
        this.org,
        this.appToken,
        this.status,
        this.type,
        this.otpVerified,
        this.firstname,
        this.lastname,
        this.contactNum,
        this.picture,
        this.refferalMoney,
        this.userVerifiedStatus,
        this.userVerifiedDetails,
        this.verifiedBy,
        this.agreementStatus,
        this.androidOtpVerify,
        this.bookingId,
        this.tenantName,
        this.tenantEmail,
        this.contactNumber,
        this.permanentAddress,
        this.sex,
        this.dob,
        this.panNum,
        this.employmentStatus,
        this.purpose,
        this.companyName,
        this.companyMailId,
        this.companyAddress,
        this.workLoc,
        this.pic});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    email = json['email'];
    contactNo = json['contact_no'];
    isAdmin = json['is_admin'];
    team = json['team'];
    org = json['org'];
    appToken = json['app_token'];
    status = json['status'];
    type = json['type'];
    otpVerified = json['otp_verified'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    contactNum = json['contact_num'];
    picture = json['picture'];
    refferalMoney = json['refferal_money'];
    userVerifiedStatus = json['user_verified_status'];
    userVerifiedDetails = json['user_verified_details'];
    verifiedBy = json['verified_by'];
    agreementStatus = json['agreement_status'];
    androidOtpVerify = json['android_otp_verify'];
    bookingId = json['booking_id'];
    tenantName = json['tenant_name'];
    tenantEmail = json['tenant_email'];
    contactNumber = json['contact_number'];
    permanentAddress = json['permanent_address'];
    sex = json['sex'];
    dob = json['dob'];
    panNum = json['pan_num'];
    employmentStatus = json['employment_status'];
    purpose = json['purpose'];
    companyName = json['company_name'];
    companyMailId = json['company_mail_id'];
    companyAddress = json['company_address'];
    workLoc = json['work_loc'];
    if (json['pic'] != null) {
      pic = <Pic>[];
      json['pic'].forEach((v) {
        pic!.add(new Pic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['contact_no'] = this.contactNo;
    data['is_admin'] = this.isAdmin;
    data['team'] = this.team;
    data['org'] = this.org;
    data['app_token'] = this.appToken;
    data['status'] = this.status;
    data['type'] = this.type;
    data['otp_verified'] = this.otpVerified;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['contact_num'] = this.contactNum;
    data['picture'] = this.picture;
    data['refferal_money'] = this.refferalMoney;
    data['user_verified_status'] = this.userVerifiedStatus;
    data['user_verified_details'] = this.userVerifiedDetails;
    data['verified_by'] = this.verifiedBy;
    data['agreement_status'] = this.agreementStatus;
    data['android_otp_verify'] = this.androidOtpVerify;
    data['booking_id'] = this.bookingId;
    data['tenant_name'] = this.tenantName;
    data['tenant_email'] = this.tenantEmail;
    data['contact_number'] = this.contactNumber;
    data['permanent_address'] = this.permanentAddress;
    data['sex'] = this.sex;
    data['dob'] = this.dob;
    data['pan_num'] = this.panNum;
    data['employment_status'] = this.employmentStatus;
    data['purpose'] = this.purpose;
    data['company_name'] = this.companyName;
    data['company_mail_id'] = this.companyMailId;
    data['company_address'] = this.companyAddress;
    data['work_loc'] = this.workLoc;
    if (this.pic != null) {
      data['pic'] = this.pic!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pic {
  String? link;
  String? desc;
  String? type;

  Pic({this.link, this.desc, this.type});

  Pic.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    desc = json['desc'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['desc'] = this.desc;
    data['type'] = this.type;
    return data;
  }
}

class ProfileCompletion {
  String? pic;
  String? idp;
  String? wid;
  String? employmentStatus;
  int? percent;

  ProfileCompletion(
      {this.pic, this.idp, this.wid, this.employmentStatus, this.percent});

  ProfileCompletion.fromJson(Map<String, dynamic> json) {
    pic = json['pic'];
    idp = json['idp'];
    wid = json['wid'];
    employmentStatus = json['employment_status'];
    percent = json['percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pic'] = this.pic;
    data['idp'] = this.idp;
    data['wid'] = this.wid;
    data['employment_status'] = this.employmentStatus;
    data['percent'] = this.percent;
    return data;
  }
}