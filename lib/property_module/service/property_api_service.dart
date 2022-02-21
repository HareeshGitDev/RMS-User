import 'package:RentMyStay_user/property_module/model/property_details_model.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';

import '../../utils/constants/api_urls.dart';
import '../../utils/service/rms_user_api_service.dart';

class PropertyApiService {
  final RMSUserApiService _apiService = RMSUserApiService();
  String? registeredToken;


  Future<String?> _getRegisteredToken()async{
    SharedPreferenceUtil _shared=SharedPreferenceUtil();
 registeredToken=await     _shared.getString(rms_registeredUserToken);
 return registeredToken;

  }

  Future<PropertyDetailsModel> fetchPropertyDetailsList(
      {required String address,}) async {
    String url = AppUrls.propertyListingUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'addr': address,
      'app_token':registeredToken ?? await _getRegisteredToken() ,

      //'roomType': '1 BHK',
      //'lat': 'lat',
      //'long': 'lang'
    });
    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'success') {
      return PropertyDetailsModel.fromJson(data);
    } else {
      return PropertyDetailsModel(status: 'failure');
    }
  }
}
