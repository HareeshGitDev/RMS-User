import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../images.dart';

class PaymentStatusPage extends StatefulWidget {
  final String amount;
  final String title;
  String? paymentId;
  final String status;

  PaymentStatusPage(
      {Key? key,
      required this.title,
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
    _goToHome();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus?WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body:
            widget.status == 'success' ? getSuccessStatus() : getFailedStatus(),
      ),
    ):RMSWidgets.networkErrorPage(context: context);
  }

  void _goToHome() {
    if (widget.status == 'failed') {
      Timer(const Duration(seconds: 5), () => Navigator.pop(context));
    } else {
      Timer(
          const Duration(seconds: 5),
          () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.dashboardPage,
                (route) => false,
              ));
    }
  }

  Widget getFailedStatus() {
    return Container(
      color: Colors.white,
      height: _mainHeight,
      width: _mainWidth,
      child: Column(
        children: [
          SizedBox(
            height: _mainHeight * 0.15,
          ),
          Container(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.all(20),
                    elevation: 10,
                    child: SizedBox(
                      height: _mainHeight * 0.45,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              child: Text(
                            'Payment Failed',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.red),
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Text(
                            'A Receipt with your payment Id has been emailed to you ',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: _mainHeight * 0.18,
                              width: _mainWidth * 0.8,
                              child: Image.asset(Images.failedIcon)
                              //Image.network('https://www.networkgeek.in/img/error.gif',),
                              ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              'Payment of $rupee ' +
                                  (double.parse(widget.amount))
                                      .toString() +
                                  '   Failed ',
                              style: TextStyle(fontSize: 18)),
                          SizedBox(
                            height: 5,
                          ),
                          Text('For', style: TextStyle(fontSize: 18)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(widget.title, style: TextStyle(fontSize: 18)),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            height: _mainHeight * 0.15,
          ),
          Container(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.all(20),
                    elevation: 10,
                    child: SizedBox(
                      height: _mainHeight * 0.51,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              child: Text(
                            'Payment Received',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: CustomTheme.myFavColor),
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Text(
                            'A Receipt with your transaction Id has been emailed to you ',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: _mainHeight * 0.2,
                              width: _mainWidth * 0.8,
                              child: Image.asset(Images.successfulIcon)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              'Payment of $rupee ' +
                                  (double.parse(widget.amount) / 100)
                                      .toString() +
                                  '   Success ',
                              style: TextStyle(fontSize: 18)),
                          SizedBox(
                            height: 5,
                          ),
                          Text('For', style: TextStyle(fontSize: 18)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(widget.title, style: TextStyle(fontSize: 18)),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Payment Id : ' + widget.paymentId.toString(),
                              style: TextStyle(fontSize: 18)),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Positioned(
                  top: 420,
                  right: 2,
                  child: Container(
                      alignment: Alignment.bottomRight,
                      margin: EdgeInsets.only(
                        right: 10,
                      ),
                      height: _mainHeight * 0.12,
                      width: _mainWidth * 0.8,
                      child: Image.asset(Images.paidIcon)
                      //Image.network('https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/paid.webp?alt=media&token=e5a2f509-4c48-4502-bee7-faf88d5f9bf4',),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
