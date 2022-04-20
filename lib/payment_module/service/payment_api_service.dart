import 'package:RentMyStay_user/utils/service/rms_user_api_service.dart';


class PaymentApiService {
  late final RMSUserApiService _apiService = RMSUserApiService();


  Future<int> submitPaymentResponse(
      {required String paymentId, required String paymentSignature, required String redirectApi}) async {
    String url = redirectApi;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      'razorpay_payment_id': paymentId,
      'razorpay_signature': paymentSignature,
    });
    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }
}