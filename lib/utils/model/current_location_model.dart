class CurrentLocationModel {
  String? fullAddress;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  String? latitude;
  String? longitude;

  CurrentLocationModel(
      {this.longitude,
      this.latitude,
      this.country,
      this.zipCode,
      this.state,
      this.fullAddress,
      this.address,
      this.city});
}
