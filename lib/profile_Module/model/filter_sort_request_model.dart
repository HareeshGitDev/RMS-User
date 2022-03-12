class FilterSortRequestModel {
  String? fromd;
  String? tod;
  String? addr;
  String? sortOrder;
  String? studio;
  String? s1Bhk;
  String? s2Bhk;
  String? s3Bhk;
  String? maxguests;
  String? pricefrom;
  String? priceto;
  String? fullyFurnish;
  String? semiFurnish;
  String? termm;
  String? roomTypee;
  String? furType;

  FilterSortRequestModel(
      {this.fromd,
        this.tod,
        this.addr,
        this.sortOrder,
        this.studio,
        this.s1Bhk,
        this.s2Bhk,
        this.s3Bhk,
        this.maxguests,
        this.pricefrom,
        this.priceto,
        this.fullyFurnish,
        this.semiFurnish,
        this.termm,
        this.roomTypee,
        this.furType});

  FilterSortRequestModel.fromJson(Map<String, dynamic> json) {
    fromd = json['fromd'];
    tod = json['tod'];
    addr = json['addr'];
    sortOrder = json['sortOrder'];
    studio = json['studio'];
    s1Bhk = json['1_bhk'];
    s2Bhk = json['2_bhk'];
    s3Bhk = json['3_bhk'];
    maxguests = json['maxguests'];
    pricefrom = json['pricefrom'];
    priceto = json['priceto'];
    fullyFurnish = json['fully_furnish'];
    semiFurnish = json['semi_furnish'];
    termm = json['termm'];
    roomTypee = json['room_typee'];
    furType = json['fur_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromd'] = this.fromd;
    data['tod'] = this.tod;
    data['addr'] = this.addr;
    data['sortOrder'] = this.sortOrder;
    data['studio'] = this.studio;
    data['1_bhk'] = this.s1Bhk;
    data['2_bhk'] = this.s2Bhk;
    data['3_bhk'] = this.s3Bhk;
    data['maxguests'] = this.maxguests;
    data['pricefrom'] = this.pricefrom;
    data['priceto'] = this.priceto;
    data['fully_furnish'] = this.fullyFurnish;
    data['semi_furnish'] = this.semiFurnish;
    data['termm'] = this.termm;
    data['room_typee'] = this.roomTypee;
    data['fur_type'] = this.furType;
    return data;
  }
}