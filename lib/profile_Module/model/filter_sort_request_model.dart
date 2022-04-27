class FilterSortRequestModel {
  String? fromDate;
  String? toDate;
  String? address;
  String? sortOrder;
  String? studio;
  String? s1bhk;
  String? s2bhk;
  String? s3bhk;
  String? pricefrom;
  String? priceto;
  String? semiFurnish;
  String? fullyFurnish;
  String? maxGuests;
  String? term;
  String? entireHouse;
  String? privateRoom;
  String? sharedRoom;

  FilterSortRequestModel(
      {this.fromDate,
        this.toDate,
        this.address,
        this.sortOrder,
        this.studio,
        this.s1bhk,
        this.s2bhk,
        this.s3bhk,
        this.pricefrom,
        this.priceto,
        this.semiFurnish,
        this.fullyFurnish,
        this.maxGuests,
        this.term,
        this.entireHouse,
        this.privateRoom,
        this.sharedRoom});

  FilterSortRequestModel.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    address = json['address'];
    sortOrder = json['sortOrder'];
    studio = json['studio'];
    s1bhk = json['1bhk'];
    s2bhk = json['2bhk'];
    s3bhk = json['3bhk'];
    pricefrom = json['pricefrom'];
    priceto = json['priceto'];
    semiFurnish = json['semiFurnish'];
    fullyFurnish = json['fullyFurnish'];
    maxGuests = json['maxGuests'];
    term = json['term'];
    entireHouse = json['entireHouse'];
    privateRoom = json['privateRoom'];
    sharedRoom = json['sharedRoom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['address'] = this.address;
    data['sortOrder'] = this.sortOrder;
    data['studio'] = this.studio;
    data['1bhk'] = this.s1bhk;
    data['2bhk'] = this.s2bhk;
    data['3bhk'] = this.s3bhk;
    data['pricefrom'] = this.pricefrom;
    data['priceto'] = this.priceto;
    data['semiFurnish'] = this.semiFurnish;
    data['fullyFurnish'] = this.fullyFurnish;
    data['maxGuests'] = this.maxGuests;
    data['term'] = this.term;
    data['entireHouse'] = this.entireHouse;
    data['privateRoom'] = this.privateRoom;
    data['sharedRoom'] = this.sharedRoom;
    return data;
  }
}
