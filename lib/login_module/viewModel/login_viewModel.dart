import 'package:RentMyStay_user/login_module/model/login_response_model.dart';
import 'package:RentMyStay_user/login_module/model/signup_request_model.dart';
import 'package:RentMyStay_user/login_module/service/login_api_service.dart';
import 'package:flutter/cupertino.dart';

import '../model/signup_response_model.dart';

class LoginViewModel extends ChangeNotifier {

  final LoginApiService _loginApiService = LoginApiService();

  Future< LoginResponseModel?> getLoginDetails({required String email , required String password}) async {
    final LoginResponseModel? response =
        await _loginApiService.fetchLoginDetails(email: email,password: password);
   return response;
  }

  Future<SignUpResponseModel?> signUpUser(
      {required SignUpRequestModel signUpRequestModel}) async {
    final SignUpResponseModel? response = await _loginApiService.signUpUser(
        signUpRequestModel: signUpRequestModel);
    return response;
  }
}