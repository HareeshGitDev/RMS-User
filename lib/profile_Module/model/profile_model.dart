class ProfileModel {
  String? msg;
  Data? data;

  ProfileModel({this.msg, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  List<Result>? result;
  ProfileCompletion? profileCompletion;

  Data({this.result, this.profileCompletion});

  Data.fromJson(Map<String, dynamic> json) {
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
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
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
  dynamic dob;
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
  String? id;
  String? userId;
  String? bookingId;
  String? tenantName;
  String? tenantEmail;
  String? contactNumber;
  String? fathersName;
  String? permanentAddress;
  String? emergencyContact;
  String? dob;
  String? sex;
  String? panNum;
  String? employmentStatus;
  String? purpose;
  String? companyName;
  String? companyMailId;
  String? companyAddress;
  String? facebook;
  String? linkedin;
  String? bankName;
  String? accoundNumber;
  String? branch;
  String? ifscCode;
  String? bookingIdDetails;
  String? proofStatus;
  String? altContactNumber;
  String? trackBookNow;
  String? tenantAltEmail;
  String? tenant;
  String? workLoc;
  String? accname;
  String? acctype;
  String? workingSince;
  String? salary;
  String? emerName;
  String? emerMail;
  String? emerRelationship;
  String? country;
  String? income;
  String? addedon;
  String? addedBy;
  String? pic;
  String? idp;
  String? wid;
  String? sid;
  String? bid;
  int? percent;

  ProfileCompletion(
      {this.id,
        this.userId,
        this.bookingId,
        this.tenantName,
        this.tenantEmail,
        this.contactNumber,
        this.fathersName,
        this.permanentAddress,
        this.emergencyContact,
        this.dob,
        this.sex,
        this.panNum,
        this.employmentStatus,
        this.purpose,
        this.companyName,
        this.companyMailId,
        this.companyAddress,
        this.facebook,
        this.linkedin,
        this.bankName,
        this.accoundNumber,
        this.branch,
        this.ifscCode,
        this.bookingIdDetails,
        this.proofStatus,
        this.altContactNumber,
        this.trackBookNow,
        this.tenantAltEmail,
        this.tenant,
        this.workLoc,
        this.accname,
        this.acctype,
        this.workingSince,
        this.salary,
        this.emerName,
        this.emerMail,
        this.emerRelationship,
        this.country,
        this.income,
        this.addedon,
        this.addedBy,
        this.pic,
        this.idp,
        this.wid,
        this.sid,
        this.bid,
        this.percent});

  ProfileCompletion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookingId = json['booking_id'];
    tenantName = json['tenant_name'];
    tenantEmail = json['tenant_email'];
    contactNumber = json['contact_number'];
    fathersName = json['fathers_name'];
    permanentAddress = json['permanent_address'];
    emergencyContact = json['emergency_contact'];
    dob = json['dob'];
    sex = json['sex'];
    panNum = json['pan_num'];
    employmentStatus = json['employment_status'];
    purpose = json['purpose'];
    companyName = json['company_name'];
    companyMailId = json['company_mail_id'];
    companyAddress = json['company_address'];
    facebook = json['facebook'];
    linkedin = json['linkedin'];
    bankName = json['bank_name'];
    accoundNumber = json['accound_number'];
    branch = json['branch'];
    ifscCode = json['ifsc_code'];
    bookingIdDetails = json['booking_id_details'];
    proofStatus = json['proof_status'];
    altContactNumber = json['alt_contact_number'];
    trackBookNow = json['track_book_now'];
    tenantAltEmail = json['tenant_alt_email'];
    tenant = json['tenant'];
    workLoc = json['work_loc'];
    accname = json['accname'];
    acctype = json['acctype'];
    workingSince = json['working_since'];
    salary = json['salary'];
    emerName = json['emer_name'];
    emerMail = json['emer_mail'];
    emerRelationship = json['emer_relationship'];
    country = json['country'];
    income = json['income'];
    addedon = json['addedon'];
    addedBy = json['added_by'];
    pic = json['pic'];
    idp = json['idp'];
    wid = json['wid'];
    sid = json['sid'];
    bid = json['bid'];
    percent = json['percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['booking_id'] = this.bookingId;
    data['tenant_name'] = this.tenantName;
    data['tenant_email'] = this.tenantEmail;
    data['contact_number'] = this.contactNumber;
    data['fathers_name'] = this.fathersName;
    data['permanent_address'] = this.permanentAddress;
    data['emergency_contact'] = this.emergencyContact;
    data['dob'] = this.dob;
    data['sex'] = this.sex;
    data['pan_num'] = this.panNum;
    data['employment_status'] = this.employmentStatus;
    data['purpose'] = this.purpose;
    data['company_name'] = this.companyName;
    data['company_mail_id'] = this.companyMailId;
    data['company_address'] = this.companyAddress;
    data['facebook'] = this.facebook;
    data['linkedin'] = this.linkedin;
    data['bank_name'] = this.bankName;
    data['accound_number'] = this.accoundNumber;
    data['branch'] = this.branch;
    data['ifsc_code'] = this.ifscCode;
    data['booking_id_details'] = this.bookingIdDetails;
    data['proof_status'] = this.proofStatus;
    data['alt_contact_number'] = this.altContactNumber;
    data['track_book_now'] = this.trackBookNow;
    data['tenant_alt_email'] = this.tenantAltEmail;
    data['tenant'] = this.tenant;
    data['work_loc'] = this.workLoc;
    data['accname'] = this.accname;
    data['acctype'] = this.acctype;
    data['working_since'] = this.workingSince;
    data['salary'] = this.salary;
    data['emer_name'] = emerName;
    data['emer_mail'] = emerMail;
    data['emer_relationship'] = emerRelationship;
    data['country'] = country;
    data['income'] = income;
    data['addedon'] = addedon;
    data['added_by'] = addedBy;
    data['pic'] = pic;
    data['idp'] = idp;
    data['wid'] = wid;
    data['sid'] = sid;
    data['bid'] = bid;
    data['percent'] = percent;
    return data;
  }
}