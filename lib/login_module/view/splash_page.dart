import 'dart:async';
import 'dart:developer';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;

  Future<void> initConnectionStatus() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      log(e.toString());
    }
    if (!mounted) {
      return null;
    }

    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = false);
        break;
      case ConnectivityResult.ethernet:
        setState(() => _connectionStatus = true);
        break;
      default:
        setState(() => _connectionStatus = false);
        break;
    }
  }

  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initMethod();
  }

  Future<void> initMethod() async {
    SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
    String? token = await preferenceUtil.getToken();
    String lang=await preferenceUtil.getString(rms_language) ?? 'english';

    if (token == null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Timer(const Duration(milliseconds: 1000), ()  {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.languageScreen,
              (route) => false,
                arguments:{
                  'fromDashboard':false,
                  'lang':lang

                }
            );
          }
        });
      });
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Timer(const Duration(milliseconds: 1000), () {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.dashboardPage,
              (route) => false,
            );
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus
        ? Scaffold(
            body: Container(
              decoration: BoxDecoration(color: CustomTheme.appTheme
                  /*gradient: LinearGradient(
              colors: [CustomTheme.appTheme.withAlpha(50), CustomTheme.appTheme],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),*/
                  ),
              child: Center(
                child: Image.asset("assets/images/transparent_logo_rms.png"),
                widthFactor: 100,
                heightFactor: 100,
              ),
            ),
          )
        : RMSWidgets.networkErrorPage(context: context);
  }
}
