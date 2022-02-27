import 'package:RentMyStay_user/home_module/model/invite_and_earn_model.dart';

import '../../utils/constants/api_urls.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../../utils/service/shared_prefrences_util.dart';

class HomeApiService{

  final RMSUserApiService _apiService = RMSUserApiService();

  String? registeredToken;
  String? registeredEmail;
  final SharedPreferenceUtil _shared = SharedPreferenceUtil();
  Future<String?> _getRegisteredToken() async {
    registeredToken = await _shared.getString(rms_registeredUserToken);
    return registeredToken;
  }
  Future<String?> _getRegisteredEmail() async {
    registeredEmail = await _shared.getString(rms_email);
    return registeredEmail;
  }

  Future<InviteModel> fetchInviteEarnDetails() async {
    String url = AppUrls.referUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'email': await _getRegisteredEmail(),
      'apptoken': await _getRegisteredToken(),
    });
    final data = response as Map<String, dynamic>;

    if (data['status'].toString().toLowerCase() == 'sucess'&& data['refferal_money']!= null) {
      return InviteModel.fromJson(data);
    } else {
      return InviteModel(
          status: 'failure', );
    }
  }

}