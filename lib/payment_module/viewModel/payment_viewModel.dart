import 'package:RentMyStay_user/payment_module/service/payment_api_service.dart';
import 'package:flutter/cupertino.dart';

class PaymentViewModel extends ChangeNotifier{
  late final PaymentApiService _apiService=PaymentApiService();

  Future<int> submitPaymentResponse(
      {required String paymentId,
        required String paymentSignature,
        required String redirectApi}) async {
    return await _apiService.submitPaymentResponse(
        paymentId: paymentId,
        paymentSignature: paymentSignature,
        redirectApi: redirectApi);
  }



}