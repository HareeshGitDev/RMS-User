import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RMSWidgets{
  late BuildContext context;
  static void showLoaderDialog({required BuildContext context, required String message}) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
              valueColor:AlwaysStoppedAnimation<Color>(Color(0xff7AB02A))),
          SizedBox(width: 5,),
          Container(
              child: Text('$message...',style: TextStyle(fontFamily: 'Nunito'),)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(child: alert, onWillPop: ()async=>false);
      },
    );
  }
  static void showLoaderDialogWithoutText({required BuildContext context}) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
              valueColor:AlwaysStoppedAnimation<Color>(Color(0xff7AB02A))),
          SizedBox(width: 5,),
          Container(
              child: Text('',style: TextStyle(fontFamily: 'Nunito'),)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(child: alert, onWillPop: ()async=>false);
      },
    );
  }
  static void getToast({required String message, required Color color}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }
  static void showSnackbar({required BuildContext context,required String message , required Color color})
  {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 1500),
          backgroundColor: color,

        ),
      );
    }
  }
