class PropertyDetailsModel {
  String? shareLink;
  Details? details;
  PropOwner? propOwner;
  Amenities? amenities;
  List<SimilarProp>? similarProp;

  PropertyDetailsModel(
      {this.shareLink,
        this.details,
        this.propOwner,
        this.amenities,
        this.similarProp});

  PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    shareLink = json['share_link'];
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
    propOwner = json['prop_owner'] != null
        ? new PropOwner.fromJson(json['prop_owner'])
        : null;
    amenities = json['amenities'] != null
        ? new Amenities.fromJson(json['amenities'])
        : null;
    if (json['similar_prop'] != null) {
      similarProp = <SimilarProp>[];
      json['similar_prop'].forEach((v) {
        similarProp!.add(new SimilarProp.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['share_link'] = this.shareLink;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    if (this.propOwner != null) {
      data['prop_owner'] = this.propOwner!.toJson();
    }
    if (this.amenities != null) {
      data['amenities'] = this.amenities!.toJson();
    }
    if (this.similarProp != null) {
      data['similar_prop'] = this.similarProp!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? area;
  String? buildingId;
  String? city;
  String? pdarea;
  String? propId;
  String? propertyName;
  String? bedrooms;
  String? bathrooms;
  String? maxGuests;
  String? freeGuests;
  String? extraPerGuest;
  String? unitArea;
  String? propFloor;
  String? propTypeId;
  String? roomTypeId;
  String? deposit;
  String? rent;
  String? orgRent;
  String? weeklyRent;
  String? monthlyRent;
  String? orgMonthRent;
  String? forMonthlyRent;
  String? rmsRent;
  String? orgRmsRent;
  String? rmsDeposit;
  String? lastMinDeal;
  String? currencyRefId;
  String? value;
  String? completeness;
  String? cleanliness;
  String? location;
  String? overall;
  String? advancePercentage;
  String? offerStatus;
  String? offerPrice;
  String? bookable;
  String? title;
  String? usp;
  String? description;
  String? buildingDesc;
  String? things2note;
  String? otherinfo;
  String? newDetails;
  String? getaround;
  String? neighbor;
  String? country;
  String? directions;
  String? state;
  String? uiAddress;
  String? zipCode;
  String? glat;
  String? glng;
  String? pageViews;
  String? numBooking;
  String? applyServiceCharges;
  String? active;
  String? videoLink;
  String? propType;
  String? furnishing;
  String? propTypeCat;
  String? propertyTypeDetail;
  String? stRental;
  String? ltRental;
  String? roomType;
  String? roomTypeCat;
  String? rmsProp;
  String? bname;
  List<Pic>? pic;
  String? salesNumber;
  String? userPic;

  Details(
      {this.area,
        this.buildingId,
        this.city,
        this.pdarea,
        this.propId,
        this.propertyName,
        this.bedrooms,
        this.bathrooms,
        this.maxGuests,
        this.freeGuests,
        this.extraPerGuest,
        this.unitArea,
        this.propFloor,
        this.propTypeId,
        this.roomTypeId,
        this.deposit,
        this.rent,
        this.orgRent,
        this.weeklyRent,
        this.monthlyRent,
        this.orgMonthRent,
        this.forMonthlyRent,
        this.rmsRent,
        this.orgRmsRent,
        this.rmsDeposit,
        this.lastMinDeal,
        this.currencyRefId,
        this.value,
        this.completeness,
        this.cleanliness,
        this.location,
        this.overall,
        this.advancePercentage,
        this.offerStatus,
        this.offerPrice,
        this.bookable,
        this.title,
        this.usp,
        this.description,
        this.buildingDesc,
        this.things2note,
        this.otherinfo,
        this.newDetails,
        this.getaround,
        this.neighbor,
        this.country,
        this.directions,
        this.state,
        this.uiAddress,
        this.zipCode,
        this.glat,
        this.glng,
        this.pageViews,
        this.numBooking,
        this.applyServiceCharges,
        this.active,
        this.videoLink,
        this.propType,
        this.furnishing,
        this.propTypeCat,
        this.propertyTypeDetail,
        this.stRental,
        this.ltRental,
        this.roomType,
        this.roomTypeCat,
        this.rmsProp,
        this.bname,
        this.pic,
        this.salesNumber,
        this.userPic});

  Details.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    buildingId = json['building_id'];
    city = json['city'];
    pdarea = json['pdarea'];
    propId = json['prop_id'];
    propertyName = json['property_name'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    maxGuests = json['max_guests'];
    freeGuests = json['free_guests'];
    extraPerGuest = json['extra_per_guest'];
    unitArea = json['unit_area'];
    propFloor = json['prop_floor'];
    propTypeId = json['prop_type_id'];
    roomTypeId = json['room_type_id'];
    deposit = json['deposit'];
    rent = json['rent'];
    orgRent = json['org_rent'];
    weeklyRent = json['weekly_rent'];
    monthlyRent = json['monthly_rent'];
    orgMonthRent = json['org_month_rent'];
    forMonthlyRent = json['for_monthly_rent'];
    rmsRent = json['rms_rent'];
    orgRmsRent = json['org_rms_rent'];
    rmsDeposit = json['rms_deposit'];
    lastMinDeal = json['last_min_deal'];
    currencyRefId = json['currency_ref_id'];
    value = json['value'];
    completeness = json['completeness'];
    cleanliness = json['cleanliness'];
    location = json['location'];
    overall = json['overall'];
    advancePercentage = json['advance_percentage'];
    offerStatus = json['offer_status'];
    offerPrice = json['offer_price'];
    bookable = json['bookable'];
    title = json['title'];
    usp = json['usp'];
    description = json['description'];
    buildingDesc = json['building_desc'];
    things2note = json['things2note'];
    otherinfo = json['otherinfo'];
    newDetails = json['new_details'];
    getaround = json['getaround'];
    neighbor = json['neighbor'];
    country = json['country'];
    directions = json['directions'];
    state = json['state'];
    uiAddress = json['ui_address'];
    zipCode = json['zip_code'];
    glat = json['glat'];
    glng = json['glng'];
    pageViews = json['page_views'];
    numBooking = json['num_booking'];
    applyServiceCharges = json['apply_service_charges'];
    active = json['active'];
    videoLink = json['video_link'];
    propType = json['prop_type'];
    furnishing = json['furnishing'];
    propTypeCat = json['prop_type_cat'];
    propertyTypeDetail = json['property_type_detail'];
    stRental = json['st_rental'];
    ltRental = json['lt_rental'];
    roomType = json['room_type'];
    roomTypeCat = json['room_type_cat'];
    rmsProp = json['rms_prop'];
    bname = json['bname'];
    if (json['pic'] != null) {
      pic = <Pic>[];
      json['pic'].forEach((v) {
        pic!.add(new Pic.fromJson(v));
      });
    }
    salesNumber = json['sales_number'];
    userPic = json['user_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['building_id'] = this.buildingId;
    data['city'] = this.city;
    data['pdarea'] = this.pdarea;
    data['prop_id'] = this.propId;
    data['property_name'] = this.propertyName;
    data['bedrooms'] = this.bedrooms;
    data['bathrooms'] = this.bathrooms;
    data['max_guests'] = this.maxGuests;
    data['free_guests'] = this.freeGuests;
    data['extra_per_guest'] = this.extraPerGuest;
    data['unit_area'] = this.unitArea;
    data['prop_floor'] = this.propFloor;
    data['prop_type_id'] = this.propTypeId;
    data['room_type_id'] = this.roomTypeId;
    data['deposit'] = this.deposit;
    data['rent'] = this.rent;
    data['org_rent'] = this.orgRent;
    data['weekly_rent'] = this.weeklyRent;
    data['monthly_rent'] = this.monthlyRent;
    data['org_month_rent'] = this.orgMonthRent;
    data['for_monthly_rent'] = this.forMonthlyRent;
    data['rms_rent'] = this.rmsRent;
    data['org_rms_rent'] = this.orgRmsRent;
    data['rms_deposit'] = this.rmsDeposit;
    data['last_min_deal'] = this.lastMinDeal;
    data['currency_ref_id'] = this.currencyRefId;
    data['value'] = this.value;
    data['completeness'] = this.completeness;
    data['cleanliness'] = this.cleanliness;
    data['location'] = this.location;
    data['overall'] = this.overall;
    data['advance_percentage'] = this.advancePercentage;
    data['offer_status'] = this.offerStatus;
    data['offer_price'] = this.offerPrice;
    data['bookable'] = this.bookable;
    data['title'] = this.title;
    data['usp'] = this.usp;
    data['description'] = this.description;
    data['building_desc'] = this.buildingDesc;
    data['things2note'] = this.things2note;
    data['otherinfo'] = this.otherinfo;
    data['new_details'] = this.newDetails;
    data['getaround'] = this.getaround;
    data['neighbor'] = this.neighbor;
    data['country'] = this.country;
    data['directions'] = this.directions;
    data['state'] = this.state;
    data['ui_address'] = this.uiAddress;
    data['zip_code'] = this.zipCode;
    data['glat'] = this.glat;
    data['glng'] = this.glng;
    data['page_views'] = this.pageViews;
    data['num_booking'] = this.numBooking;
    data['apply_service_charges'] = this.applyServiceCharges;
    data['active'] = this.active;
    data['video_link'] = this.videoLink;
    data['prop_type'] = this.propType;
    data['furnishing'] = this.furnishing;
    data['prop_type_cat'] = this.propTypeCat;
    data['property_type_detail'] = this.propertyTypeDetail;
    data['st_rental'] = this.stRental;
    data['lt_rental'] = this.ltRental;
    data['room_type'] = this.roomType;
    data['room_type_cat'] = this.roomTypeCat;
    data['rms_prop'] = this.rmsProp;
    data['bname'] = this.bname;
    if (this.pic != null) {
      data['pic'] = this.pic!.map((v) => v.toJson()).toList();
    }
    data['sales_number'] = this.salesNumber;
    data['user_pic'] = this.userPic;
    return data;
  }
}

class Pic {
  String? propId;
  String? picLink;
  String? picWp;
  String? picThumbnail;
  String? picDesc;
  String? id;
  String? picOrgLink;
  String? category;
  String? onCloud;
  String? online;

  Pic(
      {this.propId,
        this.picLink,
        this.picWp,
        this.picThumbnail,
        this.picDesc,
        this.id,
        this.picOrgLink,
        this.category,
        this.onCloud,
        this.online});

  Pic.fromJson(Map<String, dynamic> json) {
    propId = json['prop_id'];
    picLink = json['pic_link'];
    picWp = json['pic_wp'];
    picThumbnail = json['pic_thumbnail'];
    picDesc = json['pic_desc'];
    id = json['id'];
    picOrgLink = json['pic_org_link'];
    category = json['category'];
    onCloud = json['on_cloud'];
    online = json['online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prop_id'] = this.propId;
    data['pic_link'] = this.picLink;
    data['pic_wp'] = this.picWp;
    data['pic_thumbnail'] = this.picThumbnail;
    data['pic_desc'] = this.picDesc;
    data['id'] = this.id;
    data['pic_org_link'] = this.picOrgLink;
    data['category'] = this.category;
    data['on_cloud'] = this.onCloud;
    data['online'] = this.online;
    return data;
  }
}

class PropOwner {
  String? fullname;
  String? firstname;
  String? lastname;
  String? picture;
  String? appToken;
  String? accountId;

  PropOwner(
      {this.fullname,
        this.firstname,
        this.lastname,
        this.picture,
        this.appToken,
        this.accountId});

  PropOwner.fromJson(Map<String, dynamic> json) {
    fullname = json['fullname'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    picture = json['picture'];
    appToken = json['app_token'];
    accountId = json['account_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullname'] = this.fullname;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['picture'] = this.picture;
    data['app_token'] = this.appToken;
    data['account_id'] = this.accountId;
    return data;
  }
}

class Amenities {
  String? security;
  String? elevator;
  String? washingMachine;

  Amenities({this.security, this.elevator, this.washingMachine});

  Amenities.fromJson(Map<String, dynamic> json) {
    security = json['security'];
    elevator = json['elevator'];
    washingMachine = json['washing_machine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['security'] = this.security;
    data['elevator'] = this.elevator;
    data['washing_machine'] = this.washingMachine;
    return data;
  }
}

class SimilarProp {
  String? propId;
  String? title;
  String? buildingName;
  String? glat;
  String? glng;
  String? propType;
  String? unitType;
  String? newDetails;
  String? neighbor;
  String? area;
  String? city;
  String? roomType;
  String? orgRent;
  String? rent;
  String? monthlyRent;
  String? rmsRent;
  String? uiAddress;
  String? freeGuests;
  String? extraPerGuest;
  String? maxGuests;
  String? bedrooms;
  String? rmsDeposit;
  String? distance;
  String? picThumbnail;
  String? rmsProp;
  int? wishlist;
  String? picture;

  SimilarProp(
      {this.propId,
        this.title,
        this.buildingName,
        this.glat,
        this.glng,
        this.propType,
        this.unitType,
        this.newDetails,
        this.neighbor,
        this.area,
        this.city,
        this.roomType,
        this.orgRent,
        this.rent,
        this.monthlyRent,
        this.rmsRent,
        this.uiAddress,
        this.freeGuests,
        this.extraPerGuest,
        this.maxGuests,
        this.bedrooms,
        this.rmsDeposit,
        this.distance,
        this.picThumbnail,
        this.rmsProp,
        this.wishlist,
        this.picture});

  SimilarProp.fromJson(Map<String, dynamic> json) {
    propId = json['prop_id'];
    title = json['title'];
    buildingName = json['building_name'];
    glat = json['glat'];
    glng = json['glng'];
    propType = json['prop_type'];
    unitType = json['unit_type'];
    newDetails = json['new_details'];
    neighbor = json['neighbor'];
    area = json['area'];
    city = json['city'];
    roomType = json['room_type'];
    orgRent = json['org_rent'];
    rent = json['rent'];
    monthlyRent = json['monthly_rent'];
    rmsRent = json['rms_rent'];
    uiAddress = json['ui_address'];
    freeGuests = json['free_guests'];
    extraPerGuest = json['extra_per_guest'];
    maxGuests = json['max_guests'];
    bedrooms = json['bedrooms'];
    rmsDeposit = json['rms_deposit'];
    distance = json['distance'];
    picThumbnail = json['pic_thumbnail'];
    rmsProp = json['rms_prop'];
    wishlist = json['wishlist'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prop_id'] = this.propId;
    data['title'] = this.title;
    data['building_name'] = this.buildingName;
    data['glat'] = this.glat;
    data['glng'] = this.glng;
    data['prop_type'] = this.propType;
    data['unit_type'] = this.unitType;
    data['new_details'] = this.newDetails;
    data['neighbor'] = this.neighbor;
    data['area'] = this.area;
    data['city'] = this.city;
    data['room_type'] = this.roomType;
    data['org_rent'] = this.orgRent;
    data['rent'] = this.rent;
    data['monthly_rent'] = this.monthlyRent;
    data['rms_rent'] = this.rmsRent;
    data['ui_address'] = this.uiAddress;
    data['free_guests'] = this.freeGuests;
    data['extra_per_guest'] = this.extraPerGuest;
    data['max_guests'] = this.maxGuests;
    data['bedrooms'] = this.bedrooms;
    data['rms_deposit'] = this.rmsDeposit;
    data['distance'] = this.distance;
    data['pic_thumbnail'] = this.picThumbnail;
    data['rms_prop'] = this.rmsProp;
    data['wishlist'] = this.wishlist;
    data['picture'] = this.picture;
    return data;
  }
}