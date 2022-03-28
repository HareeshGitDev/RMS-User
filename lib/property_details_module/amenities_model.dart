class AmenitiesModel {
  String name;
  String imageUrl;

  AmenitiesModel({required this.name,required this.imageUrl});

  @override
  String toString() {
    return 'Amenities :: $name -- $imageUrl';
  }
}
