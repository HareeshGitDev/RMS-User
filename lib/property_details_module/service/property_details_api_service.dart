import 'dart:convert';
import 'dart:developer';

import 'package:RentMyStay_user/property_details_module/model/booking_amount_request_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_amounts_response_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_credential_response_model.dart';
import 'package:RentMyStay_user/property_module/model/property_list_model.dart';
import 'package:RentMyStay_user/property_module/model/wish_list_model.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';

import '../../utils/constants/api_urls.dart';
import '../../utils/constants/enum_consts.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../model/property_details_model.dart';

class PropertyDetailsApiService {
  final RMSUserApiService _apiService = RMSUserApiService();
  String? registeredToken;

  Future<String?> _getRegisteredToken() async {
    SharedPreferenceUtil _shared = SharedPreferenceUtil();
    registeredToken = await _shared.getString(rms_registeredUserToken);
    return registeredToken;
  }

  Future<PropertyDetailsModel> fetchPropertyDetails(
      {required String propId}) async {
    String url = AppUrls.propertyDetailsUrl;

    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'id': propId,
      'app_token': registeredToken ?? await _getRegisteredToken(),
    });
    return PropertyDetailsModel.fromJson(response);
  }

  Future<String> addToWishList({required String propertyId}) async {
    String url = AppUrls.addWishListPropertyUrl;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      'apptoken': await _getRegisteredToken(),
      'prop_id': base64Encode(utf8.encode(propertyId)),
    });

    final data = response as Map<String, dynamic>;

    return data['response'];
  }

  Future<WishListModel> fetchWishList() async {
    String url = AppUrls.fetchWishListPropertyUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'app_token': await _getRegisteredToken(),
    });

    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'success') {
      return WishListModel.fromJson(data);
    } else {
      return WishListModel(status: 'failure', data: []);
    }
  }

  Future<String> scheduleSiteVisit({required Map<String, dynamic> data}) async {
    String url = AppUrls.scheduleSiteVisitUrl;
    final response =
        await _apiService.postApiCall(endPoint: url, bodyParams: data);
    return response['status'];
  }

  Future<BookingAmountsResponseModel> fetchBookingAmounts(
      {required BookingAmountRequestModel model}) async {
    String url = AppUrls.bookingDetailsUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'id': base64Encode(utf8.encode(model.propId.toString())),
      'travel_from_date': model.fromDate,
      'travel_to_date': model.toDate,
      'num_guests': model.numOfGuests,
      'coupon_code': model.couponCode,
      'app_token': model.token,
    });
    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'success') {
      return BookingAmountsResponseModel.fromJson(data);
    } else {
      return BookingAmountsResponseModel(
          status: 'failure', message: data['message']);
    }
  }
  Future<BookingCredentialResponseModel> fetchBookingCredentials(
      {required BookingAmountRequestModel model}) async {
    String url = AppUrls.bookingCredentialsUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'id': base64Encode(utf8.encode('8791')),
      'travel_from_date': model.fromDate,
      'travel_to_date': model.toDate,
      'num_guests': model.numOfGuests,
      'coupon_code': model.couponCode,
      'app_token': model.token,
      "billing_tel": model.phone,
      "traveller_name": model.name,
      "contact_email": model.email,
      "amount": 1.toString(),
      "payment_gatway": model.paymentGateway,
    });
    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'success') {
      return BookingCredentialResponseModel.fromJson(data);
    } else {
      return BookingCredentialResponseModel(
          status: 'failure');
    }
  }

  Future<dynamic> submitPaymentResponse(
      {required String paymentId,required String paymentSignature}) async {
    String url = AppUrls.submitBookingResponseUrl;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      'razorpay_payment_id': paymentId,
      'razorpay_signature':paymentSignature,
      'app_token': await _getRegisteredToken() ?? '',
    });

    //final data = response as Map<String, dynamic>;

    /*if (data['status'].toString().toLowerCase() == 'success') {
      return BookingAmountsResponseModel.fromJson(data);
    } else {
      return BookingAmountsResponseModel(
          status: 'failure', message: data['message']);
    }*/
    return response;
  }
}
