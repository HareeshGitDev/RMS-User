class WishListModel {
  String? msg;
  List<Data>? data;

  WishListModel({this.msg, this.data});

  WishListModel.fromJson(Map<String, dynamic> json) {
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
  String? propId;
  String? rmsProp;
  String? offerPrice;
  String? area;
  String? buildingName;
  String? areas;
  String? title;
  String? city;
  String? neighbor;
  String? uiAddress;
  String? unitType;
  String? newDetails;
  String? avlDate;
  String? furnishingType;
  String? description;
  String? bedrooms;
  String? bathrooms;
  String? maxGuests;
  String? freeGuests;
  String? overall;
  String? extraPerGuest;
  String? rmsRent;
  String? orgRmsRent;
  String? rmsDeposit;
  String? monthlyRent;
  String? orgMonthRent;
  String? weeklyRent;
  String? rent;
  String? orgRent;
  String? propType;
  String? roomType;
  String? glat;
  String? glng;
  String? userId;
  String? coliveType;
  String? roomTypeId;
  List<Pic>? pic;
  int? wishlist;

  Data(
      {this.propId,
        this.rmsProp,
        this.offerPrice,
        this.area,
        this.buildingName,
        this.areas,
        this.title,
        this.city,
        this.neighbor,
        this.uiAddress,
        this.unitType,
        this.newDetails,
        this.avlDate,
        this.furnishingType,
        this.description,
        this.bedrooms,
        this.bathrooms,
        this.maxGuests,
        this.freeGuests,
        this.overall,
        this.extraPerGuest,
        this.rmsRent,
        this.orgRmsRent,
        this.rmsDeposit,
        this.monthlyRent,
        this.orgMonthRent,
        this.weeklyRent,
        this.rent,
        this.orgRent,
        this.propType,
        this.roomType,
        this.glat,
        this.glng,
        this.userId,
        this.coliveType,
        this.roomTypeId,
        this.pic,
        this.wishlist});

  Data.fromJson(Map<String, dynamic> json) {
    propId = json['prop_id'];
    rmsProp = json['rms_prop'];
    offerPrice = json['offer_price'];
    area = json['area'];
    buildingName = json['building_name'];
    areas = json['areas'];
    title = json['title'];
    city = json['city'];
    neighbor = json['neighbor'];
    uiAddress = json['ui_address'];
    unitType = json['unit_type'];
    newDetails = json['new_details'];
    avlDate = json['avl_date'];
    furnishingType = json['furnishing_type'];
    description = json['description'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    maxGuests = json['max_guests'];
    freeGuests = json['free_guests'];
    overall = json['overall'];
    extraPerGuest = json['extra_per_guest'];
    rmsRent = json['rms_rent'];
    orgRmsRent = json['org_rms_rent'];
    rmsDeposit = json['rms_deposit'];
    monthlyRent = json['monthly_rent'];
    orgMonthRent = json['org_month_rent'];
    weeklyRent = json['weekly_rent'];
    rent = json['rent'];
    orgRent = json['org_rent'];
    propType = json['prop_type'];
    roomType = json['room_type'];
    glat = json['glat'];
    glng = json['glng'];
    userId = json['user_id'];
    coliveType = json['colive_type'];
    roomTypeId = json['room_type_id'];
    if (json['pic'] != null) {
      pic = <Pic>[];
      json['pic'].forEach((v) {
        pic!.add(new Pic.fromJson(v));
      });
    }
    wishlist = json['wishlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prop_id'] = this.propId;
    data['rms_prop'] = this.rmsProp;
    data['offer_price'] = this.offerPrice;
    data['area'] = this.area;
    data['building_name'] = this.buildingName;
    data['areas'] = this.areas;
    data['title'] = this.title;
    data['city'] = this.city;
    data['neighbor'] = this.neighbor;
    data['ui_address'] = this.uiAddress;
    data['unit_type'] = this.unitType;
    data['new_details'] = this.newDetails;
    data['avl_date'] = this.avlDate;
    data['furnishing_type'] = this.furnishingType;
    data['description'] = this.description;
    data['bedrooms'] = this.bedrooms;
    data['bathrooms'] = this.bathrooms;
    data['max_guests'] = this.maxGuests;
    data['free_guests'] = this.freeGuests;
    data['overall'] = this.overall;
    data['extra_per_guest'] = this.extraPerGuest;
    data['rms_rent'] = this.rmsRent;
    data['org_rms_rent'] = this.orgRmsRent;
    data['rms_deposit'] = this.rmsDeposit;
    data['monthly_rent'] = this.monthlyRent;
    data['org_month_rent'] = this.orgMonthRent;
    data['weekly_rent'] = this.weeklyRent;
    data['rent'] = this.rent;
    data['org_rent'] = this.orgRent;
    data['prop_type'] = this.propType;
    data['room_type'] = this.roomType;
    data['glat'] = this.glat;
    data['glng'] = this.glng;
    data['user_id'] = this.userId;
    data['colive_type'] = this.coliveType;
    data['room_type_id'] = this.roomTypeId;
    if (this.pic != null) {
      data['pic'] = this.pic!.map((v) => v.toJson()).toList();
    }
    data['wishlist'] = this.wishlist;
    return data;
  }
}

class Pic {
  String? propId;
  String? picLink;
  String? defaultPic;

  Pic({this.propId, this.picLink, this.defaultPic});

  Pic.fromJson(Map<String, dynamic> json) {
    propId = json['prop_id'];
    picLink = json['pic_link'];
    defaultPic = json['default_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prop_id'] = this.propId;
    data['pic_link'] = this.picLink;
    data['default_pic'] = this.defaultPic;
    return data;
  }
}