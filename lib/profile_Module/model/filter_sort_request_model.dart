class FilterSortRequestModel {
  String? fromd='dd-MM-YYYY';
  String? tod='dd-MM-YYYY';
  String? addr='location';
  String? sortOrder='0';
  String? studio='Studio';
  String? s1Bhk='1BHK';
  String? s2Bhk='2BHK';
  String? s3Bhk='3BHK';
  String? maxguests;
  String? pricefrom;
  String? priceto;
  String? fullyFurnish='fully_furnish';
  String? semiFurnish='semi_furnish';
  String? term='daily_basis/monthly_basis/long_basis';
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
        this.term,
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
    term = json['term'];
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
    data['term'] = this.term;
    data['room_typee'] = this.roomTypee;
    data['fur_type'] = this.furType;
    return data;
  }
}