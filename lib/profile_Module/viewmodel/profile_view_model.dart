import 'package:RentMyStay_user/profile_Module/model/profile_model.dart';
import 'package:flutter/cupertino.dart';

import '../../language_module/model/language_model.dart';
import '../../language_module/service/language_api_service.dart';
import '../service/profile_api_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileApiService _profileApiService = ProfileApiService();
  final LanguageApiService _languageApiService = LanguageApiService();
  List<LanguageModel> languageData = [];
  ProfileModel profileModel = ProfileModel();

  Future<void> getProfileDetails({ required BuildContext context,}) async {
    final ProfileModel response =
        await _profileApiService.fetchProfileDetails(context:context );
    profileModel = response;
    notifyListeners();
  }

  Future<void> getLanguagesData(
      {required String language, required String pageName}) async {
    final response = await _languageApiService.fetchLanguagesData(
        language: language, pageName: pageName);
    languageData = response;
    notifyListeners();
  }
}
