import 'package:RentMyStay_user/home_module/home_page.dart';
import 'package:RentMyStay_user/login_module/view/login_page.dart';
import 'package:flutter/material.dart';

class NavigationService{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case AppRoutes.loginPage:
        return MaterialPageRoute(builder: (context) => LoginPage(),);
      case AppRoutes.homePage:
        return MaterialPageRoute(builder: (context) => HomePage(),);

      default:
      return MaterialPageRoute(builder: (context) => const Scaffold(body: Text('Hii'),),);
    }
  }
}
class AppRoutes{
  static const String loginPage='loginPage';
  static const String homePage='homePage';
}