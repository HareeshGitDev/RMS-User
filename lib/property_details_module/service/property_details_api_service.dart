import 'dart:convert';
import 'dart:developer';

import 'package:RentMyStay_user/property_module/model/property_list_model.dart';
import 'package:RentMyStay_user/property_module/model/wish_list_model.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';

import '../../utils/constants/api_urls.dart';
import '../../utils/constants/enum_consts.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../model/property_details_model.dart';

class PropertyDetailsApiService {
  final RMSUserApiService _apiService = RMSUserApiService();
  String? registeredToken;

  Future<String?> _getRegisteredToken() async {
    SharedPreferenceUtil _shared = SharedPreferenceUtil();
    registeredToken = await _shared.getString(rms_registeredUserToken);
    return registeredToken;
  }

  Future<PropertyDetailsModel> fetchPropertyDetails(
      {required String propId}) async {
    String url = AppUrls.propertyDetailsUrl;

    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'id': propId,
      'app_token': registeredToken ?? await _getRegisteredToken(),
    });
    return PropertyDetailsModel.fromJson(response);
  }

  Future<String> addToWishList({required String propertyId}) async {
    String url = AppUrls.addWishListPropertyUrl;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      'apptoken': await _getRegisteredToken(),
      'prop_id': base64Encode(utf8.encode(propertyId)),
    });

    final data = response as Map<String, dynamic>;

    return data['response'];
  }

  Future<WishListModel> fetchWishList() async {
    String url = AppUrls.fetchWishListPropertyUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'app_token': await _getRegisteredToken(),
    });

    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'success') {
      return WishListModel.fromJson(data);
    } else {
      return WishListModel(status: 'failure', data: []);
    }
  }
}
