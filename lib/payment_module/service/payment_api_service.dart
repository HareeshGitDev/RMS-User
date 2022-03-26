import 'dart:developer';

import 'package:RentMyStay_user/utils/service/rms_user_api_service.dart';

import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';

class PaymentApiService {
  late final RMSUserApiService _apiService = RMSUserApiService();

  String? registeredToken;

  Future<String?>  get _getRegisteredToken async {
    SharedPreferenceUtil _shared = SharedPreferenceUtil();
    registeredToken ??= await _shared.getString(rms_registeredUserToken);
    return registeredToken;
  }


  Future<int> submitPaymentResponse(
      {required String paymentId, required String paymentSignature, required String redirectApi}) async {
    String url = 'v2/$redirectApi';
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      'razorpay_payment_id': paymentId,
      'razorpay_signature': paymentSignature,
      'app_token': await _getRegisteredToken ?? '',
    });
    final data = response as Map<String, dynamic>;
    log('PAYMENT :: ${data.toString()} -- ZZ $response');
    return data['msg'].toString()=='success'?200:404;
  }
}