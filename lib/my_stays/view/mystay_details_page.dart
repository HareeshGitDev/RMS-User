import 'dart:convert';
import 'dart:developer';

import 'package:RentMyStay_user/Web_View_Container.dart';
import 'package:RentMyStay_user/my_stays/model/mystay_details_model.dart';
import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:RentMyStay_user/utils/service/date_time_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../../utils/service/system_service.dart';
import '../viewmodel/mystay_viewmodel.dart';
import 'invoices_view_page.dart';

class MyStayDetailsPage extends StatefulWidget {
  final String bookingId;

  const MyStayDetailsPage({Key? key, required this.bookingId})
      : super(key: key);

  @override
  _MyStayDetailsPageState createState() => _MyStayDetailsPageState();
}

class _MyStayDetailsPageState extends State<MyStayDetailsPage> {
  late String token;

  late MyStayViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;
  late SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getMyStayDetails(bookingId: widget.bookingId);
    getLanguageData();
    preferenceUtil.getToken().then((value) => token = value ?? '');
  }

  getLanguageData() async {
    await _viewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'BookingDetails');
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _getAppBar(context: context, bookingId: widget.bookingId),
      body: Consumer<MyStayViewModel>(
        builder: (context, value, child) {
          return value.myStayDetailsModel != null &&
                  value.myStayDetailsModel?.msg != null &&
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
                                    nullCheck(list: value.bookingDetailsLang)
                                        ? ' ${value.bookingDetailsLang[1].name} '
                                        : ' Map ',
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
                                        '${value.myStayDetailsModel?.data?.title}',
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
                                            color: CustomTheme.appTheme,
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
                                          '  ${value.myStayDetailsModel?.data?.numGuests ?? ''} ${nullCheck(list: value.bookingDetailsLang) ? '${value.bookingDetailsLang[2].name}' : 'Guests'}',
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
                                          '  ${value.myStayDetailsModel?.data?.numGuests ?? ''} ${nullCheck(list: value.bookingDetailsLang) ? '${value.bookingDetailsLang[3].name}' : 'Nights'}',
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
                                "${nullCheck(list: value.bookingDetailsLang) ? ' ${value.bookingDetailsLang[5].name} ' : 'Name'} : ${value.myStayDetailsModel?.data?.travellerName ?? ''}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () => _updateKyc(
                                    context,
                                    updateKYCLink,
                                    'Update Your kyc',
                                    value.myStayDetailsModel?.data?.userId ??
                                        ''),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: CustomTheme.appTheme),
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, top: 1, bottom: 1),
                                  child: Text(
                                    nullCheck(list: value.bookingDetailsLang)
                                        ? ' ${value.bookingDetailsLang[4].name} '
                                        : "Update Your Kyc",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
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
                              "${nullCheck(list: value.bookingDetailsLang) ? ' ${value.bookingDetailsLang[6].name} ' : 'Phone No'} : ${value.myStayDetailsModel?.data?.travellerContactNum ?? ''}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black))),
                      Container(
                          padding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                              top: _mainHeight * 0.01,
                              right: _mainWidth * 0.04),
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "${nullCheck(list: value.bookingDetailsLang) ? ' ${value.bookingDetailsLang[7].name} ' : 'Email'} : ${value.myStayDetailsModel?.data?.contactEmail ?? ''}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black))),
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
                                ? nullCheck(list: value.bookingDetailsLang)
                                    ? ' ${value.bookingDetailsLang[17].name} '
                                    : 'Completed Booking'
                                : nullCheck(list: value.bookingDetailsLang)
                                    ? ' ${value.bookingDetailsLang[18].name} '
                                    : 'Active Booking',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          IgnorePointer(
                            ignoring: showBookingFromDateExpand(
                                value.myStayDetailsModel?.data),
                            child: ExpansionTile(
                              title: Container(
                                  width: _mainWidth,
                                  child: Row(
                                    children: [
                                      Text(
                                        nullCheck(
                                                list: value.bookingDetailsLang)
                                            ? ' ${value.bookingDetailsLang[8].name} '
                                            : "Booking From",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                      showBookingFromDate(
                                              value.myStayDetailsModel?.data)
                                          ? Text(
                                              DateTimeService.checkDateFormat(
                                                      value
                                                          .myStayDetailsModel
                                                          ?.data
                                                          ?.travelFromDate) ??
                                                  '',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            )
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
                                          getCheckInDate(value
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
                                        getCheckInBy(value
                                                .myStayDetailsModel?.data) ??
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
                          Positioned(
                            left: _mainWidth * 0.7,
                            top: _mainHeight * 0.025,
                            child: Visibility(
                              visible:
                                  showCheckIn(value.myStayDetailsModel?.data),
                              child: GestureDetector(
                                onTap: () async {
                                  RMSWidgets.showLoaderDialog(
                                      context: context, message: 'Loading');
                                  int response =
                                      await _viewModel.checkInAndCheckOut(
                                          bookingId: widget.bookingId,
                                          checkIn: true);
                                  if (response == 200) {
                                    await _viewModel.getMyStayDetails(
                                        bookingId: widget.bookingId);
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: CustomTheme.appThemeContrast
                                            .withAlpha(50)),
                                    child: Text(" Check In ")),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          IgnorePointer(
                            ignoring: showBookingExpand(
                                value.myStayDetailsModel?.data),
                            child: ExpansionTile(
                                title: Container(
                                    width: _mainWidth,
                                    child: Row(
                                      children: [
                                        Text(
                                          nullCheck(
                                                  list:
                                                      value.bookingDetailsLang)
                                              ? ' ${value.bookingDetailsLang[9].name} '
                                              : "Booking To",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Spacer(),
                                        showBookingToDate(
                                                value.myStayDetailsModel?.data)
                                            ? Text(
                                                DateTimeService.checkDateFormat(
                                                        value
                                                            .myStayDetailsModel
                                                            ?.data
                                                            ?.travelToDate) ??
                                                    '',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
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
                                          Text("Check Out Date",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600)),
                                          Text(
                                            getCheckOutDate(value
                                                    .myStayDetailsModel
                                                    ?.data) ??
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
                                          Text("Check Out By",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600)),
                                          Text(
                                            getCheckOutBy(value
                                                    .myStayDetailsModel
                                                    ?.data) ??
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
                          Positioned(
                            left: _mainWidth * 0.7,
                            top: _mainHeight * 0.025,
                            child: Visibility(
                              visible:
                                  showCheckOut(value.myStayDetailsModel?.data),
                              child: GestureDetector(
                                onTap: () async {
                                  RMSWidgets.showLoaderDialog(
                                      context: context, message: 'Loading');
                                  int response =
                                      await _viewModel.checkInAndCheckOut(
                                          bookingId: widget.bookingId,
                                          checkIn: false);
                                  if (response == 200) {
                                    await _viewModel.getMyStayDetails(
                                        bookingId: widget.bookingId);
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: CustomTheme.appThemeContrast
                                            .withAlpha(50)),
                                    child: Text(" Check Out ")),
                              ),
                            ),
                          ),
                        ],
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
                                nullCheck(list: value.bookingDetailsLang)
                                    ? ' ${value.bookingDetailsLang[10].name} '
                                    : "Pending Details ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '$rupee ${value.myStayDetailsModel?.data?.pendingAmount ?? '0'}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _gridInput(
                              hint: nullCheck(list: value.bookingDetailsLang)
                                  ? ' ${value.bookingDetailsLang[11].name} '
                                  : "Monthly Invoice(s)",
                              icon: Icon(
                                Icons.line_weight_outlined,
                                size: _mainHeight * 0.032,
                                color: CustomTheme.appTheme,
                              ),
                              callBack: () => Navigator.pushNamed(
                                      context, AppRoutes.invoicePage,
                                      arguments: {
                                        'address': value.myStayDetailsModel
                                                ?.data?.addressDisplay ??
                                            '',
                                        'bookingId': widget.bookingId,
                                        'propertyId': value.myStayDetailsModel
                                                ?.data?.propId ??
                                            '0',
                                        'name': value.myStayDetailsModel?.data
                                                ?.travellerName ??
                                            '',
                                        'mobile': value.myStayDetailsModel?.data
                                                ?.travellerContactNum ??
                                            '',
                                        'email': value.myStayDetailsModel?.data
                                                ?.contactEmail ??
                                            '',
                                      })),
                          _gridInput(
                              hint: value.myStayDetailsModel?.data?.agreementStatus != null &&
                                      value.myStayDetailsModel?.data?.agreementStatus ==
                                          '1'
                                  ? 'Download Agreement '
                                  : nullCheck(list: value.bookingDetailsLang)
                                      ? ' ${value.bookingDetailsLang[12].name} '
                                      : 'Agreement Sign',
                              icon: value.myStayDetailsModel?.data?.agreementStatus !=
                                          null &&
                                      value.myStayDetailsModel?.data
                                              ?.agreementStatus ==
                                          '1'
                                  ? Icon(
                                      Icons.assignment_turned_in,
                                      size: _mainHeight * 0.032,
                                      color: CustomTheme.myFavColor,
                                    )
                                  : Icon(
                                      Icons.assignment_late_outlined,
                                      size: _mainHeight * 0.032,
                                      color: CustomTheme.appTheme,
                                    ),
                              callBack: value.myStayDetailsModel?.data
                                              ?.agreementStatus !=
                                          null &&
                                      value.myStayDetailsModel?.data
                                              ?.agreementStatus ==
                                          '1'
                                  ? () async {
                                      String agreementLink = value
                                              .myStayDetailsModel
                                              ?.data
                                              ?.agreementLink ??
                                          '';
                                      if (await canLaunch(agreementLink)) {
                                        launch(agreementLink)
                                            .catchError((error) async {
                                          log(error.toString());
                                          return true;
                                        });
                                      }
                                    }
                                  : () => _handleURLButtonPress(
                                      context,
                                      agreementLink,
                                  nullCheck(list: value.bookingDetailsLang)
                                      ? ' ${value.bookingDetailsLang[12].name} '
                                      :'Agreement Sign',
                                      base64Encode(utf8.encode(widget.bookingId)) +
                                          '/' +
                                          token)),
                          _gridInput(
                            hint: nullCheck(list: value.bookingDetailsLang)
                                ? ' ${value.bookingDetailsLang[13].name} '
                                : "Refund SplitUp",
                            icon: Icon(
                              Icons.sticky_note_2_outlined,
                              size: _mainHeight * 0.032,
                              color: CustomTheme.appTheme,
                            ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: _gridInput(
                                hint: nullCheck(list: value.bookingDetailsLang)
                                    ? ' ${value.bookingDetailsLang[14].name} '
                                    : "Raise Ticket",
                                icon: Icon(
                                  Icons.report_problem_outlined,
                                  size: _mainHeight * 0.032,
                                  color: value.myStayDetailsModel?.data
                                                  ?.checkOutStatus !=
                                              null &&
                                          value.myStayDetailsModel?.data
                                                  ?.checkOutStatus ==
                                              '1'
                                      ? CustomTheme.appThemeContrast
                                      : CustomTheme.appTheme,
                                ),
                                callBack: value.myStayDetailsModel?.data
                                                ?.checkOutStatus !=
                                            null &&
                                        value.myStayDetailsModel?.data
                                                ?.checkOutStatus ==
                                            '1'
                                    ? () {
                                        RMSWidgets.showSnackbar(
                                            context: context,
                                            message:
                                                'This Booking is Completed So You can not raise Ticket',
                                            color:
                                                CustomTheme.appThemeContrast);
                                      }
                                    : () => Navigator.of(context).pushNamed(
                                            AppRoutes.generateTicketPage,
                                            arguments: {
                                              'bookingId': value
                                                      .myStayDetailsModel
                                                      ?.data
                                                      ?.bookingId ??
                                                  '',
                                              'propertyId': value
                                                      .myStayDetailsModel
                                                      ?.data
                                                      ?.propId ??
                                                  '',
                                              'address': value
                                                      .myStayDetailsModel
                                                      ?.data
                                                      ?.addressDisplay ??
                                                  ''
                                            })),
                          ),
                          _gridInput(
                              hint: nullCheck(list: value.bookingDetailsLang)
                                  ? ' ${value.bookingDetailsLang[15].name} '
                                  : "Refund Form",
                              icon: Icon(
                                Icons.person_outline,
                                size: _mainHeight * 0.032,
                                color: CustomTheme.appTheme,
                              ),
                              callBack: () => Navigator.of(context).pushNamed(
                                      AppRoutes.refundFormPage,
                                      arguments: {
                                        'name': value.myStayDetailsModel?.data
                                                ?.travellerName ??
                                            '',
                                        'title': value.myStayDetailsModel?.data
                                                ?.title ??
                                            '',
                                        'email': value.myStayDetailsModel?.data
                                                ?.contactEmail ??
                                            '',
                                        'bookingId': widget.bookingId,
                                      })),
                          _gridInput(
                              hint: nullCheck(list: value.bookingDetailsLang)
                                  ? ' ${value.bookingDetailsLang[16].name} '
                                  : "Privacy Policies",
                              icon: Icon(
                                Icons.policy_outlined,
                                size: _mainHeight * 0.032,
                                color: CustomTheme.appTheme,
                              ),
                              callBack: () => _handleURLButtonPress(context,
                                  privacyPolicyLink, nullCheck(list: value.bookingDetailsLang)
                                      ? ' ${value.bookingDetailsLang[16].name} '
                                      :'Privacy Policy', '1'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : value.myStayDetailsModel != null &&
                      value.myStayDetailsModel?.msg != null &&
                      value.myStayDetailsModel?.data == null
                  ? RMSWidgets.noData(
                      context: context,
                      message:
                          'Something went Wrong.Booking Details could not be found.')
                  : Center(child: RMSWidgets.getLoader());
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
        child: Text(nullCheck(
                list: context.watch<MyStayViewModel>().bookingDetailsLang)
            ? '${context.watch<MyStayViewModel>().bookingDetailsLang[0].name} : $bookingId'
            : 'Booking Id : $bookingId'),
      ),
    );
  }

  Widget _gridInput(
      {required String hint, required Icon icon, required Function callBack}) {
    return GestureDetector(
      onTap: () => callBack(),
      child: Container(
        width: _mainWidth * 0.3,
        height: _mainHeight * 0.07,
        decoration: BoxDecoration(
          //color: CustomTheme.appTheme.withAlpha(25),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            icon,
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

  void _handleURLButtonPress(
      BuildContext context, String url, String title, String params) {
    String urlwithparams = url + params;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Web_View_Container(urlwithparams, title)),
    );
  }

  void _updateKyc(
      BuildContext context, String url, String title, String params) async {
    log(params);
    SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
    String? token = await preferenceUtil.getToken();
    String kycUrl = '${url + base64Encode(utf8.encode(params))}/$token?app=1';

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Web_View_Container(kycUrl, title)),
    );
  }

  String? getDate(Data? data) {
    if (data?.earlyCout == null) {
      return DateTimeService.checkDateFormat(data?.travelToDate);
    } else {
      return DateTimeService.checkDateFormat(data?.earlyCout);
    }
  }

  String? getCheckInDate(Data? data) {
    if (data?.cinUserTimeMark == null) {
      return DateTimeService.checkDateFormat(data?.checkInTimeMark);
    } else {
      return DateTimeService.checkDateFormat(data?.cinUserTimeMark);
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
      return DateTimeService.checkDateFormat(data?.checkOutTimeMark);
    } else {
      return DateTimeService.checkDateFormat(data?.coutUserTimeMark);
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
