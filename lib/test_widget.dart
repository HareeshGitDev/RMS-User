import 'dart:developer';

import 'package:RentMyStay_user/property_details_module/amenities_model.dart';
import 'package:RentMyStay_user/property_details_module/model/property_details_model.dart';
import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/theme/custom_theme.dart';
import 'package:RentMyStay_user/theme/fonts.dart';
import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:RentMyStay_user/utils/view/webView_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'images.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  var _mainHeight;
  var _mainWidth;
  bool isDailyChecked = false;
  bool isMonthlyChecked = false;
  bool isLOngTermChecked = true;
  bool isDetailsExpanded = false;
  bool isHouseRulesExpanded = false;

  late PropertyDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<PropertyDetailsViewModel>(context, listen: false);
    _viewModel.getPropertyDetails(propId: 9133.toString());
  }



  @override
  Widget build(BuildContext context) {
    _mainWidth = MediaQuery.of(context).size.width;
    _mainHeight = MediaQuery.of(context).size.height;
    log('$_mainWidth  -- $_mainHeight');

    return SafeArea(
      child: Scaffold(
        body: Consumer<PropertyDetailsViewModel>(
          builder: (context, value, child) {
            return value.propertyDetailsModel != null &&
                    value.propertyDetailsModel?.msg != null &&
                    value.propertyDetailsModel?.data != null
                ? Container(
                    color: Colors.white,
                    height: _mainHeight,
                    width: _mainWidth,
                    padding: EdgeInsets.only(bottom: _mainHeight * 0.02),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CarouselSlider(
                                    items: value.propertyDetailsModel?.data
                                                    ?.details !=
                                                null &&
                                            value.propertyDetailsModel?.data
                                                    ?.details?.pic !=
                                                null
                                        ? value.propertyDetailsModel?.data
                                                ?.details?.pic
                                                ?.map((e) => Container(
                                                      height:
                                                          _mainHeight * 0.35,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            e.picWp.toString(),
                                                        fit: BoxFit.fill,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Shimmer.fromColors(
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      _mainHeight *
                                                                          0.35,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                baseColor:
                                                                    Colors.grey[
                                                                            200]
                                                                        as Color,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                            350]
                                                                        as Color),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ))
                                                .toList() ??
                                            []
                                        : [Container()],
                                    options: CarouselOptions(
                                        height: _mainHeight * 0.35,
                                        enlargeCenterPage: false,
                                        autoPlayInterval:
                                            const Duration(seconds: 4),
                                        autoPlay: true,
                                        aspectRatio: 16 / 9,
                                        autoPlayCurve: Curves.decelerate,
                                        enableInfiniteScroll: true,
                                        viewportFraction: 1),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: _mainHeight * 0.045,
                                      left: _mainWidth * 0.03,
                                      //right: _mainWidth * 0.03,
                                    ),
                                    //color: Colors.amber,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          // color: Colors.amber,
                                          width: _mainWidth * 0.85,

                                          child: RichText(
                                              text: TextSpan(
                                                  text: 'Please Note : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: getHeight(context: context, height:12),
                                                      fontFamily: getThemeFont,
                                                      color: CustomTheme
                                                          .appThemeContrast),
                                                  children:  <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      'The furniture and furnishings may appear different from what’s shown in the pictures. Dewan/sofa may be provided as available.',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: getHeight(context: context, height:10),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ])),
                                        ),
                                        Image.asset(Images.locationIcon,height:_mainHeight * 0.06,width: _mainWidth * 0.06, ),
                                      /*  Icon(
                                          Icons.location_on_outlined,
                                          color: CustomTheme.appTheme,
                                          size: _mainHeight * 0.03,
                                        ),*/
                                        SizedBox(
                                          width: _mainWidth * 0.01,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: _mainHeight * 0.01,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: _mainWidth * 0.9,
                                          padding: getHeadingPadding,
                                          child: Text(
                                            value.propertyDetailsModel?.data
                                                            ?.details !=
                                                        null &&
                                                    value
                                                            .propertyDetailsModel
                                                            ?.data
                                                            ?.details
                                                            ?.title !=
                                                        null
                                                ? (value.propertyDetailsModel
                                                        ?.data?.details?.title)
                                                    .toString()
                                                : '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: getHeight(context: context, height:16),
                                                fontWeight: FontWeight.w600),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        /*Container(
                                          padding: EdgeInsets.only(left: 5, right: 5),
                                          margin: EdgeInsets.only(
                                              right: _mainWidth * 0.02),
                                          color: CustomTheme.myFavColor,
                                          child: Text(
                                            '4.3* | 1440',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                  /* SizedBox(
                                    height: _mainHeight * 0.005,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: _mainWidth * 0.03,
                                      //right: _mainWidth * 0.03,
                                    ),
                                    child: Text(
                                      value.propertyDetailsModel?.data?.details !=
                                                  null &&
                                              value.propertyDetailsModel?.data
                                                      ?.details?.propId !=
                                                  null
                                          ? 'PropId : ${(value.propertyDetailsModel?.data?.details?.propId)}'
                                              .toString()
                                          : '',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),*/
                                  SizedBox(
                                    height: _mainHeight * 0.01,
                                  ),
                                  Padding(
                                    padding: getHeadingPadding,
                                    child: _getRentView(
                                        context: context,
                                        model: value.propertyDetailsModel,
                                        value: value),
                                  ),
                                  SizedBox(
                                    height: _mainHeight * 0.02,
                                  ),
                                  InkWell(
                                    onTap: () => _handleURLButtonPress(
                                        context,
                                        cancellationPolicyUrl,
                                        'Cancellation Policy'),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: _mainWidth * 0.03,
                                        right: _mainWidth * 0.03,
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  'Free Cancellation within 24 hours of booking. ',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: getThemeFont,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getHeight(context: context, height:12)),
                                            ),
                                            TextSpan(
                                              text: 'Click here',
                                              style: TextStyle(
                                                  color: CustomTheme
                                                      .appThemeContrast,
                                                  fontSize: getHeight(context: context, height:12),
                                                  fontFamily: getThemeFont,
                                                  fontWeight: FontWeight.w600,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                            TextSpan(
                                              text: '  to View.',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: getThemeFont,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getHeight(context: context, height:12)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _mainHeight * 0.01,
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  SizedBox(
                                    height: _mainHeight * 0.01,
                                  ),
                                  _getRoomDetails(value: value),
                                  SizedBox(
                                    height: _mainHeight * 0.02,
                                  ),
                                  Container(
                                    padding: getHeadingPadding,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Available Amenities',
                                          style: getHeadingStyle,
                                        ),
                                        /*Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.black54,
                                          size: 20,
                                        )*/
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: _mainHeight * 0.015,
                                  ),
                                  Container(
                                    padding: getHeadingPadding,
                                    height: _mainHeight * 0.07,
                                    child: getAvailableAmenities(
                                        list: value.amenitiesList),
                                  ),
                                  ExpansionTile(
                                      tilePadding: getHeadingPadding,
                                      childrenPadding: EdgeInsets.only(
                                        bottom: _mainHeight * 0.01,
                                        left: _mainWidth * 0.03,
                                        right: _mainWidth * 0.03,
                                      ),
                                      onExpansionChanged: (val) {
                                        setState(() {
                                          isDetailsExpanded = val;
                                        });
                                      },
                                      trailing: Icon(
                                        isDetailsExpanded
                                            ? Icons.keyboard_arrow_down
                                            : Icons.keyboard_arrow_right,
                                        color: CustomTheme.appTheme,
                                      ),
                                      title: Text(
                                        'Details',
                                        style: getHeadingStyle,
                                      ),
                                      children: [
                                        Html(
                                          data: value.propertyDetailsModel?.data
                                                          ?.details !=
                                                      null &&
                                                  value
                                                          .propertyDetailsModel
                                                          ?.data
                                                          ?.details
                                                          ?.description !=
                                                      null
                                              ? (value
                                                      .propertyDetailsModel
                                                      ?.data
                                                      ?.details
                                                      ?.description)
                                                  .toString()
                                              : ' ',
                                          style: {
                                            "body": Style(
                                              fontSize: FontSize(getHeight(context: context, height:12)),
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                              wordSpacing: 0.5,
                                              letterSpacing: 0.5,
                                              display: Display.INLINE,
                                            ),
                                          },
                                        )
                                      ]),
                                  SizedBox(
                                    height: _mainHeight * 0.015,
                                  ),
                                  Container(
                                    padding: getHeadingPadding,
                                    child: Text(
                                      'Whats Nearby',
                                      style: getHeadingStyle,
                                    ),
                                  ),
                                  SizedBox(
                                    height: _mainHeight * 0.005,
                                  ),
                                  Container(
                                      padding: getHeadingPadding,
                                      height: _mainHeight * 0.22,
                                      child: NearbyFacilities(tabCount: 4)),
                                  SizedBox(
                                    height: _mainHeight * 0.005,
                                  ),
                                  Container(
                                    padding: getHeadingPadding,
                                    // height: _mainHeight * 0.03,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Get In Touch',
                                            style: getHeadingStyle,
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              if (value.propertyDetailsModel !=
                                                      null &&
                                                  value.propertyDetailsModel
                                                          ?.data?.details !=
                                                      null &&
                                                  value
                                                          .propertyDetailsModel
                                                          ?.data
                                                          ?.details
                                                          ?.salesNumber !=
                                                      null) {
                                                launch(
                                                    'tel:${value.propertyDetailsModel?.data?.details?.salesNumber}');
                                              }
                                            },
                                            child: Image.asset(Images.callIcon,width: _mainWidth * 0.06,height: _mainHeight * 0.06,)/*Icon(
                                              Icons.call,
                                              color: CustomTheme.appTheme,
                                              size: _mainWidth * 0.06,
                                            ),*/
                                          ),
                                          SizedBox(
                                            width: _mainWidth * 0.04,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (value.propertyDetailsModel !=
                                                      null &&
                                                  value.propertyDetailsModel
                                                          ?.data?.details !=
                                                      null &&
                                                  value
                                                          .propertyDetailsModel
                                                          ?.data
                                                          ?.details
                                                          ?.salesNumber !=
                                                      null) {
                                                launch(
                                                    'https://wa.me/${value.propertyDetailsModel?.data?.details?.salesNumber}?text=${value.propertyDetailsModel?.data?.shareLink ?? 'Hello'}');
                                              }
                                            },
                                            child: Image.asset(Images.whatsapplogo,width: _mainWidth * 0.06,height: _mainHeight * 0.06,)
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: _mainHeight * 0.015,
                                  ),
                                  Container(
                                    color: Colors.grey.shade50,
                                    height: _mainHeight * 0.13,
                                    padding: EdgeInsets.only(
                                      top: _mainHeight * 0.01,
                                      left: _mainWidth * 0.03,
                                      right: _mainWidth * 0.03,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '5 Reasons to choose Rent My Stay',
                                          style: getHeadingStyle,
                                        ),
                                        SizedBox(
                                          height: _mainHeight * 0.01,
                                        ),
                                        Container(
                                          height: _mainHeight * 0.075,
                                          child: ListView.separated(
                                              itemBuilder: (_, index) {
                                                return Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(
                                                    left: _mainWidth * 0.02,
                                                    right: _mainWidth * 0.01,
                                                    top: _mainHeight * 0.005,
                                                  ),
                                                  width: _mainWidth * 0.42,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    getReasonsList[index],
                                                    style: TextStyle(
                                                        fontSize:
                                                        getHeight(context: context, height:12),
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                );
                                              },
                                              scrollDirection: Axis.horizontal,
                                              separatorBuilder: (_, __) =>
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                              itemCount: getReasonsList.length),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: _mainHeight * 0.01,
                                  ),
                                  Container(
                                    color: Colors.grey.shade50,
                                    child: ExpansionTile(
                                        onExpansionChanged: (val) {
                                          setState(() {
                                            isHouseRulesExpanded = val;
                                          });
                                        },
                                        trailing: Icon(
                                          isHouseRulesExpanded
                                              ? Icons.keyboard_arrow_down
                                              : Icons.keyboard_arrow_right,
                                          color: CustomTheme.appTheme,
                                        ),
                                        childrenPadding: EdgeInsets.only(
                                          bottom: _mainHeight * 0.01,
                                          left: _mainWidth * 0.04,
                                          right: _mainWidth * 0.04,
                                        ),
                                        title: Text(
                                          'House Rules',
                                          style: getHeadingStyle,
                                        ),
                                        children: [
                                          Html(
                                            data: value.propertyDetailsModel
                                                            ?.data?.details !=
                                                        null &&
                                                    value
                                                            .propertyDetailsModel
                                                            ?.data
                                                            ?.details
                                                            ?.things2note !=
                                                        null
                                                ? (value
                                                        .propertyDetailsModel
                                                        ?.data
                                                        ?.details
                                                        ?.things2note)
                                                    .toString()
                                                : ' ',
                                            style: {
                                              "body": Style(
                                                fontSize: FontSize(getHeight(context: context, height:12)),
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54,
                                                wordSpacing: 0.5,
                                                letterSpacing: 0.5,
                                                display: Display.INLINE,
                                              ),
                                            },
                                          )
                                        ]),
                                  ),
                                  SizedBox(
                                    height: _mainHeight * 0.01,
                                  ),
                                  GestureDetector(
                                    onTap: () => _handleURLButtonPress(
                                        context, faqUrl, 'FAQ'),
                                    child: Container(
                                      height: _mainHeight * 0.06,
                                      color: Colors.grey.shade50,
                                      padding: EdgeInsets.only(
                                        left: _mainWidth * 0.03,
                                        right: _mainWidth * 0.04,
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'FAQ',
                                              style: getHeadingStyle,
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_right,
                                              color: CustomTheme.appTheme,
                                            ),
                                          ]),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _mainHeight * 0.015,
                                  ),
                                  Container(
                                    padding: getHeadingPadding,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Properties You May Like',
                                          style: getHeadingStyle,
                                        ),
                                        Text(
                                          'See All',
                                          style: TextStyle(
                                              color:
                                                  CustomTheme.appThemeContrast,
                                              fontSize: getHeight(context: context, height:14),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: _mainHeight * 0.01,
                                  ),
                                  _getSimilarProperties(
                                      context: context, model: value),
                                  SizedBox(
                                    height: _mainHeight * 0.02,
                                  )
                                ],
                              ),
                              Positioned(
                                top: _mainHeight * 0.015,
                                child: Container(
                                  width: _mainWidth,
                                  child: Row(
                                    children: [
                                      BackButton(
                                        color: Colors.white,
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.favorite_outline_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: _mainWidth * 0.04,
                                      ),
                                      Icon(
                                        Icons.share,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: _mainWidth * 0.03,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: _mainHeight * 0.32,
                                left: _mainWidth * 0.1,
                                right: _mainWidth * 0.1,
                                child: Material(
                                  elevation: 5, shadowColor: Colors.white,
                                  //color: Colors.white,
                                  child: Container(
                                    height: _mainHeight * 0.06,
                                    // margin: EdgeInsets.symmetric(horizontal: _mainWidth*0.05),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle),
                                    width: _mainWidth * 0.75,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isDailyChecked = true;
                                              isMonthlyChecked = false;
                                              isLOngTermChecked = false;
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              Text(
                                                'Daily',
                                                style: TextStyle(
                                                    color: CustomTheme.appTheme,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        _mainWidth * 0.045),
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 2,
                                                width: _mainWidth * 0.25,
                                                color: isDailyChecked
                                                    ? CustomTheme.appTheme
                                                    : Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isDailyChecked = false;
                                              isMonthlyChecked = true;
                                              isLOngTermChecked = false;
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              Text(
                                                'Monthly',
                                                style: TextStyle(
                                                    color: CustomTheme.appTheme,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        _mainWidth * 0.045),
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 2,
                                                width: _mainWidth * 0.25,
                                                color: isMonthlyChecked
                                                    ? CustomTheme.appTheme
                                                    : Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isDailyChecked = false;
                                              isMonthlyChecked = false;
                                              isLOngTermChecked = true;
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              Text(
                                                '3+ Months',
                                                style: TextStyle(
                                                    color: CustomTheme.appTheme,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        _mainWidth * 0.045),
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 2,
                                                width: _mainWidth * 0.25,
                                                color: isLOngTermChecked
                                                    ? CustomTheme.appTheme
                                                    : Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : RMSWidgets.getLoader();
          },
        ),
      ),
    );
  }

  Widget _getRoomDetails({required PropertyDetailsViewModel value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
         /*   const Icon(
              Icons.person_outline_outlined,
              size: 20,
              color: Colors.black38,
            ),*/
            Image.asset(Images.personIcon,),
            Text(
              value.propertyDetailsModel?.data?.details != null &&
                      value.propertyDetailsModel?.data?.details?.maxGuests !=
                          null
                  ? (value.propertyDetailsModel?.data?.details?.maxGuests)
                          .toString() +
                      ' Guest'
                  : ' ',
              style: TextStyle(
                  fontSize: getHeight(context: context, height:12),
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Column(
          children: [
          /*  const Icon(
              Icons.bed_rounded,
              size: 20,
              color: Colors.black38,
            ),*/
            Image.asset(Images.bedroomIcon),
            Text(
              value.propertyDetailsModel?.data?.details != null &&
                      value.propertyDetailsModel?.data?.details?.bedrooms !=
                          null
                  ? (value.propertyDetailsModel?.data?.details?.bedrooms)
                          .toString() +
                      ' BedRoom'
                  : ' ',
              style: TextStyle(
                  fontSize: getHeight(context: context, height:12),
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Column(
          children: [
           /* const Icon(
              Icons.bathroom_outlined,
              size: 20,
              color: Colors.black38,
            ),*/
            Image.asset(Images.bathroomIcon),
            Text(
              value.propertyDetailsModel?.data?.details != null &&
                      value.propertyDetailsModel?.data?.details?.bathrooms !=
                          null
                  ? (value.propertyDetailsModel?.data?.details?.bathrooms)
                          .toString() +
                      ' BathRoom'
                  : ' ',
              style: TextStyle(
                  fontSize: getHeight(context: context, height:12),
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        )
      ],
    );
  }

  List<String> get getReasonsList {
    return [
      'Family and Bachelor Friendly.',
      'Free Maintenance for first 30 days of stay(T&C).',
      'Free movement across any property in first 48hrs.',
      'No Brokerage and No maintenance charged.',
      'Rent for Short term or Long term.'
    ];
  }

  Widget _getRentView(
      {required BuildContext context,
      PropertyDetailsModel? model,
      required PropertyDetailsViewModel value}) {
    if (isDailyChecked) {
      return Row(
        children: [
          Text(
            'Rent : ',
            style: const TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            model?.data?.details != null &&
                    model?.data?.details?.rent != null &&
                    model?.data?.details?.rent != 0
                ? '$rupee ${model?.data?.details?.rent}'
                : 'Unavailable',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else if (isMonthlyChecked) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rent : ',
            style: const TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            model?.data != null &&
                    model?.data?.details != null &&
                    model?.data?.details?.monthlyRent != null
                ? '$rupee ${model?.data?.details?.monthlyRent}'
                : ' ',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Text(
            'Deposit : ',
            style: const TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            '$rupee 10000',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rent : ',
            style: const TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            model?.data != null &&
                    model?.data?.details != null &&
                    model?.data != null &&
                    model?.data?.details?.rmsRent != null
                ? '$rupee ${model?.data?.details?.rmsRent}'
                : ' ',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Text(
            'Deposit : ',
            style: const TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            model?.data != null &&
                    model?.data?.details != null &&
                    model?.data?.details?.rmsDeposit != null
                ? '$rupee ${model?.data?.details?.rmsDeposit}'
                : ' ',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ],
      );
    }
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Web_View_Container(url, title)),
    );
  }

  Widget getAvailableAmenities({required List<AmenitiesModel> list}) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      // physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: _mainHeight * 0.03,
              width: _mainWidth * 0.08,
              //  padding: EdgeInsets.only(right: _mainWidth * 0.02),
              child: CachedNetworkImage(
                imageUrl: list[index].imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                    child: Container(
                      height: _mainHeight * 0.03,
                      width: _mainWidth * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        // borderRadius: BorderRadius.circular(10),
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
            SizedBox(
              height: _mainHeight * 0.01,
            ),
            Text(
              list[index].name.toString(),
              style: TextStyle(
                  color: CustomTheme.appThemeContrast,
                  fontWeight: FontWeight.w500,
                  fontSize: getHeight(context: context, height: 14)),
            ),
          ],
        );
      },
      itemCount: list.length,
      separatorBuilder: (_, __) => SizedBox(
        width: 10,
      ),
    );
  }

  Widget _getSimilarProperties(
      {required BuildContext context,
      required PropertyDetailsViewModel model}) {
    return Container(
      height: _mainHeight * 0.23,
      decoration: BoxDecoration(
        //  color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: getHeadingPadding,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final data = model.propertyDetailsModel?.data?.similarProp![index] ??
              SimilarProp();
          return InkWell(
            onTap: () => Navigator.of(context)
                .pushNamed(AppRoutes.propertyDetailsPage, arguments: {
              'propId': data.propId,
              'fromExternalLink': false,
            }),
            child: Stack(
              children: [
                Card(
                  elevation: 2,

                  child: Container(
                      // height: _mainHeight * 0.2,
                      width: _mainWidth * 0.42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: data.picThumbnail.toString(),
                            imageBuilder: (context, imageProvider) => Container(
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
                                const Icon(Icons.error),
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
                                      fontSize: getHeight(context: context, height: 12),
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
                                    fontSize: getHeight(context: context, height: 12),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
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
                                          style:TextStyle(
                                            fontSize: getHeight(context: context, height: 12),
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: _mainWidth * 0.005,
                                    ),
                                    showRatingAndPrice(
                                            monthlyRent: data.monthlyRent,
                                            orgRent: data.orgRent)
                                        ? Container()
                                        : Container(

                                            width: _mainWidth * 0.1,
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(
                                                right: _mainWidth * 0.01,
                                                top: _mainHeight * 0.003),
                                            child: FittedBox(
                                              child: Text(
                                                data.orgRent != null
                                                    ? rupee + '${data.orgRent}'
                                                    : '',
                                                style: TextStyle(
                                                  fontSize:getHeight(context: context, height: 10) ,
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
                                    showRatingAndPrice(
                                            monthlyRent: data.monthlyRent,
                                            orgRent: data.orgRent)
                                        ? Container()
                                        : Container(
                                            width: _mainWidth * 0.15,
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(
                                                right: _mainWidth * 0.01,
                                                top: _mainHeight * 0.003),
                                            child: FittedBox(
                                              child: Text(
                                                '70% OFF',
                                                style: TextStyle(
                                                  fontSize: getHeight(context: context, height: 12),
                                                  color: CustomTheme.myFavColor,
                                                  fontWeight: FontWeight.w600,

                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(
                                    left: _mainWidth * 0.01,
                                    top: _mainHeight * 0.003),
                                child: Text(
                                  'More',
                                  style: TextStyle(
                                    fontSize: getHeight(context: context, height:14),
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
                    child: Icon(
                      Icons.favorite_outline,
                      color: Colors.white,
                      size: _mainWidth * 0.04,
                    ))
              ],
            ),
          );
        },
        itemCount: model.propertyDetailsModel?.data?.similarProp?.length ?? 0,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  bool showRatingAndPrice({String? monthlyRent, String? orgRent}) {
    if (orgRent != null && orgRent == '0') {
      return true;
    } else if (orgRent == null) {
      return true;
    }
    return orgRent != '0' &&
        monthlyRent != null &&
        monthlyRent != '0' &&
        (monthlyRent.toString() == orgRent.toString());
  }

  TextStyle get getHeadingStyle => TextStyle(
      color: CustomTheme.appTheme, fontSize: getHeight(context: context, height:16), fontWeight: FontWeight.w500);

  EdgeInsets get getHeadingPadding =>
      EdgeInsets.only(left: _mainWidth * 0.03, right: _mainWidth * 0.03);
}

class NearbyFacilities extends StatefulWidget {
  final int tabCount;

  const NearbyFacilities({Key? key, required this.tabCount}) : super(key: key);

  @override
  State<NearbyFacilities> createState() => _NearbyFacilitiesState();
}

class _NearbyFacilitiesState extends State<NearbyFacilities> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: widget.tabCount,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 00,
            backgroundColor: Colors.white,
            bottom: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.black54,
              indicatorColor: CustomTheme.appThemeContrast,
              labelColor: CustomTheme.appThemeContrast,
              tabs: getTabs(context: context, tabCount: widget.tabCount),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: TabBarView(
              children:
                  getTabBarWidgets(context: context, tabCount: widget.tabCount),
            ),
          ),
        ));
  }

  List<Tab> getTabs({required BuildContext context, required int tabCount}) {
    return List.generate(
        widget.tabCount,
        (index) => Tab(
              child: Text('Transportation',style: TextStyle(
                fontSize: getHeight(context: context, height:14)
              ),),
            )).toList();
  }

  List<Widget> getTabBarWidgets(
      {required BuildContext context, required int tabCount}) {
    return List.generate(
        widget.tabCount,
        (index) => Tab(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    padding: EdgeInsets.only(top: 5),
                    child: ListTileTheme.merge(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.03,
                              right: MediaQuery.of(context).size.width * 0.03,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Uber Cab',style: TextStyle(
                                  fontSize: getHeight(context: context, height:12)
                                ),),
                                Spacer(),
                                Text('0.3Km',style: TextStyle(
                                  fontSize: getHeight(context: context, height:12)
                                ),),

                              ],
                            ),
                          );
                        },
                        itemCount: 10,
                        separatorBuilder:(_,__)=>SizedBox(height: 5,),
                      ),
                    ),
                  ),
                ],
              ),
            )).toList();
  }
}