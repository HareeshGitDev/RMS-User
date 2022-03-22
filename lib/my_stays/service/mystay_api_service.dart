import 'dart:convert';

import 'package:RentMyStay_user/my_stays/model/Invoice_Details_Model.dart';

import '../../utils/constants/api_urls.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../model/mystay_details_model.dart';
import '../model/mystay_list_model.dart';
import '../model/refund_splitup_model.dart';

class MyStayApiService {
  final RMSUserApiService _apiService = RMSUserApiService();

  String? registeredToken;
  final SharedPreferenceUtil _shared = SharedPreferenceUtil();

  Future<String?> _getRegisteredToken() async {
    registeredToken = await _shared.getString(rms_registeredUserToken);
    return registeredToken;
  }

  Future<MyStayListModel> fetchMyStayList() async {
    String url = AppUrls.myStayListUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'token_id': await _getRegisteredToken(),
    });
    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'success') {
      return MyStayListModel.fromJson(data);
    } else {
      return MyStayListModel(
        status: 'failure',
      );
    }
  }

  Future<MyStayDetailsModel> fetchMyStayDetails(
      {required String bookingId}) async {
    String url = AppUrls.myBookingDetails;
    final response = await _apiService.getApiCallWithQueryParams(
      endPoint: url,
      queryParams: {
        'booking_id': base64Encode(utf8.encode(bookingId)),
      },
    );
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() == 'success') {
      return MyStayDetailsModel.fromJson(data);
    } else {
      return MyStayDetailsModel(
        msg: 'failure',
      );
    }
  }

  Future<RefundSplitUpModel> fetchRefundSplitUpDetails(
      {required String bookingId}) async {
    String url = AppUrls.refundDetailsUrl;
    final response = await _apiService.getApiCallWithQueryParams(
        endPoint: url, queryParams: {'booking_id': bookingId});
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() == 'success') {
      return RefundSplitUpModel.fromJson(data);
    } else {
      return RefundSplitUpModel(
        msg: 'failure',
      );
    }
  }

  Future<InvoiceDetailsModel> fetchInvoiceDetails(
      {required String bookingId}) async {
    String url = AppUrls.invoiceDetailsUrl;
    final response = await _apiService.getApiCallWithQueryParams(
        endPoint: url,
        queryParams: {'booking_id': base64Encode(utf8.encode(bookingId))});
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() == 'success') {
      return InvoiceDetailsModel.fromJson(data);
    } else {
      return InvoiceDetailsModel(
        msg: 'failure',
      );
    }
  }

  Future<int> submitFeedbackAndBankDetails(
      {required String bookingId,
      required String email,
      required String ratings,
      String? bankDetails,
      required String buildingRatings,
      required String suggestions,
      required String friendRecommendation}) async {
    String url = AppUrls.feedbackAndBankDetailsUrl;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      "booking_id": bookingId,
      "email": email,
      "bankdetails": bankDetails,
      "rating": ratings,
      "building_rating": buildingRatings,
      "frnd_recomd": friendRecommendation,
      "suggest": suggestions,
    });
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() ==
        'bank details updated successfully.') {
      return 200;
    } else {
      return 404;
    }
  }

  Future<int> checkInAndCheckOut(
      {required String bookingId, required bool checkIn}) async {
    String checkInUrl = AppUrls.checkInUrl;
    String checkOutUrl = AppUrls.checkOutUrl;
    final response = await _apiService.postApiCall(
        endPoint: checkIn ? checkInUrl : checkOutUrl,
        bodyParams: {'booking_id': bookingId});
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() == 'success') {
      return 200;
    } else {
      return 404;
    }
  }
}
