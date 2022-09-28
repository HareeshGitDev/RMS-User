import 'dart:convert';
import 'dart:developer';

import 'package:RentMyStay_user/property_details_module/model/booking_amount_request_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_amounts_response_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_credential_response_model.dart';
import 'package:RentMyStay_user/property_module/model/property_list_model.dart';
import 'package:RentMyStay_user/property_module/model/wish_list_model.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/constants/api_urls.dart';
import '../../utils/constants/enum_consts.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../model/property_details_model.dart';

class PropertyDetailsApiService {
  final RMSUserApiService _apiService = RMSUserApiService();

  Future<PropertyDetailsModel> fetchPropertyDetails(
      {required String propId, required BuildContext context,}) async {
    String url = AppUrls.propertyDetailsUrl;

    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url,context: context, queryParams: {
      'id': propId,
    });
    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure')
        ? PropertyDetailsModel(
      msg: 'failure',
    )
        : PropertyDetailsModel.fromJson(data);
  }

  Future<int> addToWishList({required String propertyId, required BuildContext context,}) async {
    String url = AppUrls.addWishListPropertyUrl;
    final response = await _apiService.postApiCall(endPoint: url,context: context, bodyParams: {
      'prop_id': base64Encode(utf8.encode(propertyId)),
    });

    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }

  Future<int> scheduleSiteVisit(
      {required String email,
      required String propId,
        required BuildContext context,
      required String name,
      required String phoneNumber,
      required String date,
      required String visitType}) async {
    String url = AppUrls.scheduleSiteVisitUrl;
    final response = await _apiService.postApiCall(endPoint: url,context: context, bodyParams: {
      'email': email,
      'propid': propId,
      'name': name,
      'phone': phoneNumber,
      'date': date,
      'visit_type': visitType,
    });
    final data = response as Map<String, dynamic>;
    return data['msg'].toString().toLowerCase().contains('failure')
        ? 404
        : 200;
  }

  Future<BookingAmountsResponseModel> fetchBookingAmounts(
      {required BookingAmountRequestModel model, required BuildContext context,}) async {
    String url = AppUrls.bookingDetailsUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, context:context,queryParams: {
      'id': model.propId.toString(),
      'travel_from_date': model.fromDate,
      'travel_to_date': model.toDate,
      'num_guests': model.numOfGuests,
      'coupon_code': model.couponCode,
      'booking_type':model.bookingType,
    });
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return BookingAmountsResponseModel(
          msg: data['msg']  ?? 'failure');
    } else {
      return BookingAmountsResponseModel.fromJson(data);
    }
  }

  Future<BookingCredentialResponseModel> fetchBookingCredentials(
      {required BookingAmountRequestModel model, required BuildContext context,}) async {
    String url = AppUrls.bookingCredentialsUrl;
    final response = await _apiService.postApiCall(endPoint: url, context:context,bodyParams: {
      'id': model.propId,
      'travel_from_date': model.fromDate,
      'travel_to_date': model.toDate,
      'num_guests': model.numOfGuests,
      "billing_name": model.name,
      "billing_email": model.email,
      "amount":model.depositAmount,
      "billing_tel": model.phone,
      "cart_id":model.cartId,
      "payment_gateway": model.paymentGateway,
    });
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return BookingCredentialResponseModel(msg: 'failure');
    } else {
      return BookingCredentialResponseModel.fromJson(data);
    }
  }

}
