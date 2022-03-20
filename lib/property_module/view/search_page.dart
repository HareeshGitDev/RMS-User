import 'dart:developer';

import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/color.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/service/system_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../utils/constants/enum_consts.dart';
import '../../utils/service/date_time_service.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/view/calander_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

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


  TextStyle get getTextStyle => const TextStyle(
      color: Colors.black,
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 15);

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Consumer<PropertyViewModel>(
      builder: (context, value, child) {
        return Scaffold(
          body: Container(
            width: _mainWidth,
            color: Colors.white,
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 45,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                          // shadowLightColor: CustomTheme.appTheme.withAlpha(150),
                          shadowDarkColor: Colors.blueGrey.shade100,
                         // color: Colors.black26.withAlpha(40),
                        color: Colors.white,border: NeumorphicBorder(color: CustomTheme.appTheme,width: 1),
                        lightSource: LightSource.bottom,
                          intensity: 5,
                          depth: 2,
                          shape:NeumorphicShape.convex, ),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back,
                                size: 20,
                              )),
                          Container(
                            width: _mainWidth * 0.78,
                            height: 44,
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
                                  hintText:
                                      'Search by Locality , Landmark or City',
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
                  Visibility(
                    visible: !showSearchResults,
                    replacement: Container(
                        padding: EdgeInsets.only(
                            left: 0, bottom: 10, right: 0, top: 10),
                        height: _mainHeight,
                        color: Colors.white,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => setState(() {
                                showSearchResults = false;
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _searchController.text = value.locations[index];
                              }),
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 15,
                                ),
                                height: 35,
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
                                  checkInDate =
                                      DateTimeService.ddMMYYYYformatDate(
                                          dateRange.startDate ??
                                              DateTime.now());
                                  checkOutDate =
                                      DateTimeService.ddMMYYYYformatDate(
                                          dateRange.endDate ??
                                              DateTime.now().add(
                                                  const Duration(days: 1)));
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 35,
                            width: 80,
                            child:
                            ElevatedButton(
                              onPressed: () {
                                if (_searchController.text.isEmpty ||
                                    _searchController.text.length < 3) {
                                  return;
                                }

                                Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location': _searchController.text,
                                      'property': Property.FromSearch,
                                      'checkInDate': checkInDate,
                                      'checkOutDate': checkOutDate,
                                    });
                                FocusScope.of(context).unfocus();
                              },
                              child:
                              Text(
                                'Search',
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    CustomTheme.appTheme,
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Frequently Searched Locations',
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
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location': 'Bengaluru-Karnataka-India',
                                      'property': Property.FromLocation,
                                    }),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    //  color: Colors.blueGrey.shade50,
                                    border:
                                        Border.all(color: CustomTheme.appTheme),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Bangalore',
                                    style: getTextStyle,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location':
                                          'BTM-Layout-Bengaluru-Karnataka-India',
                                      'property': Property.FromLocation,
                                    }),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    //  color: Colors.blueGrey.shade50,
                                    border:
                                        Border.all(color: CustomTheme.appTheme),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'BTM Layout',
                                    style: getTextStyle,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location':
                                          'Hsr-layout-Bengaluru-Karnataka-India',
                                      'property': Property.FromLocation,
                                    }),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    //  color: Colors.blueGrey.shade50,
                                    border:
                                        Border.all(color: CustomTheme.appTheme),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'HSR Layout',
                                    style: getTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location':
                                          'Kundanahalli-Gate-ITPL-Main-Road-Brookefield-Bengaluru-Karnataka-India',
                                      'property': Property.FromLocation,
                                    }),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    //  color: Colors.blueGrey.shade50,
                                    border:
                                        Border.all(color: CustomTheme.appTheme),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Kundlahalli',
                                    style: getTextStyle,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location':
                                          'Marathahalli-Bengaluru-Karnataka-India',
                                      'property': Property.FromLocation,
                                    }),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    //  color: Colors.blueGrey.shade50,
                                    border:
                                        Border.all(color: CustomTheme.appTheme),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Marathalli',
                                    style: getTextStyle,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location':
                                          'Whitefield-Bengaluru-Karnataka-India',
                                      'property': Property.FromLocation,
                                    }),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    //  color: Colors.blueGrey.shade50,
                                    border:
                                        Border.all(color: CustomTheme.appTheme),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Whitefield',
                                    style: getTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                                AppRoutes.propertyListingPage,
                                arguments: {
                                  'location':
                                      'Old-airport-road-Bengaluru-Karnataka-India',
                                  'property': Property.FromLocation,
                                }),
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              width: 110,
                              decoration: BoxDecoration(
                                //  color: Colors.blueGrey.shade50,
                                border: Border.all(color: CustomTheme.appTheme),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Old Airport Road',
                                style: getTextStyle,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Search by Desired Property Type',
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
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location': 'Bengaluru-Karnataka-India',
                                      'propertyType': '1BHK',
                                      'property': Property.FromBHK,
                                    }),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    //  color: Colors.blueGrey.shade50,
                                    border:
                                        Border.all(color: CustomTheme.appTheme),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '1 BHK',
                                    style: getTextStyle,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location': 'Bengaluru-Karnataka-India',
                                      'propertyType': '2BHK',
                                      'property': Property.FromBHK,
                                    }),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    //  color: Colors.blueGrey.shade50,
                                    border:
                                        Border.all(color: CustomTheme.appTheme),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '2 BHK',
                                    style: getTextStyle,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.propertyListingPage,
                                    arguments: {
                                      'location': 'Bengaluru-Karnataka-India',
                                      'propertyType': '1BHK',
                                      'property': Property.FromBHK,
                                    }),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    //  color: Colors.blueGrey.shade50,
                                    border:
                                        Border.all(color: CustomTheme.appTheme),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Studio',
                                    style: getTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
