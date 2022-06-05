import 'dart:async';
import 'dart:developer' as logger;
import 'dart:developer';
import 'dart:math' as math;

import 'package:RentMyStay_user/profile_Module/model/filter_sort_request_model.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/utils/constants/enum_consts.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/service/rms_user_api_service.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/service/system_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/date_time_service.dart';
import '../../utils/service/location_service.dart';
import '../../utils/view/calander_page.dart';

class PropertyListingPage extends StatefulWidget {
  String locationName;
  String? propertyType;
  Property property;
  String? checkInDate;
  String? checkOutDate;

  PropertyListingPage(
      {Key? key,
      required this.locationName,
      this.propertyType,
      required this.property,
      this.checkInDate,
      this.checkOutDate})
      : super(key: key);

  @override
  _PropertyListingPageState createState() => _PropertyListingPageState();
}

class _PropertyListingPageState extends State<PropertyListingPage> {
  var _mainHeight;
  var _mainWidth;
  late PropertyViewModel _propertyViewModel;
  static const String fontFamily = 'hk-grotest';
  String sortOrder = '0';
  final List<bool> _sortKeys = [
    false,
    false,
    false,
  ];
  SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
  String checkInDate = DateTimeService.ddMMYYYYformatDate(DateTime.now());
  String checkOutDate = DateTimeService.ddMMYYYYformatDate(
      DateTime.now().add(const Duration(days: 1)));
  bool showSearchResults = false;
  late TextEditingController _searchController;
  bool fullyFurnishedSelected = false;
  bool semiFurnishedSelected = false;
  bool entireHouseSelected = false;
  bool privateRoomSelected = false;
  bool sharedRoomSelected = false;
  bool studioSelected = false;
  bool oneBHKSelected = false;
  bool twoBHKSelected = false;
  bool threeBHKSelected = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;

  SfRangeValues _values = SfRangeValues(500, 40000);

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
    _searchController = TextEditingController();
    _searchController.text = widget.locationName;

