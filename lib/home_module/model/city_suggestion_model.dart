import 'dart:developer';

class CitySuggestionModel {
  String cityName;
  String imageUrl;
  Function(String) callback;

  CitySuggestionModel(
      {required this.cityName, required this.imageUrl, required this.callback});



}
