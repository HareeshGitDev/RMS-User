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

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Consumer<PropertyViewModel>(
      builder: (context, value, child) {
        return Scaffold(
          body: Container(
             height: _mainHeight,
            width: _mainWidth,
            color: Colors.white,
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    color: Colors.blueGrey.shade50,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back,size: 20,)),
                        Container(
                          width: _mainWidth*0.78,
                          height: 44,


                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (text) async {
                              if (text.length < 3) {
                                return;
                              }
                              await value.getSearchedPlace(text);
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search by Locality , Landmark or City',hintStyle: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500
                            ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    _searchController.clear();
                                    FocusScope.of(context).unfocus();
                                    setState(() {});
                                  },
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: _searchController.text.length < 3,
                    replacement: Container(

                        padding: EdgeInsets.only(left: 0, bottom: 10,right: 0,top: 10),
                        height: _mainHeight,
                        child: ListView.separated(padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed(
                                  AppRoutes.propertyListingPage,
                                  arguments: {
                                    'location': value.locations[index],
                                    'property': Property.FromSearch,
                                    'checkInDate': checkInDate,
                                    'checkOutDate': checkOutDate,
                                  }),
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 15,
                                ),
                                height: 35,

                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 20,
                                      color: CustomTheme.skyBlue,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(

                                      width: _mainWidth*0.8,
                                      child: Text(
                                        value.locations[index],
                                        style: TextStyle(
                                            fontFamily: fontFamily,
                                            fontSize: 14,
                                            color: Colors.grey,
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
                      height: _mainHeight,
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
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
                                          dateRange.startDate ?? DateTime.now());
                                  checkOutDate =
                                      DateTimeService.ddMMYYYYformatDate(
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
                                  color: CustomTheme.peach,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
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
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Frequently Searched Locations',
                              style: TextStyle(
                                  color: CustomTheme.peach,
                                  fontFamily: fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
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
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Bangalore',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
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
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'BTM Layout',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
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
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'HSR Layout',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
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
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Kundlahalli',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
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
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Marathalli',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
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
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Whitefield',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
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
                                color: Colors.blueGrey.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Old Airport Road',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
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
                                  color: CustomTheme.peach,
                                  fontFamily: fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
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
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '1 BHK',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
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
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '2 BHK',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
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
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Studio',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
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
