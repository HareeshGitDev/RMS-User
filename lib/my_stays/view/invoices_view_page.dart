import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/my_stays/model/invoice_payment_model.dart';
import 'package:RentMyStay_user/payment_module/view/razorpay_payement_page.dart';
import 'package:RentMyStay_user/utils/service/date_time_service.dart';
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
import '../../theme/fonts.dart';
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
                        value.invoiceDetailsModel?.data != null &&
                        value.invoiceDetailsModel?.data!.length != 0
                    ? Container(
                        height: _mainHeight,
                        width: _mainWidth,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: _mainWidth * 0.02,
                            vertical: _mainHeight * 0.02),
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              var data =
                                  value.invoiceDetailsModel?.data![index];
                              futureInvoice(fromDate: data?.fromDate ?? '');
                              return Container(
                                // color: Colors.purple,
                                child: ExpansionTile(
                                  backgroundColor: Colors.grey.shade50,
                                  collapsedBackgroundColor: Colors.grey.shade50,
                                  tilePadding: EdgeInsets.zero,
                                  childrenPadding: EdgeInsets.only(
                                      bottom: _mainHeight * 0.02,
                                      left: _mainWidth * 0.02,
                                      top: _mainHeight * 0.015,
                                      right: _mainWidth * 0.09),
                                  title: Container(
                                    width: _mainWidth,
                                    height: 30,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: _mainWidth * 0.015),
                                          child: Text(
                                            data?.transactionType ?? '',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w700,
                                                fontSize: getHeight(
                                                    context: context,
                                                    height: 20)),
                                          ),
                                        ),
                                        Spacer(),
                                        Text('$rupee ${data?.amount ?? ' '}',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600,
                                                fontSize: getHeight(
                                                    context: context,
                                                    height: 18))),
                                        SizedBox(
                                          width: _mainWidth * 0.02,
                                        ),
                                        Icon(
                                          data?.pendingBalance != null &&
                                                  data?.pendingBalance == 0
                                              ? Icons.check
                                              : futureInvoice(fromDate: data?.fromDate ??'')?Icons.add_alert:Icons.alarm,
                                          color: data?.pendingBalance != null &&
                                                  data?.pendingBalance == 0
                                              ? CustomTheme.myFavColor
                                              : futureInvoice(fromDate: data?.fromDate ??'')?CustomTheme.appTheme:CustomTheme.appThemeContrast,
                                          size: _mainWidth * 0.045,
                                        )
                                      ],
                                    ),
                                  ),
                                  trailing: Container(
                                    padding: EdgeInsets.only(
                                        bottom: _mainHeight * 0.06),
                                    child: Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                  ),
                                  subtitle: Container(
                                    padding: EdgeInsets.only(
                                        top: _mainHeight * 0.01,
                                        left: _mainWidth * 0.015),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text('From : ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 12))),
                                            Text('${data?.fromDate ?? ''}',
                                                style: TextStyle(
                                                    color: Colors.black87
                                                        .withAlpha(180),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 12))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('To : ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 12))),
                                            Text('${data?.tillDate ?? ''}',
                                                style: TextStyle(
                                                    color: Colors.black87
                                                        .withAlpha(180),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 12))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Id : ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 12))),
                                            Text('${data?.invoiceId ?? ''}',
                                                style: TextStyle(
                                                    color: Colors.black87
                                                        .withAlpha(180),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 12))),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      //color: Colors.amber,
                                      //height: _mainHeight * 0.03,
                                      width: _mainWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Amount',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getHeight(
                                                      context: context,
                                                      height: 14))),
                                          Text('$rupee ${data?.amount ?? ' '}',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getHeight(
                                                      context: context,
                                                      height: 14))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.01,
                                    ),
                                    Container(
                                      width: _mainWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Received',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getHeight(
                                                      context: context,
                                                      height: 14))),
                                          Text(
                                              '$rupee ${data?.amountRecieved ?? ''}',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getHeight(
                                                      context: context,
                                                      height: 14))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.01,
                                    ),
                                    data?.refferalDiscount != null &&
                                            data?.refferalDiscount.toString() !=
                                                '0'
                                        ? Container(
                                            // color: Colors.amber,
                                            //height: _mainHeight * 0.03,
                                            width: _mainWidth,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Referral',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: getHeight(
                                                            context: context,
                                                            height: 14))),
                                                Text(
                                                    '$rupee ${data?.refferalDiscount ?? ''}',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: getHeight(
                                                            context: context,
                                                            height: 14))),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: data?.refferalDiscount != null &&
                                              data?.refferalDiscount
                                                      .toString() !=
                                                  '0'
                                          ? _mainHeight * 0.01
                                          : 0,
                                    ),
                                    Divider(
                                      thickness: 0.7,
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.01,
                                    ),
                                    Container(
                                      //color: Colors.amber,
                                      //height: _mainHeight * 0.03,
                                      width: _mainWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Pending',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getHeight(
                                                      context: context,
                                                      height: 14))),
                                          Text(
                                              '$rupee ${data?.pendingBalance ?? ''}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: getHeight(
                                                      context: context,
                                                      height: 16))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.02,
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.035,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(data?.pendingBalance !=
                                                            null &&
                                                        data?.pendingBalance ==
                                                            0
                                                    ? CustomTheme.myFavColor
                                                    : CustomTheme
                                                        .appThemeContrast),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            )),
                                        onPressed: data?.pendingBalance !=
                                                    null &&
                                                data?.pendingBalance == 0
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
                                                if (invoiceLink.isNotEmpty) {
                                                  if (await canLaunch(
                                                      invoiceLink)) {
                                                    await launch(invoiceLink);
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
                                            child: data?.pendingBalance !=
                                                        null &&
                                                    data?.pendingBalance == 0
                                                ? RichText(
                                                    text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: 'Download',
                                                          style: TextStyle(
                                                              fontSize: getHeight(
                                                                  context:
                                                                      context,
                                                                  height: 14))),
                                                      WidgetSpan(
                                                        child: Icon(
                                                            Icons.download,
                                                            size: _mainHeight *
                                                                0.018),
                                                      ),
                                                    ],
                                                  ))
                                                : Text(
                                                    'Pay Now',
                                                    style: TextStyle(
                                                        fontSize: getHeight(
                                                            context: context,
                                                            height: 14)),
                                                  )),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 25,
                              );
                            },
                            itemCount:
                                value.invoiceDetailsModel?.data!.length ?? 0),
                      )
                    : ((value.invoiceDetailsModel != null &&
                                value.invoiceDetailsModel?.msg != null &&
                                value.invoiceDetailsModel?.data == null) ||
                            value.invoiceDetailsModel != null &&
                                value.invoiceDetailsModel?.msg != null &&
                                value.invoiceDetailsModel?.data!.length == 0)
                        ? RMSWidgets.noData(
                            context: context,
                            message: 'Invoice Details could not be found.')
                        : Center(child: RMSWidgets.getLoader());
              },
            ))
        : RMSWidgets.networkErrorPage(context: context);
  }

  bool futureInvoice({required String fromDate}) {
    if (fromDate.trim() == '') {
      return false;
    }
    DateTime currentDate = DateTime.now();
    try {
      currentDate = DateTime.parse(fromDate);
    } catch (e) {
      log(e.toString());
    }
    return currentDate.isAfter(
        DateTime.parse(DateTimeService.ddMMYYYYformatDate(DateTime.now())));
  }

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
                    fontSize: getHeight(context: context, height: 20)),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: _mainWidth * 0.02,
                          vertical: _mainHeight * 0.01),
                      style: NeumorphicStyle(
                          depth: 2,
                          color: Colors.white,
                          //shadowDarkColor: CustomTheme.appTheme.withAlpha(100),
                          shadowLightColor: Colors.blueGrey.shade200),
                      child: Container(
                        width: _mainWidth,

                        alignment: Alignment.centerLeft,
                        // height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pay by Razorpay',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      getHeight(context: context, height: 16),
                                  color: Colors.black87),
                            ),
                            Text(
                              'Extra 3% payment getway charges ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                      getHeight(context: context, height: 14),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: _mainWidth * 0.02,
                            vertical: _mainHeight * 0.005),

                        // height: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pay by Bank / Update Transaction',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      getHeight(context: context, height: 16),
                                  color: Colors.black87),
                            ),
                            Text(
                              'No Convenience fee',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                      getHeight(context: context, height: 14),
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
