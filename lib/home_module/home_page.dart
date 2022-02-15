import 'dart:developer';

import 'package:RentMyStay_user/extensions/extensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import '../images.dart';
import '../theme/app_notifier.dart';
import '../theme/app_theme.dart';
import '../theme/theme_type.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ThemeData theme;
  late CustomTheme customTheme;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  TextDirection textDirection = TextDirection.ltr;
  bool isDark = false;
  final _searchController = TextEditingController();
  bool shouldClearText = true;

  @override
  void initState() {
    super.initState();

    isDark = AppTheme.themeType == ThemeType.dark;
    textDirection = AppTheme.textDirection;
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: CustomTheme.skyBlue,
        centerTitle: true,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: Size(
            20,
            70,
          ),
          child: Container(
            margin: EdgeInsets.all(15),
            /*decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),*/
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: -10,
                color: Colors.white,
              ),
              child: TextFormField(
                /*validator: (value) {
                  if (value != null && value.length < 6) {
                    return "Enter proper email";
                  }
                  return null;
                },*/
                // keyboardType: TextInputType.emailAddress,
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search_rounded),
                  //suffix: _searchController.text.trim().isNotEmpty?Icon(Icons.clear):Container()
                ),
              ),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        actions: [
          Container(
            child: Icon(Icons.notifications_none),
            margin: EdgeInsets.only(right: 10),
          ),
        ],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Container(
          padding: EdgeInsets.only(top: 10),
          child: Image.asset(
            Images.brandLogo_Transparent,
            height: 40,
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.white,
        buttonBackgroundColor: CustomTheme.skyBlue,
        color: CustomTheme.skyBlue,
        items: const <Widget>[
          Icon(
            Icons.home_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.search_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.favorite_outline_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.house_outlined,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person_outline_rounded,
            size: 30,
            color: Colors.white,
          )
        ],
        onTap: (index) {},
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10),
                height: 110,
               // color: CustomTheme.peach.withAlpha(40),
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var data = getCitySuggestionList()[index];
                    return InkWell(
                      onTap: () => data.callback(data.cityName),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: 70,
                        height: 40,
                        child: Column(
                          children: [
                            CircleAvatar(
                                 backgroundImage: NetworkImage(data.imageUrl),
                                  radius: 30,
                                ),
                            Text(data.cityName),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: getCitySuggestionList().length,
                )),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                items: [
                  Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/WhatsApp%20Image%202022-02-14%20at%2012.01.04%20PM.jpeg?alt=media&token=6d78225a-59f7-4a7c-8bf3-e5d3f3c66bca'),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/bannerhome.png?alt=media&token=b66dab51-8676-470a-b876-025c613c303a"),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/WhatsApp%20Image%202022-02-14%20at%2012.01.05%20PM.jpeg?alt=media&token=153f6374-979f-46ad-aaf3-06f9ff1d0b20'),
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
                options: CarouselOptions(
                    height: 180,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.8),
              ),
            )
          ],
        ),
      ),
      drawer:
          _buildDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildDrawer() {
    return FxContainer.none(
      margin:
          FxSpacing.fromLTRB(16, FxSpacing.safeAreaTop(context) + 16, 16, 16),
      borderRadiusAll: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: theme.scaffoldBackgroundColor,
      child: Drawer(
          child: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: FxSpacing.only(left: 20, bottom: 24, top: 24, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage(Images.brandLogo),
                    height: 102,
                    width: 102,
                  ),
                  FxSpacing.height(16),
                  FxContainer(
                    padding: FxSpacing.fromLTRB(12, 4, 12, 4),
                    borderRadiusAll: 4,
                    color: theme.colorScheme.primary.withAlpha(40),
                    child: FxText.caption("Shubham",
                        color: theme.colorScheme.primary,
                        fontWeight: 600,
                        letterSpacing: 0.2),
                  ),
                  FxSpacing.height(10),
                  FxContainer(
                    padding: FxSpacing.fromLTRB(12, 4, 12, 4),
                    borderRadiusAll: 4,
                    color: theme.colorScheme.primary.withAlpha(40),
                    child: FxText.caption("Shubhamkumar@rentmystay.com",
                        color: theme.colorScheme.primary,
                        fontWeight: 600,
                        letterSpacing: 0.2),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            FxSpacing.height(15),
            Container(
              margin: FxSpacing.x(20),
              child: Column(
                children: [
                  InkWell(
                    /* onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  SelectLanguageDialog());
                        },

                        */
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 12,
                          borderRadiusAll: 4,
                          child: Icon(
                            Icons.person,
                            color: CustomTheme.skyBlue,
                            size: 20,
                          ),
                          color: CustomTheme.skyBlue.withAlpha(20),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: FxText.b1(
                            'Profile'.tr(),
                          ),
                        ),
                        FxSpacing.width(16),
                        Icon(
                          FeatherIcons.chevronRight,
                          size: 18,
                          color: theme.colorScheme.onBackground,
                        ).autoDirection(),
                      ],
                    ),
                  ),
                  FxSpacing.height(20),
                  InkWell(
                    /* onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  SelectLanguageDialog());
                        },

                        */
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 12,
                          borderRadiusAll: 4,
                          child: Icon(
                            Icons.house_rounded,
                            color: CustomTheme.skyBlue,
                            size: 20,
                          ),
                          color: CustomTheme.skyBlue.withAlpha(20),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: FxText.b1(
                            'My Stays'.tr(),
                          ),
                        ),
                        FxSpacing.width(16),
                        Icon(
                          FeatherIcons.chevronRight,
                          size: 18,
                          color: theme.colorScheme.onBackground,
                        ).autoDirection(),
                      ],
                    ),
                  ),
                  FxSpacing.height(20),
                  InkWell(
                    /* onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  SelectLanguageDialog());
                        },

                        */
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 12,
                          borderRadiusAll: 4,
                          child: Icon(
                            Icons.favorite,
                            color: CustomTheme.skyBlue,
                            size: 20,
                          ),
                          color: CustomTheme.skyBlue.withAlpha(20),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: FxText.b1(
                            'My Wishlist'.tr(),
                          ),
                        ),
                        FxSpacing.width(16),
                        Icon(
                          FeatherIcons.chevronRight,
                          size: 18,
                          color: theme.colorScheme.onBackground,
                        ).autoDirection(),
                      ],
                    ),
                  ),
                  FxSpacing.height(20),
                  InkWell(
                    /* onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  SelectLanguageDialog());
                        },

                        */
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 12,
                          borderRadiusAll: 4,
                          child: Icon(
                            Icons.logout_rounded,
                            color: CustomTheme.skyBlue,
                            size: 20,
                          ),
                          /* Image(
                                  height: 20,
                                  width: 20,
                                  image: AssetImage(Images.languageOutline),
                                  color: CustomTheme.skyBlue,
                                ),

                                */
                          color: CustomTheme.skyBlue.withAlpha(20),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: FxText.b1(
                            'Logout'.tr(),
                          ),
                        ),
                        FxSpacing.width(16),
                        Icon(
                          FeatherIcons.chevronRight,
                          size: 18,
                          color: theme.colorScheme.onBackground,
                        ).autoDirection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FxSpacing.height(20),
            Divider(
              thickness: 1,
            ),
            FxSpacing.height(16),
            Container(
              margin: FxSpacing.x(20),
              child: Column(
                children: [
                  InkWell(
                    /*
                        onTap: () {
                          launchDocumentation();
                        },
                        */
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 12,
                          borderRadiusAll: 4,
                          child: Image(
                            height: 20,
                            width: 20,
                            image: AssetImage(Images.documentationIcon),
                            color: CustomTheme.skyBlue,
                          ),
                          color: CustomTheme.skyBlue.withAlpha(20),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: FxText.b1(
                            'documentation'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FxSpacing.height(20),
                  InkWell(
                    /*
                        onTap: () {
                          launchChangeLog();
                        },*/
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        FxContainer(
                          paddingAll: 12,
                          borderRadiusAll: 4,
                          child: Image(
                            height: 20,
                            width: 20,
                            image: AssetImage(Images.changeLogIcon),
                            color: CustomTheme.peach,
                          ),
                          color: CustomTheme.peach.withAlpha(20),
                        ),
                        FxSpacing.width(16),
                        Expanded(
                          child: FxText.b1(
                            'changelog'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FxSpacing.height(20),
          ],
        ),
      )),
    );
  }

  List<CitySuggestionModel> getCitySuggestionList() {
    return [
      CitySuggestionModel(
          cityName: 'Bangalore',
          imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/newbangaloreimage.png?alt=media&token=b665228b-a72c-46f1-8683-0e0a0ce88d11",
          callback: (String value) {}),
      CitySuggestionModel(
          cityName: 'BTM',
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/btm.png?alt=media&token=8a4a92fb-c0db-4c23-9c5b-e74166373827",
          callback: (String value) {}),
      CitySuggestionModel(
          cityName: 'HSR',
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f",
          callback: log),
      CitySuggestionModel(
          cityName: 'Kundlahalli',
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/kundahalli.png?alt=media&token=73f33a3f-8219-4c28-8cd4-4f8cb2b14905",
          callback: (String value) => doSomeWork(value)),
      CitySuggestionModel(
          cityName: 'Marathalli',
          imageUrl:
             "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/marathalli.png?alt=media&token=92c56d6f-6a73-4717-8a85-8a1530a95282",
          callback: doSomeWork),
      CitySuggestionModel(
          cityName: 'Whitefield',
          imageUrl:
    "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/whitefield.png?alt=media&token=d5c56216-b5e8-4b6d-9fd3-d6675149fd45",
          callback: (String value) => doSomeWork(value)),
      CitySuggestionModel(
          cityName: 'Old Airport',
          imageUrl:"https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/old_airport_road.png?alt=media&token=3100968f-c852-4363-a805-597f8804c51c",
          callback: (String value) => doSomeWork(value)),
    ];
  }

  void doSomeWork(String cityName) {
    log(cityName);
    //api call with cityName
  }
}

class CitySuggestionModel {
  String cityName;
  String imageUrl;
  Function(String) callback;

  CitySuggestionModel(
      {required this.cityName, required this.imageUrl, required this.callback});
}
