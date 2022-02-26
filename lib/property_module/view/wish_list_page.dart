import 'dart:developer';
import 'dart:ui';

import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/color.dart';
import 'package:RentMyStay_user/utils/constants/enum_consts.dart';
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

import '../../images.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  var _mainHeight;
  var _mainWidth;
  late PropertyViewModel _propertyViewModel;

  @override
  void initState() {
    _propertyViewModel = Provider.of<PropertyViewModel>(context, listen: false);
    _propertyViewModel.getWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Consumer<PropertyViewModel>(
      builder: (context, value, child) {
        if (value.wishListModel.data != null && value.wishListModel.data!.isNotEmpty) {
          return Scaffold(
            appBar: _getAppBar(context: context),
            body: Container(
              color: Colors.white,
              height: _mainHeight,
              width: _mainWidth,
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 0),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      height: _mainHeight * 0.48,
                      child: Card(
                        elevation: 5,
                        shadowColor: CustomTheme.skyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CarouselSlider(
                                  items: value.wishListModel.data![index].pic
                                          ?.map((e) => Container(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      e.picLink.toString(),
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Shimmer.fromColors(
                                                          child: Container(
                                                            height: 225,
                                                            color: Colors.grey,
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
                                                ),
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
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
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
                                                    .wishListModel
                                                    .data![index]
                                                    .buildingName ??
                                                " ",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          value.wishListModel
                                                  .data![index].unitType ??
                                              " ",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    ),
                                  ),
                                  visible: value.wishListModel.data![index]
                                              .rmsProp !=
                                          null &&
                                      value.wishListModel.data![index]
                                              .rmsProp ==
                                          "RMS Prop",
                                ),
                                Visibility(
                                  visible: value.wishListModel.data![index]
                                              .rmsProp !=
                                          null &&
                                      value.wishListModel.data![index]
                                              .rmsProp ==
                                          "RMS Prop",
                                  child: Container(
                                    child: Text(
                                      'Multiple Units Available',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 10),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: _mainWidth * 0.75,
                                  child: Text(
                                    value.wishListModel.data![index].title ??
                                        " ",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: _mainWidth * 0.40,
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 10, top: 5),
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
                                          width: _mainWidth * 0.30,
                                          child: Wrap(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 7),
                                                child: Text(
                                                  (value
                                                              .wishListModel
                                                              .data![index]
                                                              .areas ??
                                                          value
                                                              .wishListModel
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
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: CustomTheme.skyBlue,
                                ),
                                Container(
                                    height: 25,
                                    margin: EdgeInsets.only(left: 15,right: 15),
                                    //  color: Colors.blue,
                                    child:Row(

                                      children: [
                                        Text('Rent Per Day'),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                'Rs ${value.wishListModel.data![index].orgRent ?? " "}',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontFamily:
                                                    "HKGrotest-Light",
                                                    decoration: TextDecoration
                                                        .lineThrough)),
                                            TextSpan(
                                                text:
                                                ' Rs ${value.wishListModel.data![index].rent ?? " "}',
                                                style: TextStyle(
                                                    color: myFavColor,
                                                    fontFamily:
                                                    "HKGrotest-Light",
                                                    fontSize: 14)),
                                          ]),
                                        ),
                                      ],mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    )
                                ),
                                Container(
                                    height: 25,
                                    margin: EdgeInsets.only(left: 15,right: 15),
                                    //  color: Colors.amber,
                                    child:Row(

                                      children: [
                                        Text('Rent (Stay < 3 Month)'),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                'Rs ${value.wishListModel.data![index].orgMonthRent ?? " "}',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily:
                                                    "HKGrotest-Light",
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 12)),
                                            TextSpan(
                                                text:
                                                ' Rs ${value.wishListModel.data![index].monthlyRent ?? " "}',
                                                style: TextStyle(
                                                    color: myFavColor,
                                                    fontFamily:
                                                    "HKGrotest-Light",
                                                    fontSize: 14)),
                                          ]),
                                        ),
                                      ],mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    )
                                ),
                                Container(
                                    height: 25,
                                    margin: EdgeInsets.only(left: 15,right: 15),
                                    //   color: Colors.pink,
                                    child:Row(

                                      children: [
                                        Text('Rent (Stay > 3 Month)'),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                'Rs ${value.wishListModel.data![index].orgRmsRent ?? " "}',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily:
                                                    "HKGrotest-Light",
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .lineThrough)),
                                            TextSpan(
                                                text:
                                                ' Rs ${value.wishListModel.data![index].rmsRent ?? " "}',
                                                style: TextStyle(
                                                    color: myFavColor,
                                                    fontFamily:
                                                    "HKGrotest-Light",
                                                    fontSize: 14)),
                                          ]),
                                        ),
                                      ],mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    )
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: _mainWidth,
                              padding: EdgeInsets.all(5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: value.wishListModel.data![index]
                                                .rmsProp !=
                                            null &&
                                        value.wishListModel.data![index]
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
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            )),
                                      ]),
                                    ),
                                  ),
                                  Spacer(),
                                  value.wishListModel.data![index].wishlist == 0
                                      ? GestureDetector(
                                          onTap: () async {
                                            if (value.wishListModel.data![index]
                                                    .propId !=
                                                null) {
                                              String response =
                                                  await _propertyViewModel
                                                      .addToWishlist(
                                                          propertyId: value
                                                                  .wishListModel
                                                                  .data![index]
                                                                  .propId ??
                                                              " ");
                                              if (response ==
                                                  'Successfully added') {
                                                setState(() {
                                                  value
                                                      .wishListModel
                                                      .data![index]
                                                      .wishlist = 1;
                                                });
                                                RMSWidgets.showSnackbar(
                                                    context: context,
                                                    message: response,
                                                    color: CustomTheme.skyBlue);
                                              }
                                            }
                                          },
                                          child: const CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.white60,
                                            child: Icon(
                                              Icons.favorite_outline_rounded,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            if (value.wishListModel.data![index]
                                                    .propId !=
                                                null) {
                                              String response =
                                                  await _propertyViewModel
                                                      .addToWishlist(
                                                          propertyId: value
                                                                  .wishListModel
                                                                  .data![index]
                                                                  .propId ??
                                                              " ");
                                              if (response ==
                                                  'Successfully removed') {
                                                setState(() {
                                                  value
                                                      .wishListModel
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
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: value.wishListModel.data?.length ?? 0,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 15,
                ),
              ),
            ),
          );
        } else if(value.wishListModel.data != null && value.wishListModel.data!.isEmpty){
          return Scaffold(
              appBar: _getAppBar(context: context),
              body: Center(child: Text('No Any Wishlisted Property Found.')));
        }else {
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
      title: Container(
        child: Text('My WishList'),
      ),
    );
  }
}
