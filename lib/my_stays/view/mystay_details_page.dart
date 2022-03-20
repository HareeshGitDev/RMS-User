import 'package:RentMyStay_user/Web_View_Container.dart';
import 'package:RentMyStay_user/my_stays/model/mystay_details_model.dart';
import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/custom_theme.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/system_service.dart';
import '../viewmodel/mystay_viewmodel.dart';
import 'invoices_view_page.dart';

class MyStayPage extends StatefulWidget {
  final String bookingId;

  const MyStayPage({Key? key, required this.bookingId}) : super(key: key);

  @override
  _MyStayPageState createState() => _MyStayPageState();
}

class _MyStayPageState extends State<MyStayPage> {
  late String privacy_policy =
      'https://www.rentmystay.com/info/privacy-policy/';
  static const String fontFamily = 'hk-grotest';
  late MyStayViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getMyStayDetails(bookingId: widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _getAppBar(context: context, bookingId: widget.bookingId),
      body: Consumer<MyStayViewModel>(
        builder: (context, value, child) {
          return value.myStayDetailsModel != null &&
                  value.myStayDetailsModel?.data != null
              ? Container(
                  height: _mainHeight,
                  color: Colors.white,
                  width: _mainWidth,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: _mainWidth * 0.8,
                              padding: EdgeInsets.only(
                                  left: _mainWidth * 0.04,
                                  top: _mainHeight * 0.01,
                                  right: _mainWidth * 0.04),
                              child: Text(
                                '${value.myStayDetailsModel?.data?.addressDisplay}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              )),
                          GestureDetector(
                            onTap: () async {
                              if ((value.myStayDetailsModel != null &&
                                      value.myStayDetailsModel?.data != null &&
                                      value.myStayDetailsModel?.data?.glat !=
                                          null) &&
                                  (value.myStayDetailsModel != null &&
                                      value.myStayDetailsModel?.data != null &&
                                      value.myStayDetailsModel?.data?.glng !=
                                          null)) {
                                var latitude =
                                    (value.myStayDetailsModel?.data?.glat)
                                        .toString();
                                var longitude =
                                    (value.myStayDetailsModel?.data?.glng)
                                        .toString();
                                await SystemService.launchGoogleMaps(
                                    latitude: latitude, longitude: longitude);
                              }
                            },
                            child: SizedBox(
                              height: _mainHeight * 0.04,
                              width: _mainWidth * 0.17,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: CustomTheme.appTheme,
                                  ),
                                  Text(
                                    ' Map ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        height: _mainHeight * 0.02,
                        thickness: 1,
                      ),
                      Container(
                        //color: Colors.amber,
                        width: _mainWidth,
                        padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            bottom: _mainHeight * 0.01),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: _mainHeight * 0.1,
                              width: _mainWidth * 0.25,
                              child: CachedNetworkImage(
                                imageUrl: value.myStayDetailsModel?.data
                                        ?.picThumbnail ??
                                    '',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                        child: Container(
                                          height: _mainHeight * 0.1,
                                          width: _mainWidth * 0.25,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        baseColor: Colors.grey[200] as Color,
                                        highlightColor:
                                            Colors.grey[350] as Color),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Container(
                              width: _mainWidth * 0.7,
                              height: _mainHeight * 0.11,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        '${value.myStayDetailsModel?.data?.title} hshhs dhbxhhbxshx xxsxsx xsjxnsjnx xsxsjnx xk ',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                        textAlign: TextAlign.start,
                                      )),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Container(
                                      width: _mainWidth * 0.6,
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        '${value.myStayDetailsModel?.data?.furnishedType} Type',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey),
                                        textAlign: TextAlign.start,
                                      )),
                                  Container(
                                    height: _mainHeight * 0.035,
                                    child: Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        IconButton(
                                          padding: EdgeInsets.only(
                                              right: _mainWidth * 0.02),
                                          icon: Icon(
                                            Icons.call,
                                            color: CustomTheme.myFavColor,
                                            size: _mainWidth * 0.06,
                                          ),
                                          onPressed: () {
                                            launch('tel:917204315482');
                                          },
                                        ),
                                        SizedBox(
                                          width: _mainWidth * 0.02,
                                        ),
                                        IconButton(
                                          padding: EdgeInsets.only(
                                              right: _mainWidth * 0.02),
                                          icon: const Image(
                                            image: NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/whatsapplogo.png?alt=media&token=41df11ff-b9e7-4f5b-a4fc-30b47cfe1435',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          onPressed: () {
                                            launch(
                                                'https://wa.me/917204315482?text=Hello');
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: _mainWidth,
                        color: CustomTheme.appTheme,
                        height: _mainHeight * 0.03,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: Icon(Icons.people_alt_outlined,
                                          size: 20, color: Colors.white),
                                    ),
                                    TextSpan(
                                      text:
                                          '  ${value.myStayDetailsModel?.data?.numGuests ?? ''} Guests',
                                    )
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: Icon(Icons.calendar_today_outlined,
                                          size: 20, color: Colors.white),
                                    ),
                                    TextSpan(
                                      text:
                                          '  ${value.myStayDetailsModel?.data?.nights ?? ''} Nights',
                                    )
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: Icon(Icons.outbond_outlined,
                                          size: 20, color: Colors.white),
                                    ),
                                    TextSpan(
                                      text:
                                          '  ${getDate(value.myStayDetailsModel?.data)}',
                                    )
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        width: _mainWidth,
                        padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            top: _mainHeight * 0.01,
                            right: _mainWidth * 0.04),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "Name : ${value.myStayDetailsModel?.data?.travellerName ?? ''}"),
                              Text(
                                "Update Your Kyc",
                                style: TextStyle(
                                    backgroundColor: CustomTheme.appTheme,
                                    color: Colors.white),
                              ),
                            ]),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                              top: _mainHeight * 0.01,
                              right: _mainWidth * 0.04),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Phone No : ${value.myStayDetailsModel?.data?.travellerContactNum ?? ''}",
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: _mainWidth,
                          color: CustomTheme.appTheme,
                          height: _mainHeight * 0.03,
                          padding: EdgeInsets.only(left: _mainWidth * 0.04),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value.myStayDetailsModel?.data?.checkOutStatus ==
                                    '1'
                                ? 'Completed Booking'
                                : 'Active Booking',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      IgnorePointer(
                        ignoring: showBookingFromDateExpand(
                            value.myStayDetailsModel?.data),
                        child: ExpansionTile(
                          title: Container(
                              width: _mainWidth,
                              child: Row(
                                children: [
                                  Text("Booking From"),
                                  Spacer(),
                                  Visibility(
                                    visible: showCheckIn(
                                        value.myStayDetailsModel?.data),
                                    child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: CustomTheme.appThemeContrast
                                                .withAlpha(50)),
                                        child: Text(" Check In ")),
                                  ),
                                  showBookingFromDate(
                                          value.myStayDetailsModel?.data)
                                      ? Text(value.myStayDetailsModel?.data
                                              ?.travelFromDate ??
                                          '')
                                      : Container(),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              )),
                          children: [
                            Container(
                                padding: EdgeInsets.only(
                                  left: _mainWidth * 0.04,
                                  right: _mainWidth * 0.04,
                                  bottom: _mainHeight * 0.002,
                                ),
                                width: _mainWidth,
                                child: Row(
                                  children: [
                                    Text("Check In Date",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                      getCheckInDate(
                                              value.myStayDetailsModel?.data) ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                )),
                            Container(
                              padding: EdgeInsets.only(
                                  left: _mainWidth * 0.04,
                                  right: _mainWidth * 0.04),
                              width: _mainWidth,
                              child: Row(
                                children: [
                                  Text("Check In By",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                    getCheckInBy(
                                            value.myStayDetailsModel?.data) ??
                                        '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      IgnorePointer(
                        ignoring:
                            showBookingExpand(value.myStayDetailsModel?.data),
                        child: ExpansionTile(
                            title: Container(
                                width: _mainWidth,
                                child: Row(
                                  children: [
                                    Text("Booking To"),
                                    Spacer(),
                                    showCheckOut(value.myStayDetailsModel?.data)
                                        ? Container(
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: CustomTheme
                                                    .appThemeContrast
                                                    .withAlpha(50)),
                                            child: Text(" Check Out "))
                                        : Container(),
                                    showBookingToDate(
                                            value.myStayDetailsModel?.data)
                                        ? Text(value.myStayDetailsModel?.data
                                                ?.travelToDate ??
                                            '')
                                        : Container(),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                )),
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  width: _mainWidth,
                                  child: Row(
                                    children: [
                                      Text("Check Out Date",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                        getCheckOutDate(value
                                                .myStayDetailsModel?.data) ??
                                            '',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  )),
                              Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  width: _mainWidth,
                                  child: Row(
                                    children: [
                                      Text("Check Out By",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                        getCheckOutBy(value
                                                .myStayDetailsModel?.data) ??
                                            '',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                            ]),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                              right: _mainWidth * 0.04),
                          width: _mainWidth,
                          color: CustomTheme.appTheme,
                          height: _mainHeight * 0.03,
                          child: Row(
                            children: [
                              Text(
                                "Pending Details ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '$rupee ${value.myStayDetailsModel?.data?.totalAmount}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _gridInput(
                              hint: "Monthly Invoice(s)",
                              icon: Icons.line_weight_outlined,
                              callBack: () => Navigator.pushNamed(
                                  context, AppRoutes.invoicePage)),
                          _gridInput(
                              hint: "Agreement Sign",
                              icon: Icons.assignment_turned_in_outlined,
                              callBack: () {}),
                          _gridInput(
                            hint: "Refund SplitUp",
                            icon: Icons.sticky_note_2_outlined,
                            callBack: () => Navigator.of(context).pushNamed(
                                AppRoutes.refundSplitPage,
                                arguments: widget.bookingId),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _mainHeight * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            child: _gridInput(
                                hint: "Raise Ticket",
                                icon: Icons.report_problem_outlined,
                                callBack: () {}),
                          ),
                          _gridInput(
                              hint: "Refund Form",
                              icon: Icons.person_outline,
                              callBack: () => Navigator.of(context)
                                  .pushNamed(AppRoutes.refundForm)),
                          _gridInput(
                              hint: "Privacy Policies",
                              icon: Icons.policy_outlined,
                              callBack: () => _handleURLButtonPress(
                                  context, privacy_policy, 'Privacy Policy')),
                        ],
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  AppBar _getAppBar(
      {required BuildContext context, required String bookingId}) {
    return AppBar(
      leading: BackButton(
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      titleSpacing: -10,
      backgroundColor: CustomTheme.appTheme,
      title: Padding(
        padding: EdgeInsets.all(10),
        child: Text('Booking Id : $bookingId'),
      ),
    );
  }

  Widget _gridInput(
      {required String hint,
      required IconData icon,
      required Function callBack}) {
    return GestureDetector(
      onTap: () => callBack(),
      child: Container(
        width: _mainWidth * 0.26,
        height: _mainHeight * 0.07,
        decoration: BoxDecoration(
          //color: CustomTheme.appTheme.withAlpha(25),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              icon,
              size: 30,
              color: CustomTheme.appTheme,
            ),
            SizedBox(
              height: _mainHeight * 0.005,
            ),
            Text(hint,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    String urlwithparams = url + '/1';

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Web_View_Container(urlwithparams, title)),
    );
  }

  String? getDate(Data? data) {
    if (data?.earlyCout == null) {
      return data?.travelToDate;
    } else {
      return data?.earlyCout;
    }
  }

  String? getCheckInDate(Data? data) {
    if (data?.cinUserTimeMark == null) {
      return data?.checkInTimeMark;
    } else {
      return data?.cinUserTimeMark;
    }
  }

  String? getCheckInBy(Data? data) {
    if (data?.cinUserMarkBy == null) {
      return 'Rent My Stay'; //data?.checkInMarkBy;
    } else {
      return data?.cinUserMarkBy;
    }
  }

  String? getCheckOutDate(Data? data) {
    if (data?.coutUserTimeMark == null) {
      return data?.checkOutTimeMark;
    } else {
      return data?.coutUserTimeMark;
    }
  }

  String? getCheckOutBy(Data? data) {
    if (data?.coutUserMarkBy == null) {
      return 'Rent My Stay'; //data?.checkOutMarkBy;
    } else {
      return data?.coutUserMarkBy;
    }
  }

  bool showCheckIn(Data? data) {
    if (data?.checkInStatus != null && data?.checkInStatus == '0') {
      if (data?.cinUserMarkBy != null) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  bool showBookingFromDate(Data? data) {
    if (data?.checkInStatus != null && data?.checkInStatus == '0') {
      if (data?.cinUserMarkBy != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  bool showBookingFromDateExpand(Data? data) {
    if (data?.checkInStatus != null && data?.checkInStatus == '0') {
      if (data?.cinUserMarkBy != null) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  bool showCheckOut(Data? data) {
    if (data?.checkInStatus != null && data?.checkInStatus == '0') {
      return false;
    }
    if (data?.checkOutStatus != null && data?.checkOutStatus == '0') {
      if (data?.coutUserMarkBy != null) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  bool showBookingToDate(Data? data) {
    if (data?.checkInStatus != null && data?.checkInStatus == '0') {
      return true;
    }

    if (data?.checkOutStatus != null && data?.checkOutStatus == '0') {
      if (data?.coutUserMarkBy != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  bool showBookingExpand(Data? data) {
    if (data?.checkInStatus != null && data?.checkInStatus == '1') {
      if (data?.checkOutStatus != null && data?.checkOutStatus == '0') {
        if (data?.coutUserMarkBy != null) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
