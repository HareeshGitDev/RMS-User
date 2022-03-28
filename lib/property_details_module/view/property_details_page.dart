import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/property_details_module/view/site_visit_page.dart';
import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/color.dart';
import 'package:RentMyStay_user/utils/service/system_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Web_View_Container.dart';
import '../../images.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../amenities_model.dart';
import '../model/property_details_model.dart';
import '../model/property_details_util_model.dart';

class PropertyDetailsPage extends StatefulWidget {
  String propId;

  PropertyDetailsPage({Key? key, required this.propId}) : super(key: key);

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  String cancellationPolicy =
      'https://www.rentmystay.com/info/cancellation_policy/1';
  var _mainHeight;
  var _mainWidth;
  static const String fontFamily = 'hk-grotest';
  bool dailyFlag = false;
  bool monthlyFlag = false;
  bool moreThanThreeFlag = true;
  ValueNotifier<bool> showPics = ValueNotifier(true);
  bool showAllAmenities = false;

  late PropertyDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = Provider.of<PropertyDetailsViewModel>(context, listen: false);
    _viewModel.getPropertyDetails(propId: widget.propId);
    log('Property Id :: ${widget.propId}');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    showPics.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Called::');
    _mainWidth = MediaQuery.of(context).size.width;
    _mainHeight = MediaQuery.of(context).size.height;
    return Consumer<PropertyDetailsViewModel>(
      builder: (context, value, child) {
        //value.propertyDetailsModel.
        return SafeArea(
          child: value.propertyDetailsModel != null
              ? Scaffold(
                  resizeToAvoidBottomInset: true,
                  body: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: _mainHeight * 0.30,
                        floating: true,
                        backgroundColor: CustomTheme.appTheme,
                        // pinned: true,
                        actions: [
                          GestureDetector(
                            onTap: () async {
                              if (value.propertyDetailsModel?.details != null &&
                                  value.propertyDetailsModel?.details
                                          ?.wishlist ==
                                      1) {
                                if (value.propertyDetailsModel?.details !=
                                        null &&
                                    value.propertyDetailsModel?.details
                                            ?.propId !=
                                        null) {
                                  int response = await _viewModel.addToWishlist(
                                      propertyId: value.propertyDetailsModel
                                              ?.details?.propId ??
                                          '');
                                  if (response == 200) {
                                    setState(() {
                                      value.propertyDetailsModel?.details
                                          ?.wishlist = 0;
                                    });
                                    RMSWidgets.showSnackbar(
                                        context: context,
                                        message:
                                            'Successfully Removed From Wishlist',
                                        color: CustomTheme.appTheme);
                                  }
                                }
                              } else if (value.propertyDetailsModel?.details !=
                                      null &&
                                  value.propertyDetailsModel?.details
                                          ?.wishlist ==
                                      0) {
                                if (value.propertyDetailsModel?.details !=
                                        null &&
                                    value.propertyDetailsModel?.details
                                            ?.propId !=
                                        null) {
                                  int response = await _viewModel.addToWishlist(
                                      propertyId: value.propertyDetailsModel
                                              ?.details?.propId ??
                                          '');
                                  if (response == 200) {
                                    setState(() {
                                      value.propertyDetailsModel?.details
                                          ?.wishlist = 1;
                                    });
                                    RMSWidgets.showSnackbar(
                                        context: context,
                                        message:
                                            'Successfully Added to Wishlist',
                                        color: CustomTheme.appTheme);
                                  }
                                }
                              }
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: value.propertyDetailsModel?.details !=
                                            null &&
                                        value.propertyDetailsModel?.details
                                                ?.wishlist ==
                                            1
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.favorite_outline_rounded,
                                        color: Colors.red,
                                      )),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Share.share(
                                  value.propertyDetailsModel!.shareLink ?? " ");
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: Icon(
                                  Icons.share_outlined,
                                  color: CustomTheme.appTheme,
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: ValueListenableBuilder(
                            builder: (context, bool data, child) {
                              return Visibility(
                                visible: data,
                                replacement: YoutubePlayerBuilder(
                                  onEnterFullScreen: () {
                                    log('FullScreen');
                                  },
                                  player: YoutubePlayer(
                                    aspectRatio: 1.2,
                                    controller: value.youTubeController,
                                    showVideoProgressIndicator: true,
                                    topActions: const [
                                      Text(
                                        'Powered by RMS',
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  builder:
                                      (BuildContext context, Widget player) {
                                    return player;
                                  },
                                ),
                                child: CarouselSlider(
                                  items: value.propertyDetailsModel?.details !=
                                              null &&
                                          value.propertyDetailsModel?.details
                                                  ?.pic !=
                                              null
                                      ? value.propertyDetailsModel?.details?.pic
                                              ?.map((e) => CachedNetworkImage(
                                                    imageUrl:
                                                        e.picWp.toString(),
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
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
                                                              height:
                                                                  _mainHeight *
                                                                      0.3,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            baseColor:
                                                                Colors.grey[200]
                                                                    as Color,
                                                            highlightColor:
                                                                Colors.grey[350]
                                                                    as Color),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ))
                                              .toList() ??
                                          []
                                      : [Container()],
                                  options: CarouselOptions(
                                      height: _mainHeight * 0.3,
                                      enlargeCenterPage: false,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlay: true,
                                      aspectRatio: 16 / 9,
                                      autoPlayCurve: Curves.decelerate,
                                      enableInfiniteScroll: true,
                                      viewportFraction: 1),
                                ),
                              );
                            },
                            valueListenable: showPics,
                          ),
                          titlePadding: EdgeInsets.all(0),
                          title: IconButton(
                            icon: Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              showPics.value = !showPics.value;
                              value.youTubeController.reset();
                            },
                          ),
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate.fixed([
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: EdgeInsets.only(
                            left: _mainWidth * 0.02,
                            right: _mainWidth * 0.02,
                          ),
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.02,
                            right: _mainWidth * 0.02,
                          ),
                          child: RichText(
                              text: const TextSpan(
                                  text: 'Please note: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      fontFamily: fontFamily,
                                      color: Colors.black),
                                  children: <TextSpan>[
                                TextSpan(
                                  text:
                                      'The furniture and furnishings may appear different from what’s shown in the pictures. Dewan/sofa may be provided as available.',
                                  style: TextStyle(
                                    color: Color(0xff56596A),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: fontFamily,
                                  ),
                                ),
                              ])),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.015,
                        ),
                        Container(
                          height: _mainHeight * 0.05,
                          margin: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.02,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: _mainWidth * 0.8,
                                child: Column(
                                  children: [
                                    Text(
                                      value.propertyDetailsModel?.details !=
                                                  null &&
                                              value.propertyDetailsModel
                                                      ?.details?.title !=
                                                  null
                                          ? (value.propertyDetailsModel?.details
                                                  ?.title)
                                              .toString()
                                          : '',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      value.propertyDetailsModel?.details !=
                                                  null &&
                                              value.propertyDetailsModel
                                                      ?.details?.bname !=
                                                  null
                                          ? (value.propertyDetailsModel?.details
                                                  ?.bname)
                                              .toString()
                                          : '',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if ((value.propertyDetailsModel?.details !=
                                              null &&
                                          value.propertyDetailsModel?.details
                                                  ?.glat !=
                                              null) &&
                                      (value.propertyDetailsModel?.details !=
                                              null &&
                                          value.propertyDetailsModel?.details
                                                  ?.glng !=
                                              null)) {
                                    var latitude = (value.propertyDetailsModel
                                            ?.details?.glat)
                                        .toString();
                                    var longitude = (value.propertyDetailsModel
                                            ?.details?.glng)
                                        .toString();
                                    await SystemService.launchGoogleMaps(
                                        latitude: latitude,
                                        longitude: longitude);
                                  }
                                },
                                child: Container(
                                  width: _mainWidth * 0.08,
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: CustomTheme.appTheme,
                                        size: _mainHeight * 0.02,
                                      ),
                                      Text(
                                        'Map',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: fontFamily,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        _getAmountView(
                            context: context,
                            model: value.propertyDetailsModel),
                        const Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Icon(
                                  Icons.person_outline_outlined,
                                  size: 20,
                                  color: Colors.black38,
                                ),
                                Text(
                                  value.propertyDetailsModel?.details != null &&
                                          value.propertyDetailsModel?.details
                                                  ?.maxGuests !=
                                              null
                                      ? (value.propertyDetailsModel?.details
                                                  ?.maxGuests)
                                              .toString() +
                                          ' Guest'
                                      : ' ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: fontFamily,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(
                                  Icons.bed_rounded,
                                  size: 20,
                                  color: Colors.black38,
                                ),
                                Text(
                                  value.propertyDetailsModel?.details != null &&
                                          value.propertyDetailsModel?.details
                                                  ?.bedrooms !=
                                              null
                                      ? (value.propertyDetailsModel?.details
                                                  ?.bedrooms)
                                              .toString() +
                                          ' BedRoom'
                                      : ' ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: fontFamily,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(
                                  Icons.bathroom_outlined,
                                  size: 20,
                                  color: Colors.black38,
                                ),
                                Text(
                                  value.propertyDetailsModel?.details != null &&
                                          value.propertyDetailsModel?.details
                                                  ?.bathrooms !=
                                              null
                                      ? (value.propertyDetailsModel?.details
                                                  ?.bathrooms)
                                              .toString() +
                                          ' BathRoom'
                                      : ' ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: fontFamily,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: _mainHeight * 0.015,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                          ),
                          child: const Text(
                            'Available Amenities',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: fontFamily,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),

                        getAvailableAmenities(list: value.amenitiesList),
                            SizedBox(
                              height: _mainHeight * 0.01,
                            ),
                            value.amenitiesList.length > 5?
                            GestureDetector(
                          onTap: () => setState(() {
                            showAllAmenities = !showAllAmenities;
                          }),
                          child: Container(
                            padding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                            ),
                            child: Text(
                              showAllAmenities
                                  ? 'View Less Amenities'
                                  : 'View All Amenities',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: fontFamily,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ):Container(),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Container(
                          // color: CustomTheme.peach,
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),

                          height: _mainHeight * 0.03,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Contact us',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: fontFamily,
                                      color: Colors.black),
                                ),
                                Spacer(),
                                IconButton(
                                  padding:
                                      EdgeInsets.only(left: _mainWidth * 0.08),
                                  icon: Icon(
                                    Icons.call,
                                    color: CustomTheme.myFavColor,
                                    size: _mainWidth * 0.05,
                                  ),
                                  onPressed: () {
                                    if (value.propertyDetailsModel != null &&
                                        value.propertyDetailsModel?.details !=
                                            null &&
                                        value.propertyDetailsModel?.details
                                                ?.salesNumber !=
                                            null) {
                                      launch(
                                          'tel:${value.propertyDetailsModel?.details?.salesNumber}');
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: _mainWidth * 0.02,
                                ),
                                IconButton(
                                  padding:
                                      EdgeInsets.only(left: _mainWidth * 0.06),
                                  icon: Image(
                                    image: NetworkImage(
                                        'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/whatsapplogo.png?alt=media&token=41df11ff-b9e7-4f5b-a4fc-30b47cfe1435'),
                                  ),

                                  /*Icon(Icons.email_outlined,
                                      color: CustomTheme.appTheme,
                                      size: _mainWidth * 0.06),

                                   */
                                  onPressed: () {
                                    if (value.propertyDetailsModel != null &&
                                        value.propertyDetailsModel?.details !=
                                            null &&
                                        value.propertyDetailsModel?.details
                                                ?.salesNumber !=
                                            null) {
                                      launch(
                                          'https://wa.me/${value.propertyDetailsModel?.details?.salesNumber}?text=${value.propertyDetailsModel?.shareLink ?? 'Hello'}');
                                    }
                                  },
                                ),
                              ]),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        /* Container(
                          // color: CustomTheme.peach,
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),

                          height: _mainHeight * 0.03,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Select Date',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: fontFamily,
                                      color: Colors.black),
                                ),
                                Container(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Icon(Icons.calendar_today,
                                        color: myFavColor,
                                        size: _mainWidth * 0.06),
                                  ),
                                ),
                              ]),
                        ),
                        const Divider(
                          thickness: 2,
                        ),*/
                        Padding(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          child: const Text(
                            'Details',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                fontFamily: fontFamily,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          child: Html(
                            data: value.propertyDetailsModel?.details != null &&
                                    value.propertyDetailsModel?.details
                                            ?.description !=
                                        null
                                ? (value.propertyDetailsModel?.details
                                        ?.description)
                                    .toString()
                                : ' ',
                            style: {
                              "body": Style(
                                  fontSize: FontSize(12.0),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  wordSpacing: 0.5,
                                  display: Display.INLINE,
                                  fontFamily: fontFamily),
                            },
                          )
                          /*ReadMoreText(
                            value.propertyDetailsModel?.details != null &&
                                value.propertyDetailsModel?.details
                                    ?.description !=
                                    null
                                ? (value.propertyDetailsModel?.details
                                ?.description)
                                .toString()
                                : ' '

                          ,trimLines: 3,
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            colorClickableText: Color(0xffe09c5f),
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            moreStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontFamily,
                                color: Color(0xff7ab02a)),
                          )*/
                          ,
                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          child: const Text(
                            'House Rules',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                fontFamily: fontFamily,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        Container(
                            padding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                              right: _mainWidth * 0.04,
                            ),
                            child: Html(
                              data:
                                  value.propertyDetailsModel?.details != null &&
                                          value.propertyDetailsModel?.details
                                                  ?.things2note !=
                                              null
                                      ? (value.propertyDetailsModel?.details
                                              ?.things2note)
                                          .toString()
                                      : ' ',
                              style: {
                                "body": Style(
                                    fontSize: FontSize(12.0),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    wordSpacing: 0.5,
                                    display: Display.INLINE,
                                    fontFamily: fontFamily),
                              },
                            )
                            /*const ReadMoreText(
                            'In the Second Age of Middle-earth, the lords of Elves, Dwarves, and Men are given Rings of Power. Unbeknownst to them, the Dark Lord Sauron forges the One Ring in Mount Doom, instilling into it a great part of his power, in order to dominate the other Rings so he might conquer Middle-earth. A final alliance of Men and Elves battles Saurons forces in Mordor. Isildur of Gondor severs Saurons finger and the Ring with it, thereby vanquishing Sauron and returning him to spirit form. With Sauron first defeat, the Third Age of Middle-earth begins. The Rings influence corrupts Isildur, who takes it for himself and is later killed by Orcs. The Ring is lost in a river for 2,500 years until it is found by Gollum, who owns it for over four and a half centuries. The ring abandons Gollum and it is subsequently found by a hobbit named Bilbo Baggins, who is unaware of its history.',
                            trimLines: 3,
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            colorClickableText: Color(0xffe09c5f),
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            moreStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontFamily,
                                color: Color(0xff7ab02a)),
                          ),*/
                            ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          child: const Text(
                            'Five Reasons to Choose RentMyStay',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                fontFamily: fontFamily,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          child: Text(
                            getMoreText,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontFamily: fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                          ),
                          height: _mainHeight * 0.03,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'FAQ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: fontFamily,
                                      color: Colors.black),
                                ),
                                Text(
                                  'Read',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: fontFamily,
                                      color: CustomTheme.appTheme),
                                ),
                              ]),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const Center(
                          child: Text(
                            'Similar Properties',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: fontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        _getSimilarProperties(context: context, model: value),
                        SizedBox(
                          height: _mainHeight * 0.02,
                        ),
                      ]))
                    ],
                  ),
                  bottomNavigationBar: Container(
                    height: _mainHeight * 0.06,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        left: _mainWidth * 0.02,
                        right: _mainWidth * 0.02,
                        bottom: _mainHeight * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: _mainWidth * 0.4,
                            height: _mainHeight * 0.05,
                            child: ElevatedButton(
                              onPressed: () async {
                                RMSWidgets.showLoaderDialog(
                                    context: context, message: 'Loading...');
                                SharedPreferenceUtil sharedPreferenceUtil =
                                    SharedPreferenceUtil();
                                var name = (await sharedPreferenceUtil
                                            .getString(rms_name) ??
                                        '')
                                    .toString();
                                var email = (await sharedPreferenceUtil
                                            .getString(rms_email) ??
                                        '')
                                    .toString();
                                var phone = (await sharedPreferenceUtil
                                            .getString(rms_phoneNumber) ??
                                        '')
                                    .toString();
                                Navigator.of(context).pop();
                                _showDialog(
                                  propId: value.propertyDetailsModel?.details
                                          ?.propId ??
                                      ' ',
                                  name: name,
                                  phone: phone,
                                  email: email,
                                );
                              },
                              child: Text(
                                'Site Visit',
                                style: TextStyle(
                                    color: CustomTheme.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          CustomTheme.appThemeContrast),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )),
                            )),
                        Container(
                            width: _mainWidth * 0.4,
                            height: _mainHeight * 0.05,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (value.propertyDetailsModel == null ||
                                    value.propertyDetailsModel?.details ==
                                        null) {
                                  return;
                                }
                                RMSWidgets.showLoaderDialog(
                                    context: context, message: 'Loading...');
                                SharedPreferenceUtil sharedPreferenceUtil =
                                    SharedPreferenceUtil();
                                var name = (await sharedPreferenceUtil
                                            .getString(rms_name) ??
                                        '')
                                    .toString();
                                var email = (await sharedPreferenceUtil
                                            .getString(rms_email) ??
                                        '')
                                    .toString();
                                var phone = (await sharedPreferenceUtil
                                            .getString(rms_phoneNumber) ??
                                        '')
                                    .toString();
                                var token =
                                    (await sharedPreferenceUtil.getString(
                                                rms_registeredUserToken) ??
                                            '')
                                        .toString();
                                Navigator.of(context).pop();
                                PropertyDetailsUtilModel model =
                                    PropertyDetailsUtilModel(
                                  name: name,
                                  email: email,
                                  mobile: phone,
                                  token: token,
                                  propId: int.parse((value.propertyDetailsModel
                                          ?.details?.propId)
                                      .toString()),
                                  buildingName: (value
                                          .propertyDetailsModel?.details?.bname)
                                      .toString(),
                                  title: (value
                                          .propertyDetailsModel?.details?.title)
                                      .toString(),
                                  freeGuest: int.parse((value
                                          .propertyDetailsModel
                                          ?.details
                                          ?.freeGuests)
                                      .toString()),
                                  maxGuest: int.parse((value
                                          .propertyDetailsModel
                                          ?.details
                                          ?.maxGuests)
                                      .toString()),
                                );

                                Navigator.pushNamed(
                                    context, AppRoutes.bookingPage,
                                    arguments: model);
                              },
                              child: Text(
                                'Book Now',
                                style: TextStyle(
                                    color: CustomTheme.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          CustomTheme.appTheme),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )),
                            )),
                      ],
                    ),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: CustomTheme.appTheme,
                  ),
                  body: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            CustomTheme.appTheme)),
                  ),
                ),
        );
      },
    );
  }

  Widget getAvailableAmenities({required List<AmenitiesModel> list}) {
    return ListTileTheme.merge(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            mainAxisExtent: _mainHeight * 0.05),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(
              left: _mainWidth * 0.04,
            ),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: Image.network(list[index].imageUrl ),
                ),
                SizedBox(
                  width: _mainWidth * 0.03,
                ),
                Text(
                  list[index].name.toString(),
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: fontFamily,
                      fontSize: 14),
                ),
              ],
            ),
          );
        },
        itemCount:showAllAmenities?list.length:list.length > 5 ? 5 : list.length,
      ),
    );
  }

  Widget _getAmountView(
      {required BuildContext context, PropertyDetailsModel? model}) {
    return Container(
        decoration: BoxDecoration(
          // color: Colors.amber,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.only(
          left: _mainWidth * 0.04,
          right: _mainWidth * 0.04,
        ),
        height: _mainHeight * 0.17,
        width: _mainWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              //color: Colors.deepOrange,
              height: _mainHeight * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      if (dailyFlag) {
                        return;
                      } else if (monthlyFlag || moreThanThreeFlag) {
                        setState(() {
                          monthlyFlag = false;
                          moreThanThreeFlag = false;
                          dailyFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      decoration: BoxDecoration(
                          color: dailyFlag
                              ? CustomTheme.appTheme
                              : Colors.blueGrey.shade100,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          )),
                      child: Text(
                        'Daily',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamily,
                            color: dailyFlag ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (monthlyFlag) {
                        return;
                      } else if (dailyFlag || moreThanThreeFlag) {
                        setState(() {
                          dailyFlag = false;
                          moreThanThreeFlag = false;
                          monthlyFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      color: monthlyFlag
                          ? CustomTheme.appTheme
                          : Colors.blueGrey.shade100,
                      child: Text(
                        'Monthly',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamily,
                            color: monthlyFlag ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (moreThanThreeFlag) {
                        return;
                      } else if (dailyFlag || monthlyFlag) {
                        setState(() {
                          dailyFlag = false;
                          monthlyFlag = false;
                          moreThanThreeFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      decoration: BoxDecoration(
                          color: moreThanThreeFlag
                              ? CustomTheme.appTheme
                              : Colors.blueGrey.shade100,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: Text(
                        '3+ Months',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamily,
                            color: moreThanThreeFlag
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _mainHeight * 0.015,
            ),
            _getRentView(context: context, model: model),
            SizedBox(
              height: _mainHeight * 0.01,
            ),
            Text(
              'Free Cancellation within 24 hours of booking.Click here to view.',
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: fontFamily,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () => _handleURLButtonPress(
                  context, cancellationPolicy, 'Cancellation Policy'),
              child: const Text(
                'Cancellation Policy',
                style: TextStyle(
                    color: Colors.orange,
                    fontFamily: fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ));
  }


  String get getMoreText {
    return """
1. Family and Bachelor Friendly.
2. Free Maintenance for first 30 days of stay(T&C).
3. Free movement across any property in first 48hrs.
4. No Brokerage and No maintenance charged.
5. Rent for Short term or Long term.
    """;
  }

  Widget _getSimilarProperties(
      {required BuildContext context,
      required PropertyDetailsViewModel model}) {
    return Container(
      height: _mainHeight * 0.19,
      decoration: BoxDecoration(
        //  color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(
        left: _mainWidth * 0.04,
        right: _mainWidth * 0.04,
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final data =
              model.propertyDetailsModel?.similarProp![index] ?? SimilarProp();
          return InkWell(
            onTap: () => Navigator.of(context).pushNamed(
                AppRoutes.propertyDetailsPage,
                arguments: data.propId),
            child: Card(
              elevation: 2,
              child: Container(
                  height: _mainHeight * 0.2,
                  width: _mainWidth * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: data.picThumbnail.toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          height: _mainHeight * 0.13,
                          width: _mainWidth * 0.4,
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
                              height: _mainHeight * 0.13,
                              color: Colors.grey,
                            ),
                            baseColor: Colors.grey[200] as Color,
                            highlightColor: Colors.grey[350] as Color),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: _mainWidth * 0.01,
                            right: _mainWidth * 0.01,
                            top: _mainHeight * 0.005),
                        child: Text(
                          data.title ?? '',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: fontFamily,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                                left: _mainWidth * 0.01,
                                top: _mainHeight * 0.003),
                            child: Text(
                              data.buildingName != null
                                  ? data.buildingName.toString()
                                  : '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w500,

                                //fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                                right: _mainWidth * 0.01,
                                top: _mainHeight * 0.003),
                            child: Text(
                              data.monthlyRent != null
                                  ? rupee + '${data.monthlyRent}'
                                  : '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontFamily: fontFamily,
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
          );
        },
        itemCount: model.propertyDetailsModel?.similarProp?.length ?? 0,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _getRentView(
      {required BuildContext context, PropertyDetailsModel? model}) {
    if (dailyFlag && (monthlyFlag == false && moreThanThreeFlag == false)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Rent',
            style: TextStyle(
                fontSize: 14,
                fontFamily: fontFamily,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
          Text(
            model?.details != null && model?.details?.rent != null
                ? '$rupee ${model?.details?.rent}'
                : ' ',
            style: TextStyle(
                fontSize: 14,
                fontFamily: fontFamily,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else if (monthlyFlag &&
        (dailyFlag == false && moreThanThreeFlag == false)) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rent',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                model?.details != null && model?.details?.monthlyRent != null
                    ? '$rupee ${model?.details?.monthlyRent}'
                    : ' ',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Deposit',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '$rupee 10000',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rent',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                model?.details != null && model?.details?.rmsRent != null
                    ? '$rupee ${model?.details?.rmsRent}'
                    : ' ',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Visibility(
            visible: !dailyFlag,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Deposit',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamily,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  model?.details != null && model?.details?.rmsDeposit != null
                      ? '$rupee ${model?.details?.rmsDeposit}'
                      : ' ',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamily,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  void _showDialog(
      {required String propId,
      required String name,
      required String phone,
      required String email}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ChangeNotifierProvider(
              create: (_) => PropertyDetailsViewModel(),
              child: SiteVisitPage(
                  propId: propId, email: email, phoneNumber: phone, name: name),
            ));
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Web_View_Container(url, title)),
    );
  }
}
