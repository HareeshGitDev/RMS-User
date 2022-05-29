import 'dart:developer';

import 'package:flutter/cupertino.dart';

class NavigatorKeyService{
  static GlobalKey<NavigatorState> navigatorKey=GlobalKey<NavigatorState>();

 static Future<dynamic>? navigateTo({required String routeName,required String propId}){
    return navigatorKey.currentState?.pushNamed(routeName,arguments: propId);
  }
}