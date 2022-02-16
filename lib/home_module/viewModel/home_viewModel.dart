import 'dart:developer';

import 'package:RentMyStay_user/home_module/model/popular_model.dart';
import 'package:RentMyStay_user/images.dart';
import 'package:flutter/cupertino.dart';

import '../model/City_SuggestionModel.dart';

class HomeViewModel extends ChangeNotifier {

  List<CitySuggestionModel> getCitySuggestionList() {
    return [
      CitySuggestionModel(
          cityName: 'Bangalore',
          imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/newbangaloreimage.png?alt=media&token=b665228b-a72c-46f1-8683-0e0a0ce88d11",
          callback: (String value) {}),
      CitySuggestionModel(
          cityName: 'BTM',
          imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/btm.png?alt=media&token=8a4a92fb-c0db-4c23-9c5b-e74166373827",
          callback: (String value) {}),
      CitySuggestionModel(
          cityName: 'HSR',
          imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f",
          callback: log),
      CitySuggestionModel(
          cityName: 'Kundlahalli',
          imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/kundahalli.png?alt=media&token=73f33a3f-8219-4c28-8cd4-4f8cb2b14905",
          callback: (String value) => doSomeWork(value)),
      CitySuggestionModel(
          cityName: 'Marathalli',
          imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/marathalli.png?alt=media&token=92c56d6f-6a73-4717-8a85-8a1530a95282",
          callback: doSomeWork),
      CitySuggestionModel(
          cityName: 'Whitefield',
          imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/whitefield.png?alt=media&token=d5c56216-b5e8-4b6d-9fd3-d6675149fd45",
          callback: (String value) => doSomeWork(value)),
      CitySuggestionModel(
          cityName: 'Old Airport',
          imageUrl:"https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/old_airport_road.png?alt=media&token=3100968f-c852-4363-a805-597f8804c51c",
          callback: (String value) => doSomeWork(value)),
    ];
  }
  void doSomeWork(String cityName) {
    log(cityName);
  }

  List<PopularPropertyModel> getPopularPropertyModelList(){
    return [
      PopularPropertyModel(imageUrl: Images.onebhk_img,
          propertyDesc: 'BTM Layout, Hoodi, HSR Layout,\nKoramangala, Kudlu gate,\nKundanahali, Marathahalli',
          propertyType: '1 BHK',
         hint: 'More',
        callback: log,
      ),
      PopularPropertyModel(
        //imageUrl:"https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/old_airport_road.png?alt=media&token=3100968f-c852-4363-a805-597f8804c51c",
        imageUrl: Images.twobhk_img,
      propertyDesc: 'BTM Layout, Hoodi, HSR Layout,\nKoramangala, Kudlu gate,\nKundanahali, Marathahalli',
          propertyType: '2 BHK',
          hint: 'More',
        callback: log,),
      /*
      PopularPropertyModel(imageUrl:"https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/old_airport_road.png?alt=media&token=3100968f-c852-4363-a805-597f8804c51c",
          propertyDesc: 'BTM',
          propertyType: 'Co-Live PG',
          hint: 'More',
        callback: log,),

       */
      PopularPropertyModel(
        //imageUrl:"https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/old_airport_road.png?alt=media&token=3100968f-c852-4363-a805-597f8804c51c",
        imageUrl: Images.studio_img,
        propertyDesc: 'BTM Layout, Hoodi, HSR Layout,\nKoramangala, Kudlu gate,\nKundanahali, Marathahalli',
          propertyType: 'Studio',
          hint: 'More',
        callback: log,),
    ];

  }
}
