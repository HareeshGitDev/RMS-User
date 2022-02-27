import 'dart:developer';

import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/color.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PropertyDetailsPage extends StatefulWidget {
  const PropertyDetailsPage({Key? key}) : super(key: key);

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  var _mainHeight;
  var _mainWidth;
  static const String fontFamily = 'hk-grotest';
  bool dailyFlag = true;
  bool monthlyFlag = false;
  bool moreThanThreeFlag = false;

  final YoutubePlayerController _youTubeController = YoutubePlayerController(
    initialVideoId: '8SgbcLtZaVY',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: true,
      controlsVisibleAtStart: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    _mainWidth = MediaQuery.of(context).size.width;
    _mainHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight:  _mainHeight * 0.30,
              floating: true,
              backgroundColor: CustomTheme.skyBlue,
              onStretchTrigger: ()async{
                log('Started...');
              },
             // pinned: true,
              actions: [
                CircleAvatar(
                    backgroundColor: Colors.grey,radius: 15,
                    child: Icon(Icons.favorite,color: Colors.red,)),
                SizedBox(width: 5,),
                CircleAvatar(
                    backgroundColor: Colors.grey,radius: 15,
                    child: Icon(Icons.share,color: Colors.red,)),
                SizedBox(width: 10,)
            ],
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  'https://media.istockphoto.com/photos/beautiful-luxury-home-exterior-at-twilight-picture-id1026205392?k=20&m=1026205392&s=612x612&w=0&h=lYFMV5cOuQQpddmwsE5QLBCyhgWQ1OI46i_dalro9OE=',
                  height: _mainHeight * 0.30,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(
                height: _mainHeight * 0.015,
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
                    text: TextSpan(
                        text: 'Disclaimer : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: fontFamily,
                            color: Colors.black),
                        children: <TextSpan>[
                      TextSpan(
                        text:
                            'A disclaimer is generally any statement intended to specify or delimit the scope of rights and obligations that may be exercised and enforced by parties in a legally recognized relationship.',
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
                height: _mainHeight * 0.04,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fully Furnished 1BHK With Balcony & Hall and many more things, Near SilkBoard FlyOver ',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: fontFamily,
                      ),
                    ),
                    Text(
                      'Building Name : SI Residency ',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: fontFamily,
                          color: Colors.black54),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: _mainHeight * 0.015,
              ),
              _getAmountView(context: context),
              Divider(
                thickness: 2,
              ),
              Container(
                height: _mainHeight * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Icon(Icons.person_outline_outlined),
                          Text(
                            '2 Guest',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: fontFamily,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        // color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Icon(Icons.bed_rounded),
                          Text(
                            '1 BedRoom',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: fontFamily,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        // color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Icon(Icons.bathroom_outlined),
                          Text(
                            '1 BathRoom',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: fontFamily,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: _mainHeight * 0.015,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: _mainWidth * 0.04,
                ),
                child: Text(
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
              _availableAmenitiesIconList(),
              Container(
                padding: EdgeInsets.only(
                  left: _mainWidth * 0.04,
                  top: _mainHeight * 0.01,
                ),
                child: Text(
                  'View All Amenities',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamily,
                      color: Colors.orange,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: _mainHeight * 0.015,
              ),
              Divider(
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
                      Text(
                        'Contact us',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: fontFamily,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Icon(Icons.call,
                          color: myFavColor, size: _mainWidth * 0.06),
                      SizedBox(
                        width: _mainWidth * 0.05,
                      ),
                      Icon(
                        Icons.message,
                        color: myFavColor,
                        size: _mainWidth * 0.06,
                      )
                    ]),
              ),
              Divider(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Property Location',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: fontFamily,
                            color: Colors.black),
                      ),
                      Icon(Icons.map_rounded,
                          color: myFavColor, size: _mainWidth * 0.06),
                    ]),
              ),
              Divider(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Date',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: fontFamily,
                            color: Colors.black),
                      ),
                      Icon(Icons.calendar_today,
                          color: myFavColor, size: _mainWidth * 0.06),
                    ]),
              ),
              Divider(
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: _mainWidth * 0.04,
                  right: _mainWidth * 0.04,
                ),
                child: Text(
                  'Details',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
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
                child: const ReadMoreText(
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
                ),
              ),
              SizedBox(
                height: _mainHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: _mainWidth * 0.04,
                  right: _mainWidth * 0.04,
                ),
                child: Text(
                  'House Rules',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
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
                child: const ReadMoreText(
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
                ),
              ),
              SizedBox(
                height: _mainHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: _mainWidth * 0.04,
                  right: _mainWidth * 0.04,
                ),
                child: Text(
                  'Five Reasons to Choose RentMyStay',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Divider(
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
                      Text(
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
                            color: CustomTheme.skyBlue),
                      ),
                    ]),
              ),
              Divider(
                thickness: 2,
              ),
              Center(
                child: Text(
                  'Video Tour',
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                height: _mainHeight * 0.22,
                width: _mainWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.amber,
                ),
                margin: EdgeInsets.only(
                  left: _mainWidth * 0.04,
                  right: _mainWidth * 0.04,
                  top: _mainWidth * 0.01,
                  bottom: _mainWidth * 0.01,
                ),
                child: YoutubePlayer(
                  aspectRatio: 1.2,
                  controller: _youTubeController,
                  showVideoProgressIndicator: true,
                  topActions: [
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
                    Spacer(),
                    IconButton(
                        onPressed: () => _youTubeController.unMute(),
                        icon: Icon(
                          Icons.volume_off,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Center(
                child: Text(
                  'Similar Properties',
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: _mainHeight * 0.005,
              ),
              _getSimilarProperties(context: context),
              SizedBox(
                height: _mainHeight * 0.02,
              ),
            ]))
          ],
        ),
      ),
    );
  }

  Widget _getAmountView({required BuildContext context}) {
    return Container(
        decoration: BoxDecoration(
          // color: Colors.amber,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.only(
          left: _mainWidth * 0.04,
          right: _mainWidth * 0.04,
        ),
        height: _mainHeight * 0.15,
        width: _mainWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                          color: dailyFlag ? myFavColor : Colors.black12,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          )),
                      child: Text('Daily'),
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
                      color: monthlyFlag ? myFavColor : Colors.black12,
                      child: Text('Monthly'),
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
                          color:
                              moreThanThreeFlag ? myFavColor : Colors.black12,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: Text('3+ Months'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _mainHeight * 0.015,
            ),
            Container(
              // color: Colors.pink,
              // height: _mainHeight * 0.02,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rent',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: fontFamily,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Rs 20000/Month',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: fontFamily,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              //  color: Colors.blue,
              // height: _mainHeight * 0.025,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Deposit',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: fontFamily,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Rs 20000',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: fontFamily,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
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
            Text(
              'Cancellation Policy',
              style: TextStyle(
                  color: Colors.orange,
                  fontFamily: fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            )
          ],
        ));
  }

  Widget _availableAmenitiesIconList() {
    return Container(
      // color: Colors.amber,
      padding: EdgeInsets.only(
        left: _mainWidth * 0.02,
        right: _mainWidth * 0.3,
      ),
      margin: EdgeInsets.only(
        left: _mainWidth * 0.02,
        right: _mainWidth * 0.02,
      ),
      height: _mainHeight * 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_transportation,
                size: 15,
                color: Colors.black38,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Transportation',
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: fontFamily,
                    fontSize: 14),
              ),
              Spacer(),
              Icon(
                Icons.phone,
                size: 15,
                color: Colors.black38,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Phone',
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: fontFamily,
                    fontSize: 14),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                size: 15,
                color: Colors.black38,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Electricity',
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: fontFamily,
                    fontSize: 14),
              ),
              Spacer(),
              Icon(
                Icons.camera_alt,
                size: 15,
                color: Colors.black38,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'CCTV',
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: fontFamily,
                    fontSize: 14),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Icon(
                Icons.wifi,
                size: 15,
                color: Colors.black38,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'WiFi',
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: fontFamily,
                    fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
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

  Widget _getSimilarProperties({required BuildContext context}) {
    return Container(
      height: _mainHeight * 0.2,
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
          return Card(
            child: Container(
                height: _mainHeight * 0.2,
                width: _mainWidth * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      height: _mainHeight * 0.13,
                      width: _mainWidth * 0.4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              'https://events.wbcsd.org/virtual-meetings/wp-content/uploads/2021/07/Advancing-business-understanding-of-nature-positive.jpg',
                            ),
                            fit: BoxFit.fitHeight),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                      ),
                    ),

                    /*CachedNetworkImage(
                      imageUrl:
                       'https://events.wbcsd.org/virtual-meetings/wp-content/uploads/2021/07/Advancing-business-understanding-of-nature-positive.jpg',
                        imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Shimmer.fromColors(
                          child: Container(
                            height: _mainHeight * 0.1,
                            color: Colors.grey,
                          ),
                          baseColor: Colors.grey[200] as Color,
                          highlightColor: Colors.grey[350] as Color),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),*/
                    Container(
                      padding: EdgeInsets.only(left: _mainWidth * 0.01),
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText('Rs 10000',
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic),
                              colors: [myFavColor, Colors.black]),
                        ],
                        pause: Duration(milliseconds: 1500),
                        isRepeatingAnimation: true,
                        repeatForever: true,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: _mainWidth * 0.01,
                          right: _mainWidth * 0.01,
                          top: _mainWidth * 0.01),
                      child: Text(
                        'Fully Furnished 1BHK with Balcony and Hall and terrace and many More Features Available',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: fontFamily,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )),
          );
        },
        itemCount: 6,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
