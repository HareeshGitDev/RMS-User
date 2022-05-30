import 'dart:developer';

import 'package:RentMyStay_user/utils/service/locator_service.dart';
import 'package:RentMyStay_user/utils/service/navigator_key_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DeepLinkingService {
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData dynamicLinkData) {
      Uri uri = dynamicLinkData.link;
      Map<String, dynamic> data = uri.queryParameters;
      log('DATA ${data['module']} ---- ${data['property']}');
      if (data['module'] == 'property') {
        navigateTo(routeName: data['module'], propId: data['property']);
      }
    });
    PendingDynamicLinkData? linkData =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (linkData != null) {
      Uri uri = linkData.link;
      Map<String, dynamic> data = uri.queryParameters;
      log('DATA ${data['module']} ---- ${data['property']}');
      if (data['module'] == 'property') {
        navigateTo(routeName: data['module'], propId: data['property']);
      }
    }
  }

  Future<dynamic>? navigateTo(
      {required String routeName, required String propId}) {
    return lazySingletonInstance<NavigatorKeyService>()
        .navigateTo(routeName: routeName, propId: propId);
  }
}
