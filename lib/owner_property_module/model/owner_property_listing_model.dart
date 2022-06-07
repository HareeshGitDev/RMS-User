class OwnerPropertyListingModel {
  String? msg;
  List<Data>? data;

  OwnerPropertyListingModel({this.msg, this.data});

  OwnerPropertyListingModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? bookable;
  String? title;
  String? usp;
  String? description;
  dynamic nearby;
  String? things2note;
  dynamic otherinfo;
  dynamic newDetails;
  dynamic getaround;
  String? address1;
  dynamic landmark;
  String? furnishingType;
  dynamic suitableFor;
  String? floors;
  dynamic neighbor;
  dynamic directions;
  String? country;
  String? city;
  String? state;
  String? area;
  dynamic locality;
  String? zipCode;
  String? addressDisplay;
  String? uiAddress;
  String? glat;
  String? glng;
  String? lastUpdateTime;
  String? creationTime;
  String? pageViews;
  dynamic numBooking;
  String? applyServiceCharges;
  String? videoLink;
  String? active;
  String? verified;
  String? partnerVisibility;
  String? deposit;
  String? inTwoSearch;
  String? activeSearch;
  String? gdSpecial;
  String? avlDate;
  String? chkIn;
  String? chkOut;
  String? propertyName;
  String? bedrooms;
  String? beds;
  String? bathrooms;
  String? maxGuests;
  String? freeGuests;
  String? extraPerGuest;
  String? extraPerGuestMntly;
  String? coliveType;
  String? unitArea;
  String? unitAge;
  String? facing;
  String? propFloor;
  String? propTypeId;
  String? roomTypeId;
  String? rent;
  String? orgRent;
  String? weeklyRent;
  String? monthlyRent;
  String? orgMonthRent;
  String? rmsRent;
  String? orgRmsRent;
  String? rmsDeposit;
  String? offerDuration;
  String? offerPrice;
  String? offerStatus;
  String? forMonthlyRent;
  String? tax;
  String? maintenance;
  String? lastMinDeal;
  String? currencyRefId;
  String? value;
  String? completeness;
  String? cleanliness;
  String? location;
  String? overall;
  String? advancePercentage;
  String? amenityId;
  String? cableTv;
  String? cable;
  String? wifi;
  String? airConditioning;
  String? kitchen;
  String? balcony;
  String? gym;
  String? security;
  String? elevator;
  String? pool;
  String? smoking;
  String? breakfast;
  String? mobileNetwork;
  String? refrigerator;
  String? foodService;
  String? housekeeping;
  String? wardrobes;
  String? lights;
  String? fans;
  String? hotWater;
  String? cflBulb;
  String? geysers;
  String? callingBell;
  String? dustbin;
  String? bucketsMugs;
  String? curtains;
  String? cotMattress;
  String? sofaDeewan;
  String? centerTable;
  String? stoveCylinder;
  String? washingMachine;
  String? essentials;
  String? heating;
  String? bikeParking;
  String? carParking;
  String? powerBackup;
  String? clubhouse;
  List<PicLink>? picLink;
  String? shareLink;

  Data(
      {this.propId,
        this.userId,
        this.bookable,
        this.title,
        this.usp,
        this.description,
        this.nearby,
        this.things2note,
        this.otherinfo,
        this.newDetails,
        this.getaround,
        this.address1,
        this.landmark,
        this.furnishingType,
        this.suitableFor,
        this.floors,
        this.neighbor,
        this.directions,
        this.country,
        this.city,
        this.state,
        this.area,
        this.locality,
        this.zipCode,
        this.addressDisplay,
        this.uiAddress,
        this.glat,
        this.glng,
        this.lastUpdateTime,
        this.creationTime,
        this.pageViews,
        this.numBooking,
        this.applyServiceCharges,
        this.videoLink,
        this.active,
        this.verified,
        this.partnerVisibility,
        this.deposit,
        this.inTwoSearch,
        this.activeSearch,
        this.gdSpecial,
        this.avlDate,
        this.chkIn,
        this.chkOut,
        this.propertyName,
        this.bedrooms,
        this.beds,
        this.bathrooms,
        this.maxGuests,
        this.freeGuests,
        this.extraPerGuest,
        this.extraPerGuestMntly,
        this.coliveType,
        this.unitArea,
        this.unitAge,
        this.facing,
        this.propFloor,
        this.propTypeId,
        this.roomTypeId,
        this.rent,
        this.orgRent,
        this.weeklyRent,
        this.monthlyRent,
        this.orgMonthRent,
        this.rmsRent,
        this.orgRmsRent,
        this.rmsDeposit,
        this.offerDuration,
        this.offerPrice,
        this.offerStatus,
        this.forMonthlyRent,
        this.tax,
        this.maintenance,
        this.lastMinDeal,
        this.currencyRefId,
        this.value,
        this.completeness,
        this.cleanliness,
        this.location,
        this.overall,
        this.advancePercentage,
        this.amenityId,
        this.cableTv,
        this.cable,
        this.wifi,
        this.airConditioning,
        this.kitchen,
        this.balcony,
        this.gym,
        this.security,
        this.elevator,
        this.pool,
        this.smoking,
        this.breakfast,
        this.mobileNetwork,
        this.refrigerator,
        this.foodService,
        this.housekeeping,
        this.wardrobes,
        this.lights,
        this.fans,
        this.hotWater,
        this.cflBulb,
        this.geysers,
        this.callingBell,
        this.dustbin,
        this.bucketsMugs,
        this.curtains,
        this.cotMattress,
        this.sofaDeewan,
        this.centerTable,
        this.stoveCylinder,
        this.washingMachine,
        this.essentials,
        this.heating,
        this.bikeParking,
        this.carParking,
        this.powerBackup,
        this.clubhouse,
        this.picLink,
        this.shareLink});

  Data.fromJson(Map<String, dynamic> json) {
    propId = json['prop_id'];
    userId = json['user_id'];
    bookable = json['bookable'];
    title = json['title'];
    usp = json['usp'];
    description = json['description'];
    nearby = json['nearby'];
    things2note = json['things2note'];
    otherinfo = json['otherinfo'];
    newDetails = json['new_details'];
    getaround = json['getaround'];
    address1 = json['address1'];
    landmark = json['landmark'];
    furnishingType = json['furnishing_type'];
    suitableFor = json['suitable_for'];
    floors = json['floors'];
    neighbor = json['neighbor'];
    directions = json['directions'];
    country = json['country'];
    city = json['city'];
    state = json['state'];
    area = json['area'];
    locality = json['locality'];
    zipCode = json['zip_code'];
    addressDisplay = json['address_display'];
    uiAddress = json['ui_address'];
    glat = json['glat'];
    glng = json['glng'];
    lastUpdateTime = json['last_update_time'];
    creationTime = json['creation_time'];
    pageViews = json['page_views'];
    numBooking = json['num_booking'];
    applyServiceCharges = json['apply_service_charges'];
    videoLink = json['video_link'];
    active = json['active'];
    verified = json['verified'];
    partnerVisibility = json['partner_visibility'];
    deposit = json['deposit'];
    inTwoSearch = json['in_two_search'];
    activeSearch = json['active_search'];
    gdSpecial = json['gd_special'];
    avlDate = json['avl_date'];
    chkIn = json['chk_in'];
    chkOut = json['chk_out'];
    propertyName = json['property_name'];
    bedrooms = json['bedrooms'];
    beds = json['beds'];
    bathrooms = json['bathrooms'];
    maxGuests = json['max_guests'];
    freeGuests = json['free_guests'];
    extraPerGuest = json['extra_per_guest'];
    extraPerGuestMntly = json['extra_per_guest_mntly'];
    coliveType = json['colive_type'];
    unitArea = json['unit_area'];
    unitAge = json['unit_age'];
    facing = json['facing'];
    propFloor = json['prop_floor'];
    propTypeId = json['prop_type_id'];
    roomTypeId = json['room_type_id'];
    rent = json['rent'];
    orgRent = json['org_rent'];
    weeklyRent = json['weekly_rent'];
    monthlyRent = json['monthly_rent'];
    orgMonthRent = json['org_month_rent'];
    rmsRent = json['rms_rent'];
    orgRmsRent = json['org_rms_rent'];
    rmsDeposit = json['rms_deposit'];
    offerDuration = json['offer_duration'];
    offerPrice = json['offer_price'];
    offerStatus = json['offer_status'];
    forMonthlyRent = json['for_monthly_rent'];
    tax = json['tax'];
    maintenance = json['maintenance'];
    lastMinDeal = json['last_min_deal'];
    currencyRefId = json['currency_ref_id'];
    value = json['value'];
    completeness = json['completeness'];
    cleanliness = json['cleanliness'];
    location = json['location'];
    overall = json['overall'];
    advancePercentage = json['advance_percentage'];
    amenityId = json['amenity_id'];
    cableTv = json['cable_tv'];
    cable = json['cable'];
    wifi = json['wifi'];
    airConditioning = json['air_conditioning'];
    kitchen = json['kitchen'];
    balcony = json['balcony'];
    gym = json['gym'];
    security = json['security'];
    elevator = json['elevator'];
    pool = json['pool'];
    smoking = json['smoking'];
    breakfast = json['breakfast'];
    mobileNetwork = json['mobile_network'];
    refrigerator = json['refrigerator'];
    foodService = json['food_service'];
    housekeeping = json['housekeeping'];
    wardrobes = json['wardrobes'];
    lights = json['lights'];
    fans = json['fans'];
    hotWater = json['hot_water'];
    cflBulb = json['cfl_bulb'];
    geysers = json['geysers'];
    callingBell = json['calling_bell'];
    dustbin = json['dustbin'];
    bucketsMugs = json['buckets_mugs'];
    curtains = json['curtains'];
    cotMattress = json['cot_mattress'];
    sofaDeewan = json['sofa_deewan'];
    centerTable = json['center_table'];
    stoveCylinder = json['stove_cylinder'];
    washingMachine = json['washing_machine'];
    essentials = json['essentials'];
    heating = json['heating'];
    bikeParking = json['bike_parking'];
    carParking = json['car_parking'];
    powerBackup = json['power_backup'];
    clubhouse = json['clubhouse'];
    if (json['pic_link'] != null) {
      picLink = <PicLink>[];
      json['pic_link'].forEach((v) {
        picLink!.add(new PicLink.fromJson(v));
      });
    }
    shareLink = json['share_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prop_id'] = this.propId;
    data['user_id'] = this.userId;
    data['bookable'] = this.bookable;
    data['title'] = this.title;
    data['usp'] = this.usp;
    data['description'] = this.description;
    data['nearby'] = this.nearby;
    data['things2note'] = this.things2note;
    data['otherinfo'] = this.otherinfo;
    data['new_details'] = this.newDetails;
    data['getaround'] = this.getaround;
    data['address1'] = this.address1;
    data['landmark'] = this.landmark;
    data['furnishing_type'] = this.furnishingType;
    data['suitable_for'] = this.suitableFor;
    data['floors'] = this.floors;
    data['neighbor'] = this.neighbor;
    data['directions'] = this.directions;
    data['country'] = this.country;
    data['city'] = this.city;
    data['state'] = this.state;
    data['area'] = this.area;
    data['locality'] = this.locality;
    data['zip_code'] = this.zipCode;
    data['address_display'] = this.addressDisplay;
    data['ui_address'] = this.uiAddress;
    data['glat'] = this.glat;
    data['glng'] = this.glng;
    data['last_update_time'] = this.lastUpdateTime;
    data['creation_time'] = this.creationTime;
    data['page_views'] = this.pageViews;
    data['num_booking'] = this.numBooking;
    data['apply_service_charges'] = this.applyServiceCharges;
    data['video_link'] = this.videoLink;
    data['active'] = this.active;
    data['verified'] = this.verified;
    data['partner_visibility'] = this.partnerVisibility;
    data['deposit'] = this.deposit;
    data['in_two_search'] = this.inTwoSearch;
    data['active_search'] = this.activeSearch;
    data['gd_special'] = this.gdSpecial;
    data['avl_date'] = this.avlDate;
    data['chk_in'] = this.chkIn;
    data['chk_out'] = this.chkOut;
    data['property_name'] = this.propertyName;
    data['bedrooms'] = this.bedrooms;
    data['beds'] = this.beds;
    data['bathrooms'] = this.bathrooms;
    data['max_guests'] = this.maxGuests;
    data['free_guests'] = this.freeGuests;
    data['extra_per_guest'] = this.extraPerGuest;
    data['extra_per_guest_mntly'] = this.extraPerGuestMntly;
    data['colive_type'] = this.coliveType;
    data['unit_area'] = this.unitArea;
    data['unit_age'] = this.unitAge;
    data['facing'] = this.facing;
    data['prop_floor'] = this.propFloor;
    data['prop_type_id'] = this.propTypeId;
    data['room_type_id'] = this.roomTypeId;
    data['rent'] = this.rent;
    data['org_rent'] = this.orgRent;
    data['weekly_rent'] = this.weeklyRent;
    data['monthly_rent'] = this.monthlyRent;
    data['org_month_rent'] = this.orgMonthRent;
    data['rms_rent'] = this.rmsRent;
    data['org_rms_rent'] = this.orgRmsRent;
    data['rms_deposit'] = this.rmsDeposit;
    data['offer_duration'] = this.offerDuration;
    data['offer_price'] = this.offerPrice;
    data['offer_status'] = this.offerStatus;
    data['for_monthly_rent'] = this.forMonthlyRent;
    data['tax'] = this.tax;
    data['maintenance'] = this.maintenance;
    data['last_min_deal'] = this.lastMinDeal;
    data['currency_ref_id'] = this.currencyRefId;
    data['value'] = this.value;
    data['completeness'] = this.completeness;
    data['cleanliness'] = this.cleanliness;
    data['location'] = this.location;
    data['overall'] = this.overall;
    data['advance_percentage'] = this.advancePercentage;
    data['amenity_id'] = this.amenityId;
    data['cable_tv'] = this.cableTv;
    data['cable'] = this.cable;
    data['wifi'] = this.wifi;
    data['air_conditioning'] = this.airConditioning;
    data['kitchen'] = this.kitchen;
    data['balcony'] = this.balcony;
    data['gym'] = this.gym;
    data['security'] = this.security;
    data['elevator'] = this.elevator;
    data['pool'] = this.pool;
    data['smoking'] = this.smoking;
    data['breakfast'] = this.breakfast;
    data['mobile_network'] = this.mobileNetwork;
    data['refrigerator'] = this.refrigerator;
    data['food_service'] = this.foodService;
    data['housekeeping'] = this.housekeeping;
    data['wardrobes'] = this.wardrobes;
    data['lights'] = this.lights;
    data['fans'] = this.fans;
    data['hot_water'] = this.hotWater;
    data['cfl_bulb'] = this.cflBulb;
    data['geysers'] = this.geysers;
    data['calling_bell'] = this.callingBell;
    data['dustbin'] = this.dustbin;
    data['buckets_mugs'] = this.bucketsMugs;
    data['curtains'] = this.curtains;
    data['cot_mattress'] = this.cotMattress;
    data['sofa_deewan'] = this.sofaDeewan;
    data['center_table'] = this.centerTable;
    data['stove_cylinder'] = this.stoveCylinder;
    data['washing_machine'] = this.washingMachine;
    data['essentials'] = this.essentials;
    data['heating'] = this.heating;
    data['bike_parking'] = this.bikeParking;
    data['car_parking'] = this.carParking;
    data['power_backup'] = this.powerBackup;
    data['clubhouse'] = this.clubhouse;
    if (this.picLink != null) {
      data['pic_link'] = this.picLink!.map((v) => v.toJson()).toList();
    }
    data['share_link'] = this.shareLink;
    return data;
  }
}

class PicLink {
  String? picWp;

  PicLink({this.picWp});

  PicLink.fromJson(Map<String, dynamic> json) {
    picWp = json['pic_wp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pic_wp'] = this.picWp;
    return data;
  }
}


