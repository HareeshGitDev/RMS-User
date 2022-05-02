import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/extensions/extensions.dart';
import 'package:RentMyStay_user/my_stays/model/mystay_list_model.dart';
import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../language_module/model/language_model.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/bottom_navigation_provider.dart';
import '../../utils/service/date_time_service.dart';
import '../../utils/service/shared_prefrences_util.dart';

class MyStayListPage extends StatefulWidget {
  final bool fromBottom;

  const MyStayListPage({Key? key, required this.fromBottom}) : super(key: key);

  @override
  _MyStayListPageState createState() => _MyStayListPageState();
}

class _MyStayListPageState extends State<MyStayListPage> {
  static const String fontFamily = 'hk-grotest';
  late MyStayViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;
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
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getMyStayList();
    getLanguageData();
  }

  getLanguageData() async {
    await _viewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'MyStays');
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus?DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            elevation: 5,
            leading: widget.fromBottom
                ? WillPopScope(
                    child: Container(),
                    onWillPop: () async {
                      Provider.of<BottomNavigationProvider>(context,
                              listen: false)
                          .shiftBottom(index: 0);
                      return false;
                    })
                : const BackButton(),
            backgroundColor: CustomTheme.appTheme,
            toolbarHeight: _mainHeight * 0.05,
            centerTitle: widget.fromBottom,
            title: Text(
              nullCheck(list: context.watch<MyStayViewModel>().myStayLang)
                  ? '${context.watch<MyStayViewModel>().myStayLang[0].name}'
                  : 'My Stays',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            titleSpacing: 0,
            bottom: TabBar(
              indicatorColor: CustomTheme.white,
              tabs: [
                Tab(
                  child: Text(
                    nullCheck(
                            list: context.watch<MyStayViewModel>().myStayLang)
                        ? '${context.watch<MyStayViewModel>().myStayLang[1].name}'
                        : "Active Bookings",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Tab(
                    child: Text(
                  nullCheck(list: context.watch<MyStayViewModel>().myStayLang)
                      ? '${context.watch<MyStayViewModel>().myStayLang[2].name}'
                      : "Completed Bookings",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
              ],
            ),
          ),
          body: Consumer<MyStayViewModel>(
            builder: (context, value, child) {
              return Container(
                color: Colors.white,
                height: _mainHeight,
                width: _mainWidth,
                padding: EdgeInsets.only(
                    left: _mainWidth * 0.02,
                    right: _mainWidth * 0.02,
                    top: _mainHeight * 0.01),
                margin: EdgeInsets.only(bottom: _mainHeight * 0.01),
                child: TabBarView(
                  children: <Widget>[
                    getActiveTab(
                        activeBookingList: value.activeBookingList,
                        context: context,
                        langList: value.myStayLang),
                    getCompletedTab(
                        completedBookingList: value.completedBookingList,
                        context: context,
                        langList: value.myStayLang),
                  ],
                ),
              );
            },
          )),
    ):RMSWidgets.networkErrorPage(context: context);
  }

  Widget getActiveTab(
      {required List<Result>? activeBookingList,
      required BuildContext context,
      required List<LanguageModel> langList}) {
    return activeBookingList != null && activeBookingList.isNotEmpty
        ? Container(
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
                            padding: EdgeInsets.only(
                                right: _mainWidth * 0.02,
                                bottom: _mainHeight * 0.005,
                                left: _mainWidth * 0.02),
                            child: CachedNetworkImage(
                              imageUrl: data.picThumbnail ?? '',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                                      DateTimeService.checkDateFormat(
                                              data.travelFromDate) ??
                                          '',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      DateTimeService.checkDateFormat(
                                              data.travelToDate) ??
                                          '',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
          )
        : activeBookingList != null && activeBookingList.isEmpty
            ? RMSWidgets.noData(
                context: context,
                message: nullCheck(list: langList)
                    ? '${langList[3].name}'
                    : 'No Any Active Bookings Found.')
            : Center(
                child: RMSWidgets.getLoader(
                color: CustomTheme.appTheme,
              ));
  }

  Widget getCompletedTab(
      {required List<Result>? completedBookingList,
      required BuildContext context,
      required List<LanguageModel> langList}) {
    return completedBookingList != null && completedBookingList.isNotEmpty
        ? Container(
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
                        borderRadius: BorderRadius.circular(10.0),
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
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                                      DateTimeService.checkDateFormat(
                                              data.travelFromDate) ??
                                          '',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      DateTimeService.checkDateFormat(
                                              data.travelToDate) ??
                                          '',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
          )
        : completedBookingList != null && completedBookingList.isEmpty
            ? RMSWidgets.noData(
                context: context,
                message: nullCheck(list: langList)
                    ? '${langList[4].name}'
                    : 'No Any Completed Bookings Found.')
            : Center(child: RMSWidgets.getLoader(color: CustomTheme.appTheme));
  }
}
