import 'dart:developer';

import 'package:RentMyStay_user/home_module/model/checkin_feedback_model.dart';
import 'package:RentMyStay_user/home_module/model/home_page_model.dart';
import 'package:RentMyStay_user/home_module/model/invite_and_earn_model.dart';
import 'package:RentMyStay_user/home_module/model/popular_model.dart';
import 'package:RentMyStay_user/home_module/model/tenant_leads_model.dart';
import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/language_module/service/language_api_service.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:flutter/cupertino.dart';

import '../../language_module/model/language_model.dart';
import '../model/City_suggestion_model.dart';
import '../service/home_api_service.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeApiService _homeApiService = HomeApiService();
  final LanguageApiService _languageApiService = LanguageApiService();
  ReferAndEarnModel? referAndEarnModel ;
  CheckInStatusFeedbackModel? checkInStatusFeedbackModel;
  List<LanguageModel> languageData = [];
  List<LanguageModel> tenantLeadsLang = [];
  List<LanguageModel> referAndEarnLang = [];
  bool ownerModeSelected=true;
  HomePageModel homePageModel=HomePageModel();
  TenantLeadsModel tenantLeadsModel=TenantLeadsModel();

  void switchMode({required bool ownerMode}){
    ownerModeSelected=ownerMode;
    notifyListeners();
  }

  List<CitySuggestionModel> getCitySuggestionList(
      {required BuildContext context}) {
    return [
      CitySuggestionModel(
          cityName: 'Near Me',
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/newbangaloreimage.png?alt=media&token=b665228b-a72c-46f1-8683-0e0a0ce88d11",
          value: "Bengaluru-Karnataka-India"),
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
        value: "Hsr-layout-Bengaluru-Karnataka-India",
      ),
      CitySuggestionModel(
        cityName: 'Kundalahalli',
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/kundahalli.png?alt=media&token=73f33a3f-8219-4c28-8cd4-4f8cb2b14905",
        value:
            "Kundanahalli-Gate-ITPL-Main-Road-Brookefield-Bengaluru-Karnataka-India",
      ),
      CitySuggestionModel(
        cityName: 'Marathahalli',
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
          value: "old-airport-road-Bengaluru-Karnataka-India"),
    ];
  }



  List<String> getAdsImageList() => [
        'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/WhatsApp%20Image%202022-02-14%20at%2012.01.05%20PM.jpeg?alt=media&token=153f6374-979f-46ad-aaf3-06f9ff1d0b20',
        'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/bannerhome.png?alt=media&token=b66dab51-8676-470a-b876-025c613c303a',
        'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/WhatsApp%20Image%202022-02-14%20at%2012.01.04%20PM.jpeg?alt=media&token=6d78225a-59f7-4a7c-8bf3-e5d3f3c66bca',
      ];

  Future<void> getInviteEarnDetails({ required BuildContext context,}) async {
    final ReferAndEarnModel response =
        await _homeApiService.fetchInviteEarnDetails(context: context);
    referAndEarnModel = response;
    notifyListeners();
  }
  Future<int> addToWishlist({
    required String propertyId,
    required BuildContext context,
  }) async =>
      await _homeApiService.addToWishList(propertyId: propertyId,context: context);

  Future<int> checkinFeedbackPost({
    required BuildContext context,
    required double  booking_rating,
    required double  check_in_rating,
    required String check_in_comment,
    required String   sales_comment,
    required String comment,
    required String booking_id,

  }) async {
    var response= await _homeApiService.addCheckinFeedback(context: context,
      booking_id: booking_id,
      check_in_rating: check_in_rating,
      check_in_comment: check_in_comment,
      comment: comment,
      booking_rating: booking_rating,
      sales_comment: sales_comment,


    );
    return response;
  }

  Future<void> getHomePageData({ required BuildContext context,}) async {
    final response =
    await _homeApiService.fetchHomePageData(context: context);
    homePageModel = response;
   notifyListeners();
  }
  Future<void> getTenantLeads({ required BuildContext context,}) async {
    final response =
    await _homeApiService.fetchTenantLeads(context: context);
   tenantLeadsModel = response;
    notifyListeners();
  }


  Future getCheckinFeedbackStatus({ required BuildContext context,}) async {
    final response =
    await _homeApiService.fetchCheckinStatus(context: context);
    if(response !=null) {
checkInStatusFeedbackModel=response;
notifyListeners();
return response;
    }
    else{
      notifyListeners();
      return 400;
    }

  }

  Future<void> getLanguagesData(
      {required String language, required String pageName}) async {
    final response = await _languageApiService.fetchLanguagesData(
        language: language, pageName: pageName);
    languageData = response;
    notifyListeners();
  }
  Future<void> getTenantLeadsLanguageData(
      {required String language, required String pageName}) async {
    final response = await _languageApiService.fetchLanguagesData(
        language: language, pageName: pageName);
    tenantLeadsLang = response;
    notifyListeners();
  }
  Future<void> getReferAndEarnLanguagesData(
      {required String language, required String pageName}) async {
    final response = await _languageApiService.fetchLanguagesData(
        language: language, pageName: pageName);
    referAndEarnLang = response;
    notifyListeners();
  }
}
