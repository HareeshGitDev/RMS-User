import 'package:RentMyStay_user/profile_Module/model/profile_model.dart';
import 'package:flutter/cupertino.dart';

import '../service/profile_api_service.dart';

class ProfileViewModel extends ChangeNotifier{
  final ProfileApiService _profileApiService = ProfileApiService();
  ProfileModel profileModel = ProfileModel();

Future <void> getProfileDetails() async{
  final ProfileModel response = await _profileApiService.fetchProfileDetails();
  profileModel=response;
  notifyListeners();
}
}