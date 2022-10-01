class AmenitiesModel {
  String name;
  String imageUrl;
  bool selected=false;

  AmenitiesModel({required this.name,required this.imageUrl,this.selected=false});

  @override
  String toString() {
    return 'Amenities :: $name -- $imageUrl -- $selected ';
  }
}





class NoAmenitiesModel {
  String name;
  String imageUrl;
  bool selected=false;

  NoAmenitiesModel({required this.name,required this.imageUrl,this.selected=false});

  @override
  String toString() {
    return 'Amenities :: $name -- $imageUrl -- $selected ';
  }
}