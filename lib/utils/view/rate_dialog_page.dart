import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateDialogPage extends StatefulWidget {
  final RateMyApp rateMyApp;
  const RateDialogPage({Key? key,required this.rateMyApp}) : super(key: key);

  @override
  State<RateDialogPage> createState() => _RateDialogPageState();
}

class _RateDialogPageState extends State<RateDialogPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
padding: EdgeInsets.all(48),
      child: Center(
        child: TextButton(
          onPressed: (){
            widget.rateMyApp.showStarRateDialog(context);
          },
          child: Text("Rate App"),
        ),
      ),
    );
  }
}
