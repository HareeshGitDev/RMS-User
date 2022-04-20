class FilterSortRequestModel {
  String? fromd='22-Jun-2022';
  String? tod='22-Jun-2022';
  String? addr='Bengaluru-Karnataka-India';
  String? sortOrder='0';
  String? studio='Studio';
  String? s1Bhk='1BHK';
  String? s2Bhk='2BHK';
  String? s3Bhk='3BHK';
  String? pricefrom='5000';
  String? priceto='50000';
  String? term='daily_basis/monthly_basis/long_basis';
  String? roomTypee='entire1^shared2^private3^';
  String? furType='Semi Furnished^Fully Furnished^';

  FilterSortRequestModel(
      {this.fromd,
        this.tod,
        this.addr,
        this.sortOrder,
        this.studio,
        this.s1Bhk,
        this.s2Bhk,
        this.s3Bhk,
        this.pricefrom,
        this.priceto,
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

    pricefrom = json['pricefrom'];
    priceto = json['priceto'];
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
    data['pricefrom'] = this.pricefrom;
    data['priceto'] = this.priceto;
    data['term'] = this.term;
    data['room_typee'] = this.roomTypee;
    data['fur_type'] = this.furType;
    return data;
  }
}