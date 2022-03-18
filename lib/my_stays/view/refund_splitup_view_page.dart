import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefundSplitPage extends StatefulWidget {
  const RefundSplitPage({Key? key}) : super(key: key);

  @override
  _RefundSplitPageState createState() => _RefundSplitPageState();
}
class _RefundSplitPageState extends State<RefundSplitPage> {
  @override
  var _mainHeight;
  var _mainWidth;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery
        .of(context)
        .size
        .height;
    _mainWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(appBar: AppBar(
      title: Text('Refund SplitUp '),
    ),
        body: Container(
          height: _mainHeight, color: Colors.white, width: _mainWidth,
          child: Column(children: [_splitlist(hint: 'sk'),
            _splitlist(hint: 'sk'),
          Container(
              margin: EdgeInsets.all(10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Your Security Deposit'),
                Text('10000')
                  ]
              ),),
            Container(
              margin: EdgeInsets.all(10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Your Deposit Refund'),
                    Text('1000')
                  ]
              ),),
          ]
          ),
        ));
  }
  Widget _splitlist({required String hint}) {
    return Card(margin: EdgeInsets.all(10),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('OnBoarding Charges'),
        Text('1000')]),
      ),
    );
  }
}