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

  Future<PropertyListModel> fetchPropertyDetailsList({
    required String address,
    String? propertyType,
    String? fromDate,
    String? toDate,
    required Property property,
  }) async {
    String url = AppUrls.propertyListingUrl;

    Map<String, dynamic> queryParams = {
      'addr': address,
    };
    if (property == Property.fromLocation) {
      queryParams = {
        'addr': address,
      };
    } else if (property == Property.fromBHK) {
      queryParams = {
        'addr': address,
        'roomType': propertyType,
      };
    } else if (property == Property.fromSearch) {
      queryParams = {
        'addr': address,
        'fromd': fromDate,
        'tod': toDate,
      };
    }

    final response = await _apiService.getApiCallWithQueryParams(
        endPoint: url,
        queryParams: queryParams);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return PropertyListModel(msg: 'failure');
    } else {
      return PropertyListModel.fromJson(data);
    }
  }

  Future<int> addToWishList({required String propertyId}) async {
    String url = AppUrls.addWishListPropertyUrl;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      'prop_id': base64Encode(utf8.encode(propertyId)),
    });

    final data = response as Map<String, dynamic>;
    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }

  Future<WishListModel> fetchWishList() async {
    String url = AppUrls.fetchWishListPropertyUrl;
    final response = await _apiService
        .getApiCall(endPoint: url,);

    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return WishListModel(msg: 'failure', data: []);
    } else {
      return WishListModel.fromJson(data);
    }
  }

  Future<PropertyListModel> filterSortPropertyList({
    required FilterSortRequestModel requestModel,
  }) async {
    String url = AppUrls.propertyListingUrl;

    final response = await _apiService.getApiCallWithQueryParams(
        endPoint: url, queryParams: requestModel.toJson());
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return PropertyListModel(msg: 'failure');
    } else {
      return PropertyListModel.fromJson(data);
    }
  }
}
