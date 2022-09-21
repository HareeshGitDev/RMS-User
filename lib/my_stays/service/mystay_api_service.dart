import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/my_stays/model/invoice_payment_model.dart';
import 'package:RentMyStay_user/my_stays/model/my_bank_details_model.dart';
import 'package:RentMyStay_user/my_stays/model/ticket_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

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

  Future<MyStayListModel> fetchMyStayList({ required BuildContext context,}) async {
    String url = AppUrls.myStayListUrl;
    final response = await _apiService.getApiCall(endPoint: url,context: context);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return  MyStayListModel(
        msg: 'failure',
      );
    } else {
      return MyStayListModel.fromJson(data);
    }
  }

  Future<MyStayDetailsModel> fetchMyStayDetails(
      {required String bookingId, required BuildContext context,}) async {
    String url = AppUrls.myBookingDetails;
    final response = await _apiService.getApiCallWithQueryParams(
      context: context,
      endPoint: url,
      queryParams: {
        'booking_id': base64Encode(utf8.encode(bookingId)),
      },
    );
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return MyStayDetailsModel(
        msg: 'failure',
      );
    } else {
      return MyStayDetailsModel.fromJson(data);
    }
  }

  Future<MyBankDetailsModel> fetchMyBankDetails(
      {required String bookingId, required BuildContext context,}) async {
    String url = AppUrls.feedbackAndBankDetailsUrl;
    final response = await _apiService.getApiCallWithQueryParams(
      context: context,
      endPoint: url,
      queryParams: {
        'booking_id': bookingId,
      },
    );
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return MyBankDetailsModel(
        msg: 'failure',
      );
    } else {
      return MyBankDetailsModel.fromJson(data);
    }
  }

  Future<RefundSplitUpModel> fetchRefundSplitUpDetails(
      {required String bookingId, required BuildContext context,}) async {
    String url = AppUrls.refundDetailsUrl;
    final response = await _apiService.getApiCallWithQueryParams(
      context: context,
        endPoint: url, queryParams: {'booking_id': bookingId});
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return RefundSplitUpModel(
        msg: 'failure',
      );
    } else {
      return RefundSplitUpModel.fromJson(data);
    }
  }

  Future<InvoiceDetailsModel> fetchInvoiceDetails(
      {required String bookingId, required BuildContext context,}) async {
    String url = AppUrls.invoiceDetailsUrl;
    final response = await _apiService.getApiCallWithQueryParams(
      context: context,
        endPoint: url,
        queryParams: {'booking_id': base64Encode(utf8.encode(bookingId))});
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return  InvoiceDetailsModel(
        msg: 'failure',
      );
    } else {
      return InvoiceDetailsModel.fromJson(data);
    }
  }

  Future<int> submitFeedbackAndBankDetails(
      {required String bookingId,
      required String email,
      required String ratings,
        required BuildContext context,
       required String account_number,
       required String account_name,
       required String ifsc_code,
       required String bank_name,
      required String buildingRatings,
      required String suggestions,
      required String friendRecommendation}) async {
    String url = AppUrls.feedbackAndBankDetailsUrl;
    final response = await _apiService.postApiCall(endPoint: url,context: context, bodyParams: {
      "booking_id": bookingId,
      "email": email,

      "rating": ratings,
      "building_rating": buildingRatings,
      "frnd_recomd": friendRecommendation,
      "suggest": suggestions,
      "acc_holder":account_name,
      "acc_no":account_number,
      "ifsc_code":ifsc_code,
      "bank_name":bank_name
    });
    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure') ? 404:200;
  }

  Future<int> checkInAndCheckOut(
      {required String bookingId, required bool checkIn, required BuildContext context,}) async {
    String checkInUrl = AppUrls.checkInUrl;
    String checkOutUrl = AppUrls.checkOutUrl;
    final response = await _apiService.postApiCall(
      context: context,
        endPoint: checkIn ? checkInUrl : checkOutUrl,
        bodyParams: {'booking_id': bookingId});
    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure') ? 404:200;
  }

  Future<TicketResponseModel> fetchTicketList({ required BuildContext context,}) async {
    String url = AppUrls.ticketListUrl;
    final response = await _apiService.getApiCall(endPoint: url,context: context);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return TicketResponseModel(
        msg: 'failure',
      );
    } else {
      return TicketResponseModel.fromJson(data);
    }
  }

  Future<int> updateTicketStatus(
      {required String status, required String ticketId}) async {
    String url = AppUrls.ticketStatusUrl;
    final response = await _apiService.putApiCall(
        endPoint: url, bodyParams: {"ticket_id": ticketId, "status": status});

    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }

  Future<int> generateTicket(
      {required String bookingId,
      required String requirements,
      required String propertyId,
      required String description,
      required String address,
       List<File>? imageList}) async {
    String url = AppUrls.generateTicketUrl;
    List<MultipartFile> list = [];
    if(imageList != null && imageList.isNotEmpty){
      for (var data in imageList) {
        final image=await MultipartFile.fromFile(data.path);
        log(image.filename.toString());
        list.add(image);
      }
    }

    FormData formData = imageList != null && imageList.isNotEmpty? FormData.fromMap({
      'booking_id': bookingId,
      'requirement': requirements,
      'prop_id': propertyId,
      'description': description,
      'address': address,
      'issue_img': list,
    },ListFormat.multiCompatible): FormData.fromMap({
      'booking_id': bookingId,
      'requirement': requirements,
      'prop_id': propertyId,
      'description': description,
      'address': address,
    },ListFormat.multiCompatible);

    final response = await _apiService.postApiCallFormData(
        endPoint: url, formData: formData);

    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }

  Future<String> downloadInvoice(
      {required String bookingId, required String invoiceId, required BuildContext context,}) async {
    String url = AppUrls.invoiceDownloadUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url,context: context, queryParams: {
      'invoice_id': invoiceId,
      'booking_id': bookingId,
    });

    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure')
        ? ''
        : data['data'];
  }

  Future<InvoicePaymentModel> fetchInvoicePaymentCredentials(
      {required BookingAmountRequestModel model, required BuildContext context,}) async {
    String url = AppUrls.invoicePaymentUrl;
    final response = await _apiService.postApiCall(endPoint: url,context: context, bodyParams: {
      "invoice_id": model.invoiceId,
      "amount": model.depositAmount,
      "billing_tel": model.phone,
      "billing_name": model.name,
      "billing_email": model.email,
    });
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return InvoicePaymentModel(msg: 'failure');
    } else {
      return InvoicePaymentModel.fromJson(data);
    }
  }

  Future<int> updateInvoiceUTRPayment({
    required String invoiceId,
    required String utrNumber,
    required String bookingId,
    required BuildContext context,
  }) async {
    String url = AppUrls.utrInvoiceUpdateUrl;
    final response = await _apiService.postApiCall(endPoint: url,context: context, bodyParams: {
      "utr_no": utrNumber,
      'invoice_id': invoiceId,
      "booking_id": bookingId,
    });
    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }
}
