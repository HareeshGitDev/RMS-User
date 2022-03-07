import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class Web_View_Container extends StatefulWidget {
  final url;
  final title;
  Web_View_Container(this.url,this.title);
  @override
  createState() => _WebViewContainerState();
}
class _WebViewContainerState extends State<Web_View_Container> {

  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomTheme.skyBlue,
          title: Container(

              padding: EdgeInsets.only(bottom: 10),child: Text(widget.title)),
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                  onWebViewCreated: (WebViewController controller) {

                  },
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: widget.url,

                ))
          ],
        ))
    ;
  }

}