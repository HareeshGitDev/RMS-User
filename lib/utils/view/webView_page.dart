import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/theme/custom_theme.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
//import 'package:webview_flutter/platform_interface.dart';
import 'package:flutter_webview_pro/webview_flutter.dart' as webViewIOS;
//import 'package:webview_flutter/webview_flutter.dart' as webViewIOS;

class Web_View_Container extends StatefulWidget {
  final url;
  final title;

  Web_View_Container(this.url, this.title);

  @override
  createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<Web_View_Container> {
  ValueNotifier<bool> showLoader = ValueNotifier(true);
  ValueNotifier<int> progressIndicator = ValueNotifier(0);

 // late webViewAndroid.WebViewController _webViewAndroidController;
  late webViewIOS.WebViewController _webViewIosController;

  var _mainHeight;
  var _mainWidth;

  final _key = UniqueKey();
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
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
log("${widget.url}");
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus?Scaffold(
        appBar: AppBar(
          backgroundColor: CustomTheme.appTheme,
          title: Text(widget.title),
          titleSpacing: 0,
          centerTitle: false,
        ),
        body: Container(
          height: _mainHeight,
          width: _mainWidth,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    /*Platform.isIOS? */webViewIOS.WebView(
                      onProgress: (progress) {
                        progressIndicator.value = progress;
                      },
                      onPageStarted: (start) {
                        showLoader.value = true;
                      },
                      onPageFinished: (end) {
                        showLoader.value = false;
                      },
                      onWebViewCreated: (webViewIOS.WebViewController controller) {
                        _webViewIosController =controller;
                      },
                      backgroundColor: Colors.white,
                      key: _key,
                      javascriptMode: webViewIOS.JavascriptMode.unrestricted,
                      initialUrl: widget.url,
                      allowsInlineMediaPlayback: false,
                      gestureNavigationEnabled: true,

                    ),/*:webViewAndroid.WebView(
                      onProgress: (progress) {
                        progressIndicator.value = progress;
                      },
                      onPageStarted: (start) {
                        showLoader.value = true;
                      },
                      onPageFinished: (end) {
                        showLoader.value = false;
                      },
                      onWebViewCreated: (webViewAndroid.WebViewController controller) {
                        _webViewAndroidController = controller;
                      },
                      backgroundColor: Colors.white,
                      key: _key,
                      javascriptMode: webViewAndroid.JavascriptMode.unrestricted,
                      initialUrl: widget.url,
                      allowsInlineMediaPlayback: false,
                      gestureNavigationEnabled: true,

                    ),*/
                   Positioned(
                      top: _mainHeight * 0.4,
                      left: _mainWidth * 0.4,
                      child: ValueListenableBuilder(
                        valueListenable: showLoader,
                        builder: (context, bool value, child) {
                          return value
                              ? Neumorphic(
                                  child: Container(
                                    color: CustomTheme.appTheme,
                                    height: 60,
                                    width: 120,
                                    child: Row(
                                      children: [
                                        Container(
                                          child: RMSWidgets.getLoader(
                                              color: Colors.white),
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
                                        ),
                                        ValueListenableBuilder(
                                            valueListenable: progressIndicator,
                                            builder: (context, value, child) {
                                              return Text(
                                                progressIndicator.value
                                                        .toString() +
                                                    ' %',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: CustomTheme.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                )
                              : Container();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )):RMSWidgets.networkErrorPage(context: context);
  }
}
