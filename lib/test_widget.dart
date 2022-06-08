import 'dart:developer';

import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';
import 'package:RentMyStay_user/property_details_module/amenities_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_amount_request_model.dart';
import 'package:RentMyStay_user/property_details_module/model/property_details_model.dart';
import 'package:RentMyStay_user/property_details_module/model/property_details_util_model.dart';
import 'package:RentMyStay_user/property_details_module/view/site_visit_page.dart';
import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/theme/custom_theme.dart';
import 'package:RentMyStay_user/theme/fonts.dart';
import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:RentMyStay_user/utils/constants/enum_consts.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/service/system_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:RentMyStay_user/utils/view/webView_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'images.dart';
import 'dart:math' as math;
import 'package:RentMyStay_user/my_stays/model/Invoice_Details_Model.dart'
    as invoiceModelData;

import 'my_stays/model/invoice_payment_model.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  var _mainHeight;
  var _mainWidth;

  late MyStayViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getInvoiceDetails(bookingId: 41769.toString());
  }

  @override
  Widget build(BuildContext context) {
    _mainWidth = MediaQuery.of(context).size.width;
    _mainHeight = MediaQuery.of(context).size.height;
    log('$_mainWidth  -- $_mainHeight');

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
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
                        return Container(
                         // color: Colors.purple,
                          child: ExpansionTile(
                            backgroundColor: Colors.grey.shade50,
                            collapsedBackgroundColor: Colors.grey.shade50,
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.only(
                              bottom: _mainHeight * 0.02,
                              left: _mainWidth * 0.02,
                              top: _mainHeight*0.015,
                              right: _mainWidth*0.09
                            ),
                            title: Container(
                              width: _mainWidth,
                              height: 30,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: _mainWidth*0.015),
                                    child: Text(
                                      data?.transactionType ?? '',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700,
                                          fontSize: getHeight(context: context, height: 20)),
                                    ),
                                  ),
                                  Spacer(),
                                  Text('$rupee ${data?.amount ?? ' '}',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          fontSize: getHeight(context: context, height: 18))),
                                  SizedBox(
                                    width: _mainWidth * 0.02,
                                  ),
                                  Icon(
                                    data?.pendingBalance !=
                                        null &&
                                        data?.pendingBalance == 0?Icons.check:Icons.alarm,
                                    color: data?.pendingBalance !=
                                        null &&
                                        data?.pendingBalance == 0?CustomTheme.myFavColor:CustomTheme.appThemeContrast,
                                    size: _mainWidth*0.045,

                                  )
                                ],
                              ),
                            ),
                            trailing: Container(
                              padding: EdgeInsets.only(bottom: _mainHeight*0.06),
                              child:
                                  Icon(Icons.keyboard_arrow_down_outlined),
                            ),
                            subtitle: Container(

                              padding: EdgeInsets.only(top: _mainHeight*0.01,left: _mainWidth*0.015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('From : ',
                                          style:  TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: getHeight(context: context, height: 12))),
                                      Text(  '${data?.fromDate ??''}',
                                          style: TextStyle(
                                              color: Colors.black87.withAlpha(180),
                                              fontWeight: FontWeight.w500,
                                              fontSize: getHeight(context: context, height: 12))),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Text('To : ',
                                          style:  TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: getHeight(context: context, height: 12))),
                                      Text( '${data?.tillDate??''}',
                                          style:  TextStyle(
                                              color: Colors.black87.withAlpha(180),
                                              fontWeight: FontWeight.w500,
                                              fontSize: getHeight(context: context, height: 12))),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Id : ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: getHeight(context: context, height: 12))),
                                      Text('${data?.invoiceId ??''}',
                                          style: TextStyle(
                                              color: Colors.black87.withAlpha(180),
                                              fontWeight: FontWeight.w500,
                                              fontSize: getHeight(context: context, height: 12))),
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
                                            fontSize: getHeight(context: context, height: 14))),
                                    Text('$rupee ${data?.amount ?? ' '}',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: getHeight(context: context, height: 14))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: _mainHeight*0.01,
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
                                            fontSize: getHeight(context: context, height: 14))),
                                    Text(
                                        '$rupee ${data?.amountRecieved ?? ''}',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: getHeight(context: context, height: 14))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: _mainHeight*0.01,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Referral',
                                              style:  TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.w500,
                                                  fontSize: getHeight(context: context, height: 14))),
                                          Text(
                                              '$rupee ${data?.refferalDiscount ?? ''}',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  fontSize: getHeight(context: context, height: 14))),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: data?.refferalDiscount != null &&
                                    data?.refferalDiscount.toString() !=
                                        '0'
                                    ?_mainHeight*0.01:0,
                              ),
                              Divider(
                                thickness: 0.7,
                              ),
                              SizedBox(
                                height: _mainHeight*0.01,
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
                                            fontSize: getHeight(context: context, height: 14))),
                                    Text(
                                        '$rupee ${data?.pendingBalance ?? ''}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: getHeight(context: context, height: 16))),
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
                                                  data?.pendingBalance == 0
                                              ? CustomTheme.myFavColor
                                              : CustomTheme
                                                  .appThemeContrast),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      )),
                                  onPressed: data?.pendingBalance != null &&
                                          data?.pendingBalance == 0
                                      ? () async {
                                          RMSWidgets.showLoaderDialog(
                                              context: context,
                                              message: 'Loading');
                                          String invoiceLink =
                                              await _viewModel
                                                  .downloadInvoice(
                                                      bookingId:
                                                          41769.toString(),
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
                                          /*choosePaymentDialog(
                                    context: context,
                                    model: data ??
                                        invoiceModelData
                                            .Data());*/
                                        },
                                  child: Container(
                                      child: data?.pendingBalance != null &&
                                              data?.pendingBalance == 0
                                          ? RichText(
                                              text: TextSpan(
                                              children: [
                                                TextSpan(text: 'Download',style: TextStyle(
                                                  fontSize: getHeight(context: context, height: 14)
                                                )),
                                                WidgetSpan(
                                                  child: Icon(
                                                      Icons.download,
                                                      size: _mainHeight *
                                                          0.018),
                                                ),
                                              ],
                                            ))
                                          : Text('Pay Now',style: TextStyle(
                                        fontSize: getHeight(context: context, height: 14)
                                      ),)),
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
                      value.invoiceDetailsModel?.data == null) || value.invoiceDetailsModel != null &&
              value.invoiceDetailsModel?.msg != null &&
              value.invoiceDetailsModel?.data!.length == 0)
                  ? RMSWidgets.noData(
                      context: context,
                      message:
                          'Invoice Details could not be found.')
                  : Center(child: RMSWidgets.getLoader());
        },
      ),
    );
  }
}
