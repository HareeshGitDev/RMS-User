import 'dart:developer';

import 'package:RentMyStay_user/extensions/extensions.dart';
import 'package:RentMyStay_user/my_stays/model/mystay_list_model.dart';
import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';

class MyStayListPage extends StatefulWidget {
  @override
  _MyStayListPageState createState() => _MyStayListPageState();
}

class _MyStayListPageState extends State<MyStayListPage> {
  static const String fontFamily = 'hk-grotest';
  late MyStayViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getMyStayList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: CustomTheme.green,
            toolbarHeight: 50,
            title: Text('My Stays'),
            titleSpacing: 0,
            bottom: TabBar(
              indicatorColor: CustomTheme.peach,
              tabs: const [
                Tab(
                  child: Text(
                    "Active Booking",
                    style: TextStyle(fontSize: 16, fontFamily: fontFamily),
                  ),
                ),
                Tab(
                    child: Text(
                  "Complete Booking",
                  style: TextStyle(fontSize: 16, fontFamily: fontFamily),
                )),
              ],
            ),
          ),

          /*--------------- Build Tab body here -------------------*/
          body: Consumer<MyStayViewModel>(
            builder: (context, value, child) {
              return Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 15),
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
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
          itemBuilder: (context, index) {
            var data = activeBookingList[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 5, right: 10, top: 10),
                      child: Text(
                        data.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5,top: 5,bottom: 5),
                    child: Row(
                      children: [
                        Container(
                          height: 70,
                          width: 75,
                          padding: const EdgeInsets.only(right: 10),
                          child: CachedNetworkImage(
                            imageUrl: data.picThumbnail.toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius:  BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                                child: Container(
                                  height: 70,
                                  color: Colors.grey,
                                ),
                                baseColor: Colors.grey[200] as Color,
                                highlightColor: Colors.grey[350] as Color),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.numGuests ?? " "} guests',
                              ),
                              Text(data.bookingDatetime ?? ''),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('ID: ${data.bookingId}'),
                            Text(
                              data.checkInStatus == '0'
                                  ? 'Upcoming'
                                  : 'Success',
                            ),
                            Row(
                              children: [
                                Text(
                                  checkDateFormat(data.travelFromDate) ?? '',
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  checkDateFormat(data.travelToDate) ?? '',
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: activeBookingList.length),
    );
  }

  Widget getCompletedTab(
      {required List<Result> completedBookingList,
      required BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,

      child: ListView.separated(
          itemBuilder: (context, index) {
            var data = completedBookingList[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: Colors.blueGrey.shade100,
              child: Column(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 5, right: 10, top: 10),
                      child: Text(
                        data.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5,top: 5,bottom: 5),
                    child: Row(
                      children: [
                        Container(
                          height: 70,
                          width: 75,
                          padding: const EdgeInsets.only(right: 10),
                          child: CachedNetworkImage(
                            imageUrl: data.picThumbnail.toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius:  BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                                child: Container(
                                  height: 70,
                                  width: 75,

                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:  BorderRadius.circular(10),
                                  ),
                                ),
                                baseColor: Colors.grey[200] as Color,
                                highlightColor: Colors.grey[350] as Color),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error,color: Colors.red,),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.numGuests ?? " "} guests',
                              ),
                              Text(data.bookingDatetime ?? ''),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('ID: ${data.bookingId}'),
                            Text(
                              data.checkInStatus == '0'
                                  ? 'Upcoming'
                                  : 'Success',
                            ),
                            Row(
                              children: [
                                Text(
                                  checkDateFormat(data.travelFromDate) ?? '',
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  checkDateFormat(data.travelToDate) ?? '',
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
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
