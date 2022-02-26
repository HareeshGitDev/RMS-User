class WishListModel {
  List<Data>? data;
  String? userProfilePic;
  String? status;

  WishListModel({this.data, this.userProfilePic, this.status});

  WishListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    userProfilePic = json['user_profile_pic'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['user_profile_pic'] = this.userProfilePic;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? propId;
  String? rmsRent;
  String? rmsDeposit;
  String? area;
  String? areas;
  String? title;
  String? city;
  String? neighbor;
  String? uiAddress;
  String? newDetails;
  String? avlDate;
  String? bedrooms;
  String? bathrooms;
  String? maxGuests;
  String? freeGuests;
  String? overall;
  String? extraPerGuest;
  String? orgRent;
  String? monthlyRent;
  String? orgMonthRent;
  String? todate;
  String? weeklyRent;
  String? rent;
  String? propType;
  String? roomType;
  String? glat;
  String? glng;
  String? firstname;
  String? lastname;
  String? picture;
  String? userId;
  List<Pic>? pic;
  String? picThumbnail;
  PropExp? propExp;
  String? encdPropId;
  String? propUrl;
  int? wishlist;

  Data(
      {this.propId,
        this.rmsRent,
        this.rmsDeposit,
        this.area,
        this.areas,
        this.title,
        this.city,
        this.neighbor,
        this.uiAddress,
        this.newDetails,
        this.avlDate,
        this.bedrooms,
        this.bathrooms,
        this.maxGuests,
        this.freeGuests,
        this.overall,
        this.extraPerGuest,
        this.orgRent,
        this.monthlyRent,
        this.orgMonthRent,
        this.todate,
        this.weeklyRent,
        this.rent,
        this.propType,
        this.roomType,
        this.glat,
        this.glng,
        this.firstname,
        this.lastname,
        this.picture,
        this.userId,
        this.pic,
        this.picThumbnail,
        this.propExp,
        this.encdPropId,
        this.propUrl,
        this.wishlist});

  Data.fromJson(Map<String, dynamic> json) {
    propId = json['prop_id'];
    rmsRent = json['rms_rent'];
    rmsDeposit = json['rms_deposit'];
    area = json['area'];
    areas = json['areas'];
    title = json['title'];
    city = json['city'];
    neighbor = json['neighbor'];
    uiAddress = json['ui_address'];
    newDetails = json['new_details'];
    avlDate = json['avl_date'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    maxGuests = json['max_guests'];
    freeGuests = json['free_guests'];
    overall = json['overall'];
    extraPerGuest = json['extra_per_guest'];
    orgRent = json['org_rent'];
    monthlyRent = json['monthly_rent'];
    orgMonthRent = json['org_month_rent'];
    todate = json['todate'];
    weeklyRent = json['weekly_rent'];
    rent = json['rent'];
    propType = json['prop_type'];
    roomType = json['room_type'];
    glat = json['glat'];
    glng = json['glng'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    picture = json['picture'];
    userId = json['user_id'];
    if (json['pic'] != null) {
      pic = <Pic>[];
      json['pic'].forEach((v) {
        pic!.add(new Pic.fromJson(v));
      });
    }
    picThumbnail = json['pic_thumbnail'];
    propExp = json['prop_exp'] != null
        ? new PropExp.fromJson(json['prop_exp'])
        : null;
    encdPropId = json['encd_prop_id'];
    propUrl = json['prop_url'];
    wishlist = json['wishlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prop_id'] = this.propId;
    data['rms_rent'] = this.rmsRent;
    data['rms_deposit'] = this.rmsDeposit;
    data['area'] = this.area;
    data['areas'] = this.areas;
    data['title'] = this.title;
    data['city'] = this.city;
    data['neighbor'] = this.neighbor;
    data['ui_address'] = this.uiAddress;
    data['new_details'] = this.newDetails;
    data['avl_date'] = this.avlDate;
    data['bedrooms'] = this.bedrooms;
    data['bathrooms'] = this.bathrooms;
    data['max_guests'] = this.maxGuests;
    data['free_guests'] = this.freeGuests;
    data['overall'] = this.overall;
    data['extra_per_guest'] = this.extraPerGuest;
    data['org_rent'] = this.orgRent;
    data['monthly_rent'] = this.monthlyRent;
    data['org_month_rent'] = this.orgMonthRent;
    data['todate'] = this.todate;
    data['weekly_rent'] = this.weeklyRent;
    data['rent'] = this.rent;
    data['prop_type'] = this.propType;
    data['room_type'] = this.roomType;
    data['glat'] = this.glat;
    data['glng'] = this.glng;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['picture'] = this.picture;
    data['user_id'] = this.userId;
    if (this.pic != null) {
      data['pic'] = this.pic!.map((v) => v.toJson()).toList();
    }
    data['pic_thumbnail'] = this.picThumbnail;
    if (this.propExp != null) {
      data['prop_exp'] = this.propExp!.toJson();
    }
    data['encd_prop_id'] = this.encdPropId;
    data['prop_url'] = this.propUrl;
    data['wishlist'] = this.wishlist;
    return data;
  }
}

class Pic {
  String? id;
  String? propId;
  String? picOrgLink;
  String? picLink;
  String? picWp;
  Null? picLinkHttps;
  String? picThumbnail;
  String? picDesc;
  String? addedon;
  String? defaultPic;
  String? picOrder;
  String? onCloudDatetime;
  String? onCloud;
  String? localPath;
  String? picNolg;
  String? category;
  String? online;

  Pic(
      {this.id,
        this.propId,
        this.picOrgLink,
        this.picLink,
        this.picWp,
        this.picLinkHttps,
        this.picThumbnail,
        this.picDesc,
        this.addedon,
        this.defaultPic,
        this.picOrder,
        this.onCloudDatetime,
        this.onCloud,
        this.localPath,
        this.picNolg,
        this.category,
        this.online});

  Pic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propId = json['prop_id'];
    picOrgLink = json['pic_org_link'];
    picLink = json['pic_link'];
    picWp = json['pic_wp'];
    picLinkHttps = json['pic_link_https'];
    picThumbnail = json['pic_thumbnail'];
    picDesc = json['pic_desc'];
    addedon = json['addedon'];
    defaultPic = json['default_pic'];
    picOrder = json['pic_order'];
    onCloudDatetime = json['on_cloud_datetime'];
    onCloud = json['on_cloud'];
    localPath = json['local_path'];
    picNolg = json['pic_nolg'];
    category = json['category'];
    online = json['online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prop_id'] = this.propId;
    data['pic_org_link'] = this.picOrgLink;
    data['pic_link'] = this.picLink;
    data['pic_wp'] = this.picWp;
    data['pic_link_https'] = this.picLinkHttps;
    data['pic_thumbnail'] = this.picThumbnail;
    data['pic_desc'] = this.picDesc;
    data['addedon'] = this.addedon;
    data['default_pic'] = this.defaultPic;
    data['pic_order'] = this.picOrder;
    data['on_cloud_datetime'] = this.onCloudDatetime;
    data['on_cloud'] = this.onCloud;
    data['local_path'] = this.localPath;
    data['pic_nolg'] = this.picNolg;
    data['category'] = this.category;
    data['online'] = this.online;
    return data;
  }
}

class PropExp {
  String? expId;
  String? propId;
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

  PropExp(
      {
        this.expId,
        this.propId,
        this.corporateSuite,
        this.central,
        this.beach,
        this.budget,
        this.scenic,
        this.romantic,
        this.nature,
        this.group,
        this.luxury,
        this.traditional,
        this.shopping
      }
      );

  PropExp.fromJson(Map<String, dynamic> json) {
    expId = json['exp_id'];
    propId = json['prop_id'];
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
    data['exp_id'] = this.expId;
    data['prop_id'] = this.propId;
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