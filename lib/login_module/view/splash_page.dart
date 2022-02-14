import 'dart:async';
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
    Timer(const Duration(milliseconds: 4000), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (_) => LoginViewModel(), child: LoginPage()),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [onecolor, secondcolor],
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
