import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';

class ReferAndEarn extends StatefulWidget {
  ReferAndEarn({Key? key}) : super(key: key);
  @override
  State<ReferAndEarn> createState() => _ReferAndEarnPageState();


}
class _ReferAndEarnPageState extends State<ReferAndEarn> {
  var _mainHeight;
  var _mainWidth;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _getAppBar(context: context) ,
      body: Container(
          color: Colors.white,
          height: _mainHeight,
          width: _mainWidth,
          child: Column(
            children: [

            ],
          )
      ),
    );
  }
  AppBar _getAppBar({required BuildContext context}) {
    return AppBar(
      leading: BackButton(
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      titleSpacing: 0,
      backgroundColor: CustomTheme.skyBlue,
      title: Text('Refer And Earn'),
    );
  }
}