    _propertyViewModel = Provider.of<PropertyViewModel>(context, listen: false);
    getLanguageData();
    if (widget.property == Property.fromLocation) {
      _propertyViewModel.getPropertyDetailsList(
          address: widget.locationName, property: Property.fromLocation);
    } else if (widget.property == Property.fromBHK) {
      _propertyViewModel.getPropertyDetailsList(
          address: widget.locationName,
          property: widget.property,
          propertyType: widget.propertyType);
    } else if (widget.property == Property.fromSearch) {
      _propertyViewModel.getPropertyDetailsList(
          address: widget.locationName,
          property: Property.fromSearch,
          toDate: widget.checkOutDate,
          fromDate: widget.checkInDate);
    } else if (widget.property == Property.fromCurrentLocation) {
      getCurrentLocationProperties().then((value) =>
          _propertyViewModel.getPropertyDetailsList(
              address: value, property: Property.fromLocation));
    }
  }

  getLanguageData() async {
    await _propertyViewModel.getPropertyListingLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'propertylisting');
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus
        ? Scaffold(

            appBar: _getAppBar(
              context: context,
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Consumer<PropertyViewModel>(
                builder: (context, value, child) {



                  if (value.propertyListModel.msg != null &&
                      value.propertyListModel.data != null &&
                      value.propertyListModel.data!.isNotEmpty) {
                    return Stack(
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
                                      'propId':data.propId,
                                      'fromExternalLink':false,
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
                                          CarouselSlider(
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    data.unitType ?? " ",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                var latitude =
                                                    (data.glat).toString();
                                                var longitude =
                                                    (data.glng).toString();
                                                await SystemService
                                                    .launchGoogleMaps(
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
                                                        top: _mainHeight *
                                                            0.005),
                                                    child: RichText(
                                                      text: TextSpan(children: [
                                                        WidgetSpan(
                                                          child: Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            color: CustomTheme
                                                                .appTheme,
                                                            size: _mainHeight *
                                                                0.02,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: (data.areas ??
                                                                  data.city) ??
                                                              " ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  fontFamily,
                                                              fontSize: 12),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                  data.avl?.toLowerCase() ==
                                                          'booked'
                                                      ? Padding(
                                                          padding: EdgeInsets.only(
                                                              right:
                                                                  _mainWidth *
                                                                      0.02,
                                                              top: _mainHeight *
                                                                  0.005),
                                                          child: Text(
                                                            'Booked',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xffFF0000),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14),
                                                          ),
                                                        )
                                                      : Text('')
                                                ],
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Row(
                                                children: [
                                                  Visibility(
                                                    visible:
                                                        data.rent != null &&
                                                            data.rent != "0",
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: _mainWidth *
                                                                0.02,
                                                            right: _mainWidth *
                                                                0.02),
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
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            data.orgRent ==
                                                                    data.rent
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
                                                                        fontSize:
                                                                            14))
                                                                : RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: '$rupee ${data.orgRent ?? " "}',
                                                                              style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: fontFamily, decoration: TextDecoration.lineThrough)),
                                                                          TextSpan(
                                                                              text: ' $rupee ${data.rent ?? " "}',
                                                                              style: TextStyle(color: CustomTheme.appTheme, fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: 14)),
                                                                        ]),
                                                                  ),
                                                          ],
                                                        )),
                                                  ),
                                                  Visibility(
                                                    visible:
                                                        data.rent != null &&
                                                            data.rent != "0",
                                                    child: SizedBox(
                                                      height:
                                                          _mainHeight * 0.03,
                                                      child: VerticalDivider(
                                                        color: CustomTheme
                                                            .appTheme,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left:
                                                              _mainWidth * 0.02,
                                                          right: _mainWidth *
                                                              0.02),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Rent (Stay < 3 Month)',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  fontFamily,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          data.orgMonthRent ==
                                                                  data
                                                                      .monthlyRent
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
                                                                      fontSize:
                                                                          14))
                                                              : RichText(
                                                                  text: TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                            text:
                                                                                '$rupee ${data.orgMonthRent ?? " "}',
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: fontFamily,
                                                                                decoration: TextDecoration.lineThrough)),
                                                                        TextSpan(
                                                                            text:
                                                                                ' $rupee ${data.monthlyRent ?? " "}',
                                                                            style: TextStyle(
                                                                                color: CustomTheme.appTheme,
                                                                                fontFamily: fontFamily,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 14)),
                                                                      ]),
                                                                ),
                                                        ],
                                                      )),
                                                  SizedBox(
                                                    height: _mainHeight * 0.03,
                                                    child: VerticalDivider(
                                                      color:
                                                          CustomTheme.appTheme,
                                                    ),
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left:
                                                              _mainWidth * 0.02,
                                                          right: _mainWidth *
                                                              0.02),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'Rent (Stay > 3 Month)',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                                                                      fontSize:
                                                                          14))
                                                              : RichText(
                                                                  text: TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                            text:
                                                                                '$rupee ${data.orgRmsRent ?? " "}',
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: fontFamily,
                                                                                decoration: TextDecoration.lineThrough)),
                                                                        TextSpan(
                                                                            text:
                                                                                ' $rupee ${data.rmsRent ?? " "}',
                                                                            style: TextStyle(
                                                                                color: CustomTheme.appTheme,
                                                                                fontFamily: fontFamily,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 14)),
                                                                      ]),
                                                                ),
                                                        ],
                                                      )),
                                                ],
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
                                                        color: CustomTheme
                                                            .appTheme),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(children: [
                                                  CircleAvatar(
                                                      radius:
                                                          _mainHeight * 0.012,
                                                      backgroundColor:
                                                          CustomTheme.appTheme,
                                                      child: Icon(
                                                        Icons.check,
                                                        size:
                                                            _mainHeight * 0.017,
                                                        color: Colors.white,
                                                      )),
                                                  SizedBox(
                                                    width: _mainWidth * 0.01,
                                                  ),
                                                  Text(
                                                    '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[1].name : 'Managed by RMS'}',
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.black,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                          color: CustomTheme
                                                              .appTheme);
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
                                                          color: CustomTheme
                                                              .appTheme);
                                                    }
                                                  }
                                                }
                                              },
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.white60,
                                                  radius: 15,
                                                  child: data.wishlist == 1
                                                      ? Icon(
                                                          Icons.favorite,
                                                          color: CustomTheme
                                                              .appTheme,
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .favorite_outline_rounded,
                                                          color: CustomTheme
                                                              .appTheme,
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
                            itemCount:
                                value.propertyListModel.data?.length ?? 0,
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
                                    child: showSuggestions(value: value,context: context)),
                              )
                            : Container(),
                         _getFilterSortSetting(
                                context: context, value: value)
                            ,
                      ],
                    );
                  } else if (value.propertyListModel.msg != null &&
                      value.propertyListModel.data == null) {
                    return Stack(
                      children: [
                        showSearchResults
                            ? Positioned(
                          top: _mainHeight * 0.01,
                          left: _mainWidth * 0.035,
                          child: Container(
                              height: _mainHeight * 0.32,
                              width: _mainWidth * 0.93,
                              child: showSuggestions(value: value,context: context)),
                        )
                            : Container(),
                        Center(
                            child: RMSWidgets.someError(context: context)),
                        _getFilterSortSetting(
                            context: context, value: value)
                        ,
                      ],
                    );
                  } else if (value.propertyListModel.msg != null &&
                      value.propertyListModel.data != null &&
                      value.propertyListModel.data!.isEmpty) {
                    return Stack(
                      children: [
                        showSearchResults
                            ? Positioned(
                          top: _mainHeight * 0.01,
                          left: _mainWidth * 0.035,
                          child: Container(
                              height: _mainHeight * 0.32,
                              width: _mainWidth * 0.93,
                              child: showSuggestions(value: value,context: context)),
                        )
                            : Container(),
                        Center(
                            child: RMSWidgets.noData(
                                context: context,
                                message: 'No Any Properties Found.')),
                        _getFilterSortSetting(
                            context: context, value: value)
                        ,
                      ],
                    );
                  } else {
                    return Center(
                        child:
                            RMSWidgets.getLoader(color: CustomTheme.appTheme));
                  }
                },
              ),
            ),
          )
        : RMSWidgets.networkErrorPage(context: context);
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
                  hintText: nullCheck(
                          list: context
                              .watch<PropertyViewModel>()
                              .propertyListingLang)
                      ? '${context.watch<PropertyViewModel>().propertyListingLang[0].name}'
                      : 'Search by Locality , Landmark or City',
                  hintStyle: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16,
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

  Widget _getFilterSortSetting(
      {required BuildContext context, required PropertyViewModel value}) {
    return Positioned(
      bottom: _mainHeight * 0.01,
      left: _mainWidth * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => applyFilter(context, value),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              side: BorderSide(
                width: 1.0,
                color: CustomTheme.appTheme,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Container(
              width: _mainWidth * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.filter_alt_outlined,
                    color: CustomTheme.appTheme,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[2].name : 'Filter'}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: fontFamily),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
            onPressed: () => applySorting(context, value),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              side: BorderSide(
                width: 1.0,
                color: CustomTheme.appTheme,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Container(
              width: _mainWidth * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.waves,
                    color: CustomTheme.appTheme,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[3].name : 'Sort'}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: fontFamily),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> applySorting(
      BuildContext context, PropertyViewModel value) async {
    return await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                height: 300,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(40)),
                          width: 70,
                          height: 30,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                _sortKeys[0] = false;
                                _sortKeys[1] = false;
                                _sortKeys[2] = false;
                              });
                            },
                            child: Center(
                                child: Text(
                              '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[4].name : 'Reset'}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 100,
                          height: 30,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        CustomTheme.appTheme),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                )),
                            onPressed: () async {
                              RMSWidgets.showLoaderDialog(
                                  context: context, message: 'Loading...');

                              FilterSortRequestModel model =
                                  FilterSortRequestModel(
                                sortOrder: sortOrder,
                              );

                              await _propertyViewModel.filterSortPropertyList(
                                  requestModel: model);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Center(
                                child: Text(
                              '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[5].name : 'Apply Sort'}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.clear,
                              color: CustomTheme.black,
                            ))
                      ],
                    ),
                    Divider(
                      color: CustomTheme.appTheme,
                      thickness: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[6].name : 'Price Low to High'}',
                        ),
                        Radio(
                          value: '1',
                          groupValue: sortOrder,
                          onChanged: (value) {
                            setState(() {
                              sortOrder = value as String;
                            });
                          },
                          activeColor: CustomTheme.appTheme,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[7].name : 'Price High to Low'}',
                        ),
                        Radio(
                          value: '2',
                          groupValue: sortOrder,
                          onChanged: (value) {
                            setState(() {
                              sortOrder = value as String;
                            });
                          },
                          activeColor: CustomTheme.appTheme,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[8].name : 'Show Near By'}',
                        ),
                        Radio(
                          value: '3',
                          groupValue: sortOrder,
                          onChanged: (value) {
                            setState(() {
                              sortOrder = value as String;
                            });
                          },
                          activeColor: CustomTheme.appTheme,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void applyFilter(BuildContext context, PropertyViewModel value) async {
    checkInDate = (await preferenceUtil.getString(rms_checkInDate)).toString();
    checkOutDate =
        (await preferenceUtil.getString(rms_checkOutDate)).toString();
    var data = DateTime.parse(checkOutDate)
        .difference(DateTime.parse(checkInDate))
        .inDays;
    double min = 500;
    double max = 40000;
    if (data < 30) {
      min = 500;
      max = 5000;
      _values = SfRangeValues(500, 5000);
    } else {
      min = 5000;
      max = 40000;
      _values = SfRangeValues(5000, 40000);
    }

    log(data.toString());
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (buildContext) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: _mainHeight * 0.55,
                width: _mainWidth,
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(40)),
                          width: 70,
                          height: 30,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                fullyFurnishedSelected = false;
                                semiFurnishedSelected = false;
                                entireHouseSelected = false;
                                privateRoomSelected = false;
                                sharedRoomSelected = false;
                                studioSelected = false;
                                oneBHKSelected = false;
                                twoBHKSelected = false;
                                threeBHKSelected = false;
                              });
                            },
                            child: Center(
                                child: Text(
                              '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[4].name : 'Reset'}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 30,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        CustomTheme.appTheme),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                )),
                            onPressed: () async {
                              RMSWidgets.showLoaderDialog(
                                  context: context, message: 'Loading...');
                              FilterSortRequestModel model =
                                  FilterSortRequestModel(
                                sortOrder: sortOrder,
                              );
                              if (fullyFurnishedSelected) {
                                model.fullyFurnish = '1';
                              }
                              if (semiFurnishedSelected) {
                                model.semiFurnish = '1';
                              }
                              if (entireHouseSelected) {
                                model.entireHouse = '1';
                              }
                              if (privateRoomSelected) {
                                model.privateRoom = '1';
                              }
                              if (sharedRoomSelected) {
                                model.sharedRoom = '1';
                              }
                              if (studioSelected) {
                                model.studio = '1';
                              }
                              if (oneBHKSelected) {
                                model.s1bhk = '1';
                              }
                              if (twoBHKSelected) {
                                model.s2bhk = '1';
                              }
                              if (threeBHKSelected) {
                                model.s3bhk = '1';
                              }
                              if (data < 30) {
                                model.term = 'DailyBasis';
                              } else if (data >= 30 && data <= 90) {
                                model.term = 'MonthlyBasis';
                              } else if (data > 90) {
                                model.term = 'LongTerm';
                              }
                              model.sortOrder = sortOrder;
                              model.pricefrom =
                                  double.parse(_values.start.toString())
                                      .toStringAsFixed(0)
                                      .toString();
                              model.priceto =
                                  double.parse(_values.end.toString())
                                      .toStringAsFixed(0)
                                      .toString();
                              model.fromDate = checkInDate;
                              model.toDate = checkOutDate;
                              model.address = _searchController.text;

                              await _propertyViewModel.filterSortPropertyList(
                                  requestModel: model);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Center(
                                child: Text(
                              '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[9].name : 'Apply Filter'}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.clear,
                              color: CustomTheme.black,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: _mainHeight * 0.015,
                    ),
                    GestureDetector(
                      onTap: () async {
                        PickerDateRange? dateRange =
                            await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CalenderPage(
                              initialDatesRange: PickerDateRange(
                            DateTime.parse(checkInDate),
                            DateTime.parse(checkOutDate),
                          )),
                        ));

                        if (dateRange != null) {
                          checkInDate = DateTimeService.ddMMYYYYformatDate(
                              dateRange.startDate ?? DateTime.now());
                          checkOutDate = DateTimeService.ddMMYYYYformatDate(
                              dateRange.endDate ??
                                  DateTime.now().add(const Duration(days: 31)));
                          data = DateTime.parse(checkOutDate)
                              .difference(DateTime.parse(checkInDate))
                              .inDays;
                          await preferenceUtil.setString(
                              rms_checkInDate, checkInDate);
                          await preferenceUtil.setString(
                              rms_checkOutDate, checkOutDate);
                          if (data < 30) {
                            min = 500;
                            max = 5000;
                            _values = SfRangeValues(500, 5000);
                          } else {
                            min = 5000;
                            max = 40000;
                            _values = SfRangeValues(5000, 40000);
                          }
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: CustomTheme.appTheme,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        //height: _mainHeight * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[10].name : 'CheckIn Date'}',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: fontFamily,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  checkInDate,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: fontFamily,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[11].name : 'CheckOut Date'}',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: fontFamily,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  checkOutDate,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: fontFamily,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _mainHeight * 0.01,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CustomTheme.appTheme,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      //height: _mainHeight * 0.1,
                      child: Column(
                        children: [
                          SfRangeSlider(
                            min: min,
                            max: max,
                            values: _values,
                            enableTooltip: true,
                            onChanged: (SfRangeValues values) {
                              setState(() {
                                _values = values;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[12].name : 'Min Price Selected'}',
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    '$rupee ${double.parse(_values.start.toString()).toStringAsFixed(0)}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[13].name : 'Max Price Selected'}',
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    '$rupee ${double.parse(_values.end.toString()).toStringAsFixed(0)}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _mainHeight * 0.02,
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: FilterChip(
                                selected: fullyFurnishedSelected,
                                checkmarkColor: CustomTheme.white,
                                backgroundColor: CustomTheme.white,
                                label: Text(
                                  '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[14].name : 'Fully Furnished Home'}',
                                  style: getTextStyle(
                                      isSelected: fullyFurnishedSelected),
                                ),
                                elevation: 2,
                                selectedColor: CustomTheme.appTheme,
                                pressElevation: 1,
                                onSelected: (bool selected) {
                                  setState(() {
                                    fullyFurnishedSelected =
                                        !fullyFurnishedSelected;
                                  });
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: FilterChip(
                                selected: semiFurnishedSelected,
                                checkmarkColor: CustomTheme.white,
                                backgroundColor: CustomTheme.white,
                                label: Text(
                                  '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[15].name : 'Semi Furnished Home'}',
                                  style: getTextStyle(
                                      isSelected: semiFurnishedSelected),
                                ),
                                elevation: 2,
                                selectedColor: CustomTheme.appTheme,
                                pressElevation: 1,
                                onSelected: (bool selected) {
                                  setState(() {
                                    semiFurnishedSelected =
                                        !semiFurnishedSelected;
                                  });
                                }),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _mainHeight * 0.02,
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: FilterChip(
                                selected: entireHouseSelected,
                                checkmarkColor: CustomTheme.white,
                                backgroundColor: CustomTheme.white,
                                label: Text(
                                  '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[16].name : 'Entire House'}',
                                  style: getTextStyle(
                                      isSelected: entireHouseSelected),
                                ),
                                elevation: 2,
                                selectedColor: CustomTheme.appTheme,
                                pressElevation: 1,
                                onSelected: (bool selected) {
                                  setState(() {
                                    entireHouseSelected = !entireHouseSelected;
                                  });
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: FilterChip(
                                selected: privateRoomSelected,
                                checkmarkColor: CustomTheme.white,
                                backgroundColor: CustomTheme.white,
                                label: Text(
                                  '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[17].name : 'Private Room'}',
                                  style: getTextStyle(
                                      isSelected: privateRoomSelected),
                                ),
                                elevation: 2,
                                selectedColor: CustomTheme.appTheme,
                                pressElevation: 1,
                                onSelected: (bool selected) {
                                  setState(() {
                                    privateRoomSelected = !privateRoomSelected;
                                  });
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: FilterChip(
                                selected: sharedRoomSelected,
                                checkmarkColor: CustomTheme.white,
                                backgroundColor: CustomTheme.white,
                                label: Text(
                                  '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[18].name : 'Shared Room'}',
                                  style: getTextStyle(
                                      isSelected: sharedRoomSelected),
                                ),
                                elevation: 2,
                                selectedColor: CustomTheme.appTheme,
                                pressElevation: 1,
                                onSelected: (bool selected) {
                                  setState(() {
                                    sharedRoomSelected = !sharedRoomSelected;
                                  });
                                }),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _mainHeight * 0.02,
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: FilterChip(
                                selected: studioSelected,
                                checkmarkColor: CustomTheme.white,
                                backgroundColor: CustomTheme.white,
                                label: Text(
                                  '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[20].name : 'Studio'}',
                                  style:
                                      getTextStyle(isSelected: studioSelected),
                                ),
                                elevation: 2,
                                selectedColor: CustomTheme.appTheme,
                                pressElevation: 1,
                                onSelected: (bool selected) {
                                  setState(() {
                                    studioSelected = !studioSelected;
                                  });
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: FilterChip(
                                selected: oneBHKSelected,
                                checkmarkColor: CustomTheme.white,
                                backgroundColor: CustomTheme.white,
                                label: Text(
                                  '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[22].name : 'One BHK'}',
                                  style:
                                      getTextStyle(isSelected: oneBHKSelected),
                                ),
                                elevation: 2,
                                selectedColor: CustomTheme.appTheme,
                                pressElevation: 1,
                                onSelected: (bool selected) {
                                  setState(() {
                                    oneBHKSelected = !oneBHKSelected;
                                  });
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: FilterChip(
                                selected: twoBHKSelected,
                                checkmarkColor: CustomTheme.white,
                                backgroundColor: CustomTheme.white,
                                label: Text(
                                  '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[24].name : 'Two BHK'}',
                                  style:
                                      getTextStyle(isSelected: twoBHKSelected),
                                ),
                                elevation: 2,
                                selectedColor: CustomTheme.appTheme,
                                pressElevation: 1,
                                onSelected: (bool selected) {
                                  setState(() {
                                    twoBHKSelected = !twoBHKSelected;
                                  });
                                }),
                          ),
                          FilterChip(
                              selected: threeBHKSelected,
                              checkmarkColor: CustomTheme.white,
                              backgroundColor: CustomTheme.white,
                              label: Text(
                                '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[26].name : 'Three BHK'}',
                                style:
                                    getTextStyle(isSelected: threeBHKSelected),
                              ),
                              elevation: 2,
                              selectedColor: CustomTheme.appTheme,
                              pressElevation: 1,
                              onSelected: (bool selected) {
                                setState(() {
                                  threeBHKSelected = !threeBHKSelected;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  TextStyle getTextStyle({required bool isSelected}) {
    return TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500);
  }

  Future<String> getCurrentLocationProperties() async =>
      (await LocationService.getCurrentPlace(context: context))
          .address
          .toString();

  Widget showSuggestions({required PropertyViewModel value,required BuildContext context}) {
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
                  await _propertyViewModel.getPropertyDetailsList(
                      address: value.locations[index].location,
                      property: Property.fromSearch,
                      toDate: widget.checkOutDate,
                      fromDate: widget.checkInDate);


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
                              fontSize: 14,
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
