import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/service/system_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../home_module/model/home_page_model.dart';
import '../../theme/custom_theme.dart';
import '../../theme/fonts.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/constants/enum_consts.dart';
import '../../language_module/model/language_model.dart';
import '../../utils/model/class UtilsModel.dart';
import '../../utils/service/bottom_navigation_provider.dart';
import '../../utils/service/date_time_service.dart';
import '../../utils/service/location_service.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/view/calander_page.dart';

class SearchPage extends StatefulWidget {
  final bool fromBottom;

  const SearchPage({Key? key, required this.fromBottom}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String checkInDate = DateTimeService.ddMMYYYYformatDate(DateTime.now());
  String checkOutDate = DateTimeService.ddMMYYYYformatDate(
      DateTime.now().add(const Duration(days: 1)));
  var _mainHeight;
  var _mainWidth;
  static const String fontFamily = 'hk-grotest';
  final _searchController = TextEditingController();
  final SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
  bool showSearchResults = false;
  late PropertyViewModel _propertyViewModel;
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;
  List<UtilsModel> locationsList = [];
  List<UtilsModel> exploreMoreCitiesList = [];
  late Future<Map<String, String>> searchedValues;

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

  Future<Map<String, String>> getSearchedValues() async {
    return {
      search_key1: await preferenceUtil.getString(search_key1) ?? '',
      search_key2: await preferenceUtil.getString(search_key2) ?? '',
      search_key3: await preferenceUtil.getString(search_key3) ?? '',
    };
  }

  Future<void> setRecentSearchedValue({required String place}) async {
    var key1 = await preferenceUtil.getString(search_key2);
    var key2 = await preferenceUtil.getString(search_key3);
    await preferenceUtil.setString(search_key1, key1 ?? '');
    await preferenceUtil.setString(search_key2, key2 ?? '');
    await preferenceUtil.setString(search_key3, place);
  }

  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }

  TextStyle get getTextStyle => const TextStyle(
      color: Colors.black,
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      fontSize: 15);

