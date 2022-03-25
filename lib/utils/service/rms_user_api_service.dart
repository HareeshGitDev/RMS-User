import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../constants/api_urls.dart';
import '../constants/sp_constants.dart';

class RMSUserApiService {
  final String _baseURL = AppUrls.baseUrl;

  String? registeredToken;
  final SharedPreferenceUtil _shared = SharedPreferenceUtil();

  Future<String?> _getRegisteredToken() async {
    registeredToken = await _shared.getString(rms_registeredUserToken);
    return registeredToken;
  }

  Future<Map<String, String>> get getHeaders async => {
        'authorization':
            (registeredToken ?? await _getRegisteredToken()).toString()
      };

  Future downloadFile({required String url, required String fileName}) async {
    Directory appStorage = await getApplicationDocumentsDirectory();
    final file = '${appStorage.path}/$fileName';

    final Dio dio=Dio();
    final  response=await dio.download(url,file,onReceiveProgress:(receivedBytes, totalBytes){
      String progress = ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
      print(progress);
    } );


  }

  Future<dynamic> getApiCall({
    required String endPoint,
  }) async {
    try {
      final response = await http.get(Uri.https(_baseURL, endPoint),
          headers: await getHeaders);

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

  Future<dynamic> getApiCallWithQueryParams({
    required String endPoint,
    required Map<String, dynamic> queryParams,
  }) async {
    log('URL :: $_baseURL$endPoint ---- QueryParams :: ${queryParams.toString()} ');
    try {
      final response = await http.get(
          Uri.https(_baseURL, endPoint, queryParams),
          headers: await getHeaders);

      return await _response(response);
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return null;
  }

  Future<dynamic> getApiCallWithURL({
    required String endPoint,
  }) async {
    log('URL :: $endPoint ');
    try {
      final response = await http.get(
          Uri.parse(
            endPoint,
          ),
          headers: await getHeaders);

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
        headers: await getHeaders,
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
        headers: await getHeaders,
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
        headers: await getHeaders,
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
