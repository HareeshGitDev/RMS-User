import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/property_details_module/view/site_visit_page.dart';
import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/utils/service/system_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../images.dart';
import '../../theme/custom_theme.dart';
import '../../theme/fonts.dart';
import '../../utils/constants/enum_consts.dart';
import '../../utils/view/webView_page.dart';
import '../../language_module/model/language_model.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/date_time_service.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../../utils/view/calander_page.dart';
import '../amenities_model.dart';
import '../model/property_details_model.dart';
import '../model/property_details_util_model.dart';

class PropertyDetailsPage extends StatefulWidget {
  final String propId;
  final bool fromExternalApi;

  PropertyDetailsPage(
      {Key? key, required this.propId, required this.fromExternalApi})
      : super(key: key);

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  final SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
  String checkInDate = DateTimeService.ddMMYYYYformatDate(DateTime.now());
  String checkOutDate = DateTimeService.ddMMYYYYformatDate(
      DateTime.now().add(const Duration(days: 31)));

  var _mainHeight;
  var _mainWidth;

  late PropertyDetailsViewModel _viewModel;
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;

  bool isDailyChecked = false;
  bool isMonthlyChecked = false;
  bool isLOngTermChecked = true;
  bool isDetailsExpanded = false;
  bool isHouseRulesExpanded = false;

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
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _viewModel = Provider.of<PropertyDetailsViewModel>(context, listen: false);
    _viewModel.getPropertyDetails(propId: widget.propId,context: context);
    getLanguageData();
  }

  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }

  getLanguageData() async {
    await _viewModel.getPropertyDetailsLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'propertyDetails');
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  Widget build(BuildContext context) {
    _mainWidth = MediaQuery.of(context).size.width;
    _mainHeight = MediaQuery.of(context).size.height;
    return _connectionStatus
        ? Consumer<PropertyDetailsViewModel>(
            builder: (context, value, child) {
              return SafeArea(
                child: value.propertyDetailsModel != null &&
                        value.propertyDetailsModel?.msg != null &&
                        value.propertyDetailsModel?.data != null
                    ? Scaffold(
                        resizeToAvoidBottomInset: true,
                        body: WillPopScope(
                          onWillPop: () async {
                            if (widget.fromExternalApi) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AppRoutes.dashboardPage, (route) => false);
                              return true;
                            } else {
                              Navigator.pop(context);
                              return true;
                            }
                          },
                          child: Container(
                            color: Colors.white,
                            height: _mainHeight,
                            width: _mainWidth,
                            // margin: EdgeInsets.only(bottom: _mainHeight * 0.01),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CarouselSlider(
                                            items: value.propertyDetailsModel
                                                            ?.data?.details !=
                                                        null &&
                                                    value
                                                            .propertyDetailsModel
                                                            ?.data
                                                            ?.details
                                                            ?.pic !=
                                                        null
                                                ? value.propertyDetailsModel
                                                        ?.data?.details?.pic
                                                        ?.map((e) => Container(
                                                              height:
                                                                  _mainHeight *
                                                                      0.35,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  if (value.propertyDetailsModel?.data
                                                                              ?.details !=
                                                                          null &&
                                                                      value
                                                                              .propertyDetailsModel
                                                                              ?.data
                                                                              ?.details
                                                                              ?.pic !=
                                                                          null) {
                                                                    Navigator.of(context).pushNamed(
                                                                        AppRoutes
                                                                            .propertyGalleryPage,
                                                                        arguments: {
                                                                          'fromVideo':
                                                                              false,
                                                                          'videoLink': value
                                                                              .propertyDetailsModel
                                                                              ?.data
                                                                              ?.details
                                                                              ?.videoLink,
                                                                          'imageList': value
                                                                              .propertyDetailsModel
                                                                              ?.data
                                                                              ?.details
                                                                              ?.pic,
                                                                        });
                                                                  }
                                                                },
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: e
                                                                      .picWp
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  placeholder: (context, url) => Shimmer
                                                                      .fromColors(
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                _mainHeight * 0.35,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          baseColor: Colors.grey[200]
                                                                              as Color,
                                                                          highlightColor:
                                                                              Colors.grey[350] as Color),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      const Icon(
                                                                          Icons
                                                                              .error),
                                                                ),
                                                              ),
                                                            ))
                                                        .toList() ??
                                                    []
                                                : [Container()],
                                            options: CarouselOptions(
                                                height: _mainHeight * 0.35,
                                                enlargeCenterPage: false,
                                                autoPlayInterval:
                                                    const Duration(seconds: 4),
                                                autoPlay: true,
                                                aspectRatio: 16 / 9,
                                                autoPlayCurve:
                                                    Curves.decelerate,
                                                enableInfiniteScroll: true,
                                                viewportFraction: 1),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                              top: _mainHeight * 0.045,
                                              left: _mainWidth * 0.03,
                                              //right: _mainWidth * 0.03,
                                            ),
                                            //color: Colors.amber,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  // color: Colors.amber,
                                                  width: _mainWidth * 0.85,

                                                  child: RichText(
                                                      text: TextSpan(
                                                          text:
                                                          '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[0].name :'Please Note'} : ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: getHeight(
                                                                  context:
                                                                      context,
                                                                  height: 12),
                                                              fontFamily:
                                                                  getThemeFont,
                                                              color: CustomTheme
                                                                  .appThemeContrast),
                                                          children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                          '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[1].name :'The furniture and furnishings may appear different from what’s shown in the pictures. Dewan/sofa may be provided as available.'}',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: getHeight(
                                                                context:
                                                                    context,
                                                                height: 10),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ])),
                                                ),
                                                Container(
                                                  height: _mainHeight*0.05,
                                                  //  color: Colors.amber,
                                                  child: Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          if ((value.propertyDetailsModel?.data
                                                                          ?.details !=
                                                                      null &&
                                                                  value
                                                                          .propertyDetailsModel
                                                                          ?.data
                                                                          ?.details
                                                                          ?.glat !=
                                                                      null) &&
                                                              (value.propertyDetailsModel?.data
                                                                          ?.details !=
                                                                      null &&
                                                                  value
                                                                          .propertyDetailsModel
                                                                          ?.data
                                                                          ?.details
                                                                          ?.glng !=
                                                                      null)) {
                                                            var latitude = (value
                                                                    .propertyDetailsModel
                                                                    ?.data
                                                                    ?.details
                                                                    ?.glat)
                                                                .toString();
                                                            var longitude = (value
                                                                    .propertyDetailsModel
                                                                    ?.data
                                                                    ?.details
                                                                    ?.glng)
                                                                .toString();
                                                            await SystemService
                                                                .launchGoogleMaps(
                                                                    latitude:
                                                                        latitude,
                                                                    longitude:
                                                                        longitude);
                                                          }
                                                        },
                                                        child: Image.asset(
                                                          Images.locationIcon,

                                                          width: _mainWidth * 0.06,
                                                        ),
                                                      ),
                                                      Text('Map',style: TextStyle(
                                                        fontSize: getHeight(context: context, height: 12)
                                                      ),)
                                                    ],
                                                  ),
                                                ),

                                                /*  Icon(
                                          Icons.location_on_outlined,
                                          color: CustomTheme.appTheme,
                                          size: _mainHeight * 0.03,
                                        ),*/
                                                SizedBox(
                                                  width: _mainWidth * 0.01,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: _mainHeight * 0.01,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: _mainWidth * 0.9,
                                                  padding: getHeadingPadding,
                                                  child: Text(
                                                    value.propertyDetailsModel?.data
                                                                    ?.details !=
                                                                null &&
                                                            value
                                                                    .propertyDetailsModel
                                                                    ?.data
                                                                    ?.details
                                                                    ?.title !=
                                                                null
                                                        ? '${(value.propertyDetailsModel?.data?.details?.title).toString().trim()}'
                                                        : '',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: getHeight(
                                                            context: context,
                                                            height: 16),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                /*Container(
                                          padding: EdgeInsets.only(left: 5, right: 5),
                                          margin: EdgeInsets.only(
                                              right: _mainWidth * 0.02),
                                          color: CustomTheme.myFavColor,
                                          child: Text(
                                            '4.3* | 1440',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),*/
                                              ],
                                            ),
                                          ),
                                           SizedBox(
                                    height: _mainHeight * 0.005,
                                  ),
                                          Container(
                                            width: _mainWidth * 0.9,
                                            padding: getHeadingPadding,
                                            child: Text(
                                              value.propertyDetailsModel?.data
                                                  ?.details !=
                                                  null &&
                                                  value
                                                      .propertyDetailsModel
                                                      ?.data
                                                      ?.details
                                                      ?.title !=
                                                      null
                                                  ? '${(value.propertyDetailsModel?.data?.details?.bname).toString().trim()} ${value.propertyDetailsModel?.data?.details?.floor} (Prop Id :  ${value.propertyDetailsModel?.data?.details?.propId ?? ''})'
                                                  : '',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: getHeight(
                                                      context: context,
                                                      height: 12),
                                                  fontWeight:
                                                  FontWeight.w500),
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            height: _mainHeight * 0.015,
                                          ),
                                          Container(
                                            height: 40,
                                            margin: EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(

                                                border: Border.all(
                                                    color: Colors
                                                        .grey
                                                        .shade300),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    5)),
                                            padding: getHeadingPadding,
                                            child: _getRentView(
                                                context: context,
                                                model:
                                                    value.propertyDetailsModel,
                                                value: value),
                                          ),
                                          SizedBox(
                                            height: _mainHeight * 0.02,
                                          ),
                                          InkWell(
                                            onTap: () => _handleURLButtonPress(
                                                context,
                                                cancellationPolicyUrl,
                                                'Cancellation Policy'),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                left: _mainWidth * 0.03,
                                                right: _mainWidth * 0.03,
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                      '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[8].name :'Free Cancellation within 24 hours of booking'}.  ',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              getThemeFont,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: getHeight(
                                                              context: context,
                                                              height: 12)),
                                                    ),
                                                    TextSpan(
                                                      text: '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[24].name :'Click here'}',
                                                      style: TextStyle(
                                                          color: CustomTheme
                                                              .appThemeContrast,
                                                          fontSize: getHeight(
                                                              context: context,
                                                              height: 12),
                                                          fontFamily:
                                                              getThemeFont,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
                                                    ),
                                                    TextSpan(
                                                      text: ' ${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[25].name :' to View.'}',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              getThemeFont,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: getHeight(
                                                              context: context,
                                                              height: 12)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: _mainHeight * 0.01,
                                          ),
                                          Divider(
                                            thickness: 1,
                                          ),
                                          SizedBox(
                                            height: _mainHeight * 0.01,
                                          ),
                                          _getRoomDetails(value: value),
                                          SizedBox(
                                            height: _mainHeight * 0.02,
                                          ),
                                          Container(
                                              padding: getHeadingPadding,
                                              height: _mainHeight * 0.15,
                                              child:                                           AmmentitiesTab(amenities: value.amenitiesList, noAmenities: value.noAmenitiesList),

                                          ),

                                        //   Container(
                                        //     padding: getHeadingPadding,
                                        //     child: Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment
                                        //               .spaceBetween,
                                        //       children: [
                                        //         Text(
                                        //           '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[13].name :'Available Amenities'}',
                                        //           style: getHeadingStyle,
                                        //         ),
                                        //         /*Icon(
                                        //   Icons.arrow_forward_ios,
                                        //   color: Colors.black54,
                                        //   size: 20,
                                        // )*/
                                        //       ],
                                        //     ),
                                        //   ),
                                        //   SizedBox(
                                        //     height: _mainHeight * 0.015,
                                        //   ),
                                        //   Container(
                                        //     padding: getHeadingPadding,
                                        //     height: _mainHeight * 0.07,
                                        //     child: getAvailableAmenities(
                                        //         list: value.amenitiesList),
                                        //   ),
                                        //   SizedBox(
                                        //     height: _mainHeight * 0.015,
                                        //   ),
                                        //   Container(
                                        //     padding: getHeadingPadding,
                                        //     child: Text(
                                        //       "Amenities not available",
                                        //       style: getHeadingStyle,
                                        //     ),
                                        //   ),
                                        //   SizedBox(
                                        //     height: _mainHeight * 0.015,
                                        //   ),
                                        //   Container(
                                        //     padding: getHeadingPadding,
                                        //     height: _mainHeight * 0.07,
                                        //     child: getAvailableNotAmenities(
                                        //         list: value.noAmenitiesList),
                                        //   ),
                                          ExpansionTile(
                                              tilePadding: getHeadingPadding,
                                              childrenPadding: EdgeInsets.only(
                                                bottom: _mainHeight * 0.01,
                                                left: _mainWidth * 0.03,
                                                right: _mainWidth * 0.03,
                                              ),
                                              onExpansionChanged: (val) {
                                                setState(() {
                                                  isDetailsExpanded = val;
                                                });
                                              },
                                              trailing: Icon(
                                                isDetailsExpanded
                                                    ? Icons.keyboard_arrow_down
                                                    : Icons
                                                        .keyboard_arrow_right,
                                                color: CustomTheme.appTheme,
                                              ),
                                              title: Text(
                                                '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[16].name :'Details'}',
                                                style: getHeadingStyle,
                                              ),
                                              children: [
                                                Html(
                                                  data: value.propertyDetailsModel
                                                                  ?.data?.details !=
                                                              null &&
                                                          value
                                                                  .propertyDetailsModel
                                                                  ?.data
                                                                  ?.details
                                                                  ?.description !=
                                                              null
                                                      ? (value
                                                              .propertyDetailsModel
                                                              ?.data
                                                              ?.details
                                                              ?.description)
                                                          .toString()
                                                      : ' ',
                                                  style: {
                                                    "body": Style(
                                                      fontSize: FontSize(
                                                          getHeight(
                                                              context: context,
                                                              height: 12)),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black54,
                                                      wordSpacing: 0.5,
                                                      letterSpacing: 0.5,
                                                      display: Display.INLINE,
                                                    ),
                                                  },
                                                )
                                              ]),
                                          SizedBox(
                                            height: _mainHeight * 0.015,
                                          ),
                                          Container(
                                            padding: getHeadingPadding,
                                            child: Text(
                                              '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[27].name :'What\'s Nearby'}',
                                              style: getHeadingStyle,
                                            ),
                                          ),

                                          SizedBox(
                                            height: _mainHeight * 0.005,
                                          ),
                                          value.propertyDetailsModel?.data
                                                          ?.nearBy !=
                                                      null &&
                                                  value
                                                          .propertyDetailsModel
                                                          ?.data
                                                          ?.nearBy!
                                                          .length !=
                                                      0
                                              ? Container(
                                                  padding: getHeadingPadding,
                                                  height: _mainHeight * 0.22,
                                                  child: NearbyFacilities(
                                                    nearByList: value
                                                            .propertyDetailsModel
                                                            ?.data
                                                            ?.nearBy ??
                                                        [],
                                                  ))
                                              : Container(),
                                          SizedBox(
                                            height: _mainHeight * 0.005,
                                          ),

                                          Container(
                                            padding: getHeadingPadding,
                                            child: GestureDetector(
                                              onTap: () async {
                                                if ((value.propertyDetailsModel?.data
                                                    ?.details !=
                                                    null &&
                                                    value
                                                        .propertyDetailsModel
                                                        ?.data
                                                        ?.details
                                                        ?.glat !=
                                                        null) &&
                                                    (value.propertyDetailsModel?.data
                                                        ?.details !=
                                                        null &&
                                                        value
                                                            .propertyDetailsModel
                                                            ?.data
                                                            ?.details
                                                            ?.glng !=
                                                            null)) {
                                                  var latitude = (value
                                                      .propertyDetailsModel
                                                      ?.data
                                                      ?.details
                                                      ?.glat)
                                                      .toString();
                                                  var longitude = (value
                                                      .propertyDetailsModel
                                                      ?.data
                                                      ?.details
                                                      ?.glng)
                                                      .toString();
                                                  await SystemService
                                                      .launchGoogleMaps(
                                                      latitude:
                                                      latitude,
                                                      longitude:
                                                      longitude);
                                                }
                                              },
                                              child: Text('View on Map',style: TextStyle(
                                                  fontSize: getHeight(context: context, height: 14),
                                                  color: CustomTheme.appThemeContrast,
                                                fontWeight: FontWeight.w600
                                              ),),
                                            ),
                                          ),
                                          SizedBox(
                                            height: _mainHeight * 0.005,
                                          ),
                                          Container(
                                            padding: getHeadingPadding,
                                            // height: _mainHeight * 0.03,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[14].name :'Get In Touch'}',
                                                    style: getHeadingStyle,
                                                  ),
                                                  Spacer(),
                                                  InkWell(
                                                      onTap: () {
                                                        if (value.propertyDetailsModel != null &&
                                                            value
                                                                    .propertyDetailsModel
                                                                    ?.data
                                                                    ?.details !=
                                                                null &&
                                                            value
                                                                    .propertyDetailsModel
                                                                    ?.data
                                                                    ?.details
                                                                    ?.salesNumber !=
                                                                null) {
                                                          launch(
                                                              'tel:${value.propertyDetailsModel?.data?.details?.salesNumber}');
                                                        }
                                                      },
                                                      child: Image.asset(
                                                        Images.callIcon,
                                                        width:
                                                            _mainWidth * 0.09,
                                                        height:
                                                            _mainHeight * 0.06,
                                                      ) /*Icon(
                                              Icons.call,
                                              color: CustomTheme.appTheme,
                                              size: _mainWidth * 0.06,
                                            ),*/
                                                      ),
                                                  SizedBox(
                                                    width: _mainWidth * 0.04,
                                                  ),
                                                  InkWell(
                                                      onTap: () async{
                                                        SharedPreferenceUtil prefs=SharedPreferenceUtil();
                                                        var token= await preferenceUtil.getString(rms_registeredUserToken);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => Web_View_Container(requestUrl+token.toString(), 'Request a Call Back')));

                                                      },
                                                      child: Material(
                                                        elevation: 2,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(40)),
                                                          ),
                                                          child: Icon(
                                                            Icons.add_call,
                                                           color: CustomTheme.appThemeContrast2,
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: _mainWidth * 0.04,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        if (value.propertyDetailsModel != null &&
                                                            value
                                                                    .propertyDetailsModel
                                                                    ?.data
                                                                    ?.details !=
                                                                null &&
                                                            value
                                                                    .propertyDetailsModel
                                                                    ?.data
                                                                    ?.details
                                                                    ?.salesNumber !=
                                                                null) {
                                                          launch(
                                                              'https://wa.me/${value.propertyDetailsModel?.data?.details?.salesNumber}?text=${value.propertyDetailsModel?.data?.shareLink ?? 'Hello'}');
                                                        }
                                                      },
                                                      child: Image.asset(
                                                        Images.whatsapplogo,
                                                        width:
                                                            _mainWidth * 0.09,
                                                        height:
                                                            _mainHeight * 0.06,
                                                      )
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            height: _mainHeight * 0.015,
                                          ),
                                          Container(
                                            color: Colors.grey.shade50,
                                            height: _mainHeight * 0.13,
                                            padding: EdgeInsets.only(
                                              top: _mainHeight * 0.01,
                                              left: _mainWidth * 0.03,
                                              right: _mainWidth * 0.03,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[18].name :' Reasons to choose RentMyStay'}',
                                                  style: getHeadingStyle,
                                                ),
                                                SizedBox(
                                                  height: _mainHeight * 0.01,
                                                ),
                                                Container(
                                                  height: _mainHeight * 0.075,
                                                  child: ListView.separated(
                                                      itemBuilder: (_, index) {
                                                        return Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: _mainWidth *
                                                                0.02,
                                                            right: _mainWidth *
                                                                0.01,
                                                            top: _mainHeight *
                                                                0.005,
                                                          ),
                                                          width:
                                                              _mainWidth * 0.42,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Text(
                                                            getReasonsList[
                                                                index],
                                                            style: TextStyle(
                                                                fontSize: getHeight(
                                                                    context:
                                                                        context,
                                                                    height: 12),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        );
                                                      },
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      separatorBuilder:
                                                          (_, __) =>
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                      itemCount: getReasonsList
                                                          .length),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: _mainHeight * 0.01,
                                          ),
                                          Container(
                                            color: Colors.grey.shade50,
                                            child: ExpansionTile(
                                                onExpansionChanged: (val) {
                                                  setState(() {
                                                    isHouseRulesExpanded = val;
                                                  });
                                                },
                                                trailing: Icon(
                                                  isHouseRulesExpanded
                                                      ? Icons
                                                          .keyboard_arrow_down
                                                      : Icons
                                                          .keyboard_arrow_right,
                                                  color: CustomTheme.appTheme,
                                                ),
                                                childrenPadding:
                                                    EdgeInsets.only(
                                                  bottom: _mainHeight * 0.01,
                                                  left: _mainWidth * 0.04,
                                                  right: _mainWidth * 0.04,
                                                ),
                                                title: Text(
                                                  '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[17].name :'House Rules'}',
                                                  style: getHeadingStyle,
                                                ),
                                                children: [
                                                  Html(
                                                    data: value
                                                                    .propertyDetailsModel
                                                                    ?.data
                                                                    ?.details !=
                                                                null &&
                                                            value
                                                                    .propertyDetailsModel
                                                                    ?.data
                                                                    ?.details
                                                                    ?.things2note !=
                                                                null
                                                        ? (value
                                                                .propertyDetailsModel
                                                                ?.data
                                                                ?.details
                                                                ?.things2note)
                                                            .toString()
                                                        : ' ',
                                                    style: {
                                                      "body": Style(
                                                        fontSize: FontSize(
                                                            getHeight(
                                                                context:
                                                                    context,
                                                                height: 12)),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black54,
                                                        wordSpacing: 0.5,
                                                        letterSpacing: 0.5,
                                                        display: Display.INLINE,
                                                      ),
                                                    },
                                                  )
                                                ]),
                                          ),
                                          SizedBox(
                                            height: _mainHeight * 0.01,
                                          ),
                                          GestureDetector(
                                            onTap: () => _handleURLButtonPress(
                                                context, faqUrl, 'FAQ'),
                                            child: Container(
                                              height: _mainHeight * 0.06,
                                              color: Colors.grey.shade50,
                                              padding: EdgeInsets.only(
                                                left: _mainWidth * 0.03,
                                                right: _mainWidth * 0.04,
                                              ),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[19].name :'FAQ'}',
                                                      style: getHeadingStyle,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_right,
                                                      color:
                                                          CustomTheme.appTheme,
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                          SizedBox(
                                            height: _mainHeight * 0.015,
                                          ),
                                          Container(
                                            padding: getHeadingPadding,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[21].name :'Properties You May Like'}',
                                                  style: getHeadingStyle,
                                                ),
                                                GestureDetector(
                                                  onTap: () => Navigator.of(
                                                          context)
                                                      .pushNamed(
                                                          AppRoutes
                                                              .propertyListingPage,
                                                          arguments: {
                                                        'location':
                                                            'Bengaluru-Karnataka-India',
                                                        'property': Property
                                                            .fromLocation,
                                                      }),
                                                  child: Text(
                                                    '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[26].name :'See All'}',
                                                    style: TextStyle(
                                                        color: CustomTheme
                                                            .appThemeContrast,
                                                        fontSize: getHeight(
                                                            context: context,
                                                            height: 14),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: _mainHeight * 0.01,
                                          ),
                                          _getSimilarProperties(
                                              context: context, model: value),
                                          SizedBox(
                                            height: _mainHeight * 0.02,
                                          )
                                        ],
                                      ),
                                      Positioned(
                                        top: _mainHeight * 0.015,
                                        child: Container(
                                          width: _mainWidth,
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(left:8.0),
                                                child: CircleAvatar(
                                                   backgroundColor: Colors.grey.shade400,
                                                  child: BackButton(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (value.propertyDetailsModel
                                                              ?.data?.details !=
                                                          null &&
                                                      value
                                                              .propertyDetailsModel
                                                              ?.data
                                                              ?.details
                                                              ?.wishlist ==
                                                          1) {
                                                    if (value.propertyDetailsModel
                                                                ?.data?.details !=
                                                            null &&
                                                        value
                                                                .propertyDetailsModel
                                                                ?.data
                                                                ?.details
                                                                ?.propId !=
                                                            null) {
                                                      int response = await _viewModel
                                                          .addToWishlist(
                                                        context: context,
                                                              propertyId: value
                                                                      .propertyDetailsModel
                                                                      ?.data
                                                                      ?.details
                                                                      ?.propId ??
                                                                  '');
                                                      if (response == 200) {
                                                        setState(() {
                                                          value
                                                              .propertyDetailsModel
                                                              ?.data
                                                              ?.details
                                                              ?.wishlist = 0;
                                                        });
                                                        RMSWidgets.showSnackbar(
                                                            context: context,
                                                            message:
                                                                'Successfully Removed From Wishlist',
                                                            color: CustomTheme
                                                                .appTheme);
                                                      }
                                                    }
                                                  } else if (value
                                                              .propertyDetailsModel
                                                              ?.data
                                                              ?.details !=
                                                          null &&
                                                      value
                                                              .propertyDetailsModel
                                                              ?.data
                                                              ?.details
                                                              ?.wishlist ==
                                                          0) {
                                                    if (value.propertyDetailsModel
                                                                ?.data?.details !=
                                                            null &&
                                                        value
                                                                .propertyDetailsModel
                                                                ?.data
                                                                ?.details
                                                                ?.propId !=
                                                            null) {
                                                      int response = await _viewModel
                                                          .addToWishlist(
                                                        context: context,
                                                              propertyId: value
                                                                      .propertyDetailsModel
                                                                      ?.data
                                                                      ?.details
                                                                      ?.propId ??
                                                                  '');
                                                      if (response == 200) {
                                                        setState(() {
                                                          value
                                                              .propertyDetailsModel
                                                              ?.data
                                                              ?.details
                                                              ?.wishlist = 1;
                                                        });
                                                        RMSWidgets.showSnackbar(
                                                            context: context,
                                                            message:
                                                                'Successfully Added to Wishlist',
                                                            color: CustomTheme
                                                                .appTheme);
                                                      }
                                                    }
                                                  }
                                                },
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    radius: 12,
                                                    child: value
                                                                    .propertyDetailsModel
                                                                    ?.data
                                                                    ?.details !=
                                                                null &&
                                                            value
                                                                    .propertyDetailsModel
                                                                    ?.data
                                                                    ?.details
                                                                    ?.wishlist ==
                                                                1
                                                        ? Icon(
                                                            Icons.favorite,
                                                            color: CustomTheme
                                                                .errorColor,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .favorite_outline_rounded,
                                                            color: CustomTheme
                                                                .white,
                                                          )),
                                              ),
                                              SizedBox(
                                                width: _mainWidth * 0.04,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  await Share.share(value
                                                          .propertyDetailsModel!
                                                          .data
                                                          ?.shareLink ??
                                                      " ");
                                                },
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    radius: 12,
                                                    child: Icon(
                                                      Icons.share_outlined,
                                                      color: CustomTheme.white,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: _mainWidth * 0.03,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: _mainHeight * 0.27,
                                        right: _mainWidth * 0.02,
                                        child: Visibility(
                                          visible: value.propertyDetailsModel
                                              ?.data?.details !=
                                              null && value
                                              .propertyDetailsModel
                                              ?.data
                                              ?.details
                                              ?.videoLink != null && value
                                              .propertyDetailsModel
                                              ?.data
                                              ?.details
                                              ?.videoLink?.trim() != '',
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            // width: _mainWidth*0.27,
                                            padding: EdgeInsets.only(
                                                left: _mainWidth * 0.03),
                                            child: GestureDetector(
                                                onTap: () async {
                                                  if (value.propertyDetailsModel
                                                              ?.data?.details !=
                                                          null &&
                                                      value
                                                              .propertyDetailsModel
                                                              ?.data
                                                              ?.details
                                                              ?.pic !=
                                                          null) {
                                                    Navigator.of(context).pushNamed(
                                                        AppRoutes
                                                            .propertyGalleryPage,
                                                        arguments: {
                                                          'fromVideo': true,
                                                          'videoLink': value
                                                              .propertyDetailsModel
                                                              ?.data
                                                              ?.details
                                                              ?.videoLink,
                                                          'imageList': value
                                                              .propertyDetailsModel
                                                              ?.data
                                                              ?.details
                                                              ?.pic,
                                                        });
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Video Tour',
                                                      style: TextStyle(
                                                          color: CustomTheme
                                                              .appThemeContrast,
                                                          fontFamily:
                                                              getThemeFont,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: getHeight(
                                                              context: context,
                                                              height: 12)),
                                                    ),
                                                    Icon(
                                                      Icons.play_arrow,
                                                      color: CustomTheme
                                                          .appThemeContrast,
                                                      size: _mainHeight * 0.025,
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: _mainHeight * 0.32,
                                        left: _mainWidth * 0.08,
                                        right: _mainWidth * 0.07,
                                        child: Material(
                                          elevation: 5,
                                          shadowColor: Colors.white,
                                          //color: Colors.white,
                                          child: Container(
                                            height: _mainHeight * 0.06,
                                            // margin: EdgeInsets.symmetric(horizontal: _mainWidth*0.05),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle),
                                            width: _mainWidth * 0.75,
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isDailyChecked = true;
                                                      isMonthlyChecked = false;
                                                      isLOngTermChecked = false;
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Spacer(),
                                                      Text(
                                                        '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[3].name :'Daily'}',
                                                        style: TextStyle(
                                                            color: CustomTheme
                                                                .appTheme,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                _mainWidth *
                                                                    0.045),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        height: 2,
                                                        width:
                                                            _mainWidth * 0.25,
                                                        color: isDailyChecked
                                                            ? CustomTheme
                                                                .appTheme
                                                            : Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isDailyChecked = false;
                                                      isMonthlyChecked = true;
                                                      isLOngTermChecked = false;
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Spacer(),
                                                      Text(
                                                        '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[4].name :'Monthly'}',
                                                        style: TextStyle(
                                                            color: CustomTheme
                                                                .appTheme,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                _mainWidth *
                                                                    0.045),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        height: 2,
                                                        width:
                                                            _mainWidth * 0.25,
                                                        color: isMonthlyChecked
                                                            ? CustomTheme
                                                                .appTheme
                                                            : Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: _mainWidth * 0.06,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isDailyChecked = false;
                                                      isMonthlyChecked = false;
                                                      isLOngTermChecked = true;
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Spacer(),
                                                      Text(
                                                        '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[5].name :'3+ Months'}',
                                                        style: TextStyle(
                                                            color: CustomTheme
                                                                .appTheme,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                _mainWidth *
                                                                    0.045),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        height: 2,
                                                        width:
                                                            _mainWidth * 0.25,
                                                        color: isLOngTermChecked
                                                            ? CustomTheme
                                                                .appTheme
                                                            : Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        bottomNavigationBar: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                RMSWidgets.showLoaderDialog(
                                    context: context, message: 'Loading...');
                                SharedPreferenceUtil sharedPreferenceUtil =
                                    SharedPreferenceUtil();
                                var name = (await sharedPreferenceUtil
                                            .getString(rms_name) ??
                                        '')
                                    .toString();
                                var email = (await sharedPreferenceUtil
                                            .getString(rms_email) ??
                                        '')
                                    .toString();
                                var phone = (await sharedPreferenceUtil
                                            .getString(rms_phoneNumber) ??
                                        '')
                                    .toString();
                                Navigator.of(context).pop();
                                _showDialog(
                                  propId: _viewModel.propertyDetailsModel?.data
                                          ?.details?.propId ??
                                      ' ',
                                  name: name,
                                  phone: phone,
                                  email: email,
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.white,
                                width: _mainWidth * 0.5,
                                height: _mainHeight * 0.06,
                                child: Text(
                                  '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[22].name :'Site Visit'}',
                                  style: TextStyle(
                                      color: CustomTheme.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if(_viewModel.propertyDetailsModel == null ||
                                    _viewModel.propertyDetailsModel?.data?.details?.bookable=="0")
                                {
                                  RMSWidgets.showSnackbar(context: context, message: "Sorry!!! This property is already booked", color: Colors.red);
                                }
                                else{
                                  if (_viewModel.propertyDetailsModel == null ||
                                      _viewModel.propertyDetailsModel?.data
                                          ?.details ==
                                          null) {
                                    RMSWidgets.showSnackbar(
                                        context: context,
                                        message:
                                        'Something went wrong. Property Details not Found.',
                                        color: CustomTheme.errorColor);
                                    return;
                                  }
                                  RMSWidgets.showLoaderDialog(
                                      context: context, message: 'Loading...');
                                  SharedPreferenceUtil sharedPreferenceUtil =
                                  SharedPreferenceUtil();
                                  var name = (await sharedPreferenceUtil
                                      .getString(rms_name) ??
                                      '')
                                      .toString();
                                  var email = (await sharedPreferenceUtil
                                      .getString(rms_email) ??
                                      '')
                                      .toString();
                                  var checkInDate=await sharedPreferenceUtil.getString(rms_checkInDate)??DateTimeService.ddMMYYYYformatDate(DateTime.now());
                                  var checkOutDate=await sharedPreferenceUtil.getString(rms_checkOutDate)??DateTimeService.ddMMYYYYformatDate(
                                      DateTime.now().add(const Duration(days: 1)));
                                  var formatedIn= DateTime.parse(checkInDate);
                                  var formatedOut= DateTime.parse(checkOutDate);
                                  int diff= formatedOut.difference(formatedIn).inDays;
                                  var bookingType= await sharedPreferenceUtil.getString(rms_BookingType);

                                  print("Llll  $bookingType");
                                  if(bookingType ==null ){
                                    print("kkk");
                                    if(diff<=29){
                                      print(".............1");
                                      await sharedPreferenceUtil.setString(rms_BookingType, "Daily");
                                    }
                                    else if(diff<=90 && diff>29){
                                      print("............2");
                                      await sharedPreferenceUtil.setString(rms_BookingType, "Short Term");
                                    }
                                    else if(diff>90 && diff>29){
                                      print("..........3");
                                      await sharedPreferenceUtil.setString(rms_BookingType, "Long Term");
                                    }
                                    else{
                                      print(".................4");
                                      await sharedPreferenceUtil.setString(rms_BookingType, " ");
                                    }
                                  }
                                  else{
                                    print("ijggyh");
                                  }
                                  var phone = (await sharedPreferenceUtil
                                      .getString(rms_phoneNumber) ??
                                      '')
                                      .toString();
                                  var token =
                                  (await sharedPreferenceUtil.getString(
                                      rms_registeredUserToken) ??
                                      '')
                                      .toString();

                                  Navigator.of(context).pop();
                                  List<int> guestList=[];
                                  for(int i=1;i <= int.parse(_viewModel
                                      .propertyDetailsModel
                                      ?.data
                                      ?.details
                                      ?.maxGuests ??
                                      '0');i++){
                                    guestList.add(i);
                                  }
                                  guestList.forEach(print);
                                  PropertyDetailsUtilModel model =
                                  PropertyDetailsUtilModel(
                                    name: name,
                                    email: email,
                                    mobile: phone,
                                    token: token,
                                    flexiRent: _viewModel.propertyDetailsModel?.data?.details?.monthlyRent,
                                    longTermRent: _viewModel.propertyDetailsModel?.data?.details?.rmsRent,
                                    guestList: guestList,
                                    bookingType: await preferenceUtil.getString(rms_BookingType),
                                    propId: int.parse((_viewModel
                                        .propertyDetailsModel
                                        ?.data
                                        ?.details
                                        ?.propId)
                                        .toString()),
                                    buildingName: (_viewModel.propertyDetailsModel
                                        ?.data?.details?.bname )
                                        .toString(),
                                    title: (_viewModel.propertyDetailsModel?.data
                                        ?.details?.title)
                                        .toString(),
                                    freeGuest: int.parse((_viewModel
                                        .propertyDetailsModel
                                        ?.data
                                        ?.details
                                        ?.freeGuests)
                                        .toString()),
                                    maxGuest: int.parse(_viewModel
                                        .propertyDetailsModel
                                        ?.data
                                        ?.details
                                        ?.maxGuests ??
                                        '0'),
                                  );
                                  Navigator.pushNamed(
                                      context, AppRoutes.bookingPage,
                                      arguments: model);
                                }
//                                 if (_viewModel.propertyDetailsModel == null ||
//                                     _viewModel.propertyDetailsModel?.data
//                                             ?.details ==
//                                         null) {
//                                   RMSWidgets.showSnackbar(
//                                       context: context,
//                                       message:
//                                           'Something went wrong. Property Details not Found.',
//                                       color: CustomTheme.errorColor);
//                                   return;
//                                 }
//                                 RMSWidgets.showLoaderDialog(
//                                     context: context, message: 'Loading...');
//                                 SharedPreferenceUtil sharedPreferenceUtil =
//                                     SharedPreferenceUtil();
//                                 var name = (await sharedPreferenceUtil
//                                             .getString(rms_name) ??
//                                         '')
//                                     .toString();
//                                 var email = (await sharedPreferenceUtil
//                                             .getString(rms_email) ??
//                                         '')
//                                     .toString();
//                                 var checkInDate=await sharedPreferenceUtil.getString(rms_checkInDate)??DateTimeService.ddMMYYYYformatDate(DateTime.now());
//                                 var checkOutDate=await sharedPreferenceUtil.getString(rms_checkOutDate)??DateTimeService.ddMMYYYYformatDate(
//                                     DateTime.now().add(const Duration(days: 1)));
//                             var formatedIn= DateTime.parse(checkInDate);
//                             var formatedOut= DateTime.parse(checkOutDate);
//                               int diff= formatedOut.difference(formatedIn).inDays;
//                               var bookingType= await sharedPreferenceUtil.getString(rms_BookingType);
//
//                               print("Llll  $bookingType");
//                               if(bookingType ==null ){
// print("kkk");
//                                 if(diff<=29){
//                                   print(".............1");
//                                   await sharedPreferenceUtil.setString(rms_BookingType, "Daily");
//                                 }
//                                 else if(diff<=90 && diff>29){
//                                   print("............2");
//                                   await sharedPreferenceUtil.setString(rms_BookingType, "Short Term");
//                                 }
//                                 else if(diff>90 && diff>29){
//                                   print("..........3");
//                                   await sharedPreferenceUtil.setString(rms_BookingType, "Long Term");
//                                 }
//                                 else{
//                                   print(".................4");
//                                   await sharedPreferenceUtil.setString(rms_BookingType, " ");
//                                 }
//                               }
// else{
//   print("ijggyh");
//                               }
//                                 var phone = (await sharedPreferenceUtil
//                                             .getString(rms_phoneNumber) ??
//                                         '')
//                                     .toString();
//                                 var token =
//                                     (await sharedPreferenceUtil.getString(
//                                                 rms_registeredUserToken) ??
//                                             '')
//                                         .toString();
//
//                                 Navigator.of(context).pop();
//                                 List<int> guestList=[];
//                                 for(int i=1;i <= int.parse(_viewModel
//                                     .propertyDetailsModel
//                                     ?.data
//                                     ?.details
//                                     ?.maxGuests ??
//                                     '0');i++){
//                                   guestList.add(i);
//                                 }
//                                 guestList.forEach(print);
//                                 PropertyDetailsUtilModel model =
//                                     PropertyDetailsUtilModel(
//                                   name: name,
//                                   email: email,
//                                   mobile: phone,
//                                   token: token,
//                                   flexiRent: _viewModel.propertyDetailsModel?.data?.details?.monthlyRent,
//                                   longTermRent: _viewModel.propertyDetailsModel?.data?.details?.rmsRent,
//                                   guestList: guestList,
//                                   bookingType: await preferenceUtil.getString(rms_BookingType),
//                                   propId: int.parse((_viewModel
//                                           .propertyDetailsModel
//                                           ?.data
//                                           ?.details
//                                           ?.propId)
//                                       .toString()),
//                                   buildingName: (_viewModel.propertyDetailsModel
//                                           ?.data?.details?.bname )
//                                       .toString(),
//                                   title: (_viewModel.propertyDetailsModel?.data
//                                           ?.details?.title)
//                                       .toString(),
//                                   freeGuest: int.parse((_viewModel
//                                           .propertyDetailsModel
//                                           ?.data
//                                           ?.details
//                                           ?.freeGuests)
//                                       .toString()),
//                                   maxGuest: int.parse(_viewModel
//                                           .propertyDetailsModel
//                                           ?.data
//                                           ?.details
//                                           ?.maxGuests ??
//                                       '0'),
//                                 );
//                                 Navigator.pushNamed(
//                                     context, AppRoutes.bookingPage,
//                                     arguments: model);
                              },
                              child: Container(
                                  width: _mainWidth * 0.5,
                                  height: _mainHeight * 0.06,
                                  alignment: Alignment.center,
                                  color: CustomTheme.appThemeContrast,
                                  child: Text(
                                    '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[23].name :'Book Now'}',
                                    style: TextStyle(
                                        color: CustomTheme.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ],
                        ),
                      )
                    : value.propertyDetailsModel != null &&
                            value.propertyDetailsModel?.msg != null &&
                            value.propertyDetailsModel?.data == null
                        ? Scaffold(
                            appBar: AppBar(
                              backgroundColor: CustomTheme.appTheme,
                            ),
                            body: Center(
                                child: RMSWidgets.someError(
                              context: context,
                            )),
                          )
                        : Scaffold(
                            appBar: AppBar(
                              backgroundColor: CustomTheme.appTheme,
                            ),
                            body: Center(
                              child: RMSWidgets.getLoader(),
                            ),
                          ),
              );
            },
          )
        : RMSWidgets.networkErrorPage(context: context);
  }

  Widget _getRoomDetails({required PropertyDetailsViewModel value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            /*   const Icon(
              Icons.person_outline_outlined,
              size: 20,
              color: Colors.black38,
            ),*/
            Image.asset(
              Images.personIcon,
            ),
            Text(
              value.propertyDetailsModel?.data?.details != null &&
                      value.propertyDetailsModel?.data?.details?.maxGuests !=
                          null
                  ? (value.propertyDetailsModel?.data?.details?.maxGuests)
                          .toString() +
                  ' ${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[10].name :' Guest'}'
                  : ' ',
              style: TextStyle(
                  fontSize: getHeight(context: context, height: 12),
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Column(
          children: [
            /*  const Icon(
              Icons.bed_rounded,
              size: 20,
              color: Colors.black38,
            ),*/
            Image.asset(Images.bedroomIcon),
            Text(
              value.propertyDetailsModel?.data?.details != null &&
                      value.propertyDetailsModel?.data?.details?.bedrooms !=
                          null
                  ? (value.propertyDetailsModel?.data?.details?.bedrooms)
                          .toString() +
                  ' ${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[11].name :' BedRoom'}'
                  : ' ',
              style: TextStyle(
                  fontSize: getHeight(context: context, height: 12),
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Column(
          children: [
            /* const Icon(
              Icons.bathroom_outlined,
              size: 20,
              color: Colors.black38,
            ),*/
            Image.asset(Images.bathroomIcon),
            Text(
              value.propertyDetailsModel?.data?.details != null &&
                      value.propertyDetailsModel?.data?.details?.bathrooms !=
                          null
                  ? (value.propertyDetailsModel?.data?.details?.bathrooms)
                          .toString() +
                  ' ${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[12].name : ' BathRoom'}'
                  : ' ',
              style: TextStyle(
                  fontSize: getHeight(context: context, height: 12),
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500),
            ),
          ],
        )
      ],
    );
  }

  List<String> get getReasonsList {
    return [
      'Family and Bachelor Friendly.',
      'Free Maintenance for first 30 days of stay(T&C).',
      'Free movement across any property in first 48hrs.',
      'No Brokerage and No maintenance charged.',
      'Rent for Short term or Long term.'
    ];
  }

  Widget _getRentView(
      {required BuildContext context,
      PropertyDetailsModel? model,
      required PropertyDetailsViewModel value}) {
    if (isDailyChecked) {
      return Row(
        children: [
          Text(
            '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[6].name :'Rent'} : ',
            style: TextStyle(
                fontSize: getHeight(context: context, height: 16), color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            model?.data?.details != null &&
                    model?.data?.details?.rent != null &&
                    model?.data?.details?.rent != 0
                ? '$rupee ${model?.data?.details?.rent}'
                : 'Unavailable',
            style: TextStyle(
                fontSize: getHeight(context: context, height: 16), color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else if (isMonthlyChecked) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[6].name :'Rent'} : ',
            style: TextStyle(
                fontSize: getHeight(context: context, height: 16), color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            model?.data != null &&
                    model?.data?.details != null &&
                    model?.data?.details?.monthlyRent != null
                ? '$rupee ${model?.data?.details?.monthlyRent}'
                : ' ',
            style: TextStyle(
                fontSize: getHeight(context: context, height: 16), color: Colors.black, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Text(
            '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[7].name :'Deposit'} : ',
            style: TextStyle(
                fontSize: getHeight(context: context, height: 16), color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            '$rupee 10000',
            style: TextStyle(
                fontSize: getHeight(context: context, height: 16), color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[6].name :'Rent'} : ',
            style: TextStyle(
                fontSize: getHeight(context: context, height: 16), color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            model?.data != null &&
                    model?.data?.details != null &&
                    model?.data != null &&
                    model?.data?.details?.rmsRent != null
                ? '$rupee ${model?.data?.details?.rmsRent}'
                : ' ',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Text(
            '${nullCheck(list: value.propertyDetailsLang) ? value.propertyDetailsLang[7].name :'Deposit'} : ',
            style: TextStyle(
                fontSize: getHeight(context: context, height: 16), color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            model?.data != null &&
                    model?.data?.details != null &&
                    model?.data?.details?.rmsDeposit != null
                ? '$rupee ${model?.data?.details?.rmsDeposit}'
                : ' ',
            style: TextStyle(
                fontSize: getHeight(context: context, height: 16), color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ],
      );
    }
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Web_View_Container(url, title)),
    );
  }

  Widget getAvailableAmenities({required List<AmenitiesModel> list}) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      // physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: _mainHeight * 0.03,
              width: _mainWidth * 0.08,
              //  padding: EdgeInsets.only(right: _mainWidth * 0.02),
              child: CachedNetworkImage(
                imageUrl: list[index].imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                    child: Container(
                      height: _mainHeight * 0.03,
                      width: _mainWidth * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        // borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    baseColor: Colors.grey[200] as Color,
                    highlightColor: Colors.grey[350] as Color),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(
              height: _mainHeight * 0.01,
            ),
            Text(
              list[index].name.toString(),
              style: TextStyle(
                  color: CustomTheme.appThemeContrast,
                  fontWeight: FontWeight.w500,
                  fontSize: getHeight(context: context, height: 14)),
            ),
          ],
        );
      },
      itemCount: list.length,
      separatorBuilder: (_, __) => SizedBox(
        width: 10,
      ),
    );
  }






  Widget getAvailableNotAmenities({required List<NoAmenitiesModel> list}) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      // physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: _mainHeight * 0.03,
              width: _mainWidth * 0.08,
              //  padding: EdgeInsets.only(right: _mainWidth * 0.02),
              child: CachedNetworkImage(
                imageUrl: list[index].imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                    child: Container(
                      height: _mainHeight * 0.03,
                      width: _mainWidth * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        // borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    baseColor: Colors.grey[200] as Color,
                    highlightColor: Colors.grey[350] as Color),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(
              height: _mainHeight * 0.01,
            ),
            Text(
              list[index].name.toString(),
              style: TextStyle(
                  color: CustomTheme.appThemeContrast,
                  fontWeight: FontWeight.w500,
                  fontSize: getHeight(context: context, height: 14)),
            ),
          ],
        );
      },
      itemCount: list.length,
      separatorBuilder: (_, __) => SizedBox(
        width: 10,
      ),
    );
  }





  void _showDialog(
      {required String propId,
      required String name,
      required String phone,
      required String email}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ChangeNotifierProvider(
              create: (_) => PropertyDetailsViewModel(),
              child: SiteVisitPage(
                  propId: propId, email: email, phoneNumber: phone, name: name),
            ));
  }

  Widget _getSimilarProperties(
      {required BuildContext context,
      required PropertyDetailsViewModel model}) {
    return Container(
      height: _mainHeight * 0.26,
      decoration: BoxDecoration(
        //  color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: getHeadingPadding,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final data = model.propertyDetailsModel?.data?.similarProp != null && model.propertyDetailsModel?.data?.similarProp!.length != 0 ?model.propertyDetailsModel?.data?.similarProp![index] as SimilarProp :
              SimilarProp();
          return InkWell(
            onTap: () => Navigator.of(context)
                .pushNamed(AppRoutes.propertyDetailsPage, arguments: {
              'propId': data.propId,
              'fromExternalLink': false,
            }),
            child: Stack(
              children: [
                Card(
                  elevation: 2,
                  child: Container(
                      width: _mainWidth * 0.42,
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: data.picThumbnail.toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              height: _mainHeight * 0.125,
                              //width: _mainWidth * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                                child: Container(
                                  height: _mainHeight * 0.125,
                                  color: Colors.grey,
                                ),
                                baseColor: Colors.grey[200] as Color,
                                highlightColor: Colors.grey[350] as Color),
                            errorWidget: (context, url, error) =>
                                Container(
                                    alignment: Alignment.center,
                                    height: _mainHeight * 0.125,
                                    child: const Icon(Icons.error)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: _mainWidth * 0.01,
                                    right: _mainWidth * 0.01,
                                    top: _mainHeight * 0.005),

                                child: Text(

                                  '${data.unitType ??''} - ${data.propType ??''}',
                                  style: TextStyle(
                                      fontSize: getHeight(
                                          context: context, height: 12),
                                      color: CustomTheme.appTheme,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: _mainWidth * 0.01,
                                    right: _mainWidth * 0.01,
                                    top: _mainHeight * 0.005),
                                child: Row(
                                  children: [
                                    Icon(Icons.home,color:Colors.grey ,size: _mainHeight*0.015,),
                                    SizedBox(width: _mainWidth*0.01,),
                                    Container(
                                      width: _mainWidth*0.35,
                                      child: Text(
                                        data.buildingName != null
                                            ? data.buildingName.toString()
                                            : '',
                                        style: TextStyle(
                                          fontSize: getHeight(
                                              context: context, height: 12),
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: _mainWidth * 0.01,
                                    right: _mainWidth * 0.01,
                                    top: _mainHeight * 0.005),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      Images.locationIcon,
                                      height: _mainHeight * 0.01,
                                      width: _mainWidth * 0.03,
                                    ),
                                    SizedBox(width: _mainWidth*0.01,),
                                    Container(
                                      width: _mainWidth*0.35,
                                      child: Text(
                                        data.area != null && data.area?.trim() != '' ?'${data.area}':'Bangalore',
                                        style: TextStyle(
                                          fontSize: getHeight(
                                              context: context, height: 12),
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: _mainWidth * 0.01,
                                    right: _mainWidth * 0.01,
                                    top: _mainHeight * 0.005),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: _mainWidth * 0.13,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                          right: _mainWidth * 0.01,
                                          top: _mainHeight * 0.003),
                                      child: FittedBox(
                                        child: Text(
                                          data.monthlyRent != null
                                              ? rupee + ' ${data.monthlyRent}'
                                              : '',
                                          style: TextStyle(
                                            fontSize: getHeight(
                                                context: context, height: 12),
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: _mainWidth * 0.005,
                                    ),
                                    showOrgPrice(
                                        monthlyRent:
                                        data.monthlyRent ?? '0',
                                        orgRent: data.orgMonthRent ?? '0')
                                        ? Container()
                                        : Container(
                                      width: _mainWidth * 0.1,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                          right: _mainWidth * 0.01,
                                          top: _mainHeight * 0.003),
                                      child: FittedBox(
                                        child: Text(
                                          data.orgMonthRent != null
                                              ? rupee +
                                              '${data.orgMonthRent}'
                                              : '',
                                          style: TextStyle(
                                            fontSize: getHeight(
                                                context: context,
                                                height: 10),
                                            color: Colors.grey,
                                            decoration: TextDecoration
                                                .lineThrough,
                                            fontWeight: FontWeight.w600,

                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: _mainWidth * 0.005,
                                    ),
                                    /*data.monthRentOff != null &&
                                              data.monthRentOff.toString() !=
                                                  '0'
                                          ? Container(
                                              width: _mainWidth * 0.15,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                  right: _mainWidth * 0.01,
                                                  top: _mainHeight * 0.003),
                                              child: FittedBox(
                                                child: Text(
                                                  '${data.monthRentOff.toString()}% OFF',
                                                  style: TextStyle(
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 12),
                                                    color:
                                                        CustomTheme.myFavColor,
                                                    fontWeight: FontWeight.w600,

                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),*/
                                    Container(
                                      width: _mainWidth * 0.15,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                          right: _mainWidth * 0.01,
                                          top: _mainHeight * 0.003),
                                      child: FittedBox(
                                        child: Text(
                                          ' ( < 3 Month )',
                                          style: TextStyle(
                                            fontSize: getHeight(
                                                context: context,
                                                height: 12),
                                            color:
                                            CustomTheme.myFavColor,
                                            fontWeight: FontWeight.w600,

                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: _mainWidth * 0.01,
                                    right: _mainWidth * 0.01,
                                    top: _mainHeight * 0.005),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: _mainWidth * 0.13,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                          right: _mainWidth * 0.01,
                                          top: _mainHeight * 0.003),
                                      child: FittedBox(
                                        child: Text(
                                          data.rmsRent != null
                                              ? rupee + ' ${data.rmsRent}'
                                              : '',
                                          style: TextStyle(
                                            fontSize: getHeight(
                                                context: context, height: 12),
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: _mainWidth * 0.005,
                                    ),
                                    showOrgPrice(
                                        monthlyRent:
                                        data.rmsRent ?? '0',
                                        orgRent: data.rmsRent ?? '0')
                                        ? Container()
                                        : Container(
                                      width: _mainWidth * 0.1,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                          right: _mainWidth * 0.01,
                                          top: _mainHeight * 0.003),
                                      child: FittedBox(
                                        child: Text(
                                          data.orgRmsRent != null
                                              ? rupee +
                                              '${data.orgRmsRent}'
                                              : '',
                                          style: TextStyle(
                                            fontSize: getHeight(
                                                context: context,
                                                height: 10),
                                            color: Colors.grey,
                                            decoration: TextDecoration
                                                .lineThrough,
                                            fontWeight: FontWeight.w600,

                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: _mainWidth * 0.005,
                                    ),
                                    /*data.monthRentOff != null &&
                                              data.monthRentOff.toString() !=
                                                  '0'
                                          ? Container(
                                              width: _mainWidth * 0.15,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                  right: _mainWidth * 0.01,
                                                  top: _mainHeight * 0.003),
                                              child: FittedBox(
                                                child: Text(
                                                  '${data.monthRentOff.toString()}% OFF',
                                                  style: TextStyle(
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 12),
                                                    color:
                                                        CustomTheme.myFavColor,
                                                    fontWeight: FontWeight.w600,

                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),*/
                                    Container(
                                      width: _mainWidth * 0.15,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                          right: _mainWidth * 0.01,
                                          top: _mainHeight * 0.003),
                                      child: FittedBox(
                                        child: Text(
                                          ' ( > 3 Month )',
                                          style: TextStyle(
                                            fontSize: getHeight(
                                                context: context,
                                                height: 12),
                                            color:
                                            CustomTheme.myFavColor,
                                            fontWeight: FontWeight.w600,

                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                Positioned(
                    right: _mainHeight * 0.015,
                    top: _mainHeight * 0.01,
                    child: GestureDetector(
                      onTap: () async {
                        if (data.wishlist != null &&
                            data.wishlist ==
                                1) {
                          if (data.propId !=
                                  null) {
                            int response = await _viewModel
                                .addToWishlist(
                              context: context,
                                propertyId: data.propId ??
                                    '');
                            if (response == 200) {
                              setState(() {
                                data.wishlist = 0;
                              });
                              RMSWidgets.showSnackbar(
                                  context: context,
                                  message:
                                  'Successfully Removed From Wishlist',
                                  color: CustomTheme
                                      .appTheme);
                            }
                          }
                        } else if (data.wishlist ==
                                0) {
                          if (data.propId !=
                                  null) {
                            int response = await _viewModel
                                .addToWishlist(
                              context: context,
                                propertyId: data.propId ??
                                    '');
                            if (response == 200) {
                              setState(() {
                                data.wishlist = 1;
                              });
                              RMSWidgets.showSnackbar(
                                  context: context,
                                  message:
                                  'Successfully Added to Wishlist',
                                  color: CustomTheme
                                      .appTheme);
                            }
                          }
                        }
                      },
                      child: data.wishlist ==
                              1
                          ? Icon(
                        Icons.favorite,
                        color: CustomTheme
                            .errorColor,
                      )
                          : Icon(
                        Icons
                            .favorite_outline_rounded,
                        color: CustomTheme
                            .white,
                      ),
                    ),)
              ],
            ),
          );
        },
        itemCount: model.propertyDetailsModel?.data?.similarProp?.length ?? 0,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  bool showOrgPrice(
      {required String monthlyRent, required String orgRent}) {
    if (orgRent == '0') {
      return true;
    }
    return orgRent != '0' &&
        monthlyRent != '0' &&
        (monthlyRent.toString() == orgRent.toString());
  }

  TextStyle get getHeadingStyle => TextStyle(
      color: CustomTheme.appTheme,
      fontSize: getHeight(context: context, height: 16),
      fontWeight: FontWeight.w500);

  EdgeInsets get getHeadingPadding =>
      EdgeInsets.only(left: _mainWidth * 0.03, right: _mainWidth * 0.03);
}

class NearbyFacilities extends StatefulWidget {
  final List<NearBy> nearByList;

  const NearbyFacilities({Key? key, required this.nearByList})
      : super(key: key);

  @override
  State<NearbyFacilities> createState() => _NearbyFacilitiesState();
}

class _NearbyFacilitiesState extends State<NearbyFacilities> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: widget.nearByList.length,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 00,
            backgroundColor: Colors.white,
            bottom: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: CustomTheme.appThemeContrast,
              labelColor: CustomTheme.appThemeContrast,
              tabs:
                  getTabs(context: context, tabCount: widget.nearByList.length),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: TabBarView(
              children: getTabBarWidgets(
                  context: context, tabCount: widget.nearByList.length),
            ),
          ),
        ));
  }

  List<Tab> getTabs({required BuildContext context, required int tabCount}) {
    List<Tab> tabList = [];
    for (int i = 0; i < widget.nearByList.length; i++) {
      tabList.add(Tab(
        child: Text(
          widget.nearByList[i].placeType ?? 'Popular Places Near By',
          style: TextStyle(
            fontSize: getHeight(context: context, height: 14),
          ),
        ),
      ));
    }
    return tabList;
  }

  List<Widget> getTabBarWidgets(
      {required BuildContext context, required int tabCount}) {
    List<Tab> tabList = [];
    for (int i = 0; i < widget.nearByList.length; i++) {
      tabList.add(Tab(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: const EdgeInsets.only(top: 5),
            child: ListTileTheme.merge(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  var data = widget.nearByList[i].placeList != null &&
                          widget.nearByList[i].placeList!.isNotEmpty
                      ? widget.nearByList[i].placeList![index]
                      : PlaceList();
                  return Container(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03,
                      right: MediaQuery.of(context).size.width * 0.03,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          child: Text(
                            data.placeTitle ?? '',
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: getHeight(context: context, height: 12),
                                color: Colors.grey.shade600),
                          ),
                        ),
                        const Spacer(),
                        data.distance != null && data.distance.toString() != '0'
                            ? Text(
                                '${data.distance ?? ''} Km',
                                style: TextStyle(
                                    fontSize:
                                        getHeight(context: context, height: 12),
                                    color: Colors.grey.shade600),
                              )
                            : Container(),
                      ],
                    ),
                  );
                },
                itemCount: widget.nearByList[i].placeList != null &&
                        widget.nearByList[i].placeList!.isNotEmpty
                    ? widget.nearByList[i].placeList!.length
                    : 0,
                separatorBuilder: (_, __) => SizedBox(
                  height: 5,
                ),
              ),
            ),
          ),
        ],
      )));
    }
    return tabList;
  }
}


class AmmentitiesTab extends StatefulWidget {
  List<AmenitiesModel> amenities;
  List<NoAmenitiesModel> noAmenities;
 AmmentitiesTab({required this.amenities,required this.noAmenities});

  @override
  State<AmmentitiesTab> createState() => _AmmentitiesTabState();
}

class _AmmentitiesTabState extends State<AmmentitiesTab> {
  var _mainHeight;
  var _mainWidth;
  @override
  Widget build(BuildContext context) {
    _mainWidth = MediaQuery.of(context).size.width;
    _mainHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 00,
          backgroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: CustomTheme.appThemeContrast,
            labelColor: CustomTheme.appThemeContrast,
            tabs:const [
              Text("Available Amenities"),
              Text("Non-Available Amenities"),
            ]

          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [

getAvailableAmenities(list: widget.amenities),
            getAvailableNotAmenities(list: widget.noAmenities)
          ],
        ),
      ),
    );
  }

  Widget getAvailableAmenities({required List<AmenitiesModel> list}) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      // physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                height: _mainHeight * 0.03,
                width: _mainWidth * 0.08,
                //  padding: EdgeInsets.only(right: _mainWidth * 0.02),
                child: CachedNetworkImage(
                  imageUrl: list[index].imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Shimmer.fromColors(
                      child: Container(
                        height: _mainHeight * 0.03,
                        width: _mainWidth * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          // borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      baseColor: Colors.grey[200] as Color,
                      highlightColor: Colors.grey[350] as Color),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                height: _mainHeight * 0.01,
              ),
              Text(
                list[index].name.toString(),
                style: TextStyle(
                    color: CustomTheme.appThemeContrast,
                    fontWeight: FontWeight.w500,
                    fontSize: getHeight(context: context, height: 14)),
              ),
            ],
          ),
        );
      },
      itemCount: list.length,
      separatorBuilder: (_, __) => SizedBox(
        width: 10,
      ),
    );
  }






  Widget getAvailableNotAmenities({required List<NoAmenitiesModel> list}) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      // physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Container(

                height: _mainHeight * 0.03,
                width: _mainWidth * 0.08,
                //  padding: EdgeInsets.only(right: _mainWidth * 0.02),
                child: CachedNetworkImage(
                  imageUrl: list[index].imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Shimmer.fromColors(
                      child: Container(
                        height: _mainHeight * 0.03,
                        width: _mainWidth * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          // borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      baseColor: Colors.grey[200] as Color,
                      highlightColor: Colors.grey[350] as Color),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                height: _mainHeight * 0.01,
              ),
              Text(
                list[index].name.toString(),
                style: TextStyle(
                    color: CustomTheme.appThemeContrast,
                    fontWeight: FontWeight.w500,
                    fontSize: getHeight(context: context, height: 14)),
              ),
            ],
          ),
        );
      },
      itemCount: list.length,
      separatorBuilder: (_, __) => SizedBox(
        width: 10,
      ),
    );
  }
}
