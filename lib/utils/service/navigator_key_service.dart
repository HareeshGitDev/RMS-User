import 'dart:developer';

import 'package:flutter/cupertino.dart';

class NavigatorKeyService {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void navigateTo(
      {required String routeName,required Map<String,dynamic> data}) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: data);
  }
}
