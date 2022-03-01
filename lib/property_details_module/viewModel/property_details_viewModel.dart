import 'package:RentMyStay_user/property_details_module/model/property_details_model.dart';
import 'package:RentMyStay_user/property_details_module/service/property_details_api_service.dart';
import 'package:flutter/cupertino.dart';

class PropertyDetailsViewModel extends ChangeNotifier {
  final PropertyDetailsApiService _detailsApiService =
      PropertyDetailsApiService();
  PropertyDetailsModel? propertyDetailsModel;

  Future<void> getPropertyDetails({required String propId}) async {
    final response =
        await _detailsApiService.fetchPropertyDetails(propId: propId);
    propertyDetailsModel = response;
    notifyListeners();
  }
}
