class PropertyDetailsUtilModel {
  String? name;
  String? mobile;
  String? email;
  String? title;
  String? buildingName;
  int? maxGuest;
  int? freeGuest;
  int? propId;
  String? token;
  List<int>? guestList;

  PropertyDetailsUtilModel(
      {this.email,
      this.name,
      this.propId,
      this.buildingName,
      this.title,
      this.token,
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
    data['token']=token;
    data['mobile']=mobile;
    data['maxGuest']=maxGuest;
    data['freeGuest']=freeGuest;
    data['propId']=propId;
    return data;

  }


}
