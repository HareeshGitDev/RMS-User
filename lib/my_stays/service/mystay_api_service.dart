import 'dart:convert';

import '../../utils/constants/api_urls.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../model/mystay_details_model.dart';
import '../model/mystay_list_model.dart';

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
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'booking_id': base64Encode(utf8.encode(bookingId)),
    },);
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() == 'success') {
      return MyStayDetailsModel.fromJson(data);
    } else {
      return MyStayDetailsModel(
        msg: 'failure',
      );
    }
  }
}
