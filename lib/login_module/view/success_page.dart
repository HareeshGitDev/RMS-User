import 'dart:async';

import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../images.dart';

class PaymentStatusPage extends StatefulWidget {
  final String amount;
  final String title;
  String? paymentId;
  final String buildingName;
  final String status;

  PaymentStatusPage(
      {Key? key,
      required this.title,
      required this.buildingName,
      required this.amount,
      required this.status,
      this.paymentId})
      : super(key: key);

  @override
  State<PaymentStatusPage> createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends State<PaymentStatusPage> {
  var _mainHeight;
  var _mainWidth;

  @override
  void initState() {
    super.initState();
    _goToHome();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: widget.status == 'success' ? getSuccessStatus() : getFailedStatus(),
    );
  }

  void _goToHome() => Timer(const Duration(seconds: 4),
      () => Navigator.of(context).pushNamed(AppRoutes.homePage));

  Widget getFailedStatus() {
    return Container(
      color: Colors.white,
      height: _mainHeight,
      width: _mainWidth,
      child: Column(
        children: [
          SizedBox(
            height: _mainHeight * 0.1,
          ),
          Container(
            color: Colors.amber,
            child: Image.network(
              'https://www.kindpng.com/picc/m/4-47511_red-cross-red-circle-and-cross-clipart-free.png',
              height: _mainHeight * 0.3,
              width: _mainWidth * 0.7,
              fit: BoxFit.cover,
            ),
          ),
          Text('Payment of $rupee ' +
              (double.parse(widget.amount) / 100).toString() +
              ' Failed '),
          Text('For'),
          Text(widget.buildingName + ' ,'),
          Text(widget.title),
        ],
      ),
    );
  }

  Widget getSuccessStatus() {
    return Container(
      color: Colors.white,
      height: _mainHeight,
      width: _mainWidth,
      child: Column(
        children: [
          SizedBox(
            height: _mainHeight * 0.1,
          ),
          Container(
            child: Image.asset(
              Images.successfulIcon,
              height: _mainHeight * 0.3,
              width: _mainWidth * 0.8,
              fit: BoxFit.cover,
            ),
          ),
          Text('Payment of $rupee ' +
              (double.parse(widget.amount) / 100).toString() +
              'Success '),
          Text('For'),
          Text(widget.buildingName),
          Text(widget.title),
          Text('Payment Id : ' + widget.paymentId.toString()),
        ],
      ),
    );
  }
}
