import 'dart:developer';

import 'package:RentMyStay_user/home_module/model/invite_and_earn_model.dart';
import 'package:RentMyStay_user/language_module/model/language_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<ReferAndEarnModel> fetchInviteEarnDetails() async {
    String url = AppUrls.referUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
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


}
