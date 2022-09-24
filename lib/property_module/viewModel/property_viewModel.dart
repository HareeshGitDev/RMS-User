import 'dart:developer';

import 'package:RentMyStay_user/profile_Module/model/filter_sort_request_model.dart';
import 'package:RentMyStay_user/property_module/model/wish_list_model.dart';
import 'package:RentMyStay_user/property_module/service/property_api_service.dart';
import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:flutter/cupertino.dart';

import '../../home_module/model/home_page_model.dart';
import '../../home_module/model/popular_model.dart';
import '../../images.dart';
import '../../language_module/service/language_api_service.dart';
import '../../utils/constants/enum_consts.dart';
import '../../language_module/model/language_model.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../model/location_model.dart';
import '../model/property_list_model.dart';

class PropertyViewModel extends ChangeNotifier {
  final PropertyApiService _propertyApiService = PropertyApiService();
  PropertyListModel propertyListModel = PropertyListModel();
  WishListModel wishListModel = WishListModel();
  List<LocationModel> locations = [];
  final LanguageApiService _languageApiService = LanguageApiService();
  List<LanguageModel> searchPageLang = [];
  List<LanguageModel> wishListLang = [];
  List<LanguageModel> propertyListingLang = [];
  HomePageModel homePageModel=HomePageModel();

  Future<void> getPropertyDetailsList({
    required String address,
    required BuildContext context,
    String? propertyType,
    String? fromDate,
    String? toDate,
    required Property property,
  }) async {
    final PropertyListModel data =
        await _propertyApiService.fetchPropertyDetailsList(
            address: address,
            context: context,
            property: property,
            propertyType: propertyType,
            fromDate: fromDate,
            toDate: toDate);

    propertyListModel = data;
    log('ALL PROPERTIES :: ${propertyListModel.data?.length}');
    notifyListeners();
  }
  Future<void> getHomePageData({ required BuildContext context,}) async {
    final response =
    await _propertyApiService.fetchHomePageData(context: context);
    homePageModel = response;
    notifyListeners();
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

  Future<int> addToWishlist({
    required String propertyId,
    required BuildContext context,
  }) async =>
      await _propertyApiService.addToWishList(propertyId: propertyId,context:context );

  Future<void> getWishList({ required BuildContext context,}) async {
    final WishListModel data = await _propertyApiService.fetchWishList(context: context);
    wishListModel = data;
    log('ALL WishListed PROPERTIES :: ${wishListModel.data?.length}');
    notifyListeners();
  }

  Future<void> getSearchedPlace(String searchText,{ required BuildContext context,}) async {
    RMSUserApiService apiService = RMSUserApiService();

    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchText&types=geocode&key=$googleMapKey&components=country:in';
    final data = await apiService.getApiCallWithURL(endPoint: url,context: context)
        as Map<String, dynamic>;

    if (data['status'] == 'OK' && data['predictions'] != null) {
      Iterable iterable = data['predictions'];
      locations = iterable
          .map((suggestion) => LocationModel(
              location: '${suggestion['description']}',
              placeId: '${suggestion['place_id']} '))
          .toList();
      notifyListeners();
    }else if(data['status'] == 'ZERO_RESULTS'){
      locations=[];
      notifyListeners();
    }
  }

  Future<void> filterSortPropertyList({
    required FilterSortRequestModel requestModel,
    required BuildContext context,
  }) async {
    final PropertyListModel data = await _propertyApiService
        .filterSortPropertyList(requestModel: requestModel,context: context);

    propertyListModel = data;
    log('ALL Sorted PROPERTIES ::  ${data.data?.length}');
    notifyListeners();
  }

  Future<void> getLanguagesData(
      {required String language, required String pageName}) async {
    final response = await _languageApiService.fetchLanguagesData(
        language: language, pageName: pageName);
    searchPageLang = response;
    notifyListeners();
  }

  Future<void> getWishListedLanguagesData(
      {required String language, required String pageName}) async {
    final response = await _languageApiService.fetchLanguagesData(
        language: language, pageName: pageName);
    wishListLang = response;
    notifyListeners();
  }

  Future<void> getPropertyListingLanguagesData(
      {required String language, required String pageName}) async {
    final response = await _languageApiService.fetchLanguagesData(
        language: language, pageName: pageName);
    propertyListingLang = response;
    notifyListeners();
  }
}
