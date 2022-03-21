import 'dart:developer';

import 'package:RentMyStay_user/extensions/extensions.dart';
import 'package:RentMyStay_user/my_stays/model/mystay_list_model.dart';
import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/service/bottom_navigation_provider.dart';

class MyStayListPage extends StatefulWidget {
  final bool fromBottom;
  const MyStayListPage({Key? key,required this.fromBottom}) : super(key: key);

  @override
  _MyStayListPageState createState() => _MyStayListPageState();
}

class _MyStayListPageState extends State<MyStayListPage> {
  static const String fontFamily = 'hk-grotest';
  late MyStayViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getMyStayList();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            leading: widget.fromBottom
                ? WillPopScope(
                child: Container(),
                onWillPop: () async {
                  Provider.of<BottomNavigationProvider>(context, listen: false)
                      .shiftBottom(index: 0);
                  return false;
                })
                :const BackButton(),
            backgroundColor: CustomTheme.appTheme,
            toolbarHeight: _mainHeight * 0.05,
            title: Text(
              'My Stays',
              style: TextStyle(fontFamily: fontFamily),
            ),
            titleSpacing: 0,
            bottom: TabBar(
              indicatorColor: CustomTheme.peach,
              tabs: const [
                Tab(
                  child: Text(
                    "Active Booking",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Tab(
                    child: Text(
                  "Completed Booking",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
              ],
            ),
          ),

          /*--------------- Build Tab body here -------------------*/
          body: Consumer<MyStayViewModel>(
            builder: (context, value, child) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                    left: _mainWidth * 0.02,
                    right: _mainWidth * 0.02,
                    top: _mainHeight * 0.01),
                margin: EdgeInsets.only(bottom: _mainHeight * 0.01),
                child: TabBarView(
                  children: <Widget>[
                    getActiveTab(
                        activeBookingList: value.activeBookingList != null
                            ? value.activeBookingList!
                            : [],
                        context: context),
                    getCompletedTab(
                        completedBookingList: value.completedBookingList != null
                            ? value.completedBookingList!
                            : [],
                        context: context),
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget getActiveTab(
      {required List<Result> activeBookingList,
      required BuildContext context}) {
    return Container(
      width: _mainWidth,
      child: ListView.separated(
          itemBuilder: (context, index) {
            var data = activeBookingList[index];
            return GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.myStayDetailsPage,
                  arguments: data.bookingId),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      height: _mainHeight * 0.085,
                      width: _mainWidth * 0.20,
                      padding: EdgeInsets.only(right: _mainWidth * 0.02),
                      child: CachedNetworkImage(
                        imageUrl: data.picThumbnail.toString(),
                        imageBuilder: (context, imageProvider) => Container(
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
                              height: _mainHeight * 0.075,
                              width: _mainWidth * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            baseColor: Colors.grey[200] as Color,
                            highlightColor: Colors.grey[350] as Color),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: _mainWidth * 0.72,
                            child: Text(
                              data.title ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            )),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        Container(
                          width: _mainWidth * 0.72,
                          child: Row(
                            children: [
                              Text(
                                '${data.numGuests ?? " "} guests',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              Spacer(),
                              Text(
                                checkDateFormat(data.travelFromDate) ?? '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                checkDateFormat(data.travelToDate) ?? '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        Container(
                          width: _mainWidth * 0.72,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ID: ${data.bookingId}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                data.checkInStatus == '0'
                                    ? 'Upcoming'
                                    : 'Success',
                                style: TextStyle(
                                  color: CustomTheme.myFavColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) =>
              SizedBox(height: _mainHeight * 0.005),
          itemCount: activeBookingList.length),
    );
  }

  Widget getCompletedTab(
      {required List<Result> completedBookingList,
      required BuildContext context}) {
    return Container(
      width: _mainWidth,
      child: ListView.separated(
          itemBuilder: (context, index) {
            var data = completedBookingList[index];
            return GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.myStayDetailsPage,
                  arguments: data.bookingId),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.blueGrey.shade100,
                child: Row(
                  children: [
                    Container(
                      height: _mainHeight * 0.085,
                      width: _mainWidth * 0.20,
                      padding: EdgeInsets.only(right: _mainWidth * 0.02),
                      child: CachedNetworkImage(
                        imageUrl: data.picThumbnail.toString(),
                        imageBuilder: (context, imageProvider) => Container(
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
                              height: _mainHeight * 0.075,
                              width: _mainWidth * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            baseColor: Colors.grey[200] as Color,
                            highlightColor: Colors.grey[350] as Color),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: _mainWidth * 0.72,
                            child: Text(
                              data.title ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            )),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        Container(
                          width: _mainWidth * 0.72,
                          child: Row(
                            children: [
                              Text(
                                '${data.numGuests ?? " "} guests',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              Spacer(),
                              Text(
                                checkDateFormat(data.travelFromDate) ?? '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                checkDateFormat(data.travelToDate) ?? '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        Container(
                          width: _mainWidth * 0.72,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ID: ${data.bookingId}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                data.checkInStatus == '0'
                                    ? 'Upcoming'
                                    : 'Success',
                                style: TextStyle(
                                  color: CustomTheme.myFavColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) =>
              SizedBox(height: _mainHeight * 0.005),
          itemCount: completedBookingList.length),
    );
  }

  String? checkDateFormat(String? travelFromDate) {
    DateTime date = DateTime.now();
    if (travelFromDate != null) {
      date = DateTime.parse(travelFromDate);
    }

    return '${date.monthName} ${date.day},${date.year}';
  }
}
