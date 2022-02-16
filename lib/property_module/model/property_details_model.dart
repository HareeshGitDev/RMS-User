class PropertyDetailsModel {
  bool? success;
  String? pCount;
  ReturnAddress? returnAddress;
  bool? addPresent;
  int? distance;
  int? responseCount;
  int? availableProps;
  List<Data>? data;
  Latlng? latlng;
  PropExpDesc? propExpDesc;
  String? userProfilePic;
  String? status;

  PropertyDetailsModel(
      {this.success,
        this.pCount,
        this.returnAddress,
        this.addPresent,
        this.distance,
        this.responseCount,
        this.availableProps,
        this.data,
        this.latlng,
        this.propExpDesc,
        this.userProfilePic,
        this.status});

  PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    pCount = json['p_count'];
    returnAddress = json['return_address'] != null
        ? new ReturnAddress.fromJson(json['return_address'])
        : null;
    addPresent = json['add_present'];
    distance = json['distance'];
    responseCount = json['response_count'];
    availableProps = json['available_props'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    latlng =
    json['latlng'] != null ? new Latlng.fromJson(json['latlng']) : null;
    propExpDesc = json['prop_exp_desc'] != null
        ? new PropExpDesc.fromJson(json['prop_exp_desc'])
        : null;
    userProfilePic = json['user_profile_pic'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['p_count'] = this.pCount;
    if (this.returnAddress != null) {
      data['return_address'] = this.returnAddress!.toJson();
    }
    data['add_present'] = this.addPresent;
    data['distance'] = this.distance;
    data['response_count'] = this.responseCount;
    data['available_props'] = this.availableProps;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.latlng != null) {
      data['latlng'] = this.latlng!.toJson();
    }
    if (this.propExpDesc != null) {
      data['prop_exp_desc'] = this.propExpDesc!.toJson();
    }
    data['user_profile_pic'] = this.userProfilePic;
    data['status'] = this.status;
    return data;
  }
}

class ReturnAddress {
  String? address;
  String? sublocality;
  String? city;
  String? state;
  String? country;
  String? lat;
  String? lng;
  String? searchCount;
  String? lastSearchTime;

  ReturnAddress(
      {this.address,
        this.sublocality,
        this.city,
        this.state,
        this.country,
        this.lat,
        this.lng,
        this.searchCount,
        this.lastSearchTime});

  ReturnAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    sublocality = json['sublocality'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    lat = json['lat'];
    lng = json['lng'];
    searchCount = json['search_count'];
    lastSearchTime = json['last_search_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['sublocality'] = this.sublocality;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['search_count'] = this.searchCount;
    data['last_search_time'] = this.lastSearchTime;
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
  String? rentSort;
  String? offerStatus;
  String? distance;
  Null? available;
  String? avl;
  String? encdPropId;
  String? propUrl;
  String? encdUserId;
  List<PropPics>? propPics;
  String? salesNumber;
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
        this.rentSort,
        this.offerStatus,
        this.distance,
        this.available,
        this.avl,
        this.encdPropId,
        this.propUrl,
        this.encdUserId,
        this.propPics,
        this.salesNumber,
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
    rentSort = json['rent_sort'];
    offerStatus = json['offer_status'];
    distance = json['distance'];
    available = json['available'];
    avl = json['avl'];
    encdPropId = json['encd_prop_id'];
    propUrl = json['prop_url'];
    encdUserId = json['encd_user_id'];
    if (json['prop_pics'] != null) {
      propPics = <PropPics>[];
      json['prop_pics'].forEach((v) {
        propPics!.add(new PropPics.fromJson(v));
      });
    }
    salesNumber = json['sales_number'];
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
    data['rent_sort'] = this.rentSort;
    data['offer_status'] = this.offerStatus;
    data['distance'] = this.distance;
    data['available'] = this.available;
    data['avl'] = this.avl;
    data['encd_prop_id'] = this.encdPropId;
    data['prop_url'] = this.propUrl;
    data['encd_user_id'] = this.encdUserId;
    if (this.propPics != null) {
      data['prop_pics'] = this.propPics!.map((v) => v.toJson()).toList();
    }
    data['sales_number'] = this.salesNumber;
    data['wishlist'] = this.wishlist;
    return data;
  }
}

class PropPics {
  String? propId;
  String? picLink;
  String? defaultPic;

  PropPics({this.propId, this.picLink, this.defaultPic});

  PropPics.fromJson(Map<String, dynamic> json) {
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

class Latlng {
  String? lat;
  String? lng;

  Latlng({this.lat, this.lng});

  Latlng.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class PropExpDesc {
  String? corporateSuite;
  String? central;
  String? beach;
  String? budget;
  String? scenic;
  String? romantic;
  String? nature;
  String? group;
  String? luxury;
  String? traditional;
  String? shopping;

  PropExpDesc(
      {this.corporateSuite,
        this.central,
        this.beach,
        this.budget,
        this.scenic,
        this.romantic,
        this.nature,
        this.group,
        this.luxury,
        this.traditional,
        this.shopping});

  PropExpDesc.fromJson(Map<String, dynamic> json) {
    corporateSuite = json['corporate_suite'];
    central = json['central'];
    beach = json['beach'];
    budget = json['budget'];
    scenic = json['scenic'];
    romantic = json['romantic'];
    nature = json['nature'];
    group = json['group'];
    luxury = json['luxury'];
    traditional = json['traditional'];
    shopping = json['shopping'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['corporate_suite'] = this.corporateSuite;
    data['central'] = this.central;
    data['beach'] = this.beach;
    data['budget'] = this.budget;
    data['scenic'] = this.scenic;
    data['romantic'] = this.romantic;
    data['nature'] = this.nature;
    data['group'] = this.group;
    data['luxury'] = this.luxury;
    data['traditional'] = this.traditional;
    data['shopping'] = this.shopping;
    return data;
  }
}