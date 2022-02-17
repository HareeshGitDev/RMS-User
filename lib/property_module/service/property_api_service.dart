import 'package:RentMyStay_user/property_module/model/property_details_model.dart';

import '../../utils/constants/api_urls.dart';
import '../../utils/service/rms_user_api_service.dart';

class PropertyApiService {
  final RMSUserApiService _apiService = RMSUserApiService();

  Future<PropertyDetailsModel> fetchPropertyDetailsList(
      {required String email, required String password}) async {
    String url = AppUrls.propertyListingUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'addr': 'd',
      'app_token': 'token',

      'roomType': 'BHK',
      'lat': 'lat',
      'long': 'lang'
    });
    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'success') {
      return PropertyDetailsModel.fromJson(data);
    } else {
      return PropertyDetailsModel(status: 'failure');
    }
  }
}
