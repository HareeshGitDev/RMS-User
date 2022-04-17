import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RMSWidgets {
  static void showLoaderDialog(
      {required BuildContext context, required String message}) {
    AlertDialog alert = AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(CustomTheme.appTheme)),
            SizedBox(
              width: 15,
            ),
            Container(
                child: Text(
              '$message...',
              style: TextStyle(fontFamily: 'HKGrotesk'),
            )),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert; //WillPopScope(child: alert, onWillPop: ()async=>false);
      },
    );
  }

  static void showLoaderDialogWithoutText({required BuildContext context}) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff7AB02A))),
          SizedBox(
            width: 5,
          ),
          Container(
              child: Text(
            '',
            style: TextStyle(fontFamily: 'Nunito'),
          )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(child: alert, onWillPop: () async => false);
      },
    );
  }

  static void getToast({required String message, required Color color}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Widget getLoader({required Color color}) {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color));
  }

  static Widget noData(
      {required BuildContext context,
      required String message,
      Color? fontColor,
      double? fontSize,
      FontWeight? fontWeight}) {
    FontWeight.w600;
    return Center(
      child: Text(
        message,
        style: TextStyle(
            fontSize: fontSize ?? 20, fontWeight: fontWeight, color: fontColor),
      ),
    );
  }

  static Widget someError(
      {required BuildContext context,
         String? message,
        Color? fontColor,
        double? fontSize,
        FontWeight? fontWeight}) {
    FontWeight.w600;
    return Center(
      child: Text(
        message ?? 'Something went wrong...',
        style: TextStyle(
            fontSize: fontSize ?? 20, fontWeight: fontWeight, color: fontColor ?? CustomTheme.appTheme),
      ),
    );
  }

  static void showSnackbar(
      {required BuildContext context,
      required String message,
      required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: color,
      ),
    );
  }
}
