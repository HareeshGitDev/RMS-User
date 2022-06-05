import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/utils/constants/enum_consts.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../images.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/constants/sp_constants.dart';
import '../../language_module/model/language_model.dart';
import '../../utils/service/bottom_navigation_provider.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/system_service.dart';
import 'dart:math' as math;

class WishListPage extends StatefulWidget {
  final bool fromBottom;

  const WishListPage({Key? key, required this.fromBottom}) : super(key: key);

  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  var _mainHeight;
  var _mainWidth;
  late PropertyViewModel _propertyViewModel;
  static const String fontFamily = 'hk-grotest';
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
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _propertyViewModel = Provider.of<PropertyViewModel>(context, listen: false);
    _propertyViewModel.getWishList();
    getLanguageData();
  }

  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }

  getLanguageData() async {
    await _propertyViewModel.getWishListedLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'WishlistPage');
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus == true
        ? Consumer<PropertyViewModel>(
            builder: (context, value, child) {
              if (value.wishListModel.msg != null &&
                  value.wishListModel.data != null &&
                  value.wishListModel.data!.isNotEmpty) {
                return Scaffold(
                  appBar: _getAppBar(context: context, value: value),
                  body: Container(
                    color: Colors.white,
                    height: _mainHeight,
                    width: _mainWidth,
                    padding: EdgeInsets.only(
                        left: _mainWidth * 0.03,
                        right: _mainWidth * 0.03,
                        top: _mainHeight * 0.01,
                        bottom: _mainHeight * 0.01),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        var data = value.wishListModel.data![index];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              AppRoutes.propertyDetailsPage,
                              arguments: {
                                'propId':data.propId,
                                'fromExternalLink':false,
                              }),
                          child: Card(
                            elevation: 4,
                            shadowColor: CustomTheme.appTheme,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CarouselSlider(
                                      items: data.pic
                                              ?.map((e) => CachedNetworkImage(
                                                    imageUrl:
                                                        e.picLink.toString(),
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Shimmer.fromColors(
                                                            child: Container(
                                                              height:
                                                                  _mainHeight *
                                                                      0.27,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            baseColor:
                                                                Colors.grey[200]
                                                                    as Color,
                                                            highlightColor:
                                                                Colors.grey[350]
                                                                    as Color),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ))
                                              .toList() ??
                                          [],
                                      options: CarouselOptions(
                                          height: _mainHeight * 0.27,
                                          enlargeCenterPage: true,
                                          autoPlay: true,
                                          aspectRatio: 16 / 9,
                                          autoPlayInterval: Duration(
                                              milliseconds:
                                                  math.Random().nextInt(6000) +
                                                      1500),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enableInfiniteScroll: true,
                                          viewportFraction: 1),
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.01,
                                    ),
                                    Visibility(
                                      child: Container(
                                        height: _mainHeight * 0.025,
                                        padding: EdgeInsets.only(
                                            left: _mainWidth * 0.02,
                                            right: _mainWidth * 0.02),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.home_work_outlined,
                                              color: CustomTheme.appTheme,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                data.buildingName ?? " ",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              data.unitType ?? " ",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                      ),
                                      visible: data.rmsProp != null &&
                                          data.rmsProp == "RMS Prop",
                                    ),
                                    Visibility(
                                      visible: data.rmsProp != null &&
                                          data.rmsProp == "RMS Prop",
                                      child: Container(
                                        child: const Text(
                                          'Multiple Units Available',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              fontFamily: fontFamily),
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(
                                            right: _mainWidth * 0.02),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: _mainWidth * 0.02),
                                      width: _mainWidth * 0.75,
                                      child: Text(
                                        data.title ?? " ",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: fontFamily,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if ((data.glat != null) &&
                                            (data.glng != null)) {
                                          var latitude = (data.glat).toString();
                                          var longitude =
                                              (data.glng).toString();
                                          await SystemService.launchGoogleMaps(
                                              latitude: latitude,
                                              longitude: longitude);
                                        }
                                      },
                                      child: Container(
                                        width: _mainWidth,
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: _mainWidth * 0.02,
                                                  top: _mainHeight * 0.005),
                                              child: RichText(
                                                text: TextSpan(children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color:
                                                          CustomTheme.appTheme,
                                                      size: _mainHeight * 0.02,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: (data.areas ??
                                                            data.city) ??
                                                        " ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: fontFamily,
                                                        fontSize: 12),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.007,
                                    ),
                                    Divider(
                                      color: CustomTheme.appTheme,
                                      height: 1,
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.007,
                                    ),
                                    FittedBox(
                                      child: Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            Visibility(
                                              visible: data.rent != null &&
                                                  data.rent != "0",
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: _mainWidth * 0.02,
                                                      right: _mainWidth * 0.02),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Rent Per Day',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      data.orgRent == data.rent
                                                          ? Text(
                                                              ' $rupee ${data.rent ?? " "}',
                                                              style: TextStyle(
                                                                  color: CustomTheme
                                                                      .appTheme,
                                                                  fontFamily:
                                                                      fontFamily,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 14))
                                                          : RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                            '$rupee ${data.orgRent ?? " "}',
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            fontFamily:
                                                                                fontFamily,
                                                                            decoration:
                                                                                TextDecoration.lineThrough)),
                                                                    TextSpan(
                                                                        text:
                                                                            ' $rupee ${data.rent ?? " "}',
                                                                        style: TextStyle(
                                                                            color: CustomTheme
                                                                                .appTheme,
                                                                            fontFamily:
                                                                                fontFamily,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontSize: 14)),
                                                                  ]),
                                                            ),
                                                    ],
                                                  )),
                                            ),
                                            Visibility(
                                              visible: data.rent != null &&
                                                  data.rent != "0",
                                              child: SizedBox(
                                                height: _mainHeight * 0.03,
                                                child: VerticalDivider(
                                                  color: CustomTheme.appTheme,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: _mainWidth * 0.02,
                                                    right: _mainWidth * 0.02),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Rent (Stay < 3 Month)',
                                                      style: TextStyle(
                                                        fontFamily: fontFamily,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    data.orgMonthRent ==
                                                            data.monthlyRent
                                                        ? Text(
                                                            ' $rupee ${data.monthlyRent ?? " "}',
                                                            style: TextStyle(
                                                                color: CustomTheme
                                                                    .appTheme,
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14))
                                                        : RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                          '$rupee ${data.orgMonthRent ?? " "}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              fontFamily,
                                                                          decoration:
                                                                              TextDecoration.lineThrough)),
                                                                  TextSpan(
                                                                      text:
                                                                          ' $rupee ${data.monthlyRent ?? " "}',
                                                                      style: TextStyle(
                                                                          color: CustomTheme
                                                                              .appTheme,
                                                                          fontFamily:
                                                                              fontFamily,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              14)),
                                                                ]),
                                                          ),
                                                  ],
                                                )),
                                            SizedBox(
                                              height: _mainHeight * 0.03,
                                              child: VerticalDivider(
                                                color: CustomTheme.appTheme,
                                              ),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: _mainWidth * 0.02,
                                                    right: _mainWidth * 0.02),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Rent (Stay > 3 Month)',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              fontFamily,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                    data.orgRmsRent ==
                                                            data.rmsRent
                                                        ? Text(
                                                            ' $rupee ${data.rmsRent ?? " "}',
                                                            style: TextStyle(
                                                                color: CustomTheme
                                                                    .appTheme,
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14))
                                                        : RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                          '$rupee ${data.orgRmsRent ?? " "}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              fontFamily,
                                                                          decoration:
                                                                              TextDecoration.lineThrough)),
                                                                  TextSpan(
                                                                      text:
                                                                          ' $rupee ${data.rmsRent ?? " "}',
                                                                      style: TextStyle(
                                                                          color: CustomTheme
                                                                              .appTheme,
                                                                          fontFamily:
                                                                              fontFamily,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              14)),
                                                                ]),
                                                          ),
                                                  ],
                                                )),
                                          ],
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: _mainHeight * 0.05,
                                  width: _mainWidth,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: data.rmsProp != null &&
                                            data.rmsProp == "RMS Prop",
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              right: _mainWidth * 0.02),
                                          decoration: BoxDecoration(
                                              color: Colors.white60,
                                              border: Border.all(
                                                  color: CustomTheme.appTheme),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(children: [
                                            CircleAvatar(
                                                radius: _mainHeight * 0.012,
                                                backgroundColor:
                                                    CustomTheme.appTheme,
                                                child: Icon(
                                                  Icons.check,
                                                  size: _mainHeight * 0.017,
                                                  color: Colors.white,
                                                )),
                                            SizedBox(
                                              width: _mainWidth * 0.01,
                                            ),
                                            Text(
                                              '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[1].name : 'Managed by RMS'}',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          if (data.wishlist == 1) {
                                            if (data.propId != null) {
                                              int response =
                                                  await _propertyViewModel
                                                      .addToWishlist(
                                                          propertyId:
                                                              data.propId ??
                                                                  '');
                                              if (response == 200) {
                                                setState(() {
                                                  data.wishlist = 0;
                                                });
                                                RMSWidgets.showSnackbar(
                                                    context: context,
                                                    message:
                                                        'Successfully Removed From Wishlist',
                                                    color:
                                                        CustomTheme.appTheme);
                                              }
                                            }
                                          } else if (data.wishlist == 0) {
                                            if (data.propId != null) {
                                              int response =
                                                  await _propertyViewModel
                                                      .addToWishlist(
                                                          propertyId:
                                                              data.propId ??
                                                                  '');
                                              if (response == 200) {
                                                setState(() {
                                                  data.wishlist = 1;
                                                });
                                                RMSWidgets.showSnackbar(
                                                    context: context,
                                                    message:
                                                        'Successfully Added to Wishlist',
                                                    color:
                                                        CustomTheme.appTheme);
                                              }
                                            }
                                          }
                                        },
                                        child: CircleAvatar(
                                            backgroundColor: Colors.white60,
                                            radius: 15,
                                            child: data.wishlist == 1
                                                ? Icon(
                                                    Icons.favorite,
                                                    color: CustomTheme.appTheme,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .favorite_outline_rounded,
                                                    color: CustomTheme.appTheme,
                                                  )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: value.wishListModel.data?.length ?? 0,
                      separatorBuilder: (context, index) => SizedBox(
                        height: _mainHeight * 0.008,
                      ),
                    ),
                  ),
                );
              } else if (value.wishListModel.msg != null &&
                  value.wishListModel.data == null) {
                return Scaffold(
                  appBar: _getAppBar(context: context, value: value),
                  body: Center(
                    child: RMSWidgets.someError(context: context),
                  ),
                );
              } else if (value.wishListModel.msg != null &&
                  value.wishListModel.data != null &&
                  value.wishListModel.data!.isEmpty) {
                return Scaffold(
                    appBar: _getAppBar(context: context, value: value),
                    body: Center(
                        child: RMSWidgets.noData(
                            context: context,
                            message: nullCheck(list: value.wishListLang)
                                ? '${value.wishListLang[1].name}'
                                : 'No Any Wishlisted Property Found.')));
              } else {
                return Scaffold(
                    appBar: _getAppBar(context: context, value: value),
                    body: Center(child: RMSWidgets.getLoader()));
              }
            },
          )
        : RMSWidgets.networkErrorPage(context: context);
  }

  AppBar _getAppBar(
      {required BuildContext context, required PropertyViewModel value}) {
    return AppBar(
      leading: widget.fromBottom
          ? WillPopScope(
              child: Container(),
              onWillPop: () async {
                Provider.of<BottomNavigationProvider>(context, listen: false)
                    .shiftBottom(index: 0);
                return false;
              })
          : BackButton(),
      centerTitle: widget.fromBottom,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      titleSpacing: 0,
      backgroundColor: CustomTheme.appTheme,
      title: Container(
        child: Text(
            nullCheck(list: value.wishListLang)
                ? '${value.wishListLang[0].name}'
                : 'My WishList',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}
