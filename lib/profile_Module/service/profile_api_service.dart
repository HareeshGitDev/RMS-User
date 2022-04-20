import 'package:RentMyStay_user/profile_Module/model/profile_model.dart';

import '../../utils/constants/api_urls.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../../utils/service/shared_prefrences_util.dart';

class ProfileApiService {
  final RMSUserApiService _apiService = RMSUserApiService();

  Future<ProfileModel> fetchProfileDetails() async {
    String url = AppUrls.profileUrl;
    final response = await _apiService.getApiCall(
      endPoint: url,
    );
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase().contains('failure')) {
      return ProfileModel(
        msg: 'failure',
      );
    } else {
      return ProfileModel.fromJson(data);
    }
  }
}
