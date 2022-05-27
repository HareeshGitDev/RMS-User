class OwnerPropertyDetailsRequestModel {
  String? propId;
  String? addressDisplay;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  String? glat;
  String? glng;
  String? title;
  String? description;
  String? things2note;
  String? area;
  String? propTypeId;
  String? bedrooms;
  String? bathrooms;
  String? maxGuests;
  String? propertyName;
  String? orgRent;
  String? rent;
  String? weeklyRent;
  String? monthlyRent;
  String? orgMonthRent;
  String? rmsRent;
  String? videoLink;
  String? rmsDeposit;
  Map<String ,dynamic>? amenity;

  OwnerPropertyDetailsRequestModel(
      {this.propId,
        this.addressDisplay,
        this.city,
        this.state,
        this.zipCode,
        this.country,
        this.glat,
        this.glng,
        this.title,
        this.description,
        this.things2note,
        this.area,
        this.propTypeId,
        this.bedrooms,
        this.bathrooms,
        this.maxGuests,
        this.propertyName,
        this.orgRent,
        this.rent,
        this.weeklyRent,
        this.monthlyRent,
        this.orgMonthRent,
        this.rmsRent,
        this.videoLink,
        this.rmsDeposit,
        this.amenity});

  OwnerPropertyDetailsRequestModel.fromJson(Map<String, dynamic> json) {
    propId = json['prop_id'];

    addressDisplay = json['address_display'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zip_code'];
    country = json['country'];
    glat = json['glat'];
    glng = json['glng'];
    title = json['title'];
    description = json['description'];
    things2note = json['things2note'];
    area = json['area'];
    propTypeId = json['prop_type_id'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    maxGuests = json['max_guests'];
    propertyName = json['property_name'];
    orgRent = json['org_rent'];
    rent = json['rent'];
    weeklyRent = json['weekly_rent'];
    monthlyRent = json['monthly_rent'];
    orgMonthRent = json['org_month_rent'];
    rmsRent = json['rms_rent'];
    videoLink = json['video_link'];
    rmsDeposit = json['rms_deposit'];
    amenity = json['amenity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prop_id'] = this.propId;
    data['address_display'] = this.addressDisplay;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip_code'] = this.zipCode;
    data['country'] = this.country;
    data['glat'] = this.glat;
    data['glng'] = this.glng;
    data['title'] = this.title;
    data['description'] = this.description;
    data['things2note'] = this.things2note;
    data['area'] = this.area;
    data['prop_type_id'] = this.propTypeId;
    data['bedrooms'] = this.bedrooms;
    data['bathrooms'] = this.bathrooms;
    data['max_guests'] = this.maxGuests;
    data['property_name'] = this.propertyName;
    data['org_rent'] = this.orgRent;
    data['rent'] = this.rent;
    data['weekly_rent'] = this.weeklyRent;
    data['monthly_rent'] = this.monthlyRent;
    data['org_month_rent'] = this.orgMonthRent;
    data['rms_rent'] = this.rmsRent;
    data['rms_deposit'] = this.rmsDeposit;
    data['amenity'] = this.amenity;
    data['video_link'] = this.videoLink;
    return data;
  }
}