  getLanguageData() async {
    await _propertyViewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'SearchPage');
  }

  @override
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _propertyViewModel = Provider.of<PropertyViewModel>(context, listen: false);
    _propertyViewModel.getHomePageData();
    getLanguageData();
    locationsList = getLocationsList();
    searchedValues = getSearchedValues();
    exploreMoreCitiesList=getExploreMoreCitiesList();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus
        ? Consumer<PropertyViewModel>(
            builder: (context, value, child) {
              return Scaffold(
                body: widget.fromBottom
                    ? WillPopScope(
                        onWillPop: () async {
                          Provider.of<BottomNavigationProvider>(context,
                                  listen: false)
                              .shiftBottom(index: 0);
                          return false;
                        },
                        child: getView(value: value),
                      )
                    : getView(value: value),
              );
            },
          )
        : RMSWidgets.networkErrorPage(context: context);
  }

  Widget getView({required PropertyViewModel value}) {
    return Stack(
      children: [
        Container(
          width: _mainWidth,
          color: Colors.white,
          padding: EdgeInsets.only(
              left: _mainWidth * 0.035,
              right: _mainWidth * 0.035,
              top: _mainHeight * 0.015,
              bottom: _mainHeight * 0.015),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: _mainHeight * 0.045,
                ),
                Container(
                  height: _mainHeight * 0.055,
                  child: Neumorphic(
                    margin: EdgeInsets.symmetric(horizontal: _mainWidth*0.005),
                    style: NeumorphicStyle(

                      shadowLightColor: CustomTheme.appTheme.withAlpha(150),
                      shadowDarkColor: CustomTheme.appTheme.withAlpha(150),
                      color: Colors.white,
                      lightSource: LightSource.bottom,
                      intensity: 5,
                      depth: 2,
                    ),
                    child: Row(
                      children: [
                        BackButton(
                          onPressed: widget.fromBottom
                              ? () => Provider.of<BottomNavigationProvider>(
                                      context,
                                      listen: false)
                                  .shiftBottom(index: 0)
                              : () => Navigator.pop(context),
                          color: Colors.black54,
                        ),
                        Container(
                          width: _mainWidth * 0.78,
                          height: _mainHeight * 0.055,
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
                                hintText: nullCheck(list: value.searchPageLang)
                                    ? '${value.searchPageLang[0].name}'
                                    : 'Search by locality , city or home',
                                hintStyle: TextStyle(
                                    fontSize:
                                        getHeight(context: context, height: 16),
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () async {
                                    if (showSearchResults == false) {
                                      _searchController.clear();
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    } else {
                                      setState(() {
                                        showSearchResults = false;
                                      });
                                    }
                                  },
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.015,
                ),
                InkWell(
                  onTap: () async {
                    RMSWidgets.showLoaderDialog(
                        context: context, message: 'Loading');
                    final currentLocation =
                        await LocationService.getCurrentPlace(context: context);
                    Navigator.of(context).pop();
                    if (currentLocation.address != null) {
                      _searchController.text =
                          currentLocation.address.toString();
                    }
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.my_location,
                          color: CustomTheme.appThemeContrast,
                          size: _mainHeight * 0.02,
                        ),
                        SizedBox(
                          width: _mainWidth * 0.02,
                        ),
                        Text(
                          nullCheck(list: value.searchPageLang)
                              ? '${value.searchPageLang[6].name}'
                              :'Use my Current Location',
                          style: TextStyle(
                              fontSize: getHeight(context: context, height: 14),
                              color: CustomTheme.appThemeContrast,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.02,
                ),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
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
                                DateTime.now().add(const Duration(days: 1)));
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
                    height: _mainHeight * 0.06,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              nullCheck(list: value.searchPageLang)
                                  ? '${value.searchPageLang[1].name}'
                                  : 'CheckIn Date',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize:
                                      getHeight(context: context, height: 14),
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              checkInDate,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      getHeight(context: context, height: 14),
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              nullCheck(list: value.searchPageLang)
                                  ? '${value.searchPageLang[2].name}'
                                  : 'CheckOut Date',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize:
                                      getHeight(context: context, height: 14),
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              checkOutDate,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      getHeight(context: context, height: 14),
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.02,
                ),
                Container(
                  alignment: Alignment.center,
                  height: _mainHeight * 0.045,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_searchController.text.isEmpty ||
                          _searchController.text.length < 3) {
                        RMSWidgets.showSnackbar(
                            context: context,
                            message: 'Please Enter Place or City.',
                            color: CustomTheme.errorColor);
                        return;
                      }
                      setRecentSearchedValue(place: _searchController.text);
                      Navigator.of(context)
                          .pushNamed(AppRoutes.propertyListingPage, arguments: {
                        'location': _searchController.text,
                        'property': Property.fromSearch,
                        'checkInDate': checkInDate,
                        'checkOutDate': checkOutDate,
                      });
                      FocusScope.of(context).unfocus();
                    },
                    child: Text(
                      nullCheck(list: value.searchPageLang)
                          ? '${value.searchPageLang[3].name}'
                          : 'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: getHeight(context: context, height: 16),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          CustomTheme.appTheme,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        )),
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.02,
                ),
                Text(nullCheck(list: value.searchPageLang)
                    ? '${value.searchPageLang[7].name}'
                    :'Recent Searches', style: getHeaderStyle),
                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                FutureBuilder<Map<String, dynamic>>(
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error'),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Container(
                          height: _mainHeight * 0.12,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location': snapshot.data![search_key1] !=
                                                  null &&
                                              snapshot.data![search_key1] != ''
                                          ? snapshot.data![search_key1]
                                          : 'BTM Layout',
                                      'property': Property.fromLocation,
                                    }),
                                child: Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  height: _mainHeight * 0.035,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                        size: _mainWidth * 0.04,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(
                                        width: _mainWidth * 0.02,
                                      ),
                                      Container(
                                        width: _mainWidth * 0.7,
                                        child: Text(
                                          snapshot.data != null &&
                                                  snapshot.data![search_key1] !=
                                                      ''
                                              ? snapshot.data![search_key1]
                                              : 'BTM Layout',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: getHeight(
                                                context: context,
                                                height: 12,
                                              ),
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: _mainWidth * 0.04,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location': snapshot.data![search_key1] !=
                                                  null &&
                                              snapshot.data![search_key2] != ''
                                          ? snapshot.data![search_key2]
                                          : 'HSR Layout',
                                      'property': Property.fromLocation,
                                    }),
                                child: Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  height: _mainHeight * 0.035,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                        size: _mainWidth * 0.04,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(
                                        width: _mainWidth * 0.02,
                                      ),
                                      Container(
                                        width: _mainWidth * 0.7,
                                        child: Text(
                                          snapshot.data != null &&
                                                  snapshot.data![search_key2] !=
                                                      ''
                                              ? snapshot.data![search_key2]
                                              : 'HSR Layout',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: getHeight(
                                                context: context,
                                                height: 12,
                                              ),
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: _mainWidth * 0.04,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location': snapshot.data![search_key1] !=
                                                  null &&
                                              snapshot.data![search_key3] != ''
                                          ? snapshot.data![search_key3]
                                          : 'Electronic City',
                                      'property': Property.fromLocation,
                                    }),
                                child: Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  height: _mainHeight * 0.035,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                        size: _mainWidth * 0.04,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(
                                        width: _mainWidth * 0.02,
                                      ),
                                      Container(
                                        width: _mainWidth * 0.7,
                                        child: Text(
                                          snapshot.data != null &&
                                                  snapshot.data![search_key3] !=
                                                      ''
                                              ? snapshot.data![search_key3]
                                              : 'Electronic City',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: getHeight(
                                                context: context,
                                                height: 12,
                                              ),
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: _mainWidth * 0.04,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return Text('No any recent searches');
                  },
                  future: searchedValues,
                ),
                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                Text(
                    nullCheck(list: value.searchPageLang)
                        ? '${value.searchPageLang[4].name}'
                        : 'Frequently Searched Locations',
                    style: getHeaderStyle),
                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                Container(
                  child: Row(
                    children: [
                      getLocationBox(
                          property: locationsList[0].key ?? '',
                          onTap: locationsList[0].callback ?? () {}),
                      Spacer(),
                      getLocationBox(
                          property: locationsList[1].key ?? '',
                          onTap: locationsList[1].callback ?? () {}),
                      Spacer(),
                      getLocationBox(
                          property: locationsList[2].key ?? '',
                          onTap: locationsList[2].callback ?? () {}),
                    ],
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                Container(
                  child: Row(
                    children: [
                      getLocationBox(
                          property: locationsList[3].key ?? '',
                          onTap: locationsList[3].callback ?? () {}),
                      Spacer(),
                      getLocationBox(
                          property: locationsList[4].key ?? '',
                          onTap: locationsList[4].callback ?? () {}),
                      Spacer(),
                      getLocationBox(
                          property: locationsList[5].key ?? '',
                          onTap: locationsList[5].callback ?? () {}),
                    ],
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                Container(
                  alignment: Alignment.center,
                  child: getLocationBox(
                      property: locationsList[6].key ?? '',
                      onTap: locationsList[6].callback ?? () {}),
                ),
                /*Container(
                  height: _mainHeight * 0.23,
                  width: _mainWidth,
                  child: GridView.builder(
                    //physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: _mainHeight * 0.045,
                      mainAxisSpacing: _mainHeight * 0.02,
                      crossAxisSpacing: _mainWidth * 0.035,
                      // childAspectRatio: 3.3
                    ),
                    itemBuilder: (_, index) {
                      final data = locationsList[index];
                      return getLocationBox(
                          property: data.key ?? '',
                          onTap:
                              data.callback != null ? data.callback! : () {});
                    },
                    itemCount: locationsList.length,
                  ),
                ),*/
                SizedBox(
                  height: _mainHeight * 0.02,
                ),
                Container(
                  width: _mainWidth,
                  child: Row(
                    children: [
                      Text(
                          nullCheck(list: value.searchPageLang)
                              ? '${value.searchPageLang[5].name}'
                              : 'Search by Desired Property Type',
                          style: getHeaderStyle),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              AppRoutes.propertyListingPage,
                              arguments: {
                                'location': 'Bengaluru-Karnataka-India',
                                'property': Property.fromLocation,
                              });
                        },
                        child: Text(
                          '${nullCheck(list: value.searchPageLang)
                              ? '${value.searchPageLang[11].name}'
                              : 'See All'}',
                          style: TextStyle(
                              color: CustomTheme.appThemeContrast,
                              fontSize:
                              getHeight(context: context, height: 14),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                getDesireProperties(context: context,value: value),
                SizedBox(
                  height: _mainHeight * 0.02,
                ),
                Container(
                  width: _mainWidth,
                  child: Row(
                    children: [
                      Text(
                          nullCheck(list: value.searchPageLang)
                              ? '${value.searchPageLang[12].name}'
                              : 'Explore Other Cities',
                          style: getHeaderStyle),
                      Spacer(),
                      InkWell(
                        onTap: () =>RMSWidgets.getToast(message:'Coming Soon...', color: CustomTheme.appTheme),
                        child: Text(
                          '${nullCheck(list: value.searchPageLang)
                              ? '${value.searchPageLang[11].name}'
                              : 'See All'}',
                          style: TextStyle(
                              color: CustomTheme.appThemeContrast,
                              fontSize:
                              getHeight(context: context, height: 14),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                getExploreMoreCitiesView(context: context, value: value),
                SizedBox(
                  height: _mainHeight * 0.02,
                ),
                Container(
                  width: _mainWidth,
                  child: Row(
                    children: [
                      Text(nullCheck(list: value.searchPageLang)
                          ? '${value.searchPageLang[8].name}'
                          :'Trending', style: getHeaderStyle),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              AppRoutes.propertyListingPage,
                              arguments: {
                                'location': 'Bengaluru-Karnataka-India',
                                'property': Property.fromLocation,
                              });
                        },
                        child: Text(
                          '${nullCheck(list: value.searchPageLang)
                              ? '${value.searchPageLang[11].name}'
                              : 'See All'}',
                          style: TextStyle(
                              color: CustomTheme.appThemeContrast,
                              fontSize:
                              getHeight(context: context, height: 14),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                _getTrendingProperties(context: context, model: value),
                /*Text(nullCheck(list: value.searchPageLang)
                    ? '${value.searchPageLang[9].name}'
                    :'First Booking Offer', style: getHeaderStyle),*/
                SizedBox(
                  height: _mainHeight * 0.02,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: _mainHeight * 0.13,
          left: _mainWidth * 0.035,
          child: showSearchResults
              ? Container(
                  height: _mainHeight * 0.32,
                  width: _mainWidth * 0.93,
                  child: showSuggestions(value: value))
              : Container(),
        ),
      ],
    );
  }

  Widget showSuggestions({required PropertyViewModel value}) {
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
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      _searchController.text = value.locations[index].location;
                      setState(() {
                        showSearchResults = false;
                      });
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
  Widget _getTrendingProperties(
      {required BuildContext context, required PropertyViewModel model}) {
    if (model.homePageModel.msg != null &&
        model.homePageModel.data != null &&
        model.homePageModel.data?.trendingProps != null &&
        model.homePageModel.data?.trendingProps!.length != 0) {
      return Container(
        height: _mainHeight * 0.23,
        decoration: BoxDecoration(
          //  color: Colors.amber,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          itemBuilder: (context, index) {
            final data = model.homePageModel.data != null &&
                model.homePageModel.data?.trendingProps != null &&
                model.homePageModel.data?.trendingProps!.length != 0
                ? model.homePageModel.data?.trendingProps![index]
            as TrendingProps
                : TrendingProps();
            return InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(AppRoutes.propertyDetailsPage, arguments: {
                'propId': data.propId ?? '',
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
                              imageUrl: data.picThumbnail ?? '',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                                      child: const Icon(Icons.error))
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
                                    data.title ?? '',
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
                                  child: Text(
                                    data.buildingName != null
                                        ? data.buildingName.toString()
                                        : '',
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
                                      data.monthRentOff != null &&
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
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(
                                      left: _mainWidth * 0.01,
                                      top: _mainHeight * 0.003),
                                  child: Text(
                                    nullCheck(list: model.searchPageLang)
                                        ? '${model.searchPageLang[10].name}'
                                        :'More Info',
                                    style: TextStyle(
                                      fontSize: getHeight(
                                          context: context, height: 12),
                                      color: CustomTheme.appThemeContrast,

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
                  Positioned(
                    right: _mainHeight * 0.015,
                    top: _mainHeight * 0.01,
                    child: GestureDetector(
                      onTap: () async {
                        if (data.wishlist != null && data.wishlist == 1) {

                          if (data.propId != null) {

                            int response = await _propertyViewModel.addToWishlist(
                                propertyId: data.propId ?? '');
                            if (response == 200) {
                              setState(() {
                                data.wishlist = 0;
                              });
                              RMSWidgets.showSnackbar(
                                  context: context,
                                  message: 'Successfully Removed From Wishlist',
                                  color: CustomTheme.appTheme);
                            }
                          }
                        }
                        else if (data.wishlist != null && data.wishlist == 0) {

                          if (data.propId != null) {

                            int response = await _propertyViewModel.addToWishlist(
                                propertyId: data.propId ?? '');
                            if (response == 200) {
                              setState(() {
                                data.wishlist = 1;
                              });
                              RMSWidgets.showSnackbar(
                                  context: context,
                                  message: 'Successfully Added to Wishlist',
                                  color: CustomTheme.appTheme);
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
                  )
                ],
              ),
            );
          },
          itemCount: model.homePageModel.data?.trendingProps!.length ?? 0,
          scrollDirection: Axis.horizontal,
        ),
      );
    } else if ((model.homePageModel.msg != null &&
        model.homePageModel.data != null &&
        model.homePageModel.data?.trendingProps != null &&
        model.homePageModel.data?.trendingProps!.length == 0) ||
        (model.homePageModel.msg != null &&
            model.homePageModel.data != null &&
            model.homePageModel.data?.trendingProps == null)) {
      return Center(
          child: RMSWidgets.someError(
            context: context,
          ));
    } else {
      return Container(
        height: _mainHeight * 0.23,
        width: _mainWidth,
        //color: Colors.amber,
        child: ListView.separated(itemBuilder: (_,index){

          return Shimmer
              .fromColors(
              child:
              Container(
                decoration: BoxDecoration(
                    color:
                    Colors.grey,
                    borderRadius: BorderRadius.circular(10)
                ),
                height:_mainHeight * 0.22,
                width: _mainWidth*0.42,

              ),
              baseColor: Colors.grey[200]
              as Color,
              highlightColor:
              Colors.grey[350] as Color);
        },itemCount: 4,
            separatorBuilder: (_,__)=>SizedBox(width: _mainWidth*0.02,),
            scrollDirection:Axis.horizontal),
      );
    }
  }

  bool showOrgPrice({required String monthlyRent, required String orgRent}) {
    if (orgRent == '0') {
      return true;
    }
    return orgRent != '0' &&
        monthlyRent != '0' &&
        (monthlyRent.toString() == orgRent.toString());
  }

  List<UtilsModel> getExploreMoreCitiesList() {
    exploreMoreCitiesList = [
      UtilsModel(
          key: 'Bangalore',
          value: 'Bengaluru-karnataka-India',
          imagePath: "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/newbangaloreimage.png?alt=media&token=b665228b-a72c-46f1-8683-0e0a0ce88d11",
          callback: () => Navigator.of(context)
              .pushNamed(AppRoutes.propertyListingPage, arguments: {
            'location': 'Bengaluru-Karnataka-India',
            'property': Property.fromLocation,
          })),
    ];
    return exploreMoreCitiesList;
  }
  List<UtilsModel> getLocationsList() {
    locationsList = [
      UtilsModel(
          key: 'Bangalore',
          callback: () => Navigator.of(context)
                  .pushNamed(AppRoutes.propertyListingPage, arguments: {
                'location': 'Bengaluru-Karnataka-India',
                'property': Property.fromLocation,
              })),
      UtilsModel(
          key: 'BTM Layout',
          callback: () => Navigator.of(context)
                  .pushNamed(AppRoutes.propertyListingPage, arguments: {
                'location': 'BTM-Layout-Bengaluru-Karnataka-India',
                'property': Property.fromLocation,
              })),
      UtilsModel(
          key: 'HSR Layout',
          callback: () => Navigator.of(context)
                  .pushNamed(AppRoutes.propertyListingPage, arguments: {
                'location': 'Hsr-layout-Bengaluru-Karnataka-India',
                'property': Property.fromLocation,
              })),
      UtilsModel(
          key: 'Kundlahalli',
          callback: () => Navigator.of(context)
                  .pushNamed(AppRoutes.propertyListingPage, arguments: {
                'location':
                    'Kundanahalli-Gate-ITPL-Main-Road-Brookefield-Bengaluru-Karnataka-India',
                'property': Property.fromLocation,
              })),
      UtilsModel(
          key: 'Marathalli',
          callback: () => Navigator.of(context)
                  .pushNamed(AppRoutes.propertyListingPage, arguments: {
                'location': 'Marathahalli-Bengaluru-Karnataka-India',
                'property': Property.fromLocation,
              })),
      UtilsModel(
          key: 'Whitefield',
          callback: () => Navigator.of(context)
                  .pushNamed(AppRoutes.propertyListingPage, arguments: {
                'location': 'Whitefield-Bengaluru-Karnataka-India',
                'property': Property.fromLocation,
              })),
      UtilsModel(
          key: 'Old Airport Road',
          callback: () => Navigator.of(context)
                  .pushNamed(AppRoutes.propertyListingPage, arguments: {
                'location': 'Old-airport-road-Bengaluru-Karnataka-India',
                'property': Property.fromLocation,
              })),
    ];
    return locationsList;
  }

  Widget getLocationBox({required String property, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            left: _mainWidth * 0.015, right: _mainWidth * 0.015),
        height: _mainHeight * 0.03,
        width: _mainWidth * 0.3,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          property,
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontSize: getHeight(context: context, height: 12)),
        ),
      ),
    );
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  Widget getExploreMoreCitiesView({required BuildContext context,required PropertyViewModel value}) {
    return LimitedBox(
        maxHeight: _mainHeight * 0.15,
        maxWidth: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var data = exploreMoreCitiesList[index];
            return InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(AppRoutes.propertyListingPage, arguments: {
                'location': exploreMoreCitiesList[index].value??'Bengaluru-Karnataka-India',
                'property': Property.fromLocation,
              }),
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                elevation: 3,
                shadowColor: CustomTheme.appTheme,
                child: Stack(
                  children: [
                    Container(
                      width: _mainWidth * 0.4,
                      child: CachedNetworkImage(
                        imageUrl: data.imagePath ?? '',
                        imageBuilder: (context, imageProvider) =>
                            Container(
                              height: _mainHeight * 0.15,
                              //width: _mainWidth * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                        const Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                        left: _mainWidth*0.02,
                        bottom: _mainHeight*0.01,
                        child: LimitedBox(
                          maxWidth: _mainWidth*0.38,
                          child: Text('${data.key ?? 'Bangalore'}' ,style: TextStyle(
                            color: Colors.white,
                            fontSize: getHeight(context: context, height: 14),
                            fontWeight: FontWeight.w600
                          ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ),),
                  ],
                ),
              ),
            );
          },
          itemCount: exploreMoreCitiesList.length,
        ));
  }


  Widget getDesireProperties({required BuildContext context,required PropertyViewModel value}) {
    return LimitedBox(
        maxHeight: _mainHeight * 0.255,
        maxWidth: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var data = _propertyViewModel.getPopularPropertyModelList()[index];
            return InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(AppRoutes.propertyListingPage, arguments: {
                'location': 'Bengaluru-Karnataka-India',
                'propertyType': data.propertyType,
                'property': Property.fromBHK,
              }),
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                elevation: 3,
                shadowColor: CustomTheme.appTheme,
                child: Container(
                  width: _mainWidth * 0.45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: _mainHeight * 0.13,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            image: DecorationImage(
                                image: AssetImage(data.imageUrl ?? ''),
                                fit: BoxFit.cover
                                //NetworkImage(data.imageUrl!),fit: BoxFit.cover,
                                )),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: _mainWidth * 0.02, top: _mainHeight * 0.01),
                          alignment: Alignment.topLeft,
                          child: Text(data.propertyType ?? '',
                              style: TextStyle(
                                fontSize:
                                    getHeight(context: context, height: 14),
                                color: CustomTheme.appTheme,
                                fontWeight: FontWeight.w600,
                              ))),
                      Container(
                        // width: _mainWidth*0.45,

                        // color: Colors.purple,
                        margin: EdgeInsets.only(
                            left: _mainWidth * 0.02, top: _mainHeight * 0.005),
                        alignment: Alignment.topLeft,
                        child: Text(data.propertyDesc ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: getHeight(context: context, height: 12),
                            )),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: _mainWidth * 0.02,
                              top: _mainHeight * 0.005),
                          child: Text(nullCheck(list: value.searchPageLang)
                              ? '${value.searchPageLang[10].name}'
                              :'More Info',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      getHeight(context: context, height: 12),
                                  color: CustomTheme.appThemeContrast))),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: _propertyViewModel.getPopularPropertyModelList().length,
        ));
  }

  TextStyle get getHeaderStyle => TextStyle(
      color: CustomTheme.appTheme,
      fontSize: getHeight(context: context, height: 16),
      fontWeight: FontWeight.w500);
}
