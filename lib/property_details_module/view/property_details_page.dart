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

import '../../theme/custom_theme.dart';
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
  static const String fontFamily = 'hk-grotest';
  bool dailyFlag = false;
  bool monthlyFlag = false;
  bool moreThanThreeFlag = true;
  ValueNotifier<bool> showPics = ValueNotifier(true);
  bool showAllAmenities = false;

  late PropertyDetailsViewModel _viewModel;
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
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _viewModel = Provider.of<PropertyDetailsViewModel>(context, listen: false);
    _viewModel.getPropertyDetails(propId: widget.propId);
    getLanguageData();
  }

  @override
  void dispose() {
    showPics.dispose();
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
    _mainWidth = MediaQuery
        .of(context)
        .size
        .width;
    _mainHeight = MediaQuery
        .of(context)
        .size
        .height;
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
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: BackButton(
                        onPressed: () =>
                        widget.fromExternalApi ? Navigator
                            .pushNamedAndRemoveUntil(context,
                            AppRoutes.dashboardPage, (route) => false) :
                            Navigator.pop(context),
                    ),
                    expandedHeight: _mainHeight * 0.30,
                    floating: true,
                    backgroundColor: CustomTheme.appTheme,

                    // pinned: true,
                    actions: [
                      GestureDetector(
                        onTap: () async {
                          if (value.propertyDetailsModel?.data
                              ?.details !=
                              null &&
                              value.propertyDetailsModel?.data
                                  ?.details?.wishlist ==
                                  1) {
                            if (value.propertyDetailsModel?.data
                                ?.details !=
                                null &&
                                value.propertyDetailsModel?.data
                                    ?.details?.propId !=
                                    null) {
                              int response =
                              await _viewModel.addToWishlist(
                                  propertyId: value
                                      .propertyDetailsModel
                                      ?.data
                                      ?.details
                                      ?.propId ??
                                      '');
                              if (response == 200) {
                                setState(() {
                                  value.propertyDetailsModel?.data
                                      ?.details?.wishlist = 0;
                                });
                                RMSWidgets.showSnackbar(
                                    context: context,
                                    message:
                                    'Successfully Removed From Wishlist',
                                    color: CustomTheme.appTheme);
                              }
                            }
                          } else if (value.propertyDetailsModel
                              ?.data?.details !=
                              null &&
                              value.propertyDetailsModel?.data
                                  ?.details?.wishlist ==
                                  0) {
                            if (value.propertyDetailsModel?.data
                                ?.details !=
                                null &&
                                value.propertyDetailsModel?.data
                                    ?.details?.propId !=
                                    null) {
                              int response =
                              await _viewModel.addToWishlist(
                                  propertyId: value
                                      .propertyDetailsModel
                                      ?.data
                                      ?.details
                                      ?.propId ??
                                      '');
                              if (response == 200) {
                                setState(() {
                                  value.propertyDetailsModel?.data
                                      ?.details?.wishlist = 1;
                                });
                                RMSWidgets.showSnackbar(
                                    context: context,
                                    message:
                                    'Successfully Added to Wishlist',
                                    color: CustomTheme.appTheme);
                              }
                            }
                          }
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            child: value.propertyDetailsModel?.data
                                ?.details !=
                                null &&
                                value.propertyDetailsModel?.data
                                    ?.details?.wishlist ==
                                    1
                                ? Icon(
                              Icons.favorite,
                              color: CustomTheme.appTheme,
                            )
                                : Icon(
                              Icons.favorite_outline_rounded,
                              color: CustomTheme.appTheme,
                            )),
                      ),
                      SizedBox(
                        width: 15,
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
                            backgroundColor: Colors.white,
                            radius: 15,
                            child: Icon(
                              Icons.share_outlined,
                              color: CustomTheme.appTheme,
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: ValueListenableBuilder(
                        builder: (context, bool data, child) {
                          return GestureDetector(
                            onTap: () {
                              if (value.propertyDetailsModel?.data
                                  ?.details !=
                                  null &&
                                  value.propertyDetailsModel?.data
                                      ?.details?.pic !=
                                      null) {
                                Navigator.of(context).pushNamed(
                                    AppRoutes.propertyGalleryPage,
                                    arguments: {
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
                            child: Visibility(
                              visible: data,
                              replacement: YoutubePlayerBuilder(
                                onEnterFullScreen: () {
                                  log('FullScreen');
                                },
                                player: YoutubePlayer(
                                  aspectRatio: 1.2,
                                  controller:
                                  value.youTubeController,
                                  showVideoProgressIndicator: true,
                                  topActions: const [
                                    Text(
                                      'Powered by RMS',
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                builder: (BuildContext context,
                                    Widget player) {
                                  return player;
                                },
                              ),
                              child: CarouselSlider(
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
                                    ?.map((e) =>
                                    CachedNetworkImage(
                                      imageUrl: e.picWp
                                          .toString(),
                                      imageBuilder:
                                          (context,
                                          imageProvider) =>
                                          Container(
                                            decoration:
                                            BoxDecoration(
                                              borderRadius: const BorderRadius
                                                  .only(
                                                  topLeft: Radius
                                                      .circular(
                                                      10),
                                                  topRight:
                                                  Radius.circular(
                                                      10)),
                                              image:
                                              DecorationImage(
                                                image:
                                                imageProvider,
                                                fit: BoxFit
                                                    .cover,
                                              ),
                                            ),
                                          ),
                                      placeholder: (context, url) =>
                                          Shimmer
                                              .fromColors(
                                              child:
                                              Container(
                                                height: _mainHeight *
                                                    0.3,
                                                color: Colors
                                                    .grey,
                                              ),
                                              baseColor:
                                              Colors.grey[200]
                                              as Color,
                                              highlightColor:
                                              Colors.grey[350]
                                              as Color),
                                      errorWidget: (context,
                                          url,
                                          error) =>
                                      const Icon(Icons
                                          .error),
                                    ))
                                    .toList() ??
                                    []
                                    : [Container()],
                                options: CarouselOptions(
                                    height: _mainHeight * 0.3,
                                    enlargeCenterPage: false,
                                    autoPlayInterval:
                                    const Duration(seconds: 3),
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    autoPlayCurve:
                                    Curves.decelerate,
                                    enableInfiniteScroll: true,
                                    viewportFraction: 1),
                              ),
                            ),
                          );
                        },
                        valueListenable: showPics,
                      ),
                      titlePadding: EdgeInsets.all(0),
                      title: Align(
                        alignment: Alignment.bottomLeft,
                        child: Visibility(
                          visible: value.propertyDetailsModel?.data
                              ?.details?.videoLink !=
                              '',
                          child: IconButton(
                            icon: value.propertyDetailsModel?.data
                                ?.shareLink !=
                                null &&
                                value.propertyDetailsModel?.data
                                    ?.shareLink
                                    ?.trim() !=
                                    ''
                                ? Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 20,
                            )
                                : Container(),
                            onPressed: value.propertyDetailsModel
                                ?.data?.shareLink !=
                                null &&
                                value.propertyDetailsModel?.data
                                    ?.shareLink
                                    ?.trim() !=
                                    ''
                                ? () {
                              showPics.value =
                              !showPics.value;
                              value.youTubeController.reset();
                            }
                                : () {},
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: EdgeInsets.only(
                            left: _mainWidth * 0.02,
                            right: _mainWidth * 0.02,
                          ),
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.02,
                            right: _mainWidth * 0.02,
                          ),
                          child: RichText(
                              text: TextSpan(
                                  text:
                                  '${nullCheck(list: value.propertyDetailsLang)
                                      ? value.propertyDetailsLang[0].name
                                      : 'Please note'} : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      fontFamily: fontFamily,
                                      color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                      '${nullCheck(
                                          list: value.propertyDetailsLang)
                                          ? value.propertyDetailsLang[1].name
                                          : 'The furniture and furnishings may appear different from what’s shown in the pictures. Dewan/sofa may be provided as available.'}',
                                      style: TextStyle(
                                        color: Color(0xff56596A),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: fontFamily,
                                      ),
                                    ),
                                  ])),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.015,
                        ),
                        Container(
                          //height: _mainHeight * 0.05,
                          margin: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.02,
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: _mainWidth * 0.8,
                                child: Column(
                                  children: [
                                    Text(
                                      value.propertyDetailsModel?.data
                                          ?.details !=
                                          null &&
                                          value
                                              .propertyDetailsModel
                                              ?.data
                                              ?.details
                                              ?.title !=
                                              null
                                          ? (value.propertyDetailsModel
                                          ?.data?.details?.title
                                          ?.trim())
                                          .toString()
                                          : '',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          value.propertyDetailsModel?.data
                                              ?.details !=
                                              null &&
                                              value
                                                  .propertyDetailsModel
                                                  ?.data
                                                  ?.details
                                                  ?.bname !=
                                                  null
                                              ? (value
                                              .propertyDetailsModel
                                              ?.data
                                              ?.details
                                              ?.bname)
                                              .toString()
                                              : '',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontFamily: fontFamily,
                                              fontWeight:
                                              FontWeight.w600),
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          value.propertyDetailsModel?.data
                                              ?.details !=
                                              null &&
                                              value
                                                  .propertyDetailsModel
                                                  ?.data
                                                  ?.details
                                                  ?.propId !=
                                                  null
                                              ? ' ( ${(value
                                              .propertyDetailsModel?.data
                                              ?.details?.propId)} )'
                                              .toString()
                                              : '',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontFamily: fontFamily,
                                              fontWeight:
                                              FontWeight.w600),
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                ),
                              ),
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
                                        latitude: latitude,
                                        longitude: longitude);
                                  }
                                },
                                child: Container(
                                  width: _mainWidth * 0.08,
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: CustomTheme.appTheme,
                                        size: _mainHeight * 0.02,
                                      ),
                                      Text(
                                        '${nullCheck(
                                            list: value.propertyDetailsLang)
                                            ? value.propertyDetailsLang[2].name
                                            : 'Map'}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: fontFamily,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        _getAmountView(
                            context: context,
                            model: value.propertyDetailsModel,
                            value: value),
                        const Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Icon(
                                  Icons.person_outline_outlined,
                                  size: 20,
                                  color: Colors.black38,
                                ),
                                Text(
                                  value.propertyDetailsModel?.data
                                      ?.details !=
                                      null &&
                                      value
                                          .propertyDetailsModel
                                          ?.data
                                          ?.details
                                          ?.maxGuests !=
                                          null
                                      ? (value
                                      .propertyDetailsModel
                                      ?.data
                                      ?.details
                                      ?.maxGuests)
                                      .toString() +
                                      '${nullCheck(
                                          list: value.propertyDetailsLang)
                                          ? value.propertyDetailsLang[10].name
                                          : ' Guest'}'
                                      : ' ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: fontFamily,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(
                                  Icons.bed_rounded,
                                  size: 20,
                                  color: Colors.black38,
                                ),
                                Text(
                                  value.propertyDetailsModel?.data
                                      ?.details !=
                                      null &&
                                      value
                                          .propertyDetailsModel
                                          ?.data
                                          ?.details
                                          ?.bedrooms !=
                                          null
                                      ? (value
                                      .propertyDetailsModel
                                      ?.data
                                      ?.details
                                      ?.bedrooms)
                                      .toString() +
                                      ' ${nullCheck(
                                          list: value.propertyDetailsLang)
                                          ? value.propertyDetailsLang[11].name
                                          : ' BedRoom'}'
                                      : ' ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: fontFamily,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(
                                  Icons.bathroom_outlined,
                                  size: 20,
                                  color: Colors.black38,
                                ),
                                Text(
                                  value.propertyDetailsModel?.data
                                      ?.details !=
                                      null &&
                                      value
                                          .propertyDetailsModel
                                          ?.data
                                          ?.details
                                          ?.bathrooms !=
                                          null
                                      ? (value
                                      .propertyDetailsModel
                                      ?.data
                                      ?.details
                                      ?.bathrooms)
                                      .toString() +
                                      ' ${nullCheck(
                                          list: value.propertyDetailsLang)
                                          ? value.propertyDetailsLang[12].name
                                          : ' BathRoom'}'
                                      : ' ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: fontFamily,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: _mainHeight * 0.015,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                          ),
                          child: Text(
                            '${nullCheck(list: value.propertyDetailsLang)
                                ? value.propertyDetailsLang[13].name
                                : 'Available Amenities'}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontFamily: fontFamily,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        getAvailableAmenities(
                            list: value.amenitiesList),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        value.amenitiesList.length > 5
                            ? GestureDetector(
                          onTap: () =>
                              setState(() {
                                showAllAmenities = !showAllAmenities;
                              }),
                          child: Container(
                            padding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                            ),
                            child: Text(
                              showAllAmenities
                                  ? 'View Less Amenities'
                                  : 'View All Amenities',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: fontFamily,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                            : Container(),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          height: _mainHeight * 0.03,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${nullCheck(list: value.propertyDetailsLang)
                                      ? value.propertyDetailsLang[14].name
                                      : 'Contact us'}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: fontFamily,
                                      color: Colors.black),
                                ),
                                Spacer(),
                                IconButton(
                                  padding: EdgeInsets.only(
                                      left: _mainWidth * 0.08),
                                  icon: Icon(
                                    Icons.call,
                                    color: CustomTheme.appTheme,
                                    size: _mainWidth * 0.03,
                                  ),
                                  onPressed: () {
                                    if (value.propertyDetailsModel !=
                                        null &&
                                        value.propertyDetailsModel?.data
                                            ?.details !=
                                            null &&
                                        value
                                            .propertyDetailsModel
                                            ?.data
                                            ?.details
                                            ?.salesNumber !=
                                            null) {
                                      launch(
                                          'tel:${value.propertyDetailsModel
                                              ?.data?.details?.salesNumber}');
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: _mainWidth * 0.02,
                                ),
                                IconButton(
                                  padding: EdgeInsets.only(
                                      left: _mainWidth * 0.06),
                                  icon: Image(
                                    height: _mainHeight * 0.1,
                                    width: _mainWidth * 0.03,
                                    image: NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/whatsapplogo.png?alt=media&token=41df11ff-b9e7-4f5b-a4fc-30b47cfe1435',
                                    ),
                                  ),

                                  /*Icon(Icons.email_outlined,
                                        color: CustomTheme.appTheme,
                                        size: _mainWidth * 0.06),

                                     */
                                  onPressed: () {
                                    if (value.propertyDetailsModel !=
                                        null &&
                                        value.propertyDetailsModel?.data
                                            ?.details !=
                                            null &&
                                        value
                                            .propertyDetailsModel
                                            ?.data
                                            ?.details
                                            ?.salesNumber !=
                                            null) {
                                      launch(
                                          'https://wa.me/${value
                                              .propertyDetailsModel?.data
                                              ?.details
                                              ?.salesNumber}?text=${value
                                              .propertyDetailsModel?.data
                                              ?.shareLink ?? 'Hello'}');
                                    }
                                  },
                                ),
                              ]),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          height: _mainHeight * 0.03,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${nullCheck(list: value.propertyDetailsLang)
                                      ? value.propertyDetailsLang[15].name
                                      : 'Select Date'}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: fontFamily,
                                      color: Colors.black),
                                ),
                                Container(
                                  child: GestureDetector(
                                    onTap: () async {
                                      PickerDateRange? dateRange =
                                      await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            CalenderPage(
                                                initialDatesRange:
                                                PickerDateRange(
                                                  DateTime.parse(checkInDate),
                                                  DateTime.parse(checkOutDate),
                                                )),
                                      ));
                                      if (dateRange != null) {
                                        setState(() {
                                          checkInDate = DateTimeService
                                              .ddMMYYYYformatDate(
                                              dateRange.startDate ??
                                                  DateTime.now());
                                          checkOutDate = DateTimeService
                                              .ddMMYYYYformatDate(
                                              dateRange.endDate ??
                                                  DateTime.now().add(
                                                      const Duration(
                                                          days:
                                                          1)));
                                        });
                                      }
                                      await preferenceUtil.setString(
                                          rms_checkInDate, checkInDate);
                                      await preferenceUtil.setString(
                                          rms_checkOutDate,
                                          checkOutDate);
                                    },
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: CustomTheme.appTheme,
                                      size: _mainWidth * 0.03,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          child: Text(
                            '${nullCheck(list: value.propertyDetailsLang)
                                ? value.propertyDetailsLang[16].name
                                : 'Details'}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                fontFamily: fontFamily,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          child: Html(
                            data: value.propertyDetailsModel?.data
                                ?.details !=
                                null &&
                                value.propertyDetailsModel?.data
                                    ?.details?.description !=
                                    null
                                ? (value.propertyDetailsModel?.data
                                ?.details?.description)
                                .toString()
                                : ' ',
                            style: {
                              "body": Style(
                                  fontSize: FontSize(12.0),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  wordSpacing: 0.5,
                                  display: Display.INLINE,
                                  fontFamily: fontFamily),
                            },
                          )

                          ,
                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          child: Text(
                            '${nullCheck(list: value.propertyDetailsLang)
                                ? value.propertyDetailsLang[17].name
                                : 'House Rules'}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                fontFamily: fontFamily,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        Container(
                            padding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                              right: _mainWidth * 0.04,
                            ),
                            child: Html(
                              data: value.propertyDetailsModel?.data
                                  ?.details !=
                                  null &&
                                  value.propertyDetailsModel?.data
                                      ?.details?.things2note !=
                                      null
                                  ? (value.propertyDetailsModel?.data
                                  ?.details?.things2note)
                                  .toString()
                                  : ' ',
                              style: {
                                "body": Style(
                                    fontSize: FontSize(12.0),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    wordSpacing: 0.5,
                                    display: Display.INLINE,
                                    fontFamily: fontFamily),
                              },
                            )

                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomTheme.appTheme,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: _mainHeight * 0.005,
                              ),
                              Text(
                                '${nullCheck(list: value.propertyDetailsLang)
                                    ? value.propertyDetailsLang[18].name
                                    : 'Five Reasons to Choose RentMyStay'}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    fontFamily: fontFamily,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: _mainHeight * 0.005,
                              ),
                              Text(
                                getMoreText,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontFamily: fontFamily,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        GestureDetector(
                          onTap: () =>
                              _handleURLButtonPress(
                                  context, faqUrl, 'FAQ'),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                              right: _mainWidth * 0.04,
                            ),
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${nullCheck(
                                        list: value.propertyDetailsLang) ? value
                                        .propertyDetailsLang[19].name : 'FAQ'}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        fontFamily: fontFamily,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    '${nullCheck(
                                        list: value.propertyDetailsLang)
                                        ? value.propertyDetailsLang[20].name
                                        : 'Read'}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        fontFamily: fontFamily,
                                        color: CustomTheme.appTheme),
                                  ),
                                ]),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Center(
                          child: Text(
                            '${nullCheck(list: value.propertyDetailsLang)
                                ? value.propertyDetailsLang[21].name
                                : 'Similar Properties'}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: fontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        _getSimilarProperties(
                            context: context, model: value),
                        SizedBox(
                          height: _mainHeight * 0.02,
                        ),
                      ]))
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: _mainHeight * 0.06,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: EdgeInsets.only(
                  left: _mainWidth * 0.02,
                  right: _mainWidth * 0.02,
                  bottom: _mainHeight * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: _mainWidth * 0.4,
                      height: _mainHeight * 0.05,
                      child: ElevatedButton(
                        onPressed: () async {
                          RMSWidgets.showLoaderDialog(
                              context: context,
                              message: 'Loading...');
                          SharedPreferenceUtil
                          sharedPreferenceUtil =
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
                            propId: value.propertyDetailsModel?.data
                                ?.details?.propId ??
                                ' ',
                            name: name,
                            phone: phone,
                            email: email,
                          );
                        },
                        child: Text(
                          '${nullCheck(list: value.propertyDetailsLang) ? value
                              .propertyDetailsLang[22].name : 'Site Visit'}',
                          style: TextStyle(
                              color: CustomTheme.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(
                            width: 1.0,
                            color: CustomTheme.appTheme,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        /*style:

                               ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          CustomTheme.appThemeContrast),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )), */
                      )),
                  Container(
                      width: _mainWidth * 0.4,
                      height: _mainHeight * 0.05,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (value.propertyDetailsModel == null ||
                              value.propertyDetailsModel?.data
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
                              context: context,
                              message: 'Loading...');
                          SharedPreferenceUtil
                          sharedPreferenceUtil =
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
                          var token =
                          (await sharedPreferenceUtil.getString(
                              rms_registeredUserToken) ??
                              '')
                              .toString();
                          Navigator.of(context).pop();
                          PropertyDetailsUtilModel model =
                          PropertyDetailsUtilModel(
                            name: name,
                            email: email,
                            mobile: phone,
                            token: token,
                            propId: int.parse((value
                                .propertyDetailsModel
                                ?.data
                                ?.details
                                ?.propId)
                                .toString()),
                            buildingName: (value
                                .propertyDetailsModel
                                ?.data
                                ?.details
                                ?.bname)
                                .toString(),
                            title: (value.propertyDetailsModel?.data
                                ?.details?.title)
                                .toString(),
                            freeGuest: int.parse((value
                                .propertyDetailsModel
                                ?.data
                                ?.details
                                ?.freeGuests)
                                .toString()),
                            maxGuest: int.parse(value
                                .propertyDetailsModel
                                ?.data
                                ?.details
                                ?.maxGuests ??
                                '0'),
                          );
                          Navigator.pushNamed(
                              context, AppRoutes.bookingPage,
                              arguments: model);
                        },
                        child: Text(
                          '${nullCheck(list: value.propertyDetailsLang) ? value
                              .propertyDetailsLang[23].name : 'Book Now'}',
                          style: TextStyle(
                              color: CustomTheme.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                                CustomTheme.appTheme),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10)),
                            )),
                      )),
                ],
              ),
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

  Widget getAvailableAmenities({required List<AmenitiesModel> list}) {
    return ListTileTheme.merge(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            mainAxisExtent: _mainHeight * 0.05),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(
              left: _mainWidth * 0.04,
            ),
            child: Row(
              children: [
                Container(
                  height: _mainHeight * 0.03,
                  width: _mainWidth * 0.08,
                  //  padding: EdgeInsets.only(right: _mainWidth * 0.02),
                  child: CachedNetworkImage(
                    imageUrl: list[index].imageUrl,
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                    placeholder: (context, url) =>
                        Shimmer.fromColors(
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
                    errorWidget: (context, url, error) =>
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(
                  width: _mainWidth * 0.03,
                ),
                Text(
                  list[index].name.toString(),
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: fontFamily,
                      fontSize: 14),
                ),
              ],
            ),
          );
        },
        itemCount: showAllAmenities
            ? list.length
            : list.length > 5
            ? 5
            : list.length,
      ),
    );
  }

  Widget _getAmountView({required BuildContext context,
    PropertyDetailsModel? model,
    required PropertyDetailsViewModel value}) {
    return Container(
        decoration: BoxDecoration(
          // color: Colors.amber,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.only(
          left: _mainWidth * 0.04,
          right: _mainWidth * 0.04,
        ),
        // height: _mainHeight * 0.17,
        width: _mainWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              //color: Colors.deepOrange,
              height: _mainHeight * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      if (dailyFlag) {
                        return;
                      } else if (monthlyFlag || moreThanThreeFlag) {
                        setState(() {
                          monthlyFlag = false;
                          moreThanThreeFlag = false;
                          dailyFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      decoration: BoxDecoration(
                          color: dailyFlag
                              ? CustomTheme.appTheme
                              : Colors.blueGrey.shade100,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          )),
                      child: Text(
                        '${nullCheck(list: value.propertyDetailsLang) ? value
                            .propertyDetailsLang[3].name : 'Daily'}',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamily,
                            color: dailyFlag ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (monthlyFlag) {
                        return;
                      } else if (dailyFlag || moreThanThreeFlag) {
                        setState(() {
                          dailyFlag = false;
                          moreThanThreeFlag = false;
                          monthlyFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      color: monthlyFlag
                          ? CustomTheme.appTheme
                          : Colors.blueGrey.shade100,
                      child: Text(
                        '${nullCheck(list: value.propertyDetailsLang) ? value
                            .propertyDetailsLang[4].name : 'Monthly'}',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamily,
                            color: monthlyFlag ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (moreThanThreeFlag) {
                        return;
                      } else if (dailyFlag || monthlyFlag) {
                        setState(() {
                          dailyFlag = false;
                          monthlyFlag = false;
                          moreThanThreeFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      decoration: BoxDecoration(
                          color: moreThanThreeFlag
                              ? CustomTheme.appTheme
                              : Colors.blueGrey.shade100,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: Text(
                        '${nullCheck(list: value.propertyDetailsLang) ? value
                            .propertyDetailsLang[5].name : '3+ Months'}',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamily,
                            color: moreThanThreeFlag
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _mainHeight * 0.015,
            ),
            _getRentView(context: context, model: model, value: value),
            SizedBox(
              height: _mainHeight * 0.01,
            ),
            Text(
              '${nullCheck(list: value.propertyDetailsLang)
                  ? value.propertyDetailsLang[8].name
                  : 'Free Cancellation within 24 hours of booking.Click here to view.'}',
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: fontFamily,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () =>
                  _handleURLButtonPress(
                      context, cancellationPolicyUrl, 'Cancellation Policy'),
              child: Text(
                '${nullCheck(list: value.propertyDetailsLang) ? value
                    .propertyDetailsLang[9].name : 'Cancellation Policy'}',
                style: const TextStyle(
                    color: Colors.orange,
                    fontFamily: fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ));
  }

  String get getMoreText {
    return """
1. Family and Bachelor Friendly.
2. Free Maintenance for first 30 days of stay(T&C).
3. Free movement across any property in first 48hrs.
4. No Brokerage and No maintenance charged.
5. Rent for Short term or Long term.
    """;
  }

  Widget _getSimilarProperties({required BuildContext context,
    required PropertyDetailsViewModel model}) {
    return Container(
      height: _mainHeight * 0.19,
      decoration: BoxDecoration(
        //  color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(
        left: _mainWidth * 0.04,
        right: _mainWidth * 0.04,
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final data = model.propertyDetailsModel?.data?.similarProp![index] ??
              SimilarProp();
          return InkWell(
            onTap: () =>
                Navigator.of(context)
                    .pushNamed(AppRoutes.propertyDetailsPage, arguments: {
                  'propId': data.propId,
                  'fromExternalLink': false,
                }),
            child: Card(
              elevation: 2,
              child: Container(
                  height: _mainHeight * 0.2,
                  width: _mainWidth * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: data.picThumbnail.toString(),
                        imageBuilder: (context, imageProvider) =>
                            Container(
                              height: _mainHeight * 0.125,
                              width: _mainWidth * 0.4,
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
                        placeholder: (context, url) =>
                            Shimmer.fromColors(
                                child: Container(
                                  height: _mainHeight * 0.13,
                                  color: Colors.grey,
                                ),
                                baseColor: Colors.grey[200] as Color,
                                highlightColor: Colors.grey[350] as Color),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: _mainWidth * 0.01,
                            right: _mainWidth * 0.01,
                            top: _mainHeight * 0.005),
                        child: Text(
                          data.title ?? '',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: fontFamily,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                                left: _mainWidth * 0.01,
                                top: _mainHeight * 0.003),
                            child: Text(
                              data.buildingName != null
                                  ? data.buildingName.toString()
                                  : '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,

                                //fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                                right: _mainWidth * 0.01,
                                top: _mainHeight * 0.003),
                            child: Text(
                              data.monthlyRent != null
                                  ? rupee + '${data.monthlyRent}'
                                  : '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w600,

                                //fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          );
        },
        itemCount: model.propertyDetailsModel?.data?.similarProp?.length ?? 0,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _getRentView({required BuildContext context,
    PropertyDetailsModel? model,
    required PropertyDetailsViewModel value}) {
    if (dailyFlag && (monthlyFlag == false && moreThanThreeFlag == false)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${nullCheck(list: value.propertyDetailsLang) ? value
                .propertyDetailsLang[6].name : 'Rent'}',
            style: const TextStyle(
                fontSize: 14,
                fontFamily: fontFamily,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
          Text(
            model?.data?.details != null &&
                model?.data?.details?.rent != null &&
                model?.data?.details?.rent != 0
                ? '$rupee ${model?.data?.details?.rent}'
                : 'Unavailable',
            style: TextStyle(
                fontSize: 14,
                fontFamily: fontFamily,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else if (monthlyFlag &&
        (dailyFlag == false && moreThanThreeFlag == false)) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${nullCheck(list: value.propertyDetailsLang) ? value
                    .propertyDetailsLang[6].name : 'Rent'}',
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                model?.data != null &&
                    model?.data?.details != null &&
                    model?.data?.details?.monthlyRent != null
                    ? '$rupee ${model?.data?.details?.monthlyRent}'
                    : ' ',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${nullCheck(list: value.propertyDetailsLang) ? value
                    .propertyDetailsLang[7].name : 'Deposit'}',
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '$rupee 10000',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${nullCheck(list: value.propertyDetailsLang) ? value
                    .propertyDetailsLang[6].name : 'Rent'}',
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                model?.data != null &&
                    model?.data?.details != null &&
                    model?.data != null &&
                    model?.data?.details?.rmsRent != null
                    ? '$rupee ${model?.data?.details?.rmsRent}'
                    : ' ',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Visibility(
            visible: !dailyFlag,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${nullCheck(list: value.propertyDetailsLang) ? value
                      .propertyDetailsLang[7].name : 'Deposit'}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamily,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  model?.data != null &&
                      model?.data?.details != null &&
                      model?.data?.details?.rmsDeposit != null
                      ? '$rupee ${model?.data?.details?.rmsDeposit}'
                      : ' ',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamily,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  void _showDialog({required String propId,
    required String name,
    required String phone,
    required String email}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ChangeNotifierProvider(
              create: (_) => PropertyDetailsViewModel(),
              child: SiteVisitPage(
                  propId: propId, email: email, phoneNumber: phone, name: name),
            ));
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Web_View_Container(url, title)),
    );
  }
}
