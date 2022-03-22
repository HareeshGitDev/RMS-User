import 'dart:developer';

import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  var _mainHeight;
  var _mainWidth;

  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    _mainHeight=MediaQuery.of(context).size.height;
    _mainWidth= MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomTheme.appTheme,
          title: Text(widget.title),
          titleSpacing: 0,
        ),
        body: Container(
          height: _mainHeight,
          width: _mainWidth,

          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    WebView(
                      onProgress: (progress) {
                        //log('XXX $progress');
                        progressIndicator.value = progress;
                      },
                      onPageStarted: (start) {
                        showLoader.value = true;
                      },
                      onPageFinished: (end) {
                        showLoader.value = false;
                      },

                      onWebViewCreated: (WebViewController controller) {},
                      backgroundColor: Colors.white,
                      key: _key,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: widget.url,
                    ),
                    Positioned(
                      top: _mainHeight * 0.4,
                      left:_mainWidth * 0.4,
                      child: ValueListenableBuilder(
                        valueListenable: showLoader,
                        builder: (context, bool value, child) {
                          return value
                              ? Neumorphic(
                                  child: Container(
                                    color: CustomTheme.appTheme,
                                    height: 60,
                                    width: 100,
                                    child: Row(
                                      children: [
                                        Container(
                                          child: RMSWidgets.getLoader(
                                              color: Colors.white),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
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
        ));
  }
}
