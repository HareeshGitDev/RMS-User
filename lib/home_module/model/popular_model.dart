class PopularPropertyModel{
  String? imageUrl;
  String? propertyType;
  String? propertyDesc;
  String? hint='More';
  Function(String)? callback;

  PopularPropertyModel({required this.imageUrl,required this.propertyDesc,required this.propertyType,this.hint,required this.callback});

  PopularPropertyModel.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    propertyType = json['propertyType'];
    propertyDesc = json['propertyDesc'];
    hint = json['hint'];


  }

}