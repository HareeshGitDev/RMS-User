import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
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

  Future<Map<String, String>> get getHeaders async {

    return {
        'authorization':
        (registeredToken ?? await _getRegisteredToken()).toString()
      };
  }

  Future downloadFile({required String url, required String fileName}) async {
    Directory appStorage = await getApplicationDocumentsDirectory();
    final file = '${appStorage.path}/$fileName';

    final Dio dio = Dio();
    final response = await dio.download(url, file,
        onReceiveProgress: (receivedBytes, totalBytes) {
      String progress =
          ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
      print(progress);
    });
  }

  Future<dynamic> uploadFile(
      {required String url, required Map<String, dynamic> fileData}) async {
    final Dio dio = Dio();
    FormData formData = FormData.fromMap(fileData);
    try {
      final response = await dio.post(Uri.https(_baseURL, url).toString(),
          options: Options(headers: await getHeaders), data: formData);
      if (response.statusCode == 200 && response.data.toString().isNotEmpty) {
        return response.data;
      } else {
        return {'msg': 'failure'};
      }
    } on SocketException {
      log('SocketException Happened');
      return {'msg': 'failure'};
    } catch (e) {
      log('Error : ${e.toString()}');

      return {'msg': 'failure'};
    }
  }

  Future<dynamic> getApiCall({
    required String endPoint,
  }) async {
    log('URL :: $_baseURL/$endPoint  -- ${await getHeaders}');
    try {
      final response = await http.get(Uri.https(_baseURL, endPoint),
          headers: await getHeaders);

      return await _response(response,
          url: Uri.https(_baseURL, endPoint).toString());
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return null;
  }

  Future<dynamic> getApiCallWithQueryParams({
    required String endPoint,
    required Map<String, dynamic> queryParams,
    bool fromLogin=false
  }) async {
    log('URL :: $_baseURL$endPoint ---- QueryParams :: ${queryParams.toString()} -- ${fromLogin?{}:await getHeaders} ');
    try {
      final response = await http.get(
          Uri.https(_baseURL, endPoint, queryParams),
          headers: fromLogin?{}:await getHeaders);

      return await _response(response,
          url: Uri.https(_baseURL, endPoint).toString());
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'msg': 'failure'};
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

      return await _response(response,
          url: Uri.https(_baseURL, endPoint).toString());
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'msg': 'failure'};
  }

  Future<dynamic> postApiCall(
      {required String endPoint,
      required Map<String, dynamic> bodyParams,bool fromLogin=false}) async {
    log('URL :: $_baseURL/$endPoint ---- Model :: ${bodyParams.toString()} -- ${fromLogin?'':await getHeaders}');

    try {
      final response = await http.post(
        Uri.https(_baseURL, endPoint),
        body: bodyParams,
        headers: fromLogin?{}:await getHeaders,
      );
      return await _response(response,
          url: Uri.https(_baseURL, endPoint).toString());
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'msg': 'failure'};
  }

  Future<dynamic> postApiCallFormData(
      {required String endPoint, required FormData formData}) async {
    log('URL :: $_baseURL/$endPoint ---- Model :: ${formData.toString()} -- ${await getHeaders}');

    try {
      Dio dio = Dio();
      final response = await dio.post(Uri.https(_baseURL, endPoint).toString(),
          options: Options(headers: await getHeaders), data: formData);
      return response.statusCode == 200
          ? {'msg': 'success'}
          : {'msg': 'failure'};
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'msg': 'failure'};
  }

  Future<dynamic> putApiCall({
    required String endPoint,
    required Map<String, dynamic> bodyParams,
  }) async {
    log('URL :: $_baseURL/$endPoint ---- Model :: ${bodyParams.toString()} -- ${await getHeaders}');
    try {
      final response = await http.put(
        Uri.https(_baseURL, endPoint),
        headers: await getHeaders,
        body: bodyParams,
      );

      return await _response(response,
          url: Uri.https(_baseURL, endPoint).toString());
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'msg': 'failure'};
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
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'msg': 'failure'};
  }

  dynamic _response(http.Response response,
      {String? url, BuildContext? context}) async {
    log('Status Code :: ${response.statusCode} -- $url');
    switch (response.statusCode) {
      case 200:
        log('Response Data :: ' + response.body);
        return response.body.isNotEmpty
            ? json.decode(response.body)
            : {'msg': 'failure'};
      case 400:
        return _getErrorResponse(json.decode(response.body));
      case 401:
        return _getErrorResponse(json.decode(response.body));
      case 402:
        return _getErrorResponse(json.decode(response.body));
      case 403:
        return _getErrorResponse(json.decode(response.body));
      case 404:
        return _getErrorResponse(json.decode(response.body));
      case 405:
        return _getErrorResponse(json.decode(response.body));
      case 415:
        return _getErrorResponse(json.decode(response.body));
      case 500:
        return _getErrorResponse(json.decode(response.body));
      case 501:
        return _getErrorResponse(json.decode(response.body));
      case 502:
        return _getErrorResponse(json.decode(response.body));
      default:
        return _getErrorResponse(json.decode(response.body));
    }
  }

  Map<String, dynamic> _getErrorResponse(decode) {
    final error = decode as Map<String, dynamic>;
    log(error.toString());
    RMSWidgets.getToast(
        message: error['msg'] ?? 'failure', color: Color(0xffFF0000));

    return {'msg': 'failure '+ error['msg']};
  }
}
