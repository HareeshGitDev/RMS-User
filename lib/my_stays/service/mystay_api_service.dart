import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/my_stays/model/invoice_payment_model.dart';
import 'package:RentMyStay_user/my_stays/model/ticket_response_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:http/http.dart';

import '../../property_details_module/model/booking_amount_request_model.dart';
import '../../property_details_module/model/booking_credential_response_model.dart';
import '../../utils/constants/api_urls.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../model/Invoice_Details_Model.dart';
import '../model/mystay_details_model.dart';
import '../model/mystay_list_model.dart';
import '../model/refund_splitup_model.dart';

class MyStayApiService {
  final RMSUserApiService _apiService = RMSUserApiService();

  Future<MyStayListModel> fetchMyStayList() async {
    String url = AppUrls.myStayListUrl;
    final response = await _apiService.getApiCall(endPoint: url);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() == 'success' &&
        data['data'] != []) {
      return MyStayListModel.fromJson(data);
    } else {
      return MyStayListModel(
        msg: 'failure',
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

  Future<TicketResponseModel> fetchTicketList() async {
    String url = AppUrls.ticketListUrl;
    final response = await _apiService.getApiCall(endPoint: url);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() != 'failure') {
      return TicketResponseModel.fromJson(data);
    } else {
      return TicketResponseModel(
        msg: 'failure',
      );
    }
  }

  Future<int> updateTicketStatus(
      {required String status, required String ticketId}) async {
    String url = AppUrls.ticketStatusUrl;
    final response = await _apiService.putApiCall(
        endPoint: url, bodyParams: {"ticket_id": ticketId, "status": status});

    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase() == 'success' ? 200 : 404;
  }

  Future<int> generateTicket(
      {required String bookingId,
      required String requirements,
      required String propertyId,
      required String description,
      required String address,
       String? imagePath}) async {
    String url = AppUrls.generateTicketUrl;

    FormData formData = imagePath != null? FormData.fromMap({
      'booking_id': bookingId,
      'requirement': requirements,
      'prop_id': propertyId,
      'description': description,
      'address': address,
      'issue_img': await dio.MultipartFile.fromFile(File(imagePath).path),
    }): FormData.fromMap({
      'booking_id': bookingId,
      'requirement': requirements,
      'prop_id': propertyId,
      'description': description,
      'address': address,
    });

    final response = await _apiService.postApiCallFormData(
        endPoint: url, formData: formData);

    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase() == 'success' ? 200 : 404;
  }

  Future<String> downloadInvoice(
      {required String bookingId, required String invoiceId}) async {
    String url = AppUrls.invoiceDownloadUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'invoice_id': invoiceId,
      'booking_id': bookingId,
    });

    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase() == 'success' &&
            data['data'].toString().isNotEmpty
        ? data['data']
        : '';
  }

  Future<InvoicePaymentModel> fetchInvoicePaymentCredentials(
      {required BookingAmountRequestModel model}) async {
    String url = AppUrls.invoicePaymentUrl;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      "invoice_id": model.invoiceId,
      "amount": model.depositAmount,
      "billing_tel": model.phone,
      "billing_name": model.name,
      "billing_email": model.email,
    });
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() == 'success') {
      return InvoicePaymentModel.fromJson(data);
    } else {
      return InvoicePaymentModel(msg: 'failure');
    }
  }

  Future<int> updateInvoiceUTRPayment({
    required String invoiceId,
    required String utrNumber,
    required String bookingId,
  }) async {
    String url = AppUrls.utrInvoiceUpdateUrl;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      "utr_no": utrNumber,
      'invoice_id': invoiceId,
      "booking_id": bookingId,
    });
    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase() == 'success' ? 200 : 404;
  }
}
