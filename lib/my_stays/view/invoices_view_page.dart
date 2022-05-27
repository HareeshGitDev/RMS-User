import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/my_stays/model/invoice_payment_model.dart';
import 'package:RentMyStay_user/payment_module/view/razorpay_payement_page.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../language_module/model/language_model.dart';
import '../../payment_module/model/payment_request_model.dart';
import '../../property_details_module/model/booking_amount_request_model.dart';
import '../../property_details_module/model/booking_credential_response_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/constants/enum_consts.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/view/rms_widgets.dart';
import '../model/Invoice_Details_Model.dart' as invoiceModelData;
import '../viewmodel/mystay_viewmodel.dart';

class InvoicePage extends StatefulWidget {
  final String bookingId;
  final String propertyId;
  final String name;
  final String email;
  final String mobile;
  final String address;

  const InvoicePage(
      {Key? key,
      required this.bookingId,
      required this.propertyId,
      required this.name,
      required this.email,
      required this.mobile,
      required this.address})
      : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<InvoicePage> {
  @override
  var _mainHeight;
  var _mainWidth;
  late MyStayViewModel _viewModel;
  late SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
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
    _viewModel.getInvoiceDetails(bookingId: widget.bookingId);
    getLanguageData();
  }

  getLanguageData() async {
    await _viewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'Invoices');
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  TextStyle get getKeyStyle =>
      TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14);

  TextStyle get getValueStyle =>
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);

  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus
        ? Scaffold(
            appBar: AppBar(
              title: Text(nullCheck(
                      list: context.watch<MyStayViewModel>().invoiceLang)
                  ? '${context.watch<MyStayViewModel>().invoiceLang[0].name}'
                  : 'Invoices '),
              titleSpacing: 0,
              backgroundColor: CustomTheme.appTheme,
              centerTitle: false,
            ),
            body: Consumer<MyStayViewModel>(
              builder: (context, value, child) {
                return value.invoiceDetailsModel != null &&
                        value.invoiceDetailsModel?.msg != null &&
                        value.invoiceDetailsModel?.data != null
                    ? Container(
                        height: _mainHeight,
                        width: _mainWidth,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: _mainWidth * 0.04,
                            vertical: _mainHeight * 0.02),
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              var data =
                                  value.invoiceDetailsModel?.data![index];
                              return Container(

                                decoration: BoxDecoration(
                                 // color: Colors.amber,
                                  border: Border.all(color:Colors.grey,width: 0.5),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.only(
                                    left: _mainWidth * 0.05,
                                    top: _mainHeight * 0.01,
                                  bottom: _mainHeight * 0.01,
                                    right: _mainWidth * 0.05,),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data?.transactionType ?? '',
                                      style: TextStyle(
                                          color: CustomTheme.appTheme,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.005,
                                    ),
                                    Container(
                                      //color: Colors.amber,
                                      //height: _mainHeight * 0.03,
                                      width: _mainWidth,
                                      child: Row(
                                        children: [
                                          Text(
                                              '${nullCheck(list: value.invoiceLang) ? value.invoiceLang[3].name : 'From'}   ',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                          Text(data?.fromDate ?? '',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                          const Spacer(),
                                          Text(
                                              '${nullCheck(list: value.invoiceLang) ? value.invoiceLang[4].name : 'To'}    ',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                          Text(data?.tillDate ?? '',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 0.7,
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.001,
                                    ),
                                    Container(
                                      //color: Colors.amber,
                                      //height: _mainHeight * 0.03,
                                      width: _mainWidth,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${nullCheck(list: value.invoiceLang) ? value.invoiceLang[5].name : 'Amount'} ',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                          Text(
                                              '$rupee ${data?.amount ?? ' '}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14)),

                                        ],
                                      ),
                                    ),

                                    Container(
                                      //color: Colors.amber,
                                      //height: _mainHeight * 0.03,
                                      width: _mainWidth,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${nullCheck(list: value.invoiceLang) ? value.invoiceLang[6].name : 'Received'} ',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                          Text(
                                              '$rupee ${data?.amountRecieved ?? ''}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14)),

                                        ],
                                      ),
                                    ),

                                    data?.refferalDiscount != null && data?.refferalDiscount.toString() != '0'?  Container(
                                     // color: Colors.amber,
                                      //height: _mainHeight * 0.03,
                                      width: _mainWidth,
                                      child: Row(

                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${nullCheck(list: value.invoiceLang) ? value.invoiceLang[7].name : 'Referral'} ',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                          Text(
                                              '$rupee ${data?.refferalDiscount ?? ''}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14)),

                                        ],
                                      ),
                                    ):Container(),
                                    Divider(
                                      thickness: 0.7,
                                    ),

                                    Container(
                                      //color: Colors.amber,
                                      //height: _mainHeight * 0.03,
                                      width: _mainWidth,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${nullCheck(list: value.invoiceLang) ? value.invoiceLang[8].name : 'Pending'} ',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14)),
                                          Text(
                                              '$rupee ${data?.pendingBalance ?? ''}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16)),

                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 0.7,
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.00,
                                    ),
                                    Container(
                                     // height: _mainHeight * 0.04,
                                      width: _mainWidth,
                                      child: Row(

                                        children: [
                                          Text(
                                              '${nullCheck(list: value.invoiceLang) ? value.invoiceLang[2].name : 'Invoice Id'} - ',
                                              style:  TextStyle(
                                                  color: CustomTheme.appTheme,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                          Text(
                                            data?.invoiceId ?? '',
                                              style: TextStyle(
                                                  color: CustomTheme.appTheme,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                          Spacer(),
                                          FittedBox(
                                            child: SizedBox(

                                              height: _mainHeight*0.035,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                        data?.pendingBalance ==
                                                            0
                                                            ? CustomTheme.myFavColor
                                                            : CustomTheme.appThemeContrast),
                                                    shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                    )),
                                                onPressed: data?.pendingBalance == 0
                                                    ? () async {
                                                  RMSWidgets.showLoaderDialog(
                                                      context: context,
                                                      message: 'Loading');
                                                  String invoiceLink =
                                                  await _viewModel
                                                      .downloadInvoice(
                                                      bookingId: widget
                                                          .bookingId,
                                                      invoiceId:
                                                      data?.invoiceId ??
                                                          '');
                                                  Navigator.of(context).pop();
                                                  if (invoiceLink
                                                      .isNotEmpty) {
                                                    if (await canLaunch(
                                                        invoiceLink)) {
                                                      launch(invoiceLink);
                                                    }
                                                  }
                                                }
                                                    : () {
                                                  choosePaymentDialog(
                                                      context: context,
                                                      model: data ??
                                                          invoiceModelData
                                                              .Data());
                                                },
                                                child: Container(
                                                    child: data?.pendingBalance == 0
                                                        ? RichText(
                                                        text: TextSpan(
                                                          children: [

                                                            TextSpan(
                                                                text: nullCheck(
                                                                    list: value
                                                                        .invoiceLang)
                                                                    ? ' ${value.invoiceLang[11].name} '
                                                                    : 'Download'),
                                                            WidgetSpan(
                                                              child: Icon(
                                                                  Icons.download,
                                                                  size: _mainHeight*0.018),
                                                            ),
                                                          ],
                                                        ))
                                                        : Text(nullCheck(
                                                        list: value
                                                            .invoiceLang)
                                                        ? ' ${value.invoiceLang[9].name} '
                                                        : 'Pay Now')),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 15,
                              );
                            },
                            itemCount:
                                value.invoiceDetailsModel?.data!.length ?? 0),
                      )
                    : value.invoiceDetailsModel != null &&
                            value.invoiceDetailsModel?.msg != null &&
                            value.invoiceDetailsModel?.data == null
                        ? RMSWidgets.noData(
                            context: context,
                            message:
                                'Something went Wrong.Invoice Details could not be found.')
                        : Center(child: RMSWidgets.getLoader());
              },
            ))
        : RMSWidgets.networkErrorPage(context: context);
  }
/*TableRow(
                                              children: [
                                            Visibility(
                                                visible:
                                                    data?.pendingBalance != 0,
                                                child: Text(
                                                    '${nullCheck(list: value.invoiceLang) ? value.invoiceLang[9].name : 'Pay Now'} :',
                                                    style: getKeyStyle)),
                                            Visibility(
                                              visible:
                                                  data?.pendingBalance != 0,
                                              child: Text(
                                                  '$rupee ${data?.pendingBalance ?? '0'}',
                                                  style: getValueStyle),
                                            ),
                                            Visibility(
                                                visible:
                                                    data?.pendingBalance != 0,
                                                child: Text(
                                                    '${nullCheck(list: value.invoiceLang) ? value.invoiceLang[10].name : 'Status'} :',
                                                    style: getKeyStyle)),
                                            Visibility(
                                              visible:
                                                  data?.pendingBalance != 0,
                                              child: Text(
                                                  '${data?.status ?? ''}',
                                                  style: getValueStyle),
                                            ),
                                          ]),*/
  void choosePaymentDialog(
      {required BuildContext context, required invoiceModelData.Data model}) {
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
                    color: CustomTheme.appTheme,
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
                    onTap: () async {
                      RMSWidgets.showLoaderDialog(
                          context: context, message: 'Loading');
                      final InvoicePaymentModel response =
                          await _viewModel.fetchInvoicePaymentCredentials(
                              model: BookingAmountRequestModel(
                                  propId: widget.propertyId,
                                  depositAmount: model.amount,
                                  paymentGateway: 'razorpay',
                                  invoiceId: model.invoiceId,
                                  bookingId: widget.bookingId,
                                  name: widget.name,
                                  email: widget.email,
                                  address: widget.address,
                                  phone: widget.mobile));
                      Navigator.of(context).pop();
                      if (response.msg?.toLowerCase() == 'success' &&
                          response.data != null &&
                          response.data?.prefill != null &&
                          response.data?.amount != null &&
                          response.data?.key != null &&
                          response.data?.orderId != null &&
                          response.data?.callbackApi != null) {
                        Navigator.of(context).pushNamed(
                            AppRoutes.razorpayPaymentPage,
                            arguments: PaymentRequestModel(
                                name: response.data?.prefill?.name ?? '',
                                color: response.data?.theme?.color ?? '',
                                email: response.data?.prefill?.email ?? '',
                                image: response.data?.image ?? '',
                                amount:
                                    (response.data?.amount ?? '').toString(),
                                contactNumber:
                                    response.data?.prefill?.contact ?? '',
                                description:
                                    response.data?.description ?? 'RMS Payment',
                                orderId: response.data?.orderId ?? '',
                                paymentMode: PaymentMode.FromInvoice,
                                razorPayKey: response.data?.key ?? '',
                                redirectApi: response.data?.callbackApi ?? '',
                                extraInfo: ''));
                      }
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
                              'Extra 3% payment getway charges ',
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        AppRoutes.updateInvoiceUTRPage,
                        arguments: {
                          'bookingId': widget.bookingId,
                          'invoiceId': model.invoiceId,
                          'amount': model.pendingBalance,
                        },
                      );
                    },
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
                          children: const [
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
