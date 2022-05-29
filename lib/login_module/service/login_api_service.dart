import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
          'device': Platform.isIOS ? 'ios' : 'android'
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return LoginResponseModel(msg: 'failure');
    } else {
      return LoginResponseModel.fromJson(data);
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

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return SignUpResponseModel(
        msg: 'failure',
      );
    } else {
      return SignUpResponseModel.fromJson(data);
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

    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }

  Future<LoginResponseModel> registerAfterGmail(
      {required GmailSignInRequestModel model}) async {
    String url = AppUrls.signInWithGoogleUrl;
    final response = await _apiService.postApiCall(
        endPoint: url, bodyParams: model.toJson(), fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return LoginResponseModel(msg: 'failure');
    } else {
      return LoginResponseModel.fromJson(data);
    }
  }

  Future<int> detailsValidationAfterGmail(
      {required GmailRegistrationRequestModel model}) async {
    String url = AppUrls.registrationWithGoogleUrl;
    final response = await _apiService.postApiCall(
        endPoint: url, bodyParams: model.toJson());
    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }

  Future<OtpRegistrationResponseModel> verifyOTP(
      {required String mobileNumber, String? uid}) async {
    String url = AppUrls.loginOtpUrl;
    final response = await _apiService.getApiCallWithQueryParams(
        endPoint: url,
        queryParams: {
          'mobileno': mobileNumber,
          'uid': uid,
          'device': Platform.isIOS ? 'ios' : 'android'
        },
        fromLogin: true);

    final data = response as Map<String, dynamic>;
    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return OtpRegistrationResponseModel(msg: 'failure');
    } else {
      return OtpRegistrationResponseModel.fromJson(data);
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
    return data['msg'].toString().toLowerCase().contains('failure')
        ? SignUpResponseModel(
            msg: 'failure',
          )
        : SignUpResponseModel.fromJson(data);
  }

  Future<int> updateFCMToken({required String fcmToken}) async {
    String url = AppUrls.fcmTokenUrl;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      'token': fcmToken,
    });

    final data = response as Map<String, dynamic>;
    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }
}
