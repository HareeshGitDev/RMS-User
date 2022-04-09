import 'dart:convert';
import 'dart:developer';

import 'package:RentMyStay_user/login_module/model/gmail_registration_request_model.dart';
import 'package:RentMyStay_user/login_module/model/gmail_signin_request_model.dart';
import 'package:RentMyStay_user/login_module/model/login_response_model.dart';
import 'package:RentMyStay_user/login_module/model/signup_request_model.dart';
import 'package:RentMyStay_user/login_module/model/signup_response_model.dart';
import 'package:RentMyStay_user/utils/constants/api_urls.dart';
import 'package:RentMyStay_user/utils/service/rms_user_api_service.dart';

import '../model/otp_registration_otp_model.dart';

class LoginApiService {
  final RMSUserApiService _apiService = RMSUserApiService();

  Future<LoginResponseModel> fetchLoginDetails(
      {required String email, required String password}) async {
    String url = AppUrls.loginUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'email': email,
      'password': password,
    });
    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'success') {
      return LoginResponseModel.fromJson(data);
    } else {
      return LoginResponseModel(
          status: 'failure', message: data['message'].toString());
    }
  }

  Future<SignUpResponseModel> signUpUser(
      {required SignUpRequestModel model}) async {
    String url = AppUrls.signUpUrl;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      "fname": model.fname,
      "email": model.email,
      "source_rms": model.sourceRms,
      "iam": model.iam,
      "password": model.password,
      "phonenumber": model.phonenumber,
      "city": model.city,
      "referal": model.referal,
    });
    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'success') {
      return SignUpResponseModel.fromJson(data);
    } else {
      return SignUpResponseModel(
          status: 'failure', message: data['message'].toString());
    }
  }

  Future<Map<String, dynamic>?> resetPassword({required String email}) async {
    String url = AppUrls.forgotPasswordUrl;
    final Map<String, dynamic>? response = await _apiService.postApiCall(endPoint: url, bodyParams:{
      'email': email,
    });

    return response;
  }

  Future<LoginResponseModel> registerAfterGmail(
      {required GmailSignInRequestModel model}) async {
    String url = AppUrls.signInWithGoogleUrl;
    final response = await _apiService.postApiCall(
        endPoint: url, bodyParams: model.toJson());
    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'success') {
      return LoginResponseModel.fromJson(data);
    } else {
      return LoginResponseModel(
          status: 'failure', message: data['message'].toString());
    }
  }

  Future<int> detailsValidationAfterGmail(
      {required GmailRegistrationRequestModel model}) async {
    String url = AppUrls.registrationWithGoogleUrl;
    final response = await _apiService.postApiCall(
        endPoint: url, bodyParams: model.toJson());
    final data = response as Map<String, dynamic>;

    return data['status'].toString().toLowerCase() == 'success' ? 200 : 404;
  }

  Future<OtpRegistrationResponseModel> verifyOTP(
      {required String mobileNumber, String? uid}) async {
    String url = AppUrls.loginOtpUrl;
    final response = await _apiService.getApiCallWithQueryParams(
        endPoint: url, queryParams: {'mobileno': mobileNumber, 'uid': uid});
    if (response != null) {
      final data = response as Map<String, dynamic>;
      if (data['status'].toString().toLowerCase() == 'success') {
        if (data['action'].toString() == 'sign-up') {
          return OtpRegistrationResponseModel(
              status: 'success', action: 'sign-up');
        } else if (data['action'].toString() == 'sign-in') {
          return OtpRegistrationResponseModel.fromJson(data);
        }
      }
      return OtpRegistrationResponseModel(status: 'failure');
    }
    return OtpRegistrationResponseModel(status: 'failure');
  }

  Future<SignUpResponseModel> detailsValidationAfterOTP(
      {required SignUpRequestModel model}) async {
    String url = AppUrls.signUpUrl;

    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      "fname": model.fname,
      "email": model.email,
      "source_rms": model.sourceRms,
      "uid": model.uid,
      "iam": model.iam,
      "phonenumber": model.phonenumber,
      "city": model.city
    });


      final data = response as Map<String, dynamic>;
      return data['status'].toString().toLowerCase() == 'success'
          ? SignUpResponseModel.fromJson(data)
          : SignUpResponseModel(
              status: 'failure', message: data['message'].toString());

  }
}
