import 'dart:developer';

import 'package:RentMyStay_user/property_details_module/amenities_model.dart';
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

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  var _mainHeight;
  var _mainWidth;

  bool showSearchResults = false;
  late TextEditingController _searchController = TextEditingController();

  late PropertyViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<PropertyViewModel>(context, listen: false);

    _viewModel.getPropertyDetailsList(
        address: 'Bengaluru-Karnataka-India', property: Property.fromLocation);
  }

  @override
  Widget build(BuildContext context) {
    _mainWidth = MediaQuery.of(context).size.width;
    _mainHeight = MediaQuery.of(context).size.height;
    log('$_mainWidth  -- $_mainHeight');

    return Scaffold(
      appBar: _getAppBar(context: context),
      body: Consumer<PropertyViewModel>(
        builder: (context, value, child) {
          return value.propertyListModel.msg != null &&
                  value.propertyListModel.data != null
              ? Container(
                  color: Colors.white,
                  height: _mainHeight,
                  width: _mainWidth,
                  // margin: EdgeInsets.only(bottom: _mainHeight * 0.01),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: _mainWidth*0.04,
                            right: _mainWidth*0.04,
                            top: _mainHeight*0.02
                          ),
                            width: _mainWidth,
                            child: Row(
                              children: [
                                Text('${value.propertyListModel.data?.length ??''} Stay\'s Found',
                                style: TextStyle(
                                  color: CustomTheme.appTheme,
                                  fontWeight: FontWeight.w600,
                                  fontSize: getHeight(
                                      context: context,
                                      height: 16)
                                ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.filter_alt_outlined,
                                  size: _mainHeight*0.015,
                                  color: CustomTheme.appThemeContrast,
                                ),
                                SizedBox(
                                  width: 5,
                                ),

                                Text(
                                  'Filter',
                                  style: TextStyle(
                                      fontSize: getHeight(
                                          context: context,
                                          height: 12),
                                      color: CustomTheme.appThemeContrast,
                                      fontWeight: FontWeight.w500,
                                      ),
                                ),
                                SizedBox(
                                  width: _mainWidth*0.05,
                                ),
                                Icon(
                                  Icons.waves,
                                  size: _mainHeight*0.015,
                                  color: CustomTheme.appThemeContrast,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Sort',
                                  style: TextStyle(
                                    fontSize: getHeight(
                                        context: context,
                                        height: 12),
                                    color: CustomTheme.appThemeContrast,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )),
                        Stack(
                          children: [
                            Container(
                              color: Colors.white,
                              height: _mainHeight,
                              width: _mainWidth,
                              padding: EdgeInsets.only(
                                  left: _mainWidth * 0.03,
                                  right: _mainWidth * 0.03,
                                  top: _mainHeight * 0.01,
                                  bottom: 0),
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  var data = value.propertyListModel.data![index];
                                  return GestureDetector(
                                    onTap: () => Navigator.of(context).pushNamed(
                                        AppRoutes.propertyDetailsPage,
                                        arguments: {
                                          'propId': data.propId,
                                          'fromExternalLink': false,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: _mainWidth * 0.02,
                                                    top: _mainHeight * 0.01,
                                                    right: _mainWidth * 0.02),
                                                child: CarouselSlider(
                                                  items: data.propPics
                                                          ?.map(
                                                              (e) =>
                                                                  CachedNetworkImage(
                                                                    imageUrl: e
                                                                        .picLink
                                                                        .toString(),
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
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
                                                                              height: _mainHeight *
                                                                                  0.27,
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
                                                      [],
                                                  options: CarouselOptions(
                                                      height: _mainHeight * 0.27,
                                                      enlargeCenterPage: true,
                                                      autoPlay: true,
                                                      aspectRatio: 16 / 9,
                                                      autoPlayInterval: Duration(
                                                          milliseconds: math.Random()
                                                                  .nextInt(6000) +
                                                              1500),
                                                      autoPlayCurve:
                                                          Curves.fastOutSlowIn,
                                                      enableInfiniteScroll: true,
                                                      viewportFraction: 1),
                                                ),
                                              ),
                                              SizedBox(
                                                height: _mainHeight * 0.02,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: _mainWidth * 0.02,
                                                    right: _mainWidth * 0.02),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: _mainWidth * 0.68,
                                                      child: Text(
                                                        "${data.title ?? ""}",
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: getHeight(
                                                                context: context,
                                                                height: 12),
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: data.rmsProp != null &&
                                                          data.rmsProp == "RMS Prop",
                                                      child: Text(
                                                        "${data.unitType ?? ''}",
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: getHeight(
                                                                context: context,
                                                                height: 12),
                                                            fontWeight:
                                                                FontWeight.w700),
                                                      ),
                                                    ),
                                                  ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                ),
                                              ),
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
                                                        Icons.location_on_outlined,
                                                        color: CustomTheme.appTheme,
                                                        size: _mainHeight * 0.015,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: _mainWidth * 0.01,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () => goToMap(
                                                          glat: data.glat,
                                                          glng: data.glng),
                                                      child: Text(
                                                        (data.areas ?? data.city) ??
                                                            " ",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: getHeight(
                                                                context: context,
                                                                height: 10)),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Visibility(
                                                      visible: data.rmsProp != null &&
                                                          data.rmsProp == "RMS Prop",
                                                      child: Container(
                                                        padding: EdgeInsets.only(
                                                            left: _mainWidth * 0.02,
                                                            right: _mainWidth * 0.02),
                                                        child: Row(children: [
                                                          Icon(
                                                            Icons.person,
                                                            size: _mainHeight * 0.015,
                                                            color: Colors.green,
                                                          ),
                                                          SizedBox(
                                                            width: _mainWidth * 0.01,
                                                          ),
                                                          Text(
                                                            'Managed by RMS',
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                                fontSize: getHeight(
                                                                    context: context,
                                                                    height: 10)),
                                                          ),
                                                        ]),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Visibility(
                                                      visible: data.rmsProp != null &&
                                                          data.rmsProp == "RMS Prop",
                                                      child: Text(
                                                        'Multiple Units Available',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: getHeight(
                                                              context: context,
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
                                              SizedBox(
                                                height: _mainHeight * 0.007,
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    getRents(
                                                        rentType: 'Rent Per Day',
                                                        discount: '70 % OFF',
                                                        rent: data.rent ?? '0',
                                                        orgRent: data.orgRent ?? '0'),
                                                    SizedBox(
                                                        width: _mainWidth * 0.005),
                                                    getRents(
                                                        rentType: 'Stay < 3 Month',
                                                        discount: '70 % OFF',
                                                        rent: data.monthlyRent ?? '0',
                                                        orgRent:
                                                            data.orgMonthRent ?? '0'),
                                                    SizedBox(
                                                        width: _mainWidth * 0.005),
                                                    getRents(
                                                        rentType: 'Stay > 3 Month',
                                                        discount: '70 % OFF',
                                                        rent: data.rmsRent ?? '0',
                                                        orgRent:
                                                            data.orgRmsRent ?? '0'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            top: _mainHeight * 0.025,
                                            left: _mainWidth * 0.05,
                                            child: Visibility(
                                              visible: data.rmsProp != null &&
                                                  data.rmsProp == "RMS Prop",
                                              child: Container(
                                                height: _mainHeight * 0.03,

                                                padding: EdgeInsets.only(
                                                    left: _mainWidth * 0.02,
                                                    right: _mainWidth * 0.02),
                                                decoration: BoxDecoration(
                                                    color:
                                                        CustomTheme.appThemeContrast,
                                                    borderRadius:
                                                        BorderRadius.circular(5)),
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

                                                    maxWidth: _mainWidth*0.5,
                                                    child: Text(
                                                        data.buildingName??'',
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: getHeight(
                                                            context: context,
                                                            height: 12),
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: _mainWidth * 0.04,
                                            top: _mainHeight * 0.025,
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (data.wishlist == 1) {
                                                  if (data.propId != null) {
                                                    int response = await _viewModel
                                                        .addToWishlist(
                                                            propertyId:
                                                                data.propId ?? '');
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
                                                    int response = await _viewModel
                                                        .addToWishlist(
                                                            propertyId:
                                                                data.propId ?? '');
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
                                              child: data.wishlist == 1
                                                  ? Icon(
                                                      Icons.favorite,
                                                      color: CustomTheme.errorColor,
                                                    )
                                                  : Icon(
                                                      Icons.favorite_outline_rounded,
                                                      color: CustomTheme.white,
                                                    ),
                                            ),
                                          ),
                                          Positioned(
                                            right: _mainWidth * 0.04,
                                            top: _mainHeight * 0.24,
                                            child: Visibility(
                                                visible: data.avl?.toLowerCase() ==
                                                    'booked',
                                                child: Container(
                                                  alignment: Alignment.topCenter,
                                                  height: _mainHeight * 0.022,
                                                  width: _mainWidth * 0.2,
                                                  padding: EdgeInsets.only(
                                                      left: _mainWidth * 0.02,
                                                      right: _mainWidth * 0.02),
                                                  decoration: BoxDecoration(
                                                      color: CustomTheme
                                                          .appThemeContrast,
                                                      borderRadius:
                                                          BorderRadius.circular(5)),
                                                  child: Text(
                                                    'Booked',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: getHeight(
                                                            context: context,
                                                            height: 14)),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: value.propertyListModel.data?.length ?? 0,
                                separatorBuilder: (context, index) => SizedBox(
                                  height: _mainHeight * 0.008,
                                ),
                              ),
                            ),
                            showSearchResults
                                ? Positioned(
                                    top: _mainHeight * 0.01,
                                    left: _mainWidth * 0.035,
                                    child: Container(
                                        height: _mainHeight * 0.32,
                                        width: _mainWidth * 0.93,
                                        child: showSuggestions(
                                            value: value, context: context)),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : RMSWidgets.getLoader();
        },
      ),
      /* bottomNavigationBar: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              RMSWidgets.showLoaderDialog(
                  context: context, message: 'Loading...');
              SharedPreferenceUtil sharedPreferenceUtil =
                  SharedPreferenceUtil();
              var name =
                  (await sharedPreferenceUtil.getString(rms_name) ?? '')
                      .toString();
              var email =
                  (await sharedPreferenceUtil.getString(rms_email) ?? '')
                      .toString();
              var phone =
                  (await sharedPreferenceUtil.getString(rms_phoneNumber) ??
                          '')
                      .toString();
              Navigator.of(context).pop();
              _showDialog(
                propId:
                    _viewModel.propertyDetailsModel?.data?.details?.propId ??
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
                'Site Visit',
                style: TextStyle(
                    color: CustomTheme.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (_viewModel.propertyDetailsModel == null ||
                  _viewModel.propertyDetailsModel?.data?.details == null) {
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
              var name =
                  (await sharedPreferenceUtil.getString(rms_name) ?? '')
                      .toString();
              var email =
                  (await sharedPreferenceUtil.getString(rms_email) ?? '')
                      .toString();
              var phone =
                  (await sharedPreferenceUtil.getString(rms_phoneNumber) ??
                          '')
                      .toString();
              var token = (await sharedPreferenceUtil
                          .getString(rms_registeredUserToken) ??
                      '')
                  .toString();
              Navigator.of(context).pop();
              PropertyDetailsUtilModel model = PropertyDetailsUtilModel(
                name: name,
                email: email,
                mobile: phone,
                token: token,
                propId: int.parse(
                    (_viewModel.propertyDetailsModel?.data?.details?.propId)
                        .toString()),
                buildingName:
                    (_viewModel.propertyDetailsModel?.data?.details?.bname)
                        .toString(),
                title: (_viewModel.propertyDetailsModel?.data?.details?.title)
                    .toString(),
                freeGuest: int.parse((_viewModel
                        .propertyDetailsModel?.data?.details?.freeGuests)
                    .toString()),
                maxGuest: int.parse(_viewModel
                        .propertyDetailsModel?.data?.details?.maxGuests ??
                    '0'),
              );
              Navigator.pushNamed(context, AppRoutes.bookingPage,
                  arguments: model);
            },
            child: Container(
                width: _mainWidth * 0.5,
                height: _mainHeight * 0.06,
                alignment: Alignment.center,
                color: CustomTheme.appThemeContrast,
                child: Text(
                  'Book Now',
                  style: TextStyle(
                      color: CustomTheme.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )),
          ),
        ],
      ),*/
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
      if (rent != '' || rent != '0' || orgRent != '' || orgRent != '0' ) {
        if(double.parse(rent.trim()).toInt() < double.parse(orgRent.trim()).toInt()) {
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
                    style: TextStyle(fontSize: getHeight(
                        context: context,
                        height: 10)),
                  ),
                  SizedBox(height: _mainHeight * 0.005),
                  Visibility(
                    visible: getDiscount(rent: rent, orgRent: orgRent) != 0,
                    child: Text(
                      '${getDiscount(rent: rent, orgRent: orgRent)} % OFF',
                      style: TextStyle(
                          fontSize: getHeight(
                              context: context,
                              height: 10),
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
                        fontSize: getHeight(
                            context: context,
                            height: 10),
                        color: CustomTheme.black,
                        fontWeight: FontWeight.w500),
                  )),
                  SizedBox(height: _mainHeight * 0.005),
                  Visibility(
                      visible: orgRent != '0' && rent != orgRent,
                      child: Text(
                        '$rupee $orgRent',
                        style: TextStyle(
                            fontSize: getHeight(
                                context: context,
                                height: 10),
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

  AppBar _getAppBar({required BuildContext context}) {
    return AppBar(
      leading: BackButton(
        color: Colors.white,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      titleSpacing: 0,
      backgroundColor: CustomTheme.appTheme,
      title: Consumer<PropertyViewModel>(
        builder: (context, value, child) {
          return Container(
            margin: EdgeInsets.only(right: 15),
            // width: _mainWidth * 0.78,
            height: 45,

            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: _searchController,
              onChanged: (text) async {
                if (text.length < 3) {
                  return;
                }
                showSearchResults = true;
                await value.getSearchedPlace(text);
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10, top: 10),
                  hintText: 'Search by Locality , Landmark or City',
                  hintStyle: TextStyle(
                      fontSize: getHeight(
                          context: context,
                          height: 14),
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      _searchController.clear();
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        showSearchResults = false;
                      });
                    },
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget showSuggestions(
      {required PropertyViewModel value, required BuildContext context}) {
    return Neumorphic(
      style: NeumorphicStyle(
        shadowLightColor: CustomTheme.appTheme.withAlpha(150),
        shadowDarkColor: CustomTheme.appTheme.withAlpha(150),
        color: Colors.white,
        lightSource: LightSource.bottom,
        intensity: 5,
        depth: 2,
      ),
      child: Container(
          padding: EdgeInsets.only(top: 10),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context1, index) {
              return GestureDetector(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  RMSWidgets.showLoaderDialog(
                      context: context, message: 'Loading');

                  _searchController.text = value.locations[index].location;
                  showSearchResults = false;
                  await _viewModel.getPropertyDetailsList(
                      address: value.locations[index].location,
                      property: Property.fromSearch,
                      toDate: '',
                      fromDate: '');

                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: _mainWidth * 0.02,
                  ),
                  height: _mainHeight * 0.045,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: _mainHeight * 0.022,
                        color: CustomTheme.appTheme,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: _mainWidth * 0.8,
                        child: Text(
                          value.locations[index].location,
                          style: TextStyle(
                              fontSize: getHeight(
                                  context: context,
                                  height: 14),
                              color: CustomTheme.appTheme,
                              fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: value.locations.length,
            separatorBuilder: (context, index) => const Divider(
              thickness: 1,
            ),
          )),
    );
  }
}
