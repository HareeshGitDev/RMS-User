import 'dart:convert';
import 'dart:developer';

import 'package:RentMyStay_user/home_module/model/home_page_model.dart';
import 'package:RentMyStay_user/home_module/model/invite_and_earn_model.dart';
import 'package:RentMyStay_user/home_module/model/tenant_leads_model.dart';
import 'package:RentMyStay_user/language_module/model/language_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/constants/api_urls.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../../utils/service/shared_prefrences_util.dart';

class HomeApiService {
  final RMSUserApiService _apiService = RMSUserApiService();


  String? registeredEmail;
  final SharedPreferenceUtil _shared = SharedPreferenceUtil();

  Future<String?> _getRegisteredEmail() async {
    registeredEmail = await _shared.getString(rms_email);
    return registeredEmail;
  }

  Future<ReferAndEarnModel> fetchInviteEarnDetails({ required BuildContext context,}) async {
    String url = AppUrls.referUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url,context: context, queryParams: {
      'email': await _getRegisteredEmail(),
    });
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return ReferAndEarnModel(
        msg: 'failure',
      );
    } else {
      return ReferAndEarnModel.fromJson(data);

    }
  }
  Future<int> addToWishList({required String propertyId, required BuildContext context,}) async {
    String url = AppUrls.addWishListPropertyUrl;
    final response = await _apiService.postApiCall(endPoint: url,context: context, bodyParams: {
      'prop_id': base64Encode(utf8.encode(propertyId)),
    });

    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }
  Future<HomePageModel> fetchHomePageData({ required BuildContext context,}) async {
    String url = AppUrls.homePageUrl;
    final response = await _apiService.getApiCall(endPoint: url,context: context);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return HomePageModel(
        msg: 'failure',
      );
    } else {
      return HomePageModel.fromJson(data);

    }
  }
  Future<TenantLeadsModel> fetchTenantLeads({ required BuildContext context,}) async {
    String url = AppUrls.tenantLeadsUrl;
    final response = await _apiService.getApiCall(endPoint: url,context: context);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return TenantLeadsModel(
        msg: 'failure',
      );
    } else {
      return TenantLeadsModel.fromJson(data);

    }
  }


}
