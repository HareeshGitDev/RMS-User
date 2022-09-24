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
import '../../theme/fonts.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/constants/sp_constants.dart';
import '../../language_module/model/language_model.dart';
import '../../utils/service/bottom_navigation_provider.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/system_service.dart';
import 'dart:math' as math;

import '../model/wish_list_model.dart';

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
    _propertyViewModel.getWishList(context: context);
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            height: _mainHeight,
                            width: _mainWidth,
                            padding: EdgeInsets.only(
                                left: _mainWidth * 0.03,
                                right: _mainWidth * 0.03,
                                top: _mainHeight * 0.01,
                                bottom: _mainHeight * 0.16),
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                var data = value.wishListModel.data![index];
                                return GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(
                                          AppRoutes.propertyDetailsPage,
                                          arguments: {
                                        'propId': data.propId,
                                        'fromExternalLink': false,
                                      }),
                                  child: Card(
                                    elevation: 4,
                                    shadowColor: CustomTheme.appTheme,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: _mainWidth * 0.02,
                                                  top: _mainHeight * 0.01,
                                                  right: _mainWidth * 0.02),
                                              child: CarouselSlider(
                                                items: data.pic != null && data.pic!.length != 0?data.pic
                                                        ?.map((e) =>
                                                            CachedNetworkImage(
                                                              imageUrl: e
                                                                  .picLink ??'',
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          10),
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
                                                                            _mainHeight * 0.22,
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
                                                            ))
                                                        .toList() :
                                                    [Pic()].map((e) =>
                                                        CachedNetworkImage(
                                                          imageUrl: e
                                                              .picLink ??'',
                                                          imageBuilder:
                                                              (context,
                                                              imageProvider) =>
                                                              Container(
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      10),
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
                                                                _mainHeight * 0.22,
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
                                                        ))
                                                        .toList(),
                                                options: CarouselOptions(
                                                    height: _mainHeight *
                                                        0.22,
                                                    enlargeCenterPage: true,
                                                    autoPlay: true,
                                                    aspectRatio: 16 / 9,
                                                    autoPlayInterval: Duration(
                                                        milliseconds: math
                                                                    .Random()
                                                                .nextInt(
                                                                    6000) +
                                                            1500),
                                                    autoPlayCurve: Curves
                                                        .fastOutSlowIn,
                                                    enableInfiniteScroll:
                                                        true,
                                                    viewportFraction: 1),
                                              ),
                                            ),
                                            SizedBox(
                                              height: _mainHeight * 0.02,
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                left: _mainWidth * 0.02,
                                              ),
                                              child: Row(
                                                children: [
                                                  Visibility(
                                                    visible: data
                                                        .rmsProp !=
                                                        null &&
                                                        data.rmsProp ==
                                                            "RMS Prop",
                                                    child: Container(
                                                      child: Text(
                                                        "${data.unitType ?? ''}",
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: getHeight(
                                                                context:
                                                                context,
                                                                height:
                                                                12),
                                                            fontWeight:
                                                            FontWeight
                                                                .w700),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(' - '),
                                                  Container(
                                                    child: Text(
                                                      '${data.propType}',
                                                      style: TextStyle(
                                                        fontSize: getHeight(
                                                            context:
                                                            context,
                                                            height: 12),
                                                        color:
                                                        Colors.black,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Visibility(
                                                      visible: data
                                                          .rmsProp !=
                                                          null &&
                                                          data.rmsProp ==
                                                              "RMS Prop",
                                                      child: Icon(
                                                        Icons.home,
                                                        size:
                                                        _mainHeight *
                                                            0.02,
                                                        color:
                                                        Colors.grey,
                                                      )),
                                                  SizedBox(
                                                    width: _mainWidth *
                                                        0.002,
                                                  ),
                                                  Visibility(
                                                    visible: data
                                                        .rmsProp !=
                                                        null &&
                                                        data.rmsProp ==
                                                            "RMS Prop",
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          right:
                                                          _mainWidth *
                                                              0.02),
                                                      //width: _mainWidth*0.28,
                                                      child: Text(
                                                        data.buildingName ??
                                                            '',
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: getHeight(
                                                              context:
                                                              context,
                                                              height: 12),
                                                          color: Colors
                                                              .black,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                           /* Container(
                                              padding: EdgeInsets.only(
                                                  left: _mainWidth * 0.02,
                                                  right: _mainWidth * 0.02),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  Container(
                                                    width:
                                                        _mainWidth * 0.68,
                                                    child: Text(
                                                      "${data.title?.trim() ?? ""}",
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: getHeight(
                                                              context:
                                                                  context,
                                                              height: 12),
                                                          color:
                                                              Colors.black,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: data.rmsProp !=
                                                            null &&
                                                        data.rmsProp ==
                                                            "RMS Prop",
                                                    child: Text(
                                                      "${data.unitType ?? ''}",
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: getHeight(
                                                              context:
                                                                  context,
                                                              height: 12),
                                                          fontWeight:
                                                              FontWeight
                                                                  .w700),
                                                    ),
                                                  ),
                                                ],
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                              ),
                                            ),*/
                                            SizedBox(
                                              height: _mainHeight * 0.01,
                                            ),
                                            Container(
                                              width: _mainWidth,
                                              padding: EdgeInsets.only(
                                                  left: _mainWidth * 0.02,
                                                  right: _mainWidth * 0.02),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => goToMap(
                                                        glat: data.glat,
                                                        glng: data.glng),
                                                    child: Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: Colors.grey,
                                                      size: _mainHeight *
                                                          0.015,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        _mainWidth * 0.01,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () => goToMap(
                                                        glat: data.glat,
                                                        glng: data.glng),
                                                    child: Text(
                                                      (data.areas ??
                                                              data.city) ??
                                                          " ",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                          fontSize: getHeight(
                                                              context:
                                                                  context,
                                                              height: 10)),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Visibility(
                                                    visible: data.rmsProp !=
                                                            null &&
                                                        data.rmsProp ==
                                                            "RMS Prop",
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: _mainWidth *
                                                              0.02,
                                                          right:
                                                              _mainWidth *
                                                                  0.02),
                                                      child: Row(children: [
                                                        Icon(
                                                          Icons.person,
                                                          size:
                                                              _mainHeight *
                                                                  0.015,
                                                          color:
                                                              Colors.grey,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              _mainWidth *
                                                                  0.01,
                                                        ),
                                                        Text(
                                                          'Managed by RMS',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: getHeight(
                                                                  context:
                                                                      context,
                                                                  height:
                                                                      10)),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Visibility(
                                                    visible: data.rmsProp !=
                                                            null &&
                                                        data.rmsProp ==
                                                            "RMS Prop",
                                                    child: Text(
                                                      'Multiple Units Available',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: getHeight(
                                                            context:
                                                                context,
                                                            height: 10),
                                                      ),
                                                    ),
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
                                                  getRents(
                                                      rentType:
                                                          'Rent Per Day',
                                                      discount: '70 % OFF',
                                                      rent:
                                                          data.rent ?? '0',
                                                      orgRent:
                                                          data.orgRent ??
                                                              '0'),
                                                  SizedBox(
                                                      width: _mainWidth *
                                                          0.005),
                                                  getRents(
                                                      rentType:
                                                          'Stay < 3 Month',
                                                      discount: '70 % OFF',
                                                      rent:
                                                          data.monthlyRent ??
                                                              '0',
                                                      orgRent:
                                                          data.orgMonthRent ??
                                                              '0'),
                                                  SizedBox(
                                                      width: _mainWidth *
                                                          0.005),
                                                  getRents(
                                                      rentType:
                                                          'Stay > 3 Month',
                                                      discount: '70 % OFF',
                                                      rent: data.rmsRent ??
                                                          '0',
                                                      orgRent:
                                                          data.orgRmsRent ??
                                                              '0'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                     /*   Positioned(
                                          top: _mainHeight * 0.02,
                                          left: _mainWidth * 0.04,
                                          child: Visibility(
                                            visible: data.rmsProp != null &&
                                                data.rmsProp == "RMS Prop",
                                            child: Container(
                                              height: _mainHeight * 0.03,
                                              padding: EdgeInsets.only(
                                                  left: _mainWidth * 0.02,
                                                  right: _mainWidth * 0.02),
                                              decoration: BoxDecoration(
                                                  color: CustomTheme
                                                      .highlightColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5)),
                                              child: Row(children: [
                                                Icon(
                                                  Icons.home,
                                                  size: _mainHeight * 0.017,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: _mainWidth * 0.01,
                                                ),
                                                LimitedBox(
                                                  maxWidth:
                                                      _mainWidth * 0.5,
                                                  child: Text(
                                                    data.buildingName ?? '',
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: getHeight(
                                                          context: context,
                                                          height: 12),
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),*/
                                        Positioned(
                                          right: _mainWidth * 0.04,
                                          top: _mainHeight * 0.02,
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (data.wishlist == 1) {
                                                if (data.propId != null) {
                                                  int response =
                                                      await _propertyViewModel
                                                          .addToWishlist(
                                                        context: context,
                                                              propertyId:
                                                                  data.propId ??
                                                                      '');
                                                  if (response == 200) {
                                                    RMSWidgets.showLoaderDialog(context: context, message:'Loading');
                                                    await _propertyViewModel.getWishList(context: context);
                                                    Navigator.of(context).pop();
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
                                                if (data.propId != null) {
                                                  int response =
                                                      await _propertyViewModel
                                                          .addToWishlist(
                                                        context: context,
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
                                                        color: CustomTheme
                                                            .appTheme);
                                                  }
                                                }
                                              }
                                            },
                                            child: data.wishlist == 1
                                                ? Icon(
                                                    Icons.favorite,
                                                    color: CustomTheme
                                                        .errorColor,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .favorite_outline_rounded,
                                                    color:
                                                        CustomTheme.white,
                                                  ),
                                          ),
                                        ),
                                       /* Positioned(
                                          left: _mainWidth * 0.04,
                                          top: _mainHeight * 0.2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: _mainHeight * 0.025,
                                            padding: EdgeInsets.only(
                                                left: _mainWidth * 0.02,
                                                right: _mainWidth * 0.02),
                                            decoration: BoxDecoration(
                                                color: CustomTheme
                                                    .highlightColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5)),
                                            child: LimitedBox(
                                              maxWidth: _mainWidth * 0.5,
                                              child: Text(
                                                '${value.wishListModel.data![0].propType}',
                                                style: TextStyle(
                                                  fontSize: getHeight(
                                                      context: context,
                                                      height: 12),
                                                  color: CustomTheme.white,
                                                  fontWeight:
                                                      FontWeight.w500,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount:
                                  value.wishListModel.data?.length ?? 0,
                              separatorBuilder: (context, index) =>
                                  SizedBox(
                                height: _mainHeight * 0.008,
                              ),
                            ),
                          ),
                        ],
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

  void goToMap({String? glat, String? glng}) async {
    if ((glat != null) && (glng != null)) {
      var latitude = glat.toString();
      var longitude = glng.toString();
      await SystemService.launchGoogleMaps(
          latitude: latitude, longitude: longitude);
    }
  }

  int getDiscount({required String rent, required String orgRent}) {
    double val = 0;

    try {
      if (rent != '' || rent != '0' || orgRent != '' || orgRent != '0') {
        if (double.parse(rent.trim()).toInt() <
            double.parse(orgRent.trim()).toInt()) {
          val = (double.parse(rent.trim()).toInt() * 100) /
              double.parse(orgRent.trim()).toInt();
        }
      }
    } catch (e) {
      log('Format Exception : $e');
    }

    return val.toInt();
  }

  Widget getRents(
      {required String rentType,
      required String rent,
      required String orgRent,
      String? discount}) {
    return Visibility(
      visible: rent != '0',
      child: Container(
        margin: EdgeInsets.only(
            bottom: _mainHeight * 0.01, left: _mainWidth * 0.01),
        padding: EdgeInsets.only(
            left: _mainWidth * 0.01,
            right: _mainWidth * 0.02,
            top: _mainHeight * 0.00),
        width: _mainWidth * 0.29,
        height: _mainHeight * 0.05,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(5)),
        child: FittedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rentType,
                    style: TextStyle(
                        fontSize: getHeight(context: context, height: 10)),
                  ),
                  SizedBox(height: _mainHeight * 0.005),
                  Visibility(
                    visible: getDiscount(rent: rent, orgRent: orgRent) != 0,
                    child: Text(
                      '${getDiscount(rent: rent, orgRent: orgRent)} % OFF',
                      style: TextStyle(
                          fontSize: getHeight(context: context, height: 10),
                          color: CustomTheme.myFavColor,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
              SizedBox(width: _mainWidth * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      child: Text(
                    '$rupee $rent',
                    style: TextStyle(
                        fontSize: getHeight(context: context, height: 10),
                        color: CustomTheme.black,
                        fontWeight: FontWeight.w500),
                  )),
                  SizedBox(height: _mainHeight * 0.005),
                  Visibility(
                      visible: orgRent != '0' && rent != orgRent,
                      child: Text(
                        '$rupee $orgRent',
                        style: TextStyle(
                            fontSize: getHeight(context: context, height: 10),
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w500),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
