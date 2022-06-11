import 'package:RentMyStay_user/login_module/model/gmail_registration_request_model.dart';
import 'package:RentMyStay_user/login_module/model/gmail_signin_request_model.dart';
import 'package:RentMyStay_user/login_module/model/login_response_model.dart';
import 'package:RentMyStay_user/login_module/model/otp_registration_otp_model.dart';
import 'package:RentMyStay_user/login_module/model/signup_request_model.dart';
import 'package:RentMyStay_user/login_module/service/login_api_service.dart';
import 'package:flutter/cupertino.dart';

import '../../language_module/model/language_model.dart';
import '../../language_module/service/language_api_service.dart';
import '../model/signup_response_model.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginApiService _loginApiService = LoginApiService();
  List<LanguageModel> loginLang = [];
  final LanguageApiService _languageApiService = LanguageApiService();

  Future<LoginResponseModel> getLoginDetails(
      {required String email, required String password}) async {
    final LoginResponseModel response = await _loginApiService
        .fetchLoginDetails(email: email, password: password);
    return response;
  }

  Future<SignUpResponseModel> signUpUser(
      {required SignUpRequestModel signUpRequestModel}) async {
    final SignUpResponseModel response = await _loginApiService.signUpUser(
      model: signUpRequestModel,
    );
    return response;
  }

  Future<int> resetPassword({required String email}) async =>
      await _loginApiService.resetPassword(email: email);

  Future<LoginResponseModel> registerUserAfterGmail(
      {required GmailSignInRequestModel model}) async {
    final response = await _loginApiService.registerAfterGmail(model: model);
    return response;
  }

  Future<int> detailsValidationAfterGmail(
      {required GmailRegistrationRequestModel model}) async {
    final response =
        await _loginApiService.detailsValidationAfterGmail(model: model);
    return response;
  }

  Future<OtpRegistrationResponseModel> verifyOTP(
      {required String mobileNumber, required String uid}) async {
    final response =
        await _loginApiService.verifyOTP(mobileNumber: mobileNumber, uid: uid);
    return response;
  }

  Future<SignUpResponseModel> detailsValidationAfterOTP(
      {required SignUpRequestModel model}) async {
    final response =
        await _loginApiService.detailsValidationAfterOTP(model: model);
    return response;
  }

  Future<int> updateFCMToken({required String fcmToken}) async =>
      await _loginApiService.updateFCMToken(fcmToken: fcmToken);

  Future<void> getLanguagesData(
      {required String language, required String pageName}) async {
    final response = await _languageApiService.fetchLanguagesData(
        language: language, pageName: pageName);
      loginLang = response;

    notifyListeners();
  }
}
