import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/service/system_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../theme/custom_theme.dart';
import '../../utils/constants/enum_consts.dart';
import '../../language_module/model/language_model.dart';
import '../../utils/service/bottom_navigation_provider.dart';
import '../../utils/service/date_time_service.dart';
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
    getLanguageData();
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
              left: _mainHeight * 0.015,
              right: _mainHeight * 0.015,
              top: _mainHeight * 0.015,
              bottom: _mainHeight * 0.015),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: _mainHeight * 0.045,
                ),
                Container(
                  height: 45,
                  child: Neumorphic(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    style: NeumorphicStyle(
                      shadowLightColor: CustomTheme.appTheme.withAlpha(150),
                      //CustomTheme.appTheme.withAlpha(150),
                      shadowDarkColor: CustomTheme.appTheme.withAlpha(150),

                      color: Colors.white,
                      lightSource: LightSource.bottom,
                      intensity: 5,
                      depth: 2,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: widget.fromBottom
                                ? () => Provider.of<BottomNavigationProvider>(
                                        context,
                                        listen: false)
                                    .shiftBottom(index: 0)
                                : () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back,
                              size: 20,
                            )),
                        Container(
                          width: _mainWidth * 0.78,
                          height: 45,
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
                                    setState(() {
                                      showSearchResults = false;
                                    });
                                  },
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: _mainHeight * 0.85,
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          PickerDateRange? dateRange =
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
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
                          height: _mainHeight * 0.06,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    nullCheck(list: value.searchPageLang)
                                        ? '${value.searchPageLang[1].name}'
                                        : 'CheckIn Date',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    nullCheck(list: value.searchPageLang)
                                        ? '${value.searchPageLang[2].name}'
                                        : 'CheckOut Date',
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
                        height: 10,
                      ),
                      SizedBox(
                        height: 35,
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

                            Navigator.of(context).pushNamed(
                                AppRoutes.propertyListingPage,
                                arguments: {
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
                                fontFamily: fontFamily,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                CustomTheme.appTheme,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          nullCheck(list: value.searchPageLang)
                              ? '${value.searchPageLang[4].name}'
                              : 'Frequently Searched Locations',
                          style: TextStyle(
                            //  color: CustomTheme.appTheme,
                            fontFamily: fontFamily,
                            // fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getLocationBox(
                              property: 'Bangalore',
                              onTap: () => Navigator.of(context).pushNamed(
                                      AppRoutes.propertyListingPage,
                                      arguments: {
                                        'location': 'Bengaluru-Karnataka-India',
                                        'property': Property.fromLocation,
                                      })),
                          getLocationBox(
                              property: 'BTM Layout',
                              onTap: () => Navigator.of(context).pushNamed(
                                      AppRoutes.propertyListingPage,
                                      arguments: {
                                        'location':
                                            'BTM-Layout-Bengaluru-Karnataka-India',
                                        'property': Property.fromLocation,
                                      })),
                          getLocationBox(
                              property: 'HSR Layout',
                              onTap: () => Navigator.of(context).pushNamed(
                                      AppRoutes.propertyListingPage,
                                      arguments: {
                                        'location':
                                            'Hsr-layout-Bengaluru-Karnataka-India',
                                        'property': Property.fromLocation,
                                      })),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getLocationBox(
                              property: 'Kundlahalli',
                              onTap: () => Navigator.of(context).pushNamed(
                                      AppRoutes.propertyListingPage,
                                      arguments: {
                                        'location':
                                            'Kundanahalli-Gate-ITPL-Main-Road-Brookefield-Bengaluru-Karnataka-India',
                                        'property': Property.fromLocation,
                                      })),
                          getLocationBox(
                              property: 'Marathalli',
                              onTap: () => Navigator.of(context).pushNamed(
                                      AppRoutes.propertyListingPage,
                                      arguments: {
                                        'location':
                                            'Marathahalli-Bengaluru-Karnataka-India',
                                        'property': Property.fromLocation,
                                      })),
                          getLocationBox(
                              property: 'Whitefield',
                              onTap: () => Navigator.of(context).pushNamed(
                                      AppRoutes.propertyListingPage,
                                      arguments: {
                                        'location':
                                            'Whitefield-Bengaluru-Karnataka-India',
                                        'property': Property.fromLocation,
                                      })),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getLocationBox(
                              property: 'Old Airport Road',
                              onTap: () => Navigator.of(context).pushNamed(
                                      AppRoutes.propertyListingPage,
                                      arguments: {
                                        'location':
                                            'Old-airport-road-Bengaluru-Karnataka-India',
                                        'property': Property.fromLocation,
                                      })),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          nullCheck(list: value.searchPageLang)
                              ? '${value.searchPageLang[5].name}'
                              : 'Search by Desired Property Type',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: fontFamily,
                            // fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getLocationBox(
                            property: '1 BHK',
                            onTap: () => Navigator.of(context).pushNamed(
                              AppRoutes.propertyListingPage,
                              arguments: {
                                'location': 'Bengaluru-Karnataka-India',
                                'propertyType': '1BHK',
                                'property': Property.fromBHK,
                              },
                            ),
                          ),
                          getLocationBox(
                            property: '2 BHK',
                            onTap: () => Navigator.of(context).pushNamed(
                              AppRoutes.propertyListingPage,
                              arguments: {
                                'location': 'Bengaluru-Karnataka-India',
                                'propertyType': '2BHK',
                                'property': Property.fromBHK,
                              },
                            ),
                          ),
                          getLocationBox(
                            property: 'Studio',
                            onTap: () => Navigator.of(context).pushNamed(
                              AppRoutes.propertyListingPage,
                              arguments: {
                                'location': 'Bengaluru-Karnataka-India',
                                'propertyType': 'Studio',
                                'property': Property.fromBHK,
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: _mainHeight * 0.12,
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
      child: Container(
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
          )),
    );
  }

  Widget getLocationBox({required String property, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            left: _mainWidth * 0.015, right: _mainWidth * 0.015),
        height: _mainHeight * 0.04,
        width: _mainWidth * 0.3,
        decoration: BoxDecoration(
          border: Border.all(color: CustomTheme.appTheme),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          property,
          style: getTextStyle,
        ),
      ),
    );
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;
}
