import 'dart:convert';

import 'package:RentMyStay_user/utils/service/locator_service.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/service/navigator_key_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DeepLinkingService {
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData dynamicLinkData) {
      Uri uri = dynamicLinkData.link;
      serializeData(uri: uri);
    });
    PendingDynamicLinkData? linkData =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (linkData != null) {
      Uri uri = linkData.link;
      serializeData(uri: uri);
    }
  }

  void serializeData({required Uri uri}) {
    /// for Getting QueryParams out of DeepLink
    /// Map<String, dynamic> data = uri.queryParameters;


    ///for getting pathParams
    List<String> pathParam = uri.path.split('/');
    String encoded = pathParam[pathParam.length - 1];

    /// for decoding any data,it must be in multiple of 4 like 4,8,12.. etc
    /// if less then we have to add that many '='

    while (encoded.length % 4 != 0) {
      encoded = '$encoded=';
    }
    String propId = utf8.decode(base64.decode(encoded));
    ///logic implementation for which page to navigate
    navigateTo(routeName: AppRoutes.propertyDetailsPage, propId: propId);
  }

  void navigateTo({required String routeName, required String propId}) async {
    lazySingletonInstance<NavigatorKeyService>()
        .navigateTo(routeName: routeName, propId: propId);
  }
}
