import 'dart:async';
import 'package:RentMyStay_user/home_module/view/home_page.dart';
import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:provider/provider.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    initMethod();
    super.initState();
  }

  Future<void> initMethod() async {
    SharedPreferenceUtil preferenceUtil=SharedPreferenceUtil();
    String? token=await preferenceUtil.getToken();
    if(token == null){
      Timer(const Duration(milliseconds: 2000), () {
        Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.loginPage,(route) => false,);
      });
    }else{
      Timer(const Duration(milliseconds: 2000), () {
        Navigator.pushNamedAndRemoveUntil(
            context,AppRoutes.homePage,(route) => false,);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomTheme.skyBlue.withAlpha(50), CustomTheme.skyBlue],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
        ),
        child: Center(
          child: Image.asset("assets/images/transparent_logo_rms.png"),
          widthFactor: 100,
          heightFactor: 100,
        ),
      ),
    );
  }
}
