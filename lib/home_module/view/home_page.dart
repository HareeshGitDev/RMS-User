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
  var _mainHeight;
  var _mainWidth;

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
    _mainHeight = MediaQuery.of(context).size.height;
    _mainHeight = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: CustomTheme.appTheme,
        centerTitle: true,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: Size(20, 50),
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(AppRoutes.searchPage, arguments: {
              'fromBottom': false,
            }),
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
                      .map(
                        (imageUrl) => CachedNetworkImage(
                          imageUrl: imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Shimmer.fromColors(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 180,
                              ),
                              baseColor: Colors.grey[200] as Color,
                              highlightColor: Colors.grey[350] as Color),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      )
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
      drawer: _getDrawer(
          context:
              context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _getDrawer({required BuildContext context}) {
    return Drawer(
      backgroundColor: CustomTheme.white,
      child: Container(
        height: _mainHeight,
        child: ListView(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error'),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Container(
                      color: CustomTheme.white,
                      height: _mainHeight * 0.45,
                      child: UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: [
                              CustomTheme.appTheme,
                              CustomTheme.appTheme.withAlpha(150),
                              CustomTheme.appTheme.withAlpha(50),

                            ],
                          )),
                          accountEmail: Text(
                            '${snapshot.data!['email'] ?? ''}',
                            style: TextStyle(
                                color: CustomTheme.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          accountName: Text(
                            '${snapshot.data!['name'] ?? ''}',
                            style: TextStyle(
                                color: CustomTheme.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          currentAccountPicture: CircleAvatar(
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
                                          decoration: const BoxDecoration(
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
                          ) /*,otherAccountsPictures: [
                         Image.asset(Images.brandLogo,color: CustomTheme.white,),

                      ],*/

                          ),
                    );
                  }
                }
                return Text('No Data');
              },
              future: getSharedPreferencesValues(),
            ),
            getTile(
              context: context,
              leading: Icon(
                Icons.person_outline,
                color: CustomTheme.appTheme,
                size: 20,
              ),
              title: 'Profile',
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.profilePage,
                arguments: {
                  'fromBottom': false,
                },
              ),
            ),
            getTile(
              context: context,
              leading: Icon(
                Icons.house_outlined,
                color: CustomTheme.appTheme,
                size: 20,
              ),
              title: 'My Stays',
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.myStayListPage,
                arguments: {
                  'fromBottom': false,
                },
              ),
            ),
            getTile(
              context: context,
              leading: Icon(
                Icons.style,
                color: CustomTheme.appTheme,
                size: 20,
              ),
              title: 'My Tickets',
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.ticketListPage,
              ),
            ),
            getTile(
              context: context,
              leading: Icon(
                Icons.favorite_outline,
                color: CustomTheme.appTheme,
                size: 20,
              ),
              title: 'My WishList',
              onTap: () => {
                Navigator.pushNamed(context, AppRoutes.wishListPage,
                    arguments: {
                      'fromBottom': false,
                    }),
              },
            ),
            getTile(
              context: context,
              leading: Icon(
                Icons.share,
                color: CustomTheme.appTheme,
                size: 20,
              ),
              title: 'Refer & Earn',
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.referAndEarn),
            ),
            getTile(
              context: context,
              leading: Icon(
                Icons.logout,
                color: CustomTheme.appTheme,
                size: 20,
              ),
              title: 'Logout',
              onTap: () async {
                RMSWidgets.showLoaderDialog(
                    context: context, message: 'Logging out...');
                SharedPreferenceUtil shared = SharedPreferenceUtil();
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
            ),
          ],
        ),
      ),
    );
  }

  Widget getTile(
      {required BuildContext context,
      required Icon leading,
      required String title,
      required Function onTap}) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 5),

      /*decoration: BoxDecoration(
          color: CustomTheme.appTheme.withAlpha(20),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),

      ),*/

      height: _mainHeight * 0.13,
      child: ListTile(
        leading: leading,
        title: Text(title),
        onTap: () => onTap(),
        trailing: Icon(
          Icons.arrow_right_outlined,
          color: Colors.grey,
        ),
      ),
    );
  }
}
