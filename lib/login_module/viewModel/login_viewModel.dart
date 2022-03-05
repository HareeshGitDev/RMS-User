import 'package:RentMyStay_user/login_module/model/gmail_registration_request_model.dart';
import 'package:RentMyStay_user/login_module/model/gmail_signin_request_model.dart';
import 'package:RentMyStay_user/login_module/model/login_response_model.dart';
import 'package:RentMyStay_user/login_module/model/otp_registration_otp_model.dart';
import 'package:RentMyStay_user/login_module/model/signup_request_model.dart';
import 'package:RentMyStay_user/login_module/service/login_api_service.dart';
import 'package:flutter/cupertino.dart';

import '../model/signup_response_model.dart';

class LoginViewModel extends ChangeNotifier {

  final LoginApiService _loginApiService = LoginApiService();


  Future< LoginResponseModel> getLoginDetails({required String email , required String password}) async {
    final LoginResponseModel response =
        await _loginApiService.fetchLoginDetails(email: email,password: password);
   return response;

  }

  Future<SignUpResponseModel> signUpUser(
      {required SignUpRequestModel signUpRequestModel}) async {
    final SignUpResponseModel response = await _loginApiService.signUpUser(
        model: signUpRequestModel, );
    return response;
  }
  Future<Map<String,dynamic>?> resetPassword(
      {required String email}) async {

    final Map<String,dynamic>? response = await _loginApiService.resetPassword(email: email);

    return response;
  }

  Future<LoginResponseModel> registerUserAfterGmail(
      {required GmailSignInRequestModel model}) async {
    final response = await _loginApiService.registerAfterGmail(model: model);
    return response;
  }
  Future<int> detailsValidationAfterGmail(
      {required GmailRegistrationRequestModel model}) async {
    final response = await _loginApiService.detailsValidationAfterGmail(model: model);
    return response;
  }

  Future<OtpRegistrationResponseModel> verifyOTP({required String mobileNumber,required String uid}) async {
    final response = await _loginApiService.verifyOTP(mobileNumber: mobileNumber, uid: uid);
    return response;
  }
  Future<SignUpResponseModel> detailsValidationAfterOTP(
      {required SignUpRequestModel model}) async {
    final response = await _loginApiService.detailsValidationAfterOTP(model: model);
    return response;
  }
}
