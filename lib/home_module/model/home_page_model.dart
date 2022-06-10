class HomePageModel {
  String? msg;
  Data? data;

  HomePageModel({this.msg, this.data});

  HomePageModel.fromJson(Map<String, dynamic> json) {
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
  List<TrendingProps>? trendingProps;

  Data({this.trendingProps});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['trending_props'] != null) {
      trendingProps = <TrendingProps>[];
      json['trending_props'].forEach((v) {
        trendingProps!.add(new TrendingProps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trendingProps != null) {
      data['trending_props'] =
          this.trendingProps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrendingProps {
  String? propId;
  String? title;
  String? buildingName;
  String? glat;
  String? glng;
  String? propType;
  String? unitType;
  String? neighbor;
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
  dynamic rmsDeposit;
  String? occPercent;
  String? picThumbnail;
  String? enId;
  dynamic rentOff;
  dynamic monthRentOff;
  dynamic rmsRentOff;
  int? wishlist;

  TrendingProps(
      {this.propId,
        this.title,
        this.buildingName,
        this.glat,
        this.glng,
        this.wishlist,
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
        this.occPercent,
        this.picThumbnail,
        this.enId,
        this.rentOff,
        this.monthRentOff,
        this.rmsRentOff});

  TrendingProps.fromJson(Map<String, dynamic> json) {
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
    wishlist = json['wishlist'];
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
    occPercent = json['occ_percent'];
    picThumbnail = json['pic_thumbnail'];
    enId = json['en_id'];
    rentOff = json['rent_off'];
    monthRentOff = json['month_rent_off'];
    rmsRentOff = json['rms_rent_off'];
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
    data['wishlist'] = this.wishlist;
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
    data['occ_percent'] = this.occPercent;
    data['pic_thumbnail'] = this.picThumbnail;
    data['en_id'] = this.enId;
    data['rent_off'] = this.rentOff;
    data['month_rent_off'] = this.monthRentOff;
    data['rms_rent_off'] = this.rmsRentOff;
    return data;
  }
}