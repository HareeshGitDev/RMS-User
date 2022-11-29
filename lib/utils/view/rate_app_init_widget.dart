import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppInitWidget extends StatefulWidget {
  final Widget Function(RateMyApp) builder;
  const RateAppInitWidget({Key? key,
  required this.builder
  }) : super(key: key);

  @override
  State<RateAppInitWidget> createState() => _RateAppInitWidgetState();
}

class _RateAppInitWidgetState extends State<RateAppInitWidget> {

  RateMyApp? rateMyApp;
  static const playStoreId="com.tcp.rentmystay";
  static const appStoreId="com.rms.rentmystayuserflutter";
  @override
  Widget build(BuildContext context) => RateMyAppBuilder(
    rateMyApp: RateMyApp(
      googlePlayIdentifier: playStoreId,
      appStoreIdentifier: appStoreId,
    ), onInitialized: (context,  rateMyApp) {
      setState(()=>this.rateMyApp=rateMyApp);
  }, builder: (BuildContext context)=> rateMyApp==null
      ?Center(child: CircularProgressIndicator(),)
      :widget.builder(rateMyApp!),
    );
}
