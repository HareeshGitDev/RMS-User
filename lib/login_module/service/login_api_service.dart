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
    final response = await _apiService.postApiCall(
        endPoint: url,
        bodyParams: {
          'email': email,
          'password': password,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() ==
        'you have successfully logged in') {
      return LoginResponseModel.fromJson(data);
    } else {
      return LoginResponseModel(msg: 'failure');
    }
  }

  Future<SignUpResponseModel> signUpUser(
      {required SignUpRequestModel model}) async {
    String url = AppUrls.signUpUrl;
    final response = await _apiService.postApiCall(
        endPoint: url,
        bodyParams: {
          "fname": model.fname,
          "email": model.email,
          "source_rms": model.sourceRms,
          "iam": model.iam,
          "password": model.password,
          "phonenumber": model.phonenumber,
          "city": model.city,
          "referal": model.referal,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() != 'failure') {
      return SignUpResponseModel.fromJson(data);
    } else {
      return SignUpResponseModel(
        msg: 'failure',
      );
    }
  }

  Future<int> resetPassword({required String email}) async {
    String url = AppUrls.forgotPasswordUrl;
    final response = await _apiService.postApiCall(
        endPoint: url,
        bodyParams: {
          'email': email,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase() != 'failure' ? 200 : 400;
  }

  Future<LoginResponseModel> registerAfterGmail(
      {required GmailSignInRequestModel model}) async {
    String url = AppUrls.signInWithGoogleUrl;
    final response = await _apiService.postApiCall(
        endPoint: url, bodyParams: model.toJson(), fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() != 'failure') {
      return LoginResponseModel.fromJson(data);
    } else {
      return LoginResponseModel(msg: 'failure');
    }
  }

  Future<int> detailsValidationAfterGmail(
      {required GmailRegistrationRequestModel model}) async {
    String url = AppUrls.registrationWithGoogleUrl;
    final response = await _apiService.postApiCall(
        endPoint: url, bodyParams: model.toJson());
    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase() != 'failure' ? 200 : 404;
  }

  Future<OtpRegistrationResponseModel> verifyOTP(
      {required String mobileNumber, String? uid}) async {
    String url = AppUrls.loginOtpUrl;
    final response = await _apiService.getApiCallWithQueryParams(
        endPoint: url,
        queryParams: {'mobileno': mobileNumber, 'uid': uid},
        fromLogin: true);

    final data = response as Map<String, dynamic>;
    if (data['msg'].toString().toLowerCase() != 'failure') {
      return OtpRegistrationResponseModel.fromJson(data);
    } else {
      return OtpRegistrationResponseModel(msg: 'failure');
    }
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
    return data['msg'].toString().toLowerCase() != 'failure'
        ? SignUpResponseModel.fromJson(data)
        : SignUpResponseModel(
            msg: 'failure',
          );
  }
}
