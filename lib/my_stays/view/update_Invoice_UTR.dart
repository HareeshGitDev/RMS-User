import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../theme/custom_theme.dart';
import '../../utils/service/navigation_service.dart';
import '../viewmodel/mystay_viewmodel.dart';

class UpdateInvoiceUTRPage extends StatefulWidget {
  final String bookingId;
  final String invoiceId;
  final dynamic amount;

  const UpdateInvoiceUTRPage(
      {Key? key, required this.bookingId, required this.invoiceId,required this.amount})
      : super(key: key);

  @override
  _UpdateInvoiceUTRPageState createState() => _UpdateInvoiceUTRPageState();
}

class _UpdateInvoiceUTRPageState extends State<UpdateInvoiceUTRPage> {
  final _utrController = TextEditingController();
  var _mainHeight;
  var _mainWidth;
  late MyStayViewModel _viewModel;
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
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle get getKeyStyle =>
      TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14);

  TextStyle get getValueStyle =>
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;

    return _connectionStatus?Scaffold(
      appBar: AppBar(
        title: Text('Bank Transfer '),
        titleSpacing: 0,
        backgroundColor: CustomTheme.appTheme,
        centerTitle: false,
      ),
      body: Container(
        height: _mainHeight,
        width: _mainWidth,
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                'Use Netbanking/UPI ID/QR Code to transfer amount directly to bank account and update the transaction details below:'),
            SizedBox(
              height: 10,
            ),
            Text('Account Details : ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left),
            SizedBox(
              height: 10,
            ),
            Table(
              children: [
                TableRow(children: [
                  Text('A/C holder name :', style: getKeyStyle),
                  Text(
                    ' Brightpath Technology',
                    style: getValueStyle,
                    maxLines: 2,
                  ),
                ]),
                TableRow(children: [
                  Text('A/C type :', style: getKeyStyle),
                  Text(
                    ' Current Account',
                    style: getValueStyle,
                    maxLines: 2,
                  ),
                ]),
                TableRow(children: [
                  Text('A/C Number :', style: getKeyStyle),
                  Text(
                    ' 64140859192',
                    style: getValueStyle,
                    maxLines: 2,
                  ),
                ]),
                TableRow(children: [
                  Text('IFSC Code :', style: getKeyStyle),
                  Text(
                    ' SBIN0016213',
                    style: getValueStyle,
                    maxLines: 2,
                  ),
                ]),
                TableRow(children: [
                  Text('Bank name :', style: getKeyStyle),
                  Text(
                    ' State Bank of India',
                    style: getValueStyle,
                    maxLines: 2,
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text('Pay using UPI ID : ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left),
            SizedBox(
              height: 10,
            ),
            Text('rentmystay@sbi ',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
                textAlign: TextAlign.left),
            SizedBox(
              height: 5,
            ),
            Text('rentmystay@oksbi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.left),
            SizedBox(
              height: 10,
            ),
            Text('Pay using QR Code  : ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left),
            Container(
                alignment: Alignment.center,
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/qr_code_rentmystay.jpeg?alt=media&token=22b8d369-5be5-43dc-b113-b297fd44b4ad',
                  width: 200,
                  height: 200,
                )),
            SizedBox(
              height: 10,
            ),
            Text('Payable Amount : ${widget.amount} ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left),
            SizedBox(
              height: 10,
            ),
            Container(
                alignment: Alignment.center,
                child: Text('Update UTR')),
            SizedBox(
              height: 10,
            ),
            Container(


                child:Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                   key: _formKey,
                    child:TextFormField(
                  controller: _utrController,
                  keyboardType: TextInputType.number,
                  validator: (val){
                    if(val?.length==12){
                      return null;
                    }
                    else{
                      return "Please enter proper utr Number";
                    }
                  },
                      maxLength: 12,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
counterText: "",
                 //   contentPadding: EdgeInsets.only(left: 10),
                    hintStyle: TextStyle(
                        //fontFamily: fontFamily,
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                  ),
                )),

            ),
            const SizedBox(
              height: 10,
            ),
                Text('Note: Kindly mention UTR_NO/UPI_ID once the payment is done.')
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        width: _mainWidth,
        height: _mainHeight * 0.06,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: ElevatedButton(
          onPressed: () async {
            if(_formKey.currentState!.validate()) {
              RMSWidgets.showLoaderDialog(context: context, message: 'Loading');
              int response = await _viewModel.updateInvoiceUTRPayment(
                context: context,
                  invoiceId: widget.invoiceId,
                  utrNumber: _utrController.text,
                  bookingId: widget.bookingId);
              Navigator.of(context).pop();
              if (response == 200) {
                RMSWidgets.showSnackbar(context: context,
                    message: 'Payment Successful.Please wait for update.',
                    color: CustomTheme.appTheme);
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.dashboardPage, (route) => false);
              } else {
                RMSWidgets.showSnackbar(context: context,
                    message: 'Something Went Wrong.',
                    color: CustomTheme.errorColor);
              }
            }
            },
          child: Text(
            'Update UTR / Transaction Id',
            style: TextStyle(
                color: CustomTheme.white,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(CustomTheme.appTheme),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              )),
        ),
      ),
    ):RMSWidgets.networkErrorPage(context: context);
  }
}
