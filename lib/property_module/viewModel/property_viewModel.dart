import 'dart:developer';

import 'package:RentMyStay_user/profile_Module/model/filter_sort_request_model.dart';
import 'package:RentMyStay_user/property_module/model/wish_list_model.dart';
import 'package:RentMyStay_user/property_module/service/property_api_service.dart';
import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:flutter/cupertino.dart';

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

  Future<void> getPropertyDetailsList({
    required String address,
    String? propertyType,
    String? fromDate,
    String? toDate,
    required Property property,
  }) async {
    final PropertyListModel data =
        await _propertyApiService.fetchPropertyDetailsList(
            address: address,
            property: property,
            propertyType: propertyType,
            fromDate: fromDate,
            toDate: toDate);

    propertyListModel = data;
    log('ALL PROPERTIES :: ${propertyListModel.data?.length}');
    notifyListeners();
  }

  Future<int> addToWishlist({
    required String propertyId,
  }) async =>
      await _propertyApiService.addToWishList(propertyId: propertyId);

  Future<void> getWishList() async {
    final WishListModel data = await _propertyApiService.fetchWishList();
    wishListModel = data;
    log('ALL WishListed PROPERTIES :: ${wishListModel.data?.length}');
    notifyListeners();
  }

  Future<void> getSearchedPlace(String searchText) async {
    RMSUserApiService apiService = RMSUserApiService();

    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchText&types=geocode&key=$googleMapKey&components=country:in';
    final data = await apiService.getApiCallWithURL(endPoint: url)
        as Map<String, dynamic>;

    if (data['status'] == 'OK' && data['predictions'] != null) {
      Iterable iterable = data['predictions'];
      locations = iterable
          .map((suggestion) => LocationModel(
              location: '${suggestion['description']}',
              placeId: '${suggestion['place_id']} '))
          .toList();
      notifyListeners();
    }
  }

  Future<void> filterSortPropertyList({
    required FilterSortRequestModel requestModel,
  }) async {
    final PropertyListModel data = await _propertyApiService
        .filterSortPropertyList(requestModel: requestModel);

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
