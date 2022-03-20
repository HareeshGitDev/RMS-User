import 'dart:convert';
import 'dart:developer';

import 'package:RentMyStay_user/extensions/extensions.dart';
import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/login_module/service/google_auth_service.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/bottom_navigation_provider.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../images.dart';
import '../../theme/app_notifier.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_type.dart';
import '../../utils/constants/enum_consts.dart';
import '../../utils/service/navigation_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ThemeData theme;
  late CustomTheme customTheme;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late HomeViewModel _homeViewModel;

  TextDirection textDirection = TextDirection.ltr;
  bool isDark = false;
  final _searchController = TextEditingController();
  bool shouldClearText = true;


  @override
  void initState() {
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);

    super.initState();
    isDark = AppTheme.themeType == ThemeType.dark;
    textDirection = AppTheme.textDirection;
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  Future<Map<String, String>> getSharedPreferencesValues() async {
    SharedPreferenceUtil sharedPreferenceUtil = SharedPreferenceUtil();
    await sharedPreferenceUtil.getString(rms_gmapKey);

    return {
      'email': (await sharedPreferenceUtil.getString(rms_email)).toString(),
      'name': (await sharedPreferenceUtil.getString(rms_name)).toString(),
      'phone':
          (await sharedPreferenceUtil.getString(rms_phoneNumber)).toString(),
      'pic':
          (await sharedPreferenceUtil.getString(rms_profilePicUrl)).toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: CustomTheme.appTheme,
        centerTitle: true,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: Size(20, 50),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.searchPage),
            child: Container(
              height: 40,
              padding: EdgeInsets.only(
                left: 15,
              ),
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Search'),
                ],
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
            margin: EdgeInsets.only(right: 15),
          ),
        ],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Image.asset(
            Images.brandLogo_Transparent,
            height: 100,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 110,
                  // color: CustomTheme.peach.withAlpha(40),
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var data = _homeViewModel.getCitySuggestionList(
                          context: context)[index];
                      return InkWell(
                        onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.propertyListingPage,
                            arguments: {
                              'location': data.value,
                              'property': Property.FromLocation,
                            }),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 75,
                              child: CachedNetworkImage(
                                imageUrl: data.imageUrl.toString(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                        child: Container(
                                          height: 60,
                                          width: 75,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey,
                                          ),


                                        ),
                                        baseColor: Colors.grey[200] as Color,
                                        highlightColor:
                                            Colors.grey[350] as Color),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Text(data.cityName, style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      );
                    },
                    itemCount: _homeViewModel
                        .getCitySuggestionList(context: context)
                        .length,
                  )),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  items: _homeViewModel
                      .getAdsImageList()
                      .map((imageUrl) =>  CachedNetworkImage(
                        imageUrl: imageUrl,
                        imageBuilder: (context, imageProvider) =>
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        placeholder: (context, url) =>
                            Shimmer.fromColors(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15),

                                  ),
                                  height: 180,

                                ),
                                baseColor: Colors.grey[200] as Color,
                                highlightColor:
                                Colors.grey[350] as Color),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),)
                      .toList(),
                  options: CarouselOptions(
                      height: 180,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.8),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "Popular",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    //decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 260,
                  // color: CustomTheme.peach.withAlpha(40),
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var data =
                          _homeViewModel.getPopularPropertyModelList()[index];
                      return InkWell(
                        onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.propertyListingPage,
                            arguments: {
                              'location': 'Bengaluru-Karnataka-India',
                              'propertyType': data.propertyType,
                              'property': Property.FromBHK,
                            }),
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          elevation: 3,
                          shadowColor: CustomTheme.appTheme,
                          margin: EdgeInsets.all(10),
                          child: Container(
                            //margin: EdgeInsets.all(10),
                            width: 220,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 140,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        image: DecorationImage(
                                            image: AssetImage(data.imageUrl!),
                                            fit: BoxFit.cover
                                            //NetworkImage(data.imageUrl!),fit: BoxFit.cover,
                                            )),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 5, top: 5),
                                    alignment: Alignment.topLeft,
                                    child: Text(data.propertyType!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(left: 5, top: 5),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      data.propertyDesc!,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                      right: 10,
                                    ),
                                    alignment: Alignment.topRight,
                                    child: Text(data.hint!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: CustomTheme.peach))),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount:
                        _homeViewModel.getPopularPropertyModelList().length,
                  )),
              Padding(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "Refer & Earn",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 18,

                    //decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Container(
                  child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 15),
                        child: Text(
                          "Earn",
                          style: TextStyle(
                            color: CustomTheme.peach,
                            fontSize: 28,

                            //decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "1000",
                              style: TextStyle(
                                color: CustomTheme.peach,
                                fontSize: 40,

                                //decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "Rupees",
                              style: TextStyle(
                                color: CustomTheme.peach,
                                fontSize: 16,

                                //decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "Share with your Friend",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 18,

                            //decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            color: CustomTheme.peach,
                            shadowDarkColor: CustomTheme.appTheme,
                          ),
                          child: TextButton(
                            onPressed: () async {
                              RMSWidgets.showLoaderDialog(
                                  context: context, message: 'Logging...');
                              SharedPreferenceUtil shared =
                                  SharedPreferenceUtil();
                              Navigator.of(context).pop();
                              if ((await shared.getToken()) != null &&
                                  (await shared.getToken())!.isEmpty) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    AppRoutes.loginPage, (route) => false);
                              } else {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.referAndEarn);
                              }
                            },
                            child: Text("Earn Now",
                                style: TextStyle(color: Colors.black45)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      height: 200, child: Image.asset(Images.referIconHome))
                ],
              ))
            ],
          ),
        ),
      ),
      drawer:
          _buildDrawer(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildDrawer() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Hii'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          log('done');
          if (snapshot.hasData) {
            return FxContainer.none(
              margin: FxSpacing.fromLTRB(
                  0, FxSpacing.safeAreaTop(context) + 0, 16, 0),
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
                      padding: FxSpacing.only(
                          left: 20, bottom: 10, top: 20, right: 20),
                      child: Column(
                      //
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                           child: Container(

                             child: CachedNetworkImage(
                               imageUrl: (snapshot.data!['pic']).toString(),
                               imageBuilder: (context, imageProvider) =>
                                   Container(
                                     decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       image: DecorationImage(
                                         image: imageProvider,
                                         fit: BoxFit.cover,
                                       ),
                                     ),
                                   ),
                               placeholder: (context, url) =>
                                   Shimmer.fromColors(
                                       child: Container(

                                         decoration: BoxDecoration(
                                           shape: BoxShape.circle,
                                           color: Colors.grey,
                                         ),


                                       ),
                                       baseColor: Colors.grey[200] as Color,
                                       highlightColor:
                                       Colors.grey[350] as Color),
                               errorWidget: (context, url, error) =>
                               const Icon(Icons.error),
                             ),
                           ),
                            radius: 45,
                          ),
                          FxSpacing.height(12),
                          FxContainer(
                            padding: FxSpacing.fromLTRB(12, 4, 12, 4),
                            borderRadiusAll: 4,
                            color: theme.colorScheme.primary.withAlpha(40),
                            child: FxText.caption(
                                (snapshot.data!['name']).toString(),
                                color: theme.colorScheme.primary,
                                fontWeight: 600,
                                letterSpacing: 0.2),
                          ),
                          FxSpacing.height(10),
                          FxContainer(
                            padding: FxSpacing.fromLTRB(12, 4, 12, 4),
                            borderRadiusAll: 4,
                            color: theme.colorScheme.primary.withAlpha(40),
                            child: FxText.caption(
                                (snapshot.data!['email']).toString(),
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
                    FxSpacing.height(10),
                    Container(
                      margin: FxSpacing.x(15),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.profilePage,
                              );
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Row(
                              children: [
                                FxContainer(
                                  paddingAll: 12,
                                  borderRadiusAll: 4,
                                  child: Icon(
                                    Icons.person_outline,
                                    color: CustomTheme.appTheme,
                                    size: 20,
                                  ),
                                  color: CustomTheme.appTheme.withAlpha(20),
                                ),
                                FxSpacing.width(16),
                                Expanded(
                                  child: FxText.b1(
                                    'Profile'.trim(),
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
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.myStayListPage,
                              );
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Row(
                              children: [
                                FxContainer(
                                  paddingAll: 12,
                                  borderRadiusAll: 4,
                                  child: Icon(
                                    Icons.house_outlined,
                                    color: CustomTheme.appTheme,
                                    size: 20,
                                  ),
                                  color: CustomTheme.appTheme.withAlpha(20),
                                ),
                                FxSpacing.width(16),
                                Expanded(
                                  child: FxText.b1(
                                    'My Stays'.trim(),
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
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.wishListPage);
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Row(
                              children: [
                                FxContainer(
                                  paddingAll: 12,
                                  borderRadiusAll: 4,
                                  child: Icon(
                                    Icons.favorite_outline,
                                    color: CustomTheme.appTheme,
                                    size: 20,
                                  ),
                                  color: CustomTheme.appTheme.withAlpha(20),
                                ),
                                FxSpacing.width(16),
                                Expanded(
                                  child: FxText.b1(
                                    'My Wishlist'.trim(),
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
                            onTap: () async {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.referAndEarn);
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Row(
                              children: [
                                FxContainer(
                                  paddingAll: 12,
                                  borderRadiusAll: 4,
                                  child: Icon(
                                    Icons.record_voice_over_outlined,
                                    color: CustomTheme.appTheme,
                                    size: 20,
                                  ),
                                  color: CustomTheme.appTheme.withAlpha(20),
                                ),
                                FxSpacing.width(16),
                                Expanded(
                                  child: FxText.b1(
                                    'Refer & Earn'.trim(),
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
                            }*/
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
                                    image: AssetImage(Images.wallet),
                                    color: CustomTheme.appTheme,
                                  ),
                                  color: CustomTheme.appTheme.withAlpha(20),
                                ),
                                FxSpacing.width(16),
                                Expanded(
                                  child: FxText.b1(
                                    'language'.trim(),
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
                            onTap: () async {
                              RMSWidgets.showLoaderDialog(
                                  context: context, message: 'Logging out...');
                              SharedPreferenceUtil shared =
                                  SharedPreferenceUtil();
                              await GoogleAuthService.logOut();
                              await GoogleAuthService.logoutFromFirebase();
                              bool deletedAllValues = await shared.clearAll();
                              Navigator.of(context).pop();
                              if (deletedAllValues) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    AppRoutes.loginPage, (route) => false);
                              } else {
                                log('NOT ABLE TO DELETE VALUES FROM SP');
                              }
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Row(
                              children: [
                                FxContainer(
                                  paddingAll: 12,
                                  borderRadiusAll: 4,
                                  child: Icon(
                                    Icons.logout_rounded,
                                    color: CustomTheme.appTheme,
                                    size: 20,
                                  ),
                                  /* Image(
                                  height: 20,
                                  width: 20,
                                  image: AssetImage(Images.languageOutline),
                                  color: CustomTheme.skyBlue,
                                ),

                                */
                                  color: CustomTheme.appTheme.withAlpha(20),
                                ),
                                FxSpacing.width(16),
                                Expanded(
                                  child: FxText.b1(
                                    'Logout'.trim(),
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
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.myStayDetailsPage);
                            },
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
                                    image: AssetImage(Images.wallet),
                                    color: CustomTheme.appTheme,
                                  ),
                                  color: CustomTheme.appTheme.withAlpha(20),
                                ),
                                FxSpacing.width(16),
                                Expanded(
                                  child: FxText.b1(
                                    'FAQ'.trim(),
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
        }
        return Container();
      },
      future: getSharedPreferencesValues(),
    );
  }
}
