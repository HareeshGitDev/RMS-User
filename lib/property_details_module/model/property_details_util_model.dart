class PropertyDetailsUtilModel {
  String? name;
  String? mobile;
  String? email;
  String? title;
  String? bookingType;
  String? buildingName;
  int? maxGuest;
  int? freeGuest;
  int? propId;
  dynamic longTermRent;
  dynamic flexiRent;
  String? token;
  List<int>? guestList;

  PropertyDetailsUtilModel(
      {this.email,
      this.name,
        this.bookingType,
      this.propId,
      this.buildingName,
      this.title,
      this.token,
        this.flexiRent,
        this.longTermRent,
      this.mobile,
      this.freeGuest,
        this.guestList,
this.maxGuest});

  Map<String,dynamic> toJosn(){
    Map<String,dynamic> data={};
    data['email']=email;
    data['title']=title;
    data['buildingName']=buildingName;
    data['name']=name;
    data['longTermRent']=longTermRent;
    data['flexiRent']=flexiRent;
    data['token']=token;
    data['bookingType']=bookingType;
    data['mobile']=mobile;
    data['maxGuest']=maxGuest;
    data['freeGuest']=freeGuest;
    data['propId']=propId;
    return data;

  }


}
