import 'package:RentMyStay_user/property_module/service/property_api_service.dart';
import 'package:flutter/cupertino.dart';

import '../model/property_details_model.dart';

class PropertyViewModel extends ChangeNotifier {
  final PropertyApiService _propertyApiService = PropertyApiService();
  PropertyDetailsModel propertyDetailsModel = PropertyDetailsModel();

  Future<void> getPropertyDetailsList({
    required String address,
  }) async {
    final PropertyDetailsModel data =
        await _propertyApiService.fetchPropertyDetailsList(address: address);
    propertyDetailsModel = data;
    notifyListeners();
  }
}
