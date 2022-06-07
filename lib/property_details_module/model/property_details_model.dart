class PropertyDetailsModel {
  String? msg;
  Data? data;

  PropertyDetailsModel({this.msg, this.data});

  PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? shareLink;
  Details? details;
  PropOwner? propOwner;
  Amenities? amenities;
  List<SimilarProp>? similarProp;
  List<NearBy>? nearBy;

  Data(
      {this.shareLink,
        this.details,
        this.propOwner,
        this.amenities,
        this.similarProp,
        this.nearBy});

  Data.fromJson(Map<String, dynamic> json) {
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
    if (json['near_by'] != null) {
      nearBy = <NearBy>[];
      json['near_by'].forEach((v) {
        nearBy!.add(new NearBy.fromJson(v));
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
    if (this.nearBy != null) {
      data['near_by'] = this.nearBy!.map((v) => v.toJson()).toList();
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
  dynamic deposit;
  dynamic rent;
  dynamic orgRent;
  dynamic weeklyRent;
  dynamic monthlyRent;
  dynamic orgMonthRent;
  dynamic forMonthlyRent;
  dynamic rmsRent;
  dynamic orgRmsRent;
  dynamic rmsDeposit;
  String? lastMinDeal;
  String? currencyRefId;
  String? value;
  String? completeness;
  String? cleanliness;
  String? location;
  String? overall;
  dynamic advancePercentage;
  String? offerStatus;
  String? offerPrice;
  String? bookable;
  String? title;
  String? usp;
  String? description;
  String? buildingDesc;
  String? things2note;
  dynamic otherinfo;
  String? newDetails;
  dynamic getaround;
  dynamic neighbor;
  String? country;
  String? directions;
  String? state;
  String? uiAddress;
  String? zipCode;
  String? glat;
  String? glng;
  String? pageViews;
  dynamic numBooking;
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
  String? sales;
  List<Pic>? pic;
  int? wishlist;
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
        this.sales,
        this.pic,
        this.wishlist,
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
    sales = json['sales'];
    if (json['pic'] != null) {
      pic = <Pic>[];
      json['pic'].forEach((v) {
        pic!.add(new Pic.fromJson(v));
      });
    }
    wishlist = json['wishlist'];
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
    data['sales'] = this.sales;
    if (this.pic != null) {
      data['pic'] = this.pic!.map((v) => v.toJson()).toList();
    }
    data['wishlist'] = this.wishlist;
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
  String? cableTv;
  String? kitchen;
  String? refrigerator;
  String? centerTable;
  String? washingMachine;
  String? sofaDeewan;
  String? cotMattress;
  String? curtains;
  String? bucketsMugs;
  String? dustbin;
  String? geysers;
  String? bikeParking;
  String? carParking;
  String? airConditioning;
  String? balcony;
  String? elevator;
  String? pool;
  String? powerBackup;
  String? security;
  String? clubhouse;
  String? essentials;
  String? wifi;
  String? heating;
  String? breakfast;
  String? stoveCylinder;
  String? smoking;
  String? foodService;
  String? housekeeping;

  Amenities(
      {this.cableTv,
        this.kitchen,
        this.refrigerator,
        this.centerTable,
        this.washingMachine,
        this.sofaDeewan,
        this.cotMattress,
        this.curtains,
        this.bucketsMugs,
        this.dustbin,
        this.geysers,
        this.bikeParking,
        this.carParking,
        this.airConditioning,
        this.balcony,
        this.elevator,
        this.pool,
        this.powerBackup,
        this.security,
        this.clubhouse,
        this.essentials,
        this.wifi,
        this.heating,
        this.breakfast,
        this.stoveCylinder,
        this.smoking,
        this.foodService,
        this.housekeeping});

  Amenities.fromJson(Map<String, dynamic> json) {
    cableTv = json['cable_tv'];
    kitchen = json['kitchen'];
    refrigerator = json['refrigerator'];
    centerTable = json['center_table'];
    washingMachine = json['washing_machine'];
    sofaDeewan = json['sofa_deewan'];
    cotMattress = json['cot_mattress'];
    curtains = json['curtains'];
    bucketsMugs = json['buckets_mugs'];
    dustbin = json['dustbin'];
    geysers = json['geysers'];
    bikeParking = json['bike_parking'];
    carParking = json['car_parking'];
    airConditioning = json['air_conditioning'];
    balcony = json['balcony'];
    elevator = json['elevator'];
    pool = json['pool'];
    powerBackup = json['power_backup'];
    security = json['security'];
    clubhouse = json['clubhouse'];
    essentials = json['essentials'];
    wifi = json['wifi'];
    heating = json['heating'];
    breakfast = json['breakfast'];
    stoveCylinder = json['stove_cylinder'];
    smoking = json['smoking'];
    foodService = json['food_service'];
    housekeeping = json['housekeeping'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cable_tv'] = this.cableTv;
    data['kitchen'] = this.kitchen;
    data['refrigerator'] = this.refrigerator;
    data['center_table'] = this.centerTable;
    data['washing_machine'] = this.washingMachine;
    data['sofa_deewan'] = this.sofaDeewan;
    data['cot_mattress'] = this.cotMattress;
    data['curtains'] = this.curtains;
    data['buckets_mugs'] = this.bucketsMugs;
    data['dustbin'] = this.dustbin;
    data['geysers'] = this.geysers;
    data['bike_parking'] = this.bikeParking;
    data['car_parking'] = this.carParking;
    data['air_conditioning'] = this.airConditioning;
    data['balcony'] = this.balcony;
    data['elevator'] = this.elevator;
    data['pool'] = this.pool;
    data['power_backup'] = this.powerBackup;
    data['security'] = this.security;
    data['clubhouse'] = this.clubhouse;
    data['essentials'] = this.essentials;
    data['wifi'] = this.wifi;
    data['heating'] = this.heating;
    data['breakfast'] = this.breakfast;
    data['stove_cylinder'] = this.stoveCylinder;
    data['smoking'] = this.smoking;
    data['food_service'] = this.foodService;
    data['housekeeping'] = this.housekeeping;
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
  dynamic neighbor;
  String? area;
  String? city;
  String? roomType;
  dynamic orgRent;
  dynamic rent;
  dynamic monthlyRent;
  dynamic orgMonthRent;
  dynamic rmsRent;
  dynamic orgRmsRent;
  String? uiAddress;
  String? freeGuests;
  String? extraPerGuest;
  String? maxGuests;
  String? bedrooms;
  String? rmsDeposit;
  String? picThumbnail;
  String? enId;
  dynamic rentOff;
  dynamic monthRentOff;
  dynamic rmsRentOff;
  int? wishlist;

  SimilarProp(
      {this.propId,
        this.title,
        this.buildingName,
        this.glat,
        this.glng,
        this.propType,
        this.unitType,
        this.neighbor,
        this.area,
        this.city,
        this.roomType,
        this.orgRent,
        this.rent,
        this.monthlyRent,
        this.orgMonthRent,
        this.rmsRent,
        this.orgRmsRent,
        this.uiAddress,
        this.freeGuests,
        this.extraPerGuest,
        this.maxGuests,
        this.bedrooms,
        this.rmsDeposit,
        this.picThumbnail,
        this.enId,
        this.rentOff,
        this.monthRentOff,
        this.rmsRentOff,
        this.wishlist});

  SimilarProp.fromJson(Map<String, dynamic> json) {
    propId = json['prop_id'];
    title = json['title'];
    buildingName = json['building_name'];
    glat = json['glat'];
    glng = json['glng'];
    propType = json['prop_type'];
    unitType = json['unit_type'];
    neighbor = json['neighbor'];
    area = json['area'];
    city = json['city'];
    roomType = json['room_type'];
    orgRent = json['org_rent'];
    rent = json['rent'];
    monthlyRent = json['monthly_rent'];
    orgMonthRent = json['org_month_rent'];
    rmsRent = json['rms_rent'];
    orgRmsRent = json['org_rms_rent'];
    uiAddress = json['ui_address'];
    freeGuests = json['free_guests'];
    extraPerGuest = json['extra_per_guest'];
    maxGuests = json['max_guests'];
    bedrooms = json['bedrooms'];
    rmsDeposit = json['rms_deposit'];
    picThumbnail = json['pic_thumbnail'];
    enId = json['en_id'];
    rentOff = json['rent_off'];
    monthRentOff = json['month_rent_off'];
    rmsRentOff = json['rms_rent_off'];
    wishlist = json['wishlist'];
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
    data['neighbor'] = this.neighbor;
    data['area'] = this.area;
    data['city'] = this.city;
    data['room_type'] = this.roomType;
    data['org_rent'] = this.orgRent;
    data['rent'] = this.rent;
    data['monthly_rent'] = this.monthlyRent;
    data['org_month_rent'] = this.orgMonthRent;
    data['rms_rent'] = this.rmsRent;
    data['org_rms_rent'] = this.orgRmsRent;
    data['ui_address'] = this.uiAddress;
    data['free_guests'] = this.freeGuests;
    data['extra_per_guest'] = this.extraPerGuest;
    data['max_guests'] = this.maxGuests;
    data['bedrooms'] = this.bedrooms;
    data['rms_deposit'] = this.rmsDeposit;
    data['pic_thumbnail'] = this.picThumbnail;
    data['en_id'] = this.enId;
    data['rent_off'] = this.rentOff;
    data['month_rent_off'] = this.monthRentOff;
    data['rms_rent_off'] = this.rmsRentOff;
    data['wishlist'] = this.wishlist;
    return data;
  }
}

class NearBy {
  String? placeType;
  List<PlaceList>? placeList;

  NearBy({this.placeType, this.placeList});

  NearBy.fromJson(Map<String, dynamic> json) {
    placeType = json['place_type'];
    if (json['place_list'] != null) {
      placeList = <PlaceList>[];
      json['place_list'].forEach((v) {
        placeList!.add(new PlaceList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['place_type'] = this.placeType;
    if (this.placeList != null) {
      data['place_list'] = this.placeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlaceList {
  String? placeTitle;
  String? placeAddress;
  dynamic distance;

  PlaceList({this.placeTitle, this.placeAddress, this.distance});

  PlaceList.fromJson(Map<String, dynamic> json) {
    placeTitle = json['place_title'];
    placeAddress = json['place_address'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['place_title'] = this.placeTitle;
    data['place_address'] = this.placeAddress;
    data['distance'] = this.distance;
    return data;
  }
}