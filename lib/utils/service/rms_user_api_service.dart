import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../constants/api_urls.dart';

class RMSUserApiService {
  final String _baseURL=AppUrls.baseUrl;

  /*Future<Map<String, String>> getHeaders() async {
    String? userToken = await SharedPreferenceUtil().getToken();
    return <String, String>{
      'Authorization': userToken.toString(),
      "Content-Type": "application/json",
      'x-app-os': HeaderDetails.SDK_INFO,
      'x-app-version': HeaderDetails.APP_INFO,
      'x-app-device': HeaderDetails.ANDROID_INFO,
    };
  }
*/
  Future<dynamic> getApiCall({required String endPoint}) async {
    try {
      final response = await http.get(
        Uri.https(_baseURL, endPoint),
      );

      return await _response(response);
    } on SocketException {
      log('SocketException Happened');
      //throw FetchDataException('No Internet connection');
    } catch (e) {
      /*  CustomWidgets.getToast(
        message: 'Error : ${e.toString()}',
        color: Color(0xffF40909),
      );*/
      log('Error : ${e.toString()}');
    }
    return null;
  }
  Future<dynamic> getApiCallWithQueryParams({required String endPoint,required Map<String,dynamic> queryParams}) async {
   log('URL :: $_baseURL/$endPoint ---- QueryParams :: ${queryParams.toString()}');
    try {
      final response = await http.get(
        Uri.https(_baseURL, endPoint,queryParams),

      );

      return await _response(response);
    } on SocketException {
      log('SocketException Happened');
      //throw FetchDataException('No Internet connection');
    } catch (e) {
      /*  CustomWidgets.getToast(
        message: 'Error : ${e.toString()}',
        color: Color(0xffF40909),
      );*/
      log('Error : ${e.toString()}');
    }
    return null;
  }

  Future<dynamic> postApiCall(
      {required String endPoint,
      required Map<String, dynamic> bodyParams}) async {
    log('URL :: $_baseURL/$endPoint ---- Model :: ${bodyParams.toString()}');


    try {
      final response = await http.post(
        Uri.https(_baseURL, endPoint),
        body: bodyParams,
      );
      return await _response(response);
    } on SocketException {
      log('SocketException Happened');
      // throw FetchDataException('No Internet connection');

    } catch (e) {
      log('Error : ${e.toString()}');
      /*CustomWidgets.getToast(
        message: 'Error : ${e.toString()}',
        color: Color(0xffF40909),
      );*/
    }
    return null;
  }

  Future<dynamic> putApiCall({
    required String endPoint,
    required Map<String, dynamic> bodyParams,
  }) async {
    try {
      final response = await http.put(
        Uri.https(_baseURL, endPoint),
        //headers: await getHeaders(),
        body: jsonEncode(bodyParams),
      );

      return await _response(response);
    } on SocketException {
      log('SocketException Happened');
      // throw FetchDataException('No Internet connection');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return null;
  }

  dynamic deleteApiCall({required String endPoint}) async {
    try {
      final response = await http.delete(
        Uri.https(_baseURL, endPoint),
        // headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          log('Logout Res ::  ' + response.body);
          return true;
        }
      }
    } on SocketException {
      log('SocketException Happened');
      //  throw FetchDataException('No Internet connection');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return null;
  }

  dynamic _response(http.Response response, {BuildContext? context}) async {
    switch (response.statusCode) {
      case 200:
        if (response.body != null) {
          log('Response Data :::: ${jsonDecode(response.body)}');
          return json.decode(response.body);
        } else {
          return null;
        }

      case 400:
        Map<String, dynamic> res = jsonDecode(response.body);
        if (res['message'] != null) {
          /* CustomWidgets.getToast(
              message: res['message'], color: AppResources.errorColor);*/
        }
        return null;

      case 401:
        Map<String, dynamic> res = jsonDecode(response.body);

        if (res['message'] != null) {
          /*CustomWidgets.getToast(
              message: res['message'], color: AppResources.errorColor);*/
        }

        return null;

      case 404:
        Map<String, dynamic> res = jsonDecode(response.body);
        if (res['message'] != null) {
          /* CustomWidgets.getToast(
              message: res['message'], color: AppResources.errorColor);*/
        }
        return null;
      case 405:
        Map<String, dynamic> res = jsonDecode(response.body);
        if (res['message'] != null) {
          /* CustomWidgets.getToast(
              message: res['message'], color: AppResources.errorColor);*/
        }
        return null;
      case 415:
        Map<String, dynamic> res = jsonDecode(response.body);
        if (res['message'] != null) {
          /*CustomWidgets.getToast(
              message: res['message'], color: AppResources.errorColor)*/
          ;
        }
        return null;

      case 500:
        Map<String, dynamic> res = jsonDecode(response.body);
        if (res['message'] != null) {
          /* CustomWidgets.getToast(
              message: res['message'], color: AppResources.errorColor);*/
        }
        return null;
      case 501:
        Map<String, dynamic> res = jsonDecode(response.body);
        if (res['message'] != null) {
          /*CustomWidgets.getToast(
              message: res['message'], color: AppResources.errorColor);*/
        }
        return null;
      case 502:
        Map<String, dynamic> res = jsonDecode(response.body);
        if (res['message'] != null) {
          /* CustomWidgets.getToast(
              message: res['message'], color: AppResources.errorColor);*/
        }
        return null;
      default:
        Map<String, dynamic> res = jsonDecode(response.body);
        if (res['message'] != null) {
          /* CustomWidgets.getToast(
              message: res['message'], color: AppResources.errorColor);*/
        }
    }
  }
}
