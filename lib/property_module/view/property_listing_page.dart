import 'dart:async';

import 'dart:developer';
import 'dart:math' as math;
import 'package:RentMyStay_user/property_module/model/property_list_model.dart'
    as propListModel;
import 'package:RentMyStay_user/profile_Module/model/filter_sort_request_model.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/utils/constants/enum_consts.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';

import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/service/system_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../theme/fonts.dart';
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
        context: context,
          address: widget.locationName, property: Property.fromLocation);
    } else if (widget.property == Property.fromBHK) {
      _propertyViewModel.getPropertyDetailsList(
        context: context,
          address: widget.locationName,
          property: widget.property,
          propertyType: widget.propertyType);
    } else if (widget.property == Property.fromSearch) {
      _propertyViewModel.getPropertyDetailsList(
        context: context,
          address: widget.locationName,
          property: Property.fromSearch,
          toDate: widget.checkOutDate,
          fromDate: widget.checkInDate);
    } else if (widget.property == Property.fromCurrentLocation) {
      getCurrentLocationProperties().then((value) =>
          _propertyViewModel.getPropertyDetailsList(
            context: context,
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

  String getUnitType({required propListModel.Data data}) {
    return '';
  }

  String getPropType({required propListModel.Data data}) {
    return '';
  }

  String getPropName({required propListModel.Data data}) {
    return '';
  }

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
                    return Container(
                      color: Colors.white,
                      height: _mainHeight,
                      width: _mainWidth,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            showSearchResults
                                ? Container()
                                : getPropSettings(
                                    value: value, context: context),
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
                                      bottom: _mainHeight * 0.16),
                                  child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      var data =
                                          value.propertyListModel.data![index];
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
                                                        right:
                                                            _mainWidth * 0.02),
                                                    child: CarouselSlider(
                                                      items: data.propPics
                                                              ?.map((e) =>
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
                                                                            BorderRadius.circular(10),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        Shimmer.fromColors(
                                                                            child: Container(
                                                                              height: _mainHeight * 0.22,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            baseColor: Colors.grey[200] as Color,
                                                                            highlightColor: Colors.grey[350] as Color),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.error),
                                                                  ))
                                                              .toList() ??
                                                          [],
                                                      options: CarouselOptions(
                                                          height: _mainHeight *
                                                              0.22,
                                                          enlargeCenterPage:
                                                              true,
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
                                                              maxLines: 2,
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
                                                              "${data.buildingName} ${data.floor}",
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
                                                  SizedBox(
                                                    height: _mainHeight * 0.01,
                                                  ),
                                                  Container(
                                                    width: _mainWidth,
                                                    padding: EdgeInsets.only(
                                                        left: _mainWidth * 0.02,
                                                        right:
                                                            _mainWidth * 0.02),
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
                                                                    height:
                                                                        10)),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Visibility(
                                                          visible: data
                                                                      .rmsProp !=
                                                                  null &&
                                                              data.rmsProp ==
                                                                  "RMS Prop",
                                                          child: Container(
                                                            padding: EdgeInsets.only(
                                                                left:
                                                                    _mainWidth *
                                                                        0.02,
                                                                right:
                                                                    _mainWidth *
                                                                        0.02),
                                                            child:
                                                                Row(children: [
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
                                                          visible: data
                                                                      .rmsProp !=
                                                                  null &&
                                                              data.rmsProp ==
                                                                  "RMS Prop",
                                                          child: Text(
                                                            'Multiple Units Available',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
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
                                                          rentTypeD: "",
                                                            rentType:
                                                                'Rent Per Day',
                                                            rent: data.rent ??
                                                                '0',
                                                            orgRent:
                                                                data.orgRent ??
                                                                    '0'),
                                                        SizedBox(
                                                            width: _mainWidth *
                                                                0.005),
                                                        getRents(
                                                            rentTypeD: "(Stay < 3 months)",
                                                            rentType:
                                                                'Flexi Rent',
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
                                                            rentTypeD: "(Stay > 3 months)",
                                                            rentType:
                                                                'Regular Rent',
                                                            rent:
                                                                data.rmsRent ??
                                                                    '0',
                                                            orgRent:
                                                                data.orgRmsRent ??
                                                                    '0'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              /* Positioned(
                                                top: _mainHeight * 0.02,
                                                left: _mainWidth * 0.04,
                                                child: Visibility(
                                                  visible:
                                                      data.rmsProp != null &&
                                                          data.rmsProp ==
                                                              "RMS Prop",
                                                  child: Container(
                                                    height: _mainHeight * 0.03,
                                                    padding: EdgeInsets.only(
                                                        left: _mainWidth * 0.02,
                                                        right:
                                                            _mainWidth * 0.02),
                                                    decoration: BoxDecoration(
                                                        color: CustomTheme
                                                            .highlightColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(children: [
                                                      Icon(
                                                        Icons.home,
                                                        size:
                                                            _mainHeight * 0.017,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            _mainWidth * 0.01,
                                                      ),
                                                      LimitedBox(
                                                        maxWidth:
                                                            _mainWidth * 0.5,
                                                        child: Text(
                                                          data.buildingName ??
                                                              '',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: getHeight(
                                                                context:
                                                                    context,
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
                                                      '${value.propertyListModel.data![0].propType}',
                                                      style: TextStyle(
                                                        fontSize: getHeight(
                                                            context: context,
                                                            height: 12),
                                                        color:
                                                            CustomTheme.white,
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
                                              Positioned(
                                                right: _mainWidth * 0.04,
                                                top: _mainHeight * 0.2,
                                                child: Visibility(
                                                    visible: data.avl
                                                            ?.toLowerCase() ==
                                                        'booked',
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height:
                                                          _mainHeight * 0.022,
                                                      width: _mainWidth * 0.18,

                                                      decoration: BoxDecoration(
                                                          color: CustomTheme
                                                              .appThemeContrast,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Text(
                                                        'Booked',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: getHeight(
                                                                context:
                                                                    context,
                                                                height: 14)),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount:
                                        value.propertyListModel.data?.length ??
                                            0,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
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
                                                value: value,
                                                context: context)),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                                    child: showSuggestions(
                                        value: value, context: context)),
                              )
                            : getPropSettings(value: value, context: context),
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
                                    child: showSuggestions(
                                        value: value, context: context)),
                              )
                            : getPropSettings(value: value, context: context),
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

  Widget getPropSettings(
      {required PropertyViewModel value, required BuildContext context}) {
    return Container(
        padding: EdgeInsets.only(
            left: _mainWidth * 0.04,
            right: _mainWidth * 0.05,
            top: _mainHeight * 0.02),
        width: _mainWidth,
        child: Row(
          children: [
            Text(
              '${value.propertyListModel.data?.length ?? ''} ${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[28].name : 'Stay\'s Found'}',
              style: TextStyle(
                  color: CustomTheme.appTheme,
                  fontWeight: FontWeight.w600,
                  fontSize: getHeight(context: context, height: 16)),
            ),
            Spacer(),
            InkWell(
              onTap: () => applyFilter(context, value),
              child: Icon(
                Icons.filter_alt_outlined,
                size: _mainHeight * 0.015,
                color: CustomTheme.appThemeContrast,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () => applyFilter(context, value),
              child: Text(
                '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[2].name : 'Filter'}',
                style: TextStyle(
                  fontSize: getHeight(context: context, height: 12),
                  color: CustomTheme.appThemeContrast,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              width: _mainWidth * 0.05,
            ),
            InkWell(
              onTap: () => applySorting(context, value),
              child: Icon(
                Icons.waves,
                size: _mainHeight * 0.015,
                color: CustomTheme.appThemeContrast,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () => applySorting(context, value),
              child: Text(
                '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[3].name : 'Sort'}',
                style: TextStyle(
                  fontSize: getHeight(context: context, height: 12),
                  color: CustomTheme.appThemeContrast,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ));
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
                await value.getSearchedPlace(text,context: context);
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10, top: 10),
                  hintText: nullCheck(
                          list: context
                              .watch<PropertyViewModel>()
                              .propertyListingLang)
                      ? '${context.watch<PropertyViewModel>().propertyListingLang[0].name}'
                      : 'Search by Locality , House or City',
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
                      if (showSearchResults == false) {
                        _searchController.clear();
                        FocusScope.of(context).requestFocus(FocusNode());
                      } else {
                        setState(() {
                          showSearchResults = false;
                        });
                      }
                    },
                  )),
            ),
          );
        },
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
                                  fontSize:
                                      getHeight(context: context, height: 14)),
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
                                context: context,
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
                                  fontSize:
                                      getHeight(context: context, height: 14)),
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
                          width: _mainWidth * 0.2,
                          height: _mainHeight * 0.035,
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
                                min = 500;
                                max = 40000;
                                if (data < 30) {
                                  min = 500;
                                  max = 5000;
                                  _values = SfRangeValues(500, 5000);
                                } else {
                                  min = 5000;
                                  max = 40000;
                                  _values = SfRangeValues(5000, 40000);
                                }
                              });
                            },
                            child: Center(
                                child: Text(
                              '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[4].name : 'Reset'}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      getHeight(context: context, height: 14)),
                            )),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: _mainWidth * 0.3,
                          height: _mainHeight * 0.035,
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
                                  context: context, message: 'Loading');
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
                                context: context,
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
                                  fontSize:
                                      getHeight(context: context, height: 14)),
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
                                      fontSize: getHeight(
                                          context: context, height: 14),
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  checkInDate,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: fontFamily,
                                      fontSize: getHeight(
                                          context: context, height: 14),
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
                                      fontSize: getHeight(
                                          context: context, height: 14),
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  checkOutDate,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: fontFamily,
                                      fontSize: getHeight(
                                          context: context, height: 14),
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
                                    '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[12].name : 'Min Price'} ${nullCheck(list: value.propertyListingLang) ? data < 30 ? value.propertyListingLang[29].name : value.propertyListingLang[30].name : data < 30 ? 'Daily' : 'Monthly'}',
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: getHeight(
                                            context: context, height: 14)),
                                  ),
                                  Text(
                                    '$rupee ${double.parse(_values.start.toString()).toStringAsFixed(0)}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: getHeight(
                                            context: context, height: 14)),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${nullCheck(list: value.propertyListingLang) ? value.propertyListingLang[13].name : 'Max Price'} ${nullCheck(list: value.propertyListingLang) ? data < 30 ? value.propertyListingLang[29].name : value.propertyListingLang[30].name : data < 30 ? 'Daily' : 'Monthly'}',
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: getHeight(
                                            context: context, height: 14)),
                                  ),
                                  Text(
                                    '$rupee ${double.parse(_values.end.toString()).toStringAsFixed(0)}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: getHeight(
                                            context: context, height: 14)),
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
                            padding: EdgeInsets.only(right: _mainWidth * 0.025),
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
                            padding: EdgeInsets.only(right: _mainWidth * 0.025),
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
                   /* FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: _mainWidth * 0.025),
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
                            padding: EdgeInsets.only(right: _mainWidth * 0.025),
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
                            padding: EdgeInsets.only(right: _mainWidth * 0.025),
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
                    ), */
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: _mainWidth * 0.025),
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
                            padding: EdgeInsets.only(right: _mainWidth * 0.025),
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
                            padding: EdgeInsets.only(right: _mainWidth * 0.025),
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
                              padding:
                                  EdgeInsets.only(right: _mainWidth * 0.025),
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
        fontSize: getHeight(context: context, height: 14),
        fontWeight: FontWeight.w500);
  }

  Future<String> getCurrentLocationProperties() async =>
      (await LocationService.getCurrentPlace(context: context))
          .address
          .toString();

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
      child: value.locations.isNotEmpty
          ? Container(
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
                        context: context,
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
              ))
          : Center(
              child: Text(
                'No any suggestion found !',
                style: TextStyle(
                    fontSize: getHeight(
                      context: context,
                      height: 16,
                    ),
                    color: CustomTheme.appTheme),
              ),
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
          return 100 - val.toInt();
        }
      }
    } catch (e) {
      log('Format Exception : $e');
    }
    return 0;
  }

  Widget getRents({
    required String rentType,
    required String rent,
    required String orgRent,
    required String rentTypeD,
  }) {
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
                  Text(
                    rentTypeD,
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
