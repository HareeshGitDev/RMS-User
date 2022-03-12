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
  final List<bool> _sortKeys = [
    false,
    false,
    false,
  ];

  @override
  void initState() {
    _propertyViewModel = Provider.of<PropertyViewModel>(context, listen: false);
    log('XXXXXXX  ${widget.property}');
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('Called BUUUUU');
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
              padding: EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 0),
              child: Stack(
                children: [
                  ListView.separated(
                    itemBuilder: (context, index) {
                      var data = value.propertyListModel.data![index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.propertyDetailsPage,
                            arguments:
                                value.propertyListModel.data![index].propId),
                        child: SizedBox(
                          height: _mainHeight * 0.48,
                          child: Card(
                            elevation: 5,
                            shadowColor: CustomTheme.appTheme,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CarouselSlider(
                                      items: data.propPics
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
                                                data.buildingName ?? " ",
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
                                              data.unitType ?? " ",
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
                                        data.title ?? " ",
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
                                        if ((data.glat != null) &&
                                            (data.glng != null)) {
                                          var latitude = (data.glat).toString();
                                          var longitude =
                                              (data.glng).toString();
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
                                                      (data.areas ??
                                                              data.city) ??
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
                                      color: CustomTheme.appTheme,
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
                                            data.orgRent == data.rent
                                                ? Text(
                                                    ' Rs ${data.rent ?? " "}',
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
                                                              'Rs ${data.orgRent ?? " "}',
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
                                                              ' Rs ${data.rent ?? " "}',
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
                                            data.orgMonthRent ==
                                                    data.monthlyRent
                                                ? Text(
                                                    ' Rs ${data.monthlyRent ?? " "}',
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
                                                              'Rs ${data.orgMonthRent ?? " "}',
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
                                                              ' Rs ${data.monthlyRent ?? " "}',
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
                                            data.orgRmsRent == data.rmsRent
                                                ? Text(
                                                    ' Rs ${data.rmsRent ?? " "}',
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
                                                              'Rs ${data.orgRmsRent ?? " "}',
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
                                                              ' Rs ${data.rmsRent ?? " "}',
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
                                          padding: EdgeInsets.only(right: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white60,
                                              border: Border.all(
                                                  color: CustomTheme.appTheme),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(children: [
                                            CircleAvatar(
                                                radius: 10,
                                                backgroundColor: myFavColor,
                                                child: Icon(
                                                  Icons.check,
                                                  size: 15,
                                                  color: Colors.white,
                                                )),
                                            Container(
                                                child: Text(
                                              'Managed by RMS',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            )),
                                          ]),
                                        ),
                                      ),
                                      Spacer(),
                                      data.wishlist == 0
                                          ? GestureDetector(
                                              onTap: () async {
                                                if (data.propId != null) {
                                                  String response =
                                                      await _propertyViewModel
                                                          .addToWishlist(
                                                              propertyId:
                                                                  data.propId ??
                                                                      " ");
                                                  if (response ==
                                                      'Successfully Added') {
                                                    setState(() {
                                                      data.wishlist = 1;
                                                    });
                                                    RMSWidgets.showSnackbar(
                                                        context: context,
                                                        message: response,
                                                        color: CustomTheme
                                                            .appTheme);
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
                                                if (data.propId != null) {
                                                  String response =
                                                      await _propertyViewModel
                                                          .addToWishlist(
                                                              propertyId:
                                                                  data.propId ??
                                                                      " ");
                                                  if (response ==
                                                      'Successfully removed') {
                                                    setState(() {
                                                      data.wishlist = 0;
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
      backgroundColor: CustomTheme.appTheme,
      title: Padding(
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
    return Positioned(
      bottom: _mainHeight * 0.01,
      left: _mainWidth * 0.15,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              log('Filter');
            },
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
                      fontFamily: fontFamily
                    ),
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
                        fontFamily: fontFamily
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> applySorting(
      {required BuildContext context}) async {
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
                    Text(
                      'Sort By',
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
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
                    Container(
                      height: 35,
                      width: 200,
                      child: ElevatedButton(
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
                              FilterSortRequestModel(sortOrder: sortOrder);

                          await _propertyViewModel.filterSortPropertyList(
                              requestModel: model);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Apply Sort',
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
                  ],
                ),
              );
            },
          );
        });
  }
}
