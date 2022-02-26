import 'dart:developer';

import 'package:RentMyStay_user/home_module/model/popular_model.dart';
import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:flutter/cupertino.dart';

import '../model/City_suggestion_model.dart';

class HomeViewModel extends ChangeNotifier {

  List<CitySuggestionModel> getCitySuggestionList(
      {required BuildContext context}) {
    return [
      CitySuggestionModel(
          cityName: 'Bangalore',
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/newbangaloreimage.png?alt=media&token=b665228b-a72c-46f1-8683-0e0a0ce88d11",
          value: "Bengaluru-Karnataka-India"),
      CitySuggestionModel(
          cityName: 'BTM',
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/btm.png?alt=media&token=8a4a92fb-c0db-4c23-9c5b-e74166373827",

          value: "BTM-Layout-Bengaluru-Karnataka-India",
          ),
      CitySuggestionModel(
          cityName: 'HSR',
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f",
          value: "hsr-layout-Bengaluru-Karnataka-India",
      ),
      CitySuggestionModel(
          cityName: 'Kundlahalli',
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/kundahalli.png?alt=media&token=73f33a3f-8219-4c28-8cd4-4f8cb2b14905",
      value: "Kundanahalli-Gate-ITPL-Main-Road-Brookefield-Bengaluru-Karnataka-India",
      ),
      CitySuggestionModel(
          cityName: 'Marathalli',
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/marathalli.png?alt=media&token=92c56d6f-6a73-4717-8a85-8a1530a95282",
      value: "Marathahalli-Bengaluru-Karnataka-India",
      ),
      CitySuggestionModel(
          cityName: 'Whitefield',
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/whitefield.png?alt=media&token=d5c56216-b5e8-4b6d-9fd3-d6675149fd45",
         value: "Whitefield-Bengaluru-Karnataka-India",
          ),
      CitySuggestionModel(
          cityName: 'Old Airport',
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/old_airport_road.png?alt=media&token=3100968f-c852-4363-a805-597f8804c51c",

          value:"old-airport-road-Bengaluru-Karnataka-India"),
    ];
  }

  List<PopularPropertyModel> getPopularPropertyModelList() {
    return [
      PopularPropertyModel(
        imageUrl: Images.onebhk_img,
        propertyDesc:
            'BTM Layout, Hoodi, HSR Layout,\nKoramangala, Kudlu gate,\nKundanahali, Marathahalli',
        propertyType: '1BHK',
        hint: 'More',
        callback: log,
      ),
      PopularPropertyModel(
        imageUrl: Images.twobhk_img,
        propertyDesc:
            'BTM Layout, Hoodi, HSR Layout,\nKoramangala, Kudlu gate,\nKundanahali, Marathahalli',
        propertyType: '2BHK',
        hint: 'More',
        callback: log,
      ),
      PopularPropertyModel(
        imageUrl: Images.studio_img,
        propertyDesc:
            'BTM Layout, Hoodi, HSR Layout,\nKoramangala, Kudlu gate,\nKundanahali, Marathahalli',
        propertyType: 'Studio',
        hint: 'More',
        callback: log,
      ),
    ];
  }
}
