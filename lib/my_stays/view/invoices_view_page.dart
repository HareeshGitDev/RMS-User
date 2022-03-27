import 'package:RentMyStay_user/payment_module/view/razorpay_payement_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/custom_theme.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/view/rms_widgets.dart';
import '../model/Invoice_Details_Model.dart';
import '../viewmodel/mystay_viewmodel.dart';

class InvoicePage extends StatefulWidget {
  final String bookingId;

  const InvoicePage({Key? key, required this.bookingId}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<InvoicePage> {
  @override
  var _mainHeight;
  var _mainWidth;
  static const String fontFamily = 'hk-grotest';
  late MyStayViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getInvoiceDetails(bookingId: widget.bookingId);
  }

  TextStyle get getKeyStyle =>
      TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14);

  TextStyle get getValueStyle =>
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);

  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Invoices '),
          titleSpacing: 0,
          backgroundColor: CustomTheme.appTheme,
        ),
        body: Consumer<MyStayViewModel>(
          builder: (context, value, child) {
            return value.invoiceDetailsModel != null &&
                    value.invoiceDetailsModel?.data != null &&
                    value.invoiceDetailsModel?.data?.invoiceDetails != null
                ? Container(
                    height: _mainHeight,
                    width: _mainWidth,
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 15),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          var data = value.invoiceDetailsModel?.data
                              ?.invoiceDetails![index];
                          return Container(
                            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                            child: Neumorphic(
                              padding: EdgeInsets.only(
                                  left: 10, top: 5, right: 5, bottom: 5),
                              style: NeumorphicStyle(
                                  color: Colors.white,
                                  depth: 2,
                                  shadowLightColor: Colors.blueGrey.shade200,
                                  shadowDarkColor:
                                      CustomTheme.appTheme.withAlpha(100)),
                              child: Column(
                                children: [
                                  Table(
                                    children: [
                                      TableRow(children: [
                                        Text('Category :', style: getKeyStyle),
                                        Text(
                                          '${data?.transactionType ?? ''}',
                                          style: getValueStyle,
                                          maxLines: 2,
                                        ),
                                        Text('Invoice Id :',
                                            style: getKeyStyle),
                                        Text(
                                          '${data?.invoiceId ?? ''}',
                                          style: getValueStyle,
                                        )
                                      ]),
                                      TableRow(children: [
                                        Text('From :', style: getKeyStyle),
                                        Text('${data?.fromDate ?? ''}',
                                            style: getValueStyle),
                                        Text('To :', style: getKeyStyle),
                                        Text('${data?.tillDate ?? ''}',
                                            style: getValueStyle)
                                      ]),
                                      TableRow(children: [
                                        Text('Amount :', style: getKeyStyle),
                                        Text('$rupee ${data?.amount ?? ' '}',
                                            style: getValueStyle),
                                        Text('Received :', style: getKeyStyle),
                                        Text(
                                            '$rupee ${data?.amountRecieved ?? ''}',
                                            style: getValueStyle)
                                      ]),
                                      TableRow(children: [
                                        Text('Referral :', style: getKeyStyle),
                                        Text(
                                            '$rupee ${data?.refferalDiscount ?? ''}',
                                            style: getValueStyle),
                                        Text('Pending :', style: getKeyStyle),
                                        Text(
                                            '$rupee ${data?.pendingBalance ?? ''}',
                                            style: getValueStyle)
                                      ]),
                                      TableRow(children: [
                                        Text('Pay Now :', style: getKeyStyle),
                                        Text(
                                            '$rupee ${data?.totalAmount ?? '0'}',
                                            style: getValueStyle),
                                        Text('Status :', style: getKeyStyle),
                                        Text('${data?.status ?? ''}',
                                            style: getValueStyle)
                                      ]),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: _mainWidth * 0.35,
                                    height: 30,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<
                                                  Color>(data?.status != null &&
                                                      data?.status
                                                              ?.toLowerCase() ==
                                                          'closed'
                                                  ? Color(0xff7AB02A)
                                                  : Color(0xffFF0000)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                          )),
                                      onPressed:
                                          data?.status != null &&
                                                  data?.status?.toLowerCase() ==
                                                      'closed'
                                              ? () async {
                                                  RMSWidgets.showLoaderDialog(
                                                      context: context,
                                                      message: 'Loading');
                                                  String invoiceLink =
                                                      await _viewModel.downloadInvoice(
                                                          bookingId:
                                                              data?.bookingId ??
                                                                  '',
                                                          invoiceId:
                                                              data?.invoiceId ??
                                                                  '');
                                                  Navigator.of(context).pop();
                                                  if (invoiceLink.isNotEmpty) {
                                                    if (await canLaunch(
                                                        invoiceLink)) {
                                                      launch(invoiceLink);
                                                    }
                                                  }
                                                }
                                              : () {
                                                  choosePaymentDialog(
                                                      context: context);
                                                },
                                      child: Center(
                                          child: data?.status != null &&
                                                  data?.status?.toLowerCase() ==
                                                      'closed'
                                              ? Text('Download Invoice')
                                              : Text('Pay Now')),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 15,
                          );
                        },
                        itemCount: value.invoiceDetailsModel?.data
                                ?.invoiceDetails!.length ??
                            0),
                  )
                : Center(child: CircularProgressIndicator());
          },
        ));
  }

  void choosePaymentDialog({required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Center(
              child: Text(
                'Choose Payment Mode',
                style: TextStyle(
                    color: Color(0xff226E79),
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
            content: Container(
              height: _mainHeight * 0.16,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => RazorpayPaymentPage(),));
                    },
                    child: Neumorphic(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                      style: NeumorphicStyle(
                          depth: 2,
                          color: Colors.white,
                          //shadowDarkColor: CustomTheme.appTheme.withAlpha(100),
                          shadowLightColor: Colors.blueGrey.shade200),
                      child: Container(
                        width: _mainWidth,
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pay by Razorpay',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            Text(
                              '2-3% Convenience fee will be charges ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(onTap: () => Navigator.pushNamed(
                    context, AppRoutes.updateInvoiceUTRPage,
                    arguments: widget.bookingId,),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                          depth: 2,
                          color: Colors.white,
                         // shadowDarkColor: CustomTheme.appTheme.withAlpha(100),
                          shadowLightColor: Colors.blueGrey.shade200),
                      child: Container(
                        width: _mainWidth,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:const [
                            Text(
                              'Pay by Bank / Update Transaction',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            Text(
                              'No Convenience fee',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            elevation: 5,
          );
        });
  }
}
