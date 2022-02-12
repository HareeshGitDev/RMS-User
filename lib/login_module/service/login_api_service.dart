import 'dart:convert';

import 'package:RentMyStay_user/login_module/model/login_response_model.dart';
import 'package:RentMyStay_user/login_module/model/signup_request_model.dart';
import 'package:RentMyStay_user/login_module/model/signup_response_model.dart';
import 'package:RentMyStay_user/utils/constants/api_urls.dart';
import 'package:RentMyStay_user/utils/service/rms_user_api_service.dart';

class LoginApiService {
  final RMSUserApiService _apiService = RMSUserApiService();


  Future<LoginResponseModel?> fetchLoginDetails({required String email , required String password}) async {
    String url=AppUrls.loginUrl;
    final response = await _apiService.getApiCallWithQueryParams(endPoint: url,queryParams: {
      'email':json.encode(email),
      'password':json.encode(password),
    });

    return response;
  }

  Future<SignUpResponseModel?> signUpUser(
      {required SignUpRequestModel signUpRequestModel}) async {
    String url=AppUrls.signUpUrl;
    final response = await _apiService.postApiCall(
        endPoint: url, bodyParams: signUpRequestModel.toJson());

    return response;
  }
}
