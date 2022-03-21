import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/profile_Module/model/filter_sort_request_model.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/color.dart';
import 'package:RentMyStay_user/utils/constants/enum_consts.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/service/system_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/star_rating/star_rating.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../home_module/model/invite_and_earn_model.dart';
import '../../images.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/date_time_service.dart';
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
  late ThemeData theme;
  late CustomTheme customTheme;
  var _mainHeight;
  var _mainWidth;
  late PropertyViewModel _propertyViewModel;
  static const String fontFamily = 'hk-grotest';
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
  final _searchController = TextEditingController();
  late double _lowerValue = 500;
  late double _upperValue = 10000;
  bool fullyFurnishedSelected=false;
  bool semiFurnishedSelected=false;
  bool entireHouseSelected=false;
  bool privateRoomSelected=false;
  bool sharedRoomSelected=false;
  bool studioSelected=false;
  bool oneBHKSelected=false;
  bool twoBHKSelected=false;
  bool threeBHKSelected=false;


  @override
  void initState() {
    super.initState();

    _propertyViewModel = Provider.of<PropertyViewModel>(context, listen: false);
    if (widget.property == Property.FromLocation) {
      _propertyViewModel.getPropertyDetailsList(
          address: widget.locationName, property: Property.FromLocation);
    } else if (widget.property == Property.FromBHK) {
      _propertyViewModel.getPropertyDetailsList(
          address: widget.locationName,
          property: widget.property,
          propertyType: widget.propertyType);
    } else if (widget.property == Property.FromSearch) {
      _propertyViewModel.getPropertyDetailsList(
          address: widget.locationName,
          property: Property.FromSearch,
          toDate: widget.checkOutDate,
          fromDate: widget.checkInDate);
    }
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _getAppBar(context: context),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Consumer<PropertyViewModel>(
          builder: (context, value, child) {
            return value.propertyListModel.data != null
                ? Visibility(
                    visible: !showSearchResults,
                    replacement: Container(
                        padding: EdgeInsets.only(
                            left: _mainWidth * 0.03,
                            right: _mainWidth * 0.03,
                            top: _mainHeight * 0.02),
                        height: _mainHeight,
                        color: Colors.white,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                RMSWidgets.showLoaderDialog(
                                    context: context, message: 'Loading');

                                _searchController.text = value.locations[index];
                                await _propertyViewModel.getPropertyDetailsList(
                                    address: value.locations[index],
                                    property: Property.FromSearch,
                                    toDate: widget.checkOutDate,
                                    fromDate: widget.checkInDate);
                                showSearchResults = false;
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: _mainWidth * 0.03,
                                ),
                                height: _mainHeight * 0.045,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    //  color: Colors.white,//CustomTheme.appTheme.withAlpha(20),
                                    border: Border.all(
                                        color: CustomTheme.appTheme
                                            .withAlpha(100)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 20,
                                      color: CustomTheme.appTheme,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      width: _mainWidth * 0.8,
                                      child: Text(
                                        value.locations[index],
                                        style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600),
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
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                        )),
                    child: Container(
                      color: Colors.white,
                      height: _mainHeight,
                      width: _mainWidth,
                      padding: EdgeInsets.only(left: _mainWidth*0.03, right: _mainWidth*0.03, top: _mainHeight*0.01, bottom: 0),
                      child: Stack(
                        children: [
                          ListView.separated(
                            itemBuilder: (context, index) {
                              var data = value.propertyListModel.data![index];
                              return GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyDetailsPage,
                                    arguments: data.propId),
                                child: SizedBox(
                                  height: _mainHeight * 0.46,
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
                                                  ?.map((e) =>
                                                  CachedNetworkImage(
                                                    imageUrl: e.picLink
                                                        .toString(),
                                                    imageBuilder: (context,
                                                        imageProvider) =>
                                                        Container(

                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                    10),
                                                                topRight: Radius
                                                                    .circular(
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
                                                          height:
                                                          _mainHeight*0.27,
                                                          color: Colors
                                                              .grey,
                                                        ),
                                                        baseColor: Colors
                                                            .grey[200]
                                                        as Color,
                                                        highlightColor:
                                                        Colors.grey[350]
                                                        as Color),
                                                    errorWidget:
                                                        (context, url,
                                                        error) =>
                                                        Icon(Icons
                                                            .error),
                                                  ))
                                                  .toList() ??
                                                  [],
                                              options: CarouselOptions(
                                                  height: _mainHeight*0.27,
                                                  enlargeCenterPage: true,

                                                  autoPlay: true,
                                                  aspectRatio: 16 / 9,autoPlayInterval: const Duration(milliseconds: 1500),
                                                  autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                                  enableInfiniteScroll: true,
                                                  viewportFraction: 1),
                                            ),
                                            SizedBox(
                                              height: _mainHeight*0.01,
                                            ),
                                            Visibility(
                                              child: Container(
                                                height: _mainHeight * 0.025,
                                                padding: EdgeInsets.only(
                                                    left: _mainWidth*0.02, right: _mainWidth*0.02),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.home_work_outlined,
                                                      color: myFavColor,
                                                      size: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        data.buildingName ??
                                                            " ",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black87,
                                                          fontFamily:
                                                          fontFamily,
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
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                          fontFamily,
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
                                                child: Text(
                                                  'Multiple Units Available',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      fontSize: 12,
                                                      fontFamily: fontFamily),
                                                ),
                                                alignment:
                                                Alignment.centerRight,
                                                padding:
                                                EdgeInsets.only(right: _mainWidth*0.02),
                                              ),
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(left: _mainWidth*0.02),
                                              width: _mainWidth * 0.75,
                                              child: Text(
                                                data.title ?? " ",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: fontFamily,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w600),
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
                                                width: _mainWidth * 0.40,
                                                color: Colors.white,
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: _mainWidth*0.02, top: _mainHeight*0.005),
                                                      child: Icon(
                                                        Icons
                                                            .my_location_outlined,
                                                        color: myFavColor,
                                                        size: _mainHeight*0.02,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      //    color: Colors.amber,
                                                      width: _mainWidth * 0.30,
                                                      child: Wrap(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.only(
                                                                top: _mainHeight*0.007),
                                                            child: Text(
                                                              (data.areas ??
                                                                  data.city) ??
                                                                  " ",
                                                              maxLines: 1,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  fontFamily:
                                                                  fontFamily,
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: _mainHeight*0.007,
                                            ),
                                            Divider(
                                              color: CustomTheme.appTheme,
                                              height: 1,
                                            ),
                                            SizedBox(
                                              height: _mainHeight*0.007,
                                            ),
                                            Container(
                                              //color: Colors.amber,
                                                height: _mainHeight*0.02,
                                                margin: EdgeInsets.only(
                                                    left: _mainWidth*0.02, right:  _mainWidth*0.02),

                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Rent Per Day',
                                                      style: TextStyle(
                                                        fontFamily: fontFamily,
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    data.orgRent == data.rent
                                                        ? Text(
                                                        ' $rupee ${data.rent ?? " "}',
                                                        style: TextStyle(
                                                            color:
                                                            myFavColor,
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
                                                                ' $rupee ${data.rent ?? " "}',
                                                                style: TextStyle(
                                                                    color:
                                                                    myFavColor,
                                                                    fontFamily:
                                                                    fontFamily,
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    fontSize:
                                                                    14)),
                                                          ]),
                                                    ),
                                                  ],
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                )),
                                            Container(
                                              //color: Colors.amber,
                                                height: _mainHeight*0.02,
                                                margin: EdgeInsets.only(
                                                    left: _mainWidth*0.02, right:  _mainWidth*0.02),
                                                child: Row(
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
                                                            color:
                                                            myFavColor,
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
                                                                    color:
                                                                    myFavColor,
                                                                    fontFamily:
                                                                    fontFamily,
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    fontSize:
                                                                    14)),
                                                          ]),
                                                    ),
                                                  ],
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                )),
                                            Container(
                                              //   color: Colors.amber,
                                                height: _mainHeight*0.02,
                                                margin: EdgeInsets.only(
                                                    left: _mainWidth*0.02, right:  _mainWidth*0.02),
                                                child: Row(
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
                                                            color:
                                                            myFavColor,
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
                                                                    color:
                                                                    myFavColor,
                                                                    fontFamily:
                                                                    fontFamily,
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    fontSize:
                                                                    14)),
                                                          ]),
                                                    ),
                                                  ],
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                )),
                                          ],
                                        ),
                                        Container(
                                          height: _mainHeight*0.04,

                                          width: _mainWidth,
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Visibility(
                                                visible: data.rmsProp !=
                                                    null &&
                                                    data.rmsProp ==
                                                        "RMS Prop",
                                                child: Container(
                                                  padding:
                                                  EdgeInsets.only(right:_mainWidth*0.02),
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
                                                        radius:_mainHeight*0.012,
                                                        backgroundColor:
                                                        myFavColor,
                                                        child: Icon(
                                                          Icons.check,
                                                          size: _mainHeight*0.017,
                                                          color: Colors.white,
                                                        )),
                                                    SizedBox(width: _mainWidth*0.01,),
                                                    Container(
                                                        child: Text(
                                                          'Managed by RMS',
                                                          style: TextStyle(
                                                              fontStyle:
                                                              FontStyle.italic,
                                                              color: Colors.black,
                                                              fontFamily:
                                                              fontFamily,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 14),
                                                        )),
                                                  ]),
                                                ),
                                              ),
                                              Spacer(),
                                              data.wishlist == 0
                                                  ? GestureDetector(
                                                onTap: () async {
                                                  if (data.propId !=
                                                      null) {
                                                    String response =
                                                    await _propertyViewModel
                                                        .addToWishlist(
                                                        propertyId:
                                                        data.propId ??
                                                            " ");
                                                    if (response
                                                        .toLowerCase() ==
                                                        'successfully added') {
                                                      setState(() {
                                                        data.wishlist = 1;
                                                      });
                                                      RMSWidgets.showSnackbar(
                                                          context:
                                                          context,
                                                          message:
                                                          response,
                                                          color: CustomTheme
                                                              .appTheme);
                                                    }
                                                  }
                                                },
                                                child: const CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                  Colors.white60,
                                                  child: Icon(
                                                    Icons
                                                        .favorite_outline_rounded,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                ),
                                              )
                                                  : GestureDetector(
                                                onTap: () async {
                                                  if (data.propId !=
                                                      null) {
                                                    String response =
                                                    await _propertyViewModel
                                                        .addToWishlist(
                                                        propertyId:
                                                        data.propId ??
                                                            " ");
                                                    if (response
                                                        .toLowerCase() ==
                                                        'successfully removed') {
                                                      setState(() {
                                                        data.wishlist = 0;
                                                      });
                                                      RMSWidgets.showSnackbar(
                                                          context:
                                                          context,
                                                          message:
                                                          response,
                                                          color: CustomTheme()
                                                              .colorError);
                                                    }
                                                  }
                                                },
                                                child: const CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                  Colors.white60,
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount:
                            value.propertyListModel.data?.length ?? 0,
                            separatorBuilder: (context, index) =>
                                SizedBox(
                                  height: _mainHeight*0.008,
                                ),
                          ),
                          _getFilterSortSetting(context: context),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }

  AppBar _getAppBar({required BuildContext context}) {
    return AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        titleSpacing: 0,
        backgroundColor: CustomTheme.appTheme,
        title: Container(
          margin: EdgeInsets.only(right: 15),
          // width: _mainWidth * 0.78,
          height: 44,

          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            controller: _searchController,
            onChanged: (text) async {
              if (text.length < 3) {
                return;
              }
              showSearchResults = true;
              await _propertyViewModel.getSearchedPlace(text);
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10, top: 10),
                hintText: 'Search by Locality , Landmark or City',
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
                    setState(() {
                      showSearchResults = false;
                    });
                  },
                )),
          ),
        ));
  }

  Widget _getFilterSortSetting({required BuildContext context}) {
    return Positioned(
      bottom: _mainHeight * 0.01,
      left: _mainWidth * 0.15,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              applyFilter(context);
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  CustomTheme.appTheme,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                )),
            child: Container(
              width: _mainWidth * 0.2,
              child: Row(
                children: [
                  Icon(Icons.filter_alt_outlined),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Filter',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
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
            onPressed: () => applySorting(
              context: context,
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  CustomTheme.appTheme,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                )),
            child: Container(
              width: _mainWidth * 0.2,
              child: Row(
                children: [
                  Icon(Icons.waves),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Sort',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
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

  Future<void> applySorting({required BuildContext context}) async {
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
                              border: Border.all(color: Colors.grey,width: 1),
                              borderRadius: BorderRadius.circular(40)

                          ),
                          width: 70,
                          height: 30,
                          child: GestureDetector(

                            onTap: () async {
                              setState((){
                                _sortKeys[0]=false;
                                _sortKeys[1]=false;
                                _sortKeys[2]=false;
                              });
                            },
                            child: Center(
                                child: Text(
                                  "Reset",
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
                              String sortOrder = '0';

                              if (_sortKeys[0] == true) {
                                sortOrder = '1';
                              } else if (_sortKeys[1] == true) {
                                sortOrder = '2';
                              } else if (_sortKeys[2] == true) {
                                sortOrder = '3';
                              }

                              FilterSortRequestModel model =
                              FilterSortRequestModel(sortOrder: sortOrder,);

                              await _propertyViewModel.filterSortPropertyList(
                                  requestModel: model);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Center(
                                child: Text(
                                  "Apply Sort",
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
                      color: Colors.red,
                      thickness: 0,
                    ),
                    CheckboxListTile(
                      value: _sortKeys[0],
                      activeColor: CustomTheme.appTheme,
                      contentPadding: EdgeInsets.zero,

                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _sortKeys[0] = value;
                            _sortKeys[1] = false;
                            _sortKeys[2] = false;
                          });
                        }
                      },
                      //selected:_sortKeys[0],
                      title: Text('Price Low to High'),
                    ),
                    CheckboxListTile(
                      value: _sortKeys[1],
                      activeColor: CustomTheme.appTheme,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _sortKeys[0] = false;
                            _sortKeys[1] = value;
                            _sortKeys[2] = false;
                          });
                        }
                      },
                      //selected:_sortKeys[0],
                      title: Text('Price High to Low'),
                    ),
                    CheckboxListTile(
                      value: _sortKeys[2],
                      activeColor: CustomTheme.appTheme,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _sortKeys[0] = false;
                            _sortKeys[1] = false;
                            _sortKeys[2] = value;
                          });
                        }
                      },
                      //selected:_sortKeys[0],
                      title: Text('Show Near By'),
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

  void applyFilter(BuildContext context) {
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
               height: _mainHeight*0.65,
                width: _mainWidth,
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Row(

                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey,width: 1),
                            borderRadius: BorderRadius.circular(40)
                                
                          ),
                          width: 70,
                          height: 30,
                          child: GestureDetector(

                            onTap: () async {
                              setState((){
                                fullyFurnishedSelected=false;
                                semiFurnishedSelected=false;
                                entireHouseSelected=false;
                                privateRoomSelected=false;
                                sharedRoomSelected=false;
                                studioSelected=false;
                                oneBHKSelected=false;
                                twoBHKSelected=false;
                                threeBHKSelected=false;
                              });
                            },
                            child: Center(
                                child: Text(
                                  "Reset",
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
                              log('Min Price :: $_lowerValue -- Max Price :: $_upperValue');
                            },
                            child: Center(
                                child: Text(
                              "Apply Filter",
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
                    SizedBox(height: _mainHeight*0.015,),
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
                          setState(() {
                            checkInDate = DateTimeService.ddMMYYYYformatDate(
                                dateRange.startDate ?? DateTime.now());
                            checkOutDate = DateTimeService.ddMMYYYYformatDate(
                                dateRange.endDate ??
                                    DateTime.now()
                                        .add(const Duration(days: 1)));
                          });

                          await preferenceUtil.setString(
                              rms_checkInDate, checkInDate);
                          await preferenceUtil.setString(
                              rms_checkOutDate, checkOutDate);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: CustomTheme.appTheme,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: _mainHeight * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'CheckIn Date',
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
                                  'CheckOut Date',
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
                    SizedBox(height: _mainHeight*0.01,),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CustomTheme.appTheme,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: _mainHeight * 0.1,
                      child: Column(
                        children: [
                          RangeSlider(
                            min: 500,
                            max: 10000,
                            divisions: 4,
                            activeColor: CustomTheme.appTheme,
                            inactiveColor: CustomTheme.appThemeContrast.withAlpha(50),
                            labels: RangeLabels(
                                _lowerValue.toString(),_upperValue.toString()),
                            onChanged: (RangeValues rangeValues) {
                              setState(() {
                                _lowerValue = rangeValues.start;
                                _upperValue = rangeValues.end;
                              });
                            },
                            values: RangeValues( _lowerValue,_upperValue),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text('Min Price Selected',style: TextStyle(
                                      color: Colors.blueGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14
                                  ),),
                                  Text('$rupee $_lowerValue',style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                  ),),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Max Price Selected',style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14
                                  ),),
                                  Text('$rupee $_upperValue',style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                  ),),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: _mainHeight*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilterChip(
                            selected: fullyFurnishedSelected,
                            checkmarkColor: CustomTheme.white,
                            backgroundColor: CustomTheme.white,

                            label: Text('Fully Furnished Home',style: getTextStyle(isSelected: fullyFurnishedSelected),),
                            elevation: 2,
                            selectedColor: CustomTheme.appTheme,
                            pressElevation: 1,
                            onSelected: (bool selected) {
                              setState((){
                                fullyFurnishedSelected=!fullyFurnishedSelected;
                              });
                            }),
                        FilterChip(
                            selected: semiFurnishedSelected,
                            checkmarkColor: CustomTheme.white,
                            backgroundColor: CustomTheme.white,
                            label: Text('Semi Furnished Home',style: getTextStyle(isSelected: semiFurnishedSelected),),
                            elevation: 2,
                            selectedColor: CustomTheme.appTheme,
                            pressElevation: 1,
                            onSelected: (bool selected) {
                              setState((){
                                semiFurnishedSelected=!semiFurnishedSelected;
                              });
                            })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilterChip(
                            selected: entireHouseSelected,
                            checkmarkColor: CustomTheme.white,
                            backgroundColor: CustomTheme.white,
                            label: Text('Entire House',style: getTextStyle(isSelected:entireHouseSelected),),
                            elevation: 2,
                            selectedColor: CustomTheme.appTheme,
                            pressElevation: 1,
                            onSelected: (bool selected) {
                              setState((){
                                entireHouseSelected=!entireHouseSelected;
                              });
                            }),
                        FilterChip(
                            selected: privateRoomSelected,
                            checkmarkColor: CustomTheme.white,
                            backgroundColor: CustomTheme.white,
                            label: Text('Private Room',style: getTextStyle(isSelected: privateRoomSelected),),
                            elevation: 2,
                            selectedColor: CustomTheme.appTheme,
                            pressElevation: 1,
                            onSelected: (bool selected) {
                              setState((){
                                privateRoomSelected=!privateRoomSelected;
                              });
                            }),
                        FilterChip(
                            selected: sharedRoomSelected,
                          checkmarkColor: CustomTheme.white,
                          backgroundColor: CustomTheme.white,

                              label: Text(
                              'Shared Room',style: getTextStyle(isSelected: sharedRoomSelected),
                            ),
                            elevation: 2,
                            selectedColor: CustomTheme.appTheme,
                            pressElevation: 1,
                            onSelected: (bool selected) {
                              setState((){
                                sharedRoomSelected=!sharedRoomSelected;
                              });
                            })
                      ],
                    ),
                    FilterChip(
                        selected: studioSelected,
                        checkmarkColor: CustomTheme.white,
                        backgroundColor: CustomTheme.white,
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('For Lone Rangers(1+1) members',style: getTextStyle(isSelected: studioSelected),),
                            Text('Studio',style: getTextStyle(isSelected: studioSelected),)
                          ],
                        ),
                        elevation: 2,
                        selectedColor: CustomTheme.appTheme,
                        pressElevation: 1,
                        onSelected: (bool selected) {
                          setState((){
                            studioSelected=!studioSelected;
                          });
                        }),
                    FilterChip(
                        selected: oneBHKSelected,
                        checkmarkColor: CustomTheme.white,
                        backgroundColor: CustomTheme.white,
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('For Small Family (2+1) members',style: getTextStyle(isSelected: oneBHKSelected),),
                            Text('One BHK',style: getTextStyle(isSelected: oneBHKSelected),)
                          ],
                        ),
                        elevation: 2,
                        selectedColor: CustomTheme.appTheme,
                        pressElevation: 1,
                        onSelected: (bool selected) {
                          setState((){
                            oneBHKSelected=!oneBHKSelected;
                          });
                        }),
                    FilterChip(
                        selected: twoBHKSelected,
                        checkmarkColor: CustomTheme.white,
                        backgroundColor: CustomTheme.white,
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fit For Friend Groups of (4+1) members',style: getTextStyle(isSelected: twoBHKSelected),),
                            Text('Two BHK',style: getTextStyle(isSelected: twoBHKSelected),)
                          ],
                        ),
                        elevation: 2,
                        selectedColor: CustomTheme.appTheme,
                        pressElevation: 1,
                        onSelected: (bool selected) {
                          setState((){
                            twoBHKSelected=!twoBHKSelected;
                          });
                        }),
                    FilterChip(
                        selected: threeBHKSelected,
                        checkmarkColor: CustomTheme.white,
                        backgroundColor: CustomTheme.white,
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fit For Joint Family of (6+1) members',style: getTextStyle(isSelected: threeBHKSelected),),
                            Text('Three BHK',style: getTextStyle(isSelected: threeBHKSelected),)
                          ],
                        ),
                        elevation: 2,
                        selectedColor: CustomTheme.appTheme,
                        pressElevation: 1,
                        onSelected: (bool selected) {
                          setState((){
                            threeBHKSelected=!threeBHKSelected;
                          });
                        }),

                  ],
                ),
              );
            },
          );
        });
  }
  TextStyle getTextStyle({required bool isSelected}){
    return TextStyle(
      color: isSelected?Colors.white:Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500
    );
  }
}
