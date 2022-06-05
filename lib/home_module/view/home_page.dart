import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/login_module/service/google_auth_service.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/date_time_service.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/custom_theme.dart';
import '../../webView_page.dart';
import '../../images.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/constants/enum_consts.dart';
import '../../language_module/model/language_model.dart';
import '../../utils/service/location_service.dart';
import '../../utils/service/navigation_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String token;
  late ThemeData theme;
  late CustomTheme customTheme;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late HomeViewModel _homeViewModel;
  var _mainHeight;
  var _mainWidth;
  ValueNotifier<bool> isExpanded = ValueNotifier(false);
  SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
  late Future<Map<String, String>> userDetails;
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;

  Future<void> initConnectionStatus() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      log(e.toString());
    }
    if (!mounted) {
      return null;
    }

    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = false);
        break;
      case ConnectivityResult.ethernet:
        setState(() => _connectionStatus = true);
        break;
      default:
        setState(() => _connectionStatus = false);
        break;
    }
  }

  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    userDetails = getSharedPreferencesValues();
    preferenceUtil.getToken().then((value) => token = value ?? '');

    getLanguageData();
  }

  getLanguageData() async {
    await _homeViewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'HomePage');
  }

  Future<Map<String, String>> getSharedPreferencesValues() async {
    var checkInDate = await preferenceUtil.getString(rms_checkInDate);
    var checkOutDate = await preferenceUtil.getString(rms_checkOutDate);

    if (checkInDate == null && checkOutDate == null) {
      await preferenceUtil.setString(
          rms_checkInDate, DateTimeService.ddMMYYYYformatDate(DateTime.now()));
      await preferenceUtil.setString(
          rms_checkOutDate,
          DateTimeService.ddMMYYYYformatDate(
              DateTime.now().add(const Duration(days: 32))));
    }

    return {
      'email': (await preferenceUtil.getString(rms_email)).toString(),
      'name': (await preferenceUtil.getString(rms_name)).toString(),
      'phone': (await preferenceUtil.getString(rms_phoneNumber)).toString(),
      'pic': (await preferenceUtil.getString(rms_profilePicUrl)).toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus
        ? Consumer<HomeViewModel>(
            builder: (context, value, child) {
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
                        margin:
                            EdgeInsets.only(left: 15, right: 15, bottom: 10),
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
                            Text(
                                '${nullCheck(list: value.languageData) ? value.languageData[2].name : 'Search'}'),
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
                  title: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Image.asset(
                      Images.brandLogo_Transparent,
                      height: 100,
                    ),
                  ),
                ),
                body: WillPopScope(
                  onWillPop: () async {
                    showExitDialog(context);
                    return false;
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                //top: _mainHeight * 0.015,
                                left: _mainWidth * 0.03,
                                right: _mainWidth * 0.03),
                            height: _mainHeight * 0.15,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                var data = _homeViewModel.getCitySuggestionList(
                                    context: context)[index];
                                return InkWell(
                                  onTap: index == 0
                                      ? () async {
                                          bool? granted = await LocationService
                                              .checkPermission(
                                                  context: context);
                                          if (granted != null && granted) {
                                            Navigator.of(context).pushNamed(
                                                AppRoutes.propertyListingPage,
                                                arguments: {
                                                  'location': data.value,
                                                  'property': Property
                                                      .fromCurrentLocation,
                                                });
                                          }
                                        }
                                      : () => Navigator.of(context).pushNamed(
                                              AppRoutes.propertyListingPage,
                                              arguments: {
                                                'location': data.value,
                                                'property':
                                                    Property.fromLocation,
                                              }),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: _mainHeight * 0.09,
                                        width: _mainWidth * 0.12,
                                        child: index == 0
                                            ? Transform.rotate(
                                                angle: math.pi / 4,
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                        CustomTheme.appTheme,
                                                    child: Icon(
                                                      Icons.navigation_outlined,
                                                      size: 25,
                                                      color: CustomTheme.white,
                                                    )),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl:
                                                    data.imageUrl.toString(),
                                                imageBuilder:
                                                    (context, imageProvider) =>
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
                                                          height: _mainHeight *
                                                              0.11,
                                                          width:
                                                              _mainWidth * 0.12,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        baseColor: Colors
                                                            .grey[200] as Color,
                                                        highlightColor:
                                                            Colors.grey[350]
                                                                as Color),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                      ),
                                      SizedBox(
                                        height: 0,
                                      ),
                                      Visibility(
                                        visible: index == 0,
                                        child: Text(
                                          '${nullCheck(list: value.languageData) ? value.languageData[0].name : 'My Location'}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        replacement: Text(
                                          data.cityName,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: _homeViewModel
                                  .getCitySuggestionList(context: context)
                                  .length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 10,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: CarouselSlider(
                              items: _homeViewModel
                                  .getAdsImageList()
                                  .map(
                                    (imageUrl) => CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                height: 180,
                                              ),
                                              baseColor:
                                                  Colors.grey[200] as Color,
                                              highlightColor:
                                                  Colors.grey[350] as Color),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  )
                                  .toList(),
                              options: CarouselOptions(
                                  height: _mainWidth * 0.4,
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
                              '${nullCheck(list: value.languageData) ? value.languageData[1].name : "Popular"}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                //decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10),
                              height: _mainHeight * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var data = _homeViewModel
                                      .getPopularPropertyModelList()[index];
                                  return InkWell(
                                    onTap: () => Navigator.of(context)
                                        .pushNamed(
                                            AppRoutes.propertyListingPage,
                                            arguments: {
                                          'location':
                                              'Bengaluru-Karnataka-India',
                                          'propertyType': data.propertyType,
                                          'property': Property.fromBHK,
                                        }),
                                    child: Card(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      elevation: 3,
                                      shadowColor: CustomTheme.appTheme,
                                      child: Container(
                                        width: _mainWidth * 0.62,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: _mainHeight * 0.16,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          data.imageUrl!),
                                                      fit: BoxFit.cover
                                                      //NetworkImage(data.imageUrl!),fit: BoxFit.cover,
                                                      )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 5,
                                                    top: _mainHeight * 0.002),
                                                alignment: Alignment.topLeft,
                                                child: Text(data.propertyType!,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ))),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 5,
                                                    top: _mainHeight * 0.002),
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  data.propertyDesc!,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12),
                                                )),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                    '${nullCheck(list: value.languageData) ? value.languageData[3].name : 'More Info'}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: CustomTheme
                                                            .appThemeContrast))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: _homeViewModel
                                    .getPopularPropertyModelList()
                                    .length,
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 15, top: 15),
                            child: Text(
                              '${nullCheck(list: value.languageData) ? value.languageData[4].name : "Refer & Earn"}',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 18,

                                //decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(AppRoutes.referAndEarn),
                            child: Container(
                                width: _mainWidth,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, top: 15),
                                          child: Text(
                                            "Earn",
                                            style: TextStyle(
                                              color:
                                                  CustomTheme.appThemeContrast,
                                              fontSize: 28,

                                              //decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 15, top: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                "1000",
                                                style: TextStyle(
                                                  color: CustomTheme
                                                      .appThemeContrast,
                                                  fontSize: 40,

                                                  //decoration: TextDecoration.underline,
                                                ),
                                              ),
                                              Text(
                                                "Rupees",
                                                style: TextStyle(
                                                  color: CustomTheme
                                                      .appThemeContrast,
                                                  fontSize: 16,

                                                  //decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 15, top: 10),
                                          child: Text(
                                            "Share with your Friend",
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 18,

                                              //decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        height: _mainHeight * 0.2,
                                        child: Image.asset(
                                          Images.referIconHome,
                                          fit: BoxFit.fill,
                                        ))
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                drawer: _getDrawer(
                    context: context,
                    list: value.languageData,
                    value:
                        value), // This trailing comma makes auto-formatting nicer for build methods.
              );
            },
          )
        : RMSWidgets.networkErrorPage(context: context);
  }

  Widget _getDrawer(
      {required BuildContext context,
      required List<LanguageModel> list,
      required HomeViewModel value}) {
    return Drawer(
      key: _drawerKey,
      backgroundColor: CustomTheme.white,
      child: Container(
        height: _mainHeight,
        child: ListView(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Container(
                      color: CustomTheme.white,
                      height: _mainHeight * 0.2,
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
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.profilePage,
                                arguments: {
                                  'fromBottom': false,
                                },
                              ),
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
                          ),
                          radius: 45,
                        ),
                        otherAccountsPictures: [
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.profilePage,
                              arguments: {
                                'fromBottom': false,
                              },
                            ),
                            child: Icon(Icons.mode_edit,
                                color: CustomTheme.appTheme),
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Text('No Data');
              },
              future: userDetails,
            ),
            getTile(
              context: context,
              leading: Icon(
                Icons.line_weight_rounded,
                color: CustomTheme.appTheme,
                size: 20,
              ),
              title: nullCheck(list: list) ? '${list[6].name}' : 'My Stays',
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
              title: nullCheck(list: list) ? '${list[7].name}' : 'My Tickets',
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.ticketListPage,
              ),
            ),
            getTile(
              context: context,
              leading: Icon(
                Icons.library_add_check,
                color: CustomTheme.appTheme,
                size: 20,
              ),
              title:
                  nullCheck(list: list) ? '${list[12].name}' : 'My Site Visits',
              onTap: () => {
                _handleURLButtonPress(
                    context,
                    myVisitsUrl,
                    nullCheck(list: list)
                        ? '${list[12].name}'
                        : 'My Site Visits',
                    token),
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isExpanded,
              builder: (_, expanded, __) {
                return ExpansionTile(
                  /*tilePadding: EdgeInsets.only(
                    left: _mainWidth * 0.04,
                    right: _mainWidth * 0.05,
                  ),*/
                  onExpansionChanged: (val) => isExpanded.value = val,
                  trailing: Icon(
                      expanded ? Icons.arrow_drop_down : Icons.arrow_right,
                      color: Colors.grey),
                  childrenPadding: EdgeInsets.only(
                    left: _mainWidth * 0.07,
                    bottom: _mainHeight * 0.015,
                  ),
                  leading: Container(
                      margin: EdgeInsets.only(left: _mainWidth * 0.01),
                      height: _mainHeight * 0.05,
                      width: _mainWidth * 0.1,
                      decoration: BoxDecoration(
                          color: CustomTheme.appTheme.withAlpha(20),
                          borderRadius: BorderRadius.circular(5)),
                      child: Icon(
                        Icons.add_road_rounded,
                        color: CustomTheme.appTheme,
                        size: 20,
                      )),
                  title: Container(
                      width: _mainWidth, child: Text('Owner Dashboard')),
                  children: [
                    getTile(
                      context: context,
                      leading: Icon(
                        Icons.view_agenda,
                        color: CustomTheme.appTheme,
                        size: 20,
                      ),
                      title: /*nullCheck(list: list) ? '${list[13].name}' :*/ 'Property View',
                      onTap: () => {
                        _handleURLButtonPress(
                            context,
                            ownerViewUrl,
                            nullCheck(list: list)
                                ? '${list[13].name}'
                                : 'Owner View',
                            token),
                      },
                    ),
                    getTile(
                      context: context,
                      leading: Icon(
                        Icons.wysiwyg,
                        color: CustomTheme.appTheme,
                        size: 20,
                      ),
                      title: 'My Properties',
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.ownerPropertyListingPage),
                    ),
                    getTile(
                      context: context,
                      leading: Icon(
                        Icons.adjust_rounded,
                        color: CustomTheme.appTheme,
                        size: 20,
                      ),
                      title: 'Tenants Leads',
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.referAndEarn),
                    ),
                  ],
                );
              },
            ),
            getTile(
              context: context,
              leading: Icon(
                Icons.language,
                color: CustomTheme.appTheme,
                size: 20,
              ),
              title: nullCheck(list: list) ? '${list[10].name}' : 'Language',
              onTap: () async => Navigator.of(context).popAndPushNamed(
                AppRoutes.languageScreen,
                arguments: {
                  'fromDashboard': true,
                  'lang':
                      await preferenceUtil.getString(rms_language) ?? 'english',
                },
              ),
            ),
            getTile(
              context: context,
              leading: Icon(
                Icons.logout,
                color: CustomTheme.appTheme,
                size: 20,
              ),
              title: nullCheck(list: list) ? '${list[11].name}' : 'Logout',
              onTap: () async {
                RMSWidgets.showLoaderDialog(
                    context: context, message: 'Logging out');
                SharedPreferenceUtil shared = SharedPreferenceUtil();
                await GoogleAuthService.logOut();
                await GoogleAuthService.logoutFromFirebase();
                bool deletedAllValues = await shared.clearAll();
                Navigator.of(context).pop();
                if (deletedAllValues) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.loginPage, (route) => false,
                      arguments: {
                        'fromExternalLink': false,
                      });
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
      margin: EdgeInsets.only(
          left: _mainWidth * 0.01,
          right: _mainWidth * 0.01,
          top: _mainHeight * 0.006),
      height: _mainHeight * 0.06,
      child: ListTile(
        leading: Container(
            height: _mainHeight * 0.05,
            width: _mainWidth * 0.1,
            decoration: BoxDecoration(
                color: CustomTheme.appTheme.withAlpha(20),
                borderRadius: BorderRadius.circular(5)),
            child: leading),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        onTap: () => onTap(),
        trailing: Icon(
          Icons.arrow_right_outlined,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _handleURLButtonPress(
      BuildContext context, String url, String title, String params) {
    String urlwithparams = url + params;
    log(urlwithparams);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Web_View_Container(urlwithparams, title)),
    );
  }

  Future showExitDialog(BuildContext context) async {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: _mainHeight * 0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure to exit the app ?',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black),
            ),
            SizedBox(
              height: _mainHeight * 0.035,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: _mainWidth * 0.2,
                  height: _mainHeight * 0.035,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        )),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'No',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  width: _mainWidth * 0.2,
                  height: _mainHeight * 0.035,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            CustomTheme.appTheme),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        )),
                    onPressed: () => exit(0),
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert; //WillPopScope(child: alert, onWillPop: ()async=>false);
      },
    );
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;
}
