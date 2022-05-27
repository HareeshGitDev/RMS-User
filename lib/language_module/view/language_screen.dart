import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/custom_theme.dart';
import '../../utils/service/navigation_service.dart';
import '../viewModel/language_viewModel.dart';

class LanguageScreen extends StatefulWidget {
  String language;

  LanguageScreen({Key? key, required this.language}) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late LanguageViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;

  SharedPreferenceUtil shared = SharedPreferenceUtil();
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
    _viewModel = Provider.of<LanguageViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: CustomTheme.appTheme,
              centerTitle: false,
              titleSpacing: 0,
              title: Text('Select Language'),
            ),
            body: Container(
              height: _mainHeight,
              width: _mainWidth,
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'English',
                        style: TextStyle(
                            fontSize: 16,
                            color: CustomTheme.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Radio(
                        groupValue: widget.language,
                        value: 'english',
                        activeColor: CustomTheme.appTheme,
                        onChanged: (value) {
                          setState(() => widget.language = value as String);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'हिन्दी',
                        style: TextStyle(
                            fontSize: 16,
                            color: CustomTheme.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Radio(
                        groupValue: widget.language,
                        value: 'hindi',
                        activeColor: CustomTheme.appTheme,
                        onChanged: (value) {
                          setState(() => widget.language = value as String);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ಕನ್ನಡ',
                        style: TextStyle(
                            fontSize: 16,
                            color: CustomTheme.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Radio(
                        groupValue: widget.language,
                        value: 'kannada',
                        activeColor: CustomTheme.appTheme,
                        onChanged: (value) {
                          setState(() => widget.language = value as String);
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    width: _mainWidth,
                    height: 45,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              CustomTheme.appTheme),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          )),
                      onPressed: () async {
                        await shared.setString(rms_language, widget.language);

                        Navigator.of(context)
                            .popAndPushNamed(AppRoutes.dashboardPage);
                      },
                      child: Center(child: Text("Save")),
                    ),
                  ),
                ],
              ),
            ),
          )
        : RMSWidgets.networkErrorPage(context: context);
  }
}
