import 'dart:convert';
import 'dart:developer';

import 'package:RentMyStay_user/profile_Module/model/filter_sort_request_model.dart';
import 'package:RentMyStay_user/property_module/model/property_list_model.dart';
import 'package:RentMyStay_user/property_module/model/wish_list_model.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';

import '../../utils/constants/api_urls.dart';
import '../../utils/constants/enum_consts.dart';
import '../../utils/service/rms_user_api_service.dart';

class PropertyApiService {
  final RMSUserApiService _apiService = RMSUserApiService();
  String? registeredToken;

  Future<String?> _getRegisteredToken() async {
    SharedPreferenceUtil _shared = SharedPreferenceUtil();
    registeredToken = await _shared.getString(rms_registeredUserToken);
    return registeredToken;
  }

  Future<PropertyListModel> fetchPropertyDetailsList({
    required String address,
    String? propertyType,
    String? fromDate,
    String? toDate,
    required Property property,
  }) async {
    String url = AppUrls.propertyListingUrl;
    String searchUrl = AppUrls.searchPropertyUrl;

    Map<String, dynamic> queryParams = {
      'addr': address,
      'app_token': registeredToken ?? await _getRegisteredToken(),
    };
    if (property == Property.FromLocation) {
      queryParams = {
        'addr': address,
        'app_token': registeredToken ?? await _getRegisteredToken(),
      };
    } else if (property == Property.FromBHK) {
      queryParams = {
        'addr': address,
        'app_token': registeredToken ?? await _getRegisteredToken(),
        'roomType': propertyType,
      };
    } else if (property == Property.FromSearch) {
      queryParams = {
        'addr': address,
        'app_token': registeredToken ?? await _getRegisteredToken(),
        'fromd': fromDate,
        'tod': toDate,
      };
    }

    final response = await _apiService.getApiCallWithQueryParams(
        endPoint: property == Property.FromSearch ? searchUrl : url,
        queryParams: queryParams);
    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'success') {
      return PropertyListModel.fromJson(data);
    } else {
      return PropertyListModel(status: 'failure');
    }
  }

  Future<int> addToWishList({required String propertyId}) async {
    String url = AppUrls.addWishListPropertyUrl;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      'prop_id': base64Encode(utf8.encode(propertyId)),
    });

    final data = response as Map<String, dynamic>;
    return data['msg'].toString().toLowerCase() == 'success' ? 200 : 404;
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

  Future<PropertyListModel> filterSortPropertyList({
    required FilterSortRequestModel requestModel,
  }) async {
    String url = AppUrls.filterSortPropsUrl;

    final response = await _apiService.getApiCallWithQueryParams(
        endPoint: url, queryParams: requestModel.toJson());
    final data = response as Map<String, dynamic>;

    if (data['success'].toString().toLowerCase() == 'true') {
      data['status'] = 'success';
      return PropertyListModel.fromJson(data);
    } else {
      return PropertyListModel(status: 'failure');
    }
  }
}
