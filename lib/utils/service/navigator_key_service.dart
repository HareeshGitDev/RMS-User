import 'dart:developer';

import 'package:flutter/cupertino.dart';

class NavigatorKeyService {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(
      {required String routeName, required String propId}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: propId);
  }
}
