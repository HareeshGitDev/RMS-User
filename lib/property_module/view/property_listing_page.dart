import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/color.dart';
import 'package:RentMyStay_user/utils/constants/enum_consts.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../../home_module/model/invite_and_earn_model.dart';
import '../../images.dart';

class PropertyListingPage extends StatefulWidget {
  String locationName;
  String? propertyType;
  Property property;

  PropertyListingPage(
      {Key? key,
      required this.locationName,
      this.propertyType,
      required this.property})
      : super(key: key);

  @override
  _PropertyListingPageState createState() => _PropertyListingPageState();
}

class _PropertyListingPageState extends State<PropertyListingPage> {
  var _mainHeight;
  var _mainWidth;
  late PropertyViewModel _propertyViewModel;
  static const String fontFamily = 'hk-grotest';

  @override
  void initState() {
    _propertyViewModel = Provider.of<PropertyViewModel>(context, listen: false);

    if (widget.property == Property.FromLocation) {
      _propertyViewModel.getPropertyDetailsList(
          address: widget.locationName, property: Property.FromLocation);
    } else if (widget.property == Property.FromBHK) {
      _propertyViewModel.getPropertyDetailsList(
          address: widget.locationName,
          property: widget.property,
          propertyType: widget.propertyType);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Consumer<PropertyViewModel>(
      builder: (context, value, child) {
        if (value.propertyListModel.data != null) {
          return Scaffold(
            appBar: _getAppBar(context: context),
            body: Container(
              color: Colors.white,
              height: _mainHeight,
              width: _mainWidth,
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 0),
              child: Stack(
                children: [
                  ListView.separated(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.propertyDetailsPage,
                            arguments:
                                value.propertyListModel.data![index].propId),
                        child: SizedBox(
                          height: _mainHeight * 0.46,
                          child: Card(
                            elevation: 5,
                            shadowColor: CustomTheme.skyBlue,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CarouselSlider(
                                      items: value.propertyListModel
                                              .data![index].propPics
                                              ?.map((e) => CachedNetworkImage(
                                                    imageUrl:
                                                        e.picLink.toString(),
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Shimmer.fromColors(
                                                            child: Container(
                                                              height: 225,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            baseColor:
                                                                Colors.grey[200]
                                                                    as Color,
                                                            highlightColor:
                                                                Colors.grey[350]
                                                                    as Color),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ))
                                              .toList() ??
                                          [],
                                      options: CarouselOptions(
                                          height: 225,
                                          enlargeCenterPage: true,
                                          autoPlay: true,
                                          aspectRatio: 16 / 9,
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enableInfiniteScroll: true,
                                          viewportFraction: 1),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      child: Container(
                                        height: _mainHeight * 0.025,
                                        //color:Colors.amber,

                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
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
                                                value
                                                        .propertyListModel
                                                        .data![index]
                                                        .buildingName ??
                                                    " ",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              value.propertyListModel
                                                      .data![index].unitType ??
                                                  " ",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                      ),
                                      visible: value.propertyListModel
                                                  .data![index].rmsProp !=
                                              null &&
                                          value.propertyListModel.data![index]
                                                  .rmsProp ==
                                              "RMS Prop",
                                    ),
                                    Visibility(
                                      visible: value.propertyListModel
                                                  .data![index].rmsProp !=
                                              null &&
                                          value.propertyListModel.data![index]
                                                  .rmsProp ==
                                              "RMS Prop",
                                      child: Container(
                                        child: Text(
                                          'Multiple Units Available',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              fontFamily: fontFamily),
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 10),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      width: _mainWidth * 0.75,
                                      child: Text(
                                        value.propertyListModel.data![index]
                                                .title ??
                                            " ",
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
                                        if ((value.propertyListModel.data !=
                                                    null &&
                                                value.propertyListModel
                                                        .data?[index].glat !=
                                                    null) &&
                                            (value.propertyListModel.data !=
                                                    null &&
                                                value.propertyListModel
                                                        .data?[index].glng !=
                                                    null)) {
                                          var latitude = (value
                                                  .propertyListModel
                                                  .data?[index]
                                                  .glat)
                                              .toString();
                                          var longitude = (value
                                                  .propertyListModel
                                                  .data?[index]
                                                  .glng)
                                              .toString();
                                          await SystemService.launchGoogleMaps(
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
                                                  left: 10, top: 5),
                                              child: Icon(
                                                Icons.my_location_outlined,
                                                color: myFavColor,
                                                size: 18,
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
                                                        EdgeInsets.only(top: 7),
                                                    child: Text(
                                                      (value
                                                                  .propertyListModel
                                                                  .data![index]
                                                                  .areas ??
                                                              value
                                                                  .propertyListModel
                                                                  .data![index]
                                                                  .city) ??
                                                          " ",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                      height: 5,
                                    ),
                                    Divider(
                                      color: CustomTheme.skyBlue,
                                      height: 1,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                         //color: Colors.amber,
                                        height: 20,
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        //  color: Colors.blue,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Rent Per Day',
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            value.propertyListModel.data![index]
                                                        .orgRent ==
                                                    value.propertyListModel
                                                        .data![index].rent
                                                ? Text(
                                                    ' Rs ${value.propertyListModel.data![index].rent ?? " "}',
                                                    style: TextStyle(
                                                        color: myFavColor,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14))
                                                : RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text:
                                                              'Rs ${value.propertyListModel.data![index].orgRent ?? " "}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  fontFamily,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough)),
                                                      TextSpan(
                                                          text:
                                                              ' Rs ${value.propertyListModel.data![index].rent ?? " "}',
                                                          style: TextStyle(
                                                              color: myFavColor,
                                                              fontFamily:
                                                                  fontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14)),
                                                    ]),
                                                  ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        )),
                                    Container(
                                      //color: Colors.amber,
                                        height: 20,
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        //  color: Colors.amber,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Rent (Stay < 3 Month)',
                                              style: TextStyle(
                                                fontFamily: fontFamily,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            value.propertyListModel.data![index]
                                                        .orgMonthRent ==
                                                    value
                                                        .propertyListModel
                                                        .data![index]
                                                        .monthlyRent
                                                ? Text(
                                                    ' Rs ${value.propertyListModel.data![index].monthlyRent ?? " "}',
                                                    style: TextStyle(
                                                        color: myFavColor,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14))
                                                : RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text:
                                                              'Rs ${value.propertyListModel.data![index].orgMonthRent ?? " "}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  fontFamily,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough)),
                                                      TextSpan(
                                                          text:
                                                              ' Rs ${value.propertyListModel.data![index].monthlyRent ?? " "}',
                                                          style: TextStyle(
                                                              color: myFavColor,
                                                              fontFamily:
                                                                  fontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14)),
                                                    ]),
                                                  ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        )),
                                    Container(
                                        //   color: Colors.amber,
                                        height: 20,
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        //   color: Colors.pink,
                                        child: Row(
                                          children: [
                                            Text('Rent (Stay > 3 Month)',
                                                style: TextStyle(
                                                  fontFamily: fontFamily,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            value.propertyListModel.data![index]
                                                        .orgRmsRent ==
                                                    value.propertyListModel
                                                        .data![index].rmsRent
                                                ? Text(
                                                    ' Rs ${value.propertyListModel.data![index].rmsRent ?? " "}',
                                                    style: TextStyle(
                                                        color: myFavColor,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14))
                                                : RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text:
                                                              'Rs ${value.propertyListModel.data![index].orgRmsRent ?? " "}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  fontFamily,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough)),
                                                      TextSpan(
                                                          text:
                                                              ' Rs ${value.propertyListModel.data![index].rmsRent ?? " "}',
                                                          style: TextStyle(
                                                              color: myFavColor,
                                                              fontFamily:
                                                                  fontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14)),
                                                    ]),
                                                  ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        )),
                                  ],
                                ),
                                Container(
                                  height: 40,
                                  width: _mainWidth,
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: value.propertyListModel
                                                    .data![index].rmsProp !=
                                                null &&
                                            value.propertyListModel.data![index]
                                                    .rmsProp ==
                                                "RMS Prop",
                                        child: Container(
                                          color: myFavColor,
                                          child: Row(children: [
                                            CircleAvatar(
                                                radius: 10,
                                                backgroundColor:
                                                    myFavColor.withAlpha(40),
                                                child: Icon(
                                                  Icons.check,
                                                  size: 15,
                                                  color: Colors.white,
                                                )),
                                            Container(
                                                color: myFavColor.withAlpha(95),
                                                child: Text(
                                                  'Managed by RMS',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.white,
                                                      fontFamily: fontFamily,
                                                      fontSize: 16),
                                                )),
                                          ]),
                                        ),
                                      ),
                                      Spacer(),
                                      value.propertyListModel.data![index]
                                                  .wishlist ==
                                              0
                                          ? GestureDetector(
                                              onTap: () async {
                                                if (value.propertyListModel
                                                        .data![index].propId !=
                                                    null) {
                                                  String response =
                                                      await _propertyViewModel
                                                          .addToWishlist(
                                                              propertyId: value
                                                                      .propertyListModel
                                                                      .data![
                                                                          index]
                                                                      .propId ??
                                                                  " ");
                                                  if (response ==
                                                      'Successfully added') {
                                                    setState(() {
                                                      value
                                                          .propertyListModel
                                                          .data![index]
                                                          .wishlist = 1;
                                                    });
                                                    RMSWidgets.showSnackbar(
                                                        context: context,
                                                        message: response,
                                                        color: CustomTheme
                                                            .skyBlue);
                                                  }
                                                }
                                              },
                                              child: const CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Colors.white60,
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
                                                if (value.propertyListModel
                                                        .data![index].propId !=
                                                    null) {
                                                  String response =
                                                      await _propertyViewModel
                                                          .addToWishlist(
                                                              propertyId: value
                                                                      .propertyListModel
                                                                      .data![
                                                                          index]
                                                                      .propId ??
                                                                  " ");
                                                  if (response ==
                                                      'Successfully removed') {
                                                    setState(() {
                                                      value
                                                          .propertyListModel
                                                          .data![index]
                                                          .wishlist = 0;
                                                    });
                                                    RMSWidgets.showSnackbar(
                                                        context: context,
                                                        message: response,
                                                        color: CustomTheme()
                                                            .colorError);
                                                  }
                                                }
                                              },
                                              child: const CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Colors.white60,
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
                    itemCount: value.propertyListModel.data?.length ?? 0,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                  ),
                  _getFilterSortSetting(context: context),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
              appBar: _getAppBar(context: context),
              body: Center(child: CircularProgressIndicator()));
        }
      },
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
      backgroundColor: CustomTheme.skyBlue,
      title: widget.property == Property.FromWishList
          ? Container(
              child: Text('My WishList'),
            )
          : Padding(
              padding: EdgeInsets.only(right: 10),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: -10,
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search by Area',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _getFilterSortSetting({required BuildContext context}) {
    return widget.property == Property.FromWishList
        ? Container()
        : Positioned(
            bottom: _mainHeight * 0.01,
            left: _mainWidth * 0.3,
            child: ElevatedButton(
              onPressed: () {
                log('Sort __ Filter');
              },
              child: Container(
                width: _mainWidth * 0.3,
                child: Row(
                  children: [
                    Icon(Icons.filter_alt_outlined),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Filter & Sort',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
