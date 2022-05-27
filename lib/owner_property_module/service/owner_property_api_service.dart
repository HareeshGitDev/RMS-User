import 'dart:convert';
import 'dart:developer';

import 'package:RentMyStay_user/owner_property_module/model/owner_property_details_model.dart';
import 'package:RentMyStay_user/owner_property_module/model/owner_property_listing_model.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../../utils/constants/api_urls.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../model/owner_property_details_request_model.dart';

class OwnerPropertyApiService {
  final RMSUserApiService _apiService = RMSUserApiService();

  Future<OwnerPropertyListingModel> fetchOwnerPropertyList() async {
    String url = AppUrls.ownerPropertyListingUrl;

    final response = await _apiService.getApiCall(endPoint: url);
    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure')
        ? OwnerPropertyListingModel(msg: 'failure')
        : OwnerPropertyListingModel.fromJson(data);
  }

  Future<OwnerPropertyDetailsModel> fetchOwnerPropertyDetails(
      {required String propId}) async {
    String url = AppUrls.ownerPropertyUrl;

    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {'id': propId});
    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure')
        ? OwnerPropertyDetailsModel(msg: 'failure')
        : OwnerPropertyDetailsModel.fromJson(data);
  }

  Future<String> createProperty({
    required String title,
    required String email,
    required String rent,
    required String propertyType,
    required String roomType,
  }) async {
    String url = AppUrls.ownerPropertyUrl;

    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      'title': title,
      'email': email,
      'rent': rent,
      'property_type': propertyType,
      'room_type': roomType
    });
    final data = response as Map<String, dynamic>;
    return data['msg'].toString().toLowerCase().contains('failure')
        ? 'failure'
        : data['data']['prop_id'].toString();
  }

  Future<int> updatePropertyDetails({
    required OwnerPropertyDetailsRequestModel requestModel,
  }) async {
    String url = AppUrls.ownerPropertyUrl;
    Map<String, dynamic> propJson = {};
    if (requestModel.title != null) {
      propJson['title'] = requestModel.title;
    }
    if (requestModel.propTypeId != null) {
      propJson['prop_type_id'] = requestModel.propTypeId;
    }
    if (requestModel.addressDisplay != null) {
      propJson['address_display'] = requestModel.addressDisplay;
    }
    if (requestModel.city != null) {
      propJson['city'] = requestModel.city;
    }
    if (requestModel.state != null) {
      propJson['state'] = requestModel.state;
    }
    if (requestModel.zipCode != null) {
      propJson['zip_code'] = requestModel.zipCode;
    }
    if (requestModel.country != null) {
      propJson['country'] = requestModel.country;
    }
    if (requestModel.glat != null) {
      propJson['glat'] = requestModel.glat;
    }
    if (requestModel.glng != null) {
      propJson['glng'] = requestModel.glng;
    }
    if (requestModel.description != null) {
      propJson['description'] = requestModel.description;
    }
    if (requestModel.things2note != null) {
      propJson['things2note'] = requestModel.things2note;
    }
    if (requestModel.area != null) {
      propJson['area'] = requestModel.area;
    }
    if (requestModel.bedrooms != null) {
      propJson['bedrooms'] = requestModel.bedrooms;
    }
    if (requestModel.bathrooms != null) {
      propJson['bathrooms'] = requestModel.bathrooms;
    }
    if (requestModel.maxGuests != null) {
      propJson['max_guests'] = requestModel.maxGuests;
    }
    if (requestModel.propertyName != null) {
      propJson['property_name'] = requestModel.propertyName;
    }
    if (requestModel.propId != null) {
      propJson['prop_id'] = requestModel.propId.toString().trim();
    }
    if (requestModel.orgRent != null) {
      propJson['org_rent'] = requestModel.orgRent;
    }
    if (requestModel.rent != null) {
      propJson['rent'] = requestModel.rent;
    }
    if (requestModel.weeklyRent != null) {
      propJson['weekly_rent'] = requestModel.weeklyRent;
    }
    if (requestModel.monthlyRent != null) {
      propJson['monthly_rent'] = requestModel.monthlyRent;
    }
    if (requestModel.orgMonthRent != null) {
      propJson['org_month_rent'] = requestModel.orgMonthRent;
    }
    if (requestModel.rmsRent != null) {
      propJson['rms_rent'] = requestModel.rmsRent;
    }
    if (requestModel.rmsDeposit != null) {
      propJson['rms_deposit'] = requestModel.rmsDeposit;
    }
    if (requestModel.amenity != null) {
      propJson['amenity'] =requestModel.amenity;
    }
    final response = await _apiService.putApiCall(
        endPoint: url, bodyParams: propJson);
    final data = response as Map<String, dynamic>;
    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }

  Future<int> uploadPropPics(
      {required String propId, required List<File> imageList}) async {
    String url = AppUrls.uploadPropertyPhotosUrl;
    List<MultipartFile> list = [];
    for (var data in imageList) {
      final image=await MultipartFile.fromFile(data.path);
      log(image.filename.toString());
      list.add(image);
    }

    FormData formData = FormData.fromMap({
      'prop_id': propId,
      'images': list,
    },ListFormat.multiCompatible);

    final response = await _apiService.postApiCallFormData(
        endPoint: url, formData: formData);

    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }
  Future<int> deletePropPics(
      {required String picId}) async {
    String url = AppUrls.uploadPropertyPhotosUrl;
    
    final response = await _apiService.deleteApiCall(endPoint: url,bodyParams: {'pic_id':picId});

    final data = response as Map<String, dynamic>;

    return data['msg'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }
}
