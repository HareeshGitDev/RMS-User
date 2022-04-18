import 'dart:developer';

import 'package:RentMyStay_user/home_module/model/invite_and_earn_model.dart';
import 'package:RentMyStay_user/utils/firestore_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/constants/api_urls.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/rms_user_api_service.dart';
import '../../utils/service/shared_prefrences_util.dart';

class HomeApiService {
  final RMSUserApiService _apiService = RMSUserApiService();
  final FirebaseFirestore cloudFirestore = FirebaseFirestore.instance;
  late CollectionReference collectionReference;

  String? registeredEmail;
  final SharedPreferenceUtil _shared = SharedPreferenceUtil();

  Future<String?> _getRegisteredEmail() async {
    registeredEmail = await _shared.getString(rms_email);
    return registeredEmail;
  }

  Future<ReferAndEarnModel> fetchInviteEarnDetails() async {
    String url = AppUrls.referUrl;
    final response = await _apiService
        .getApiCallWithQueryParams(endPoint: url, queryParams: {
      'email': await _getRegisteredEmail(),
    });
    final data = response as Map<String, dynamic>;

    if (data['msg'].toString().toLowerCase() == 'success') {
      return ReferAndEarnModel.fromJson(data);
    } else {
      return ReferAndEarnModel(
        msg: 'failure',
      );
    }
  }

  Future<List<FirestoreModel>> fetchLanguagesData(
      {required String language, required String pageName}) async {
    collectionReference =
        cloudFirestore.collection('RMSUser').doc(pageName).collection(language);

    try {
      var data = await collectionReference.get();
      List<FirestoreModel> list= data.docs
          .map((snapshot) =>
              FirestoreModel.fromJson(snapshot.data() as Map<String, dynamic>))
          .toList();
      for (var element in list) {
        log(element.name.toString());
      }
      return list;

    } catch (e) {
      log(e.toString());
    }
    return [];
  }
}
