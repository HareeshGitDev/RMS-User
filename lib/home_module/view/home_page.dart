import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:RentMyStay_user/home_module/model/home_page_model.dart';
import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/login_module/service/google_auth_service.dart';
import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/theme/fonts.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/date_time_service.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:RentMyStay_user/utils/view/shimmers_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../my_stays/viewmodel/mystay_viewmodel.dart';
import '../../property_module/viewModel/property_viewModel.dart';
import '../../test_widget.dart';
import '../../theme/custom_theme.dart';
import '../../utils/model/class UtilsModel.dart';
import '../../utils/view/webView_page.dart';
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
  late List<UtilsModel> explorePropertiesList = [];

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
    _homeViewModel.getHomePageData();
    _homeViewModel.getTenantLeads();
    userDetails = getSharedPreferencesValues();
    preferenceUtil.getToken().then((value) => token = value ?? '');
    getExplorePropertiesList();
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
                      onTap: () async {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.searchPage, arguments: {
                          'fromBottom': false,
                          search_key1:
                              await preferenceUtil.getString(search_key1) ?? '',
                          search_key2:
                              await preferenceUtil.getString(search_key2) ?? '',
                          search_key3:
                              await preferenceUtil.getString(search_key3) ?? '',
                        });
                      },
                      child: Container(
                        height: _mainHeight * 0.05,
                        padding: EdgeInsets.only(
                          left: _mainWidth * 0.04,
                        ),
                        margin: EdgeInsets.only(
                            left: _mainWidth * 0.04,
                            right: _mainWidth * 0.04,
                            bottom: _mainHeight * 0.012),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              size: _mainWidth * 0.05,
                            ),
                            SizedBox(
                              width: _mainWidth * 0.02,
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
                      height: _mainHeight * 0.1,
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
                          getLocationView(context: context, value: value),
                          SizedBox(
                            height: _mainHeight * 0.01,
                          ),
                          Container(
                            //color: Colors.grey.shade50,
                            height: _mainHeight * 0.13,
                            padding: EdgeInsets.only(
                              left: _mainWidth * 0.03,
                              right: _mainWidth * 0.03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${nullCheck(list: value.languageData) ? value.languageData[16].name : 'Reasons to choose RentMyStay'}',
                                    style: getHeaderStyle),
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
                                                  color: Colors.grey.shade300),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            getReasonsList[index],
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: getHeight(
                                                    context: context,
                                                    height: 12),
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      },
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (_, __) => SizedBox(
                                            width: _mainWidth * 0.025,
                                          ),
                                      itemCount: getReasonsList.length),
                                ),
                              ],
                            ),
                          ),
                          /*Container(
                            height: _mainHeight * 0.07,
                            padding: EdgeInsets.only(
                              left: _mainWidth * 0.035,
                              right: _mainWidth * 0.035,
                            ),
                            child: ListView.separated(
                                itemBuilder: (_, index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                      left: _mainWidth * 0.015,
                                    ),
                                    width: _mainWidth * 0.45,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: _mainWidth * 0.33,
                                          child: Text(
                                            getRMSFeaturesList[index].key ?? '',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: getHeight(
                                                    context: context,
                                                    height: 12),
                                                color: CustomTheme.appTheme,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          getRMSFeaturesList[index].icon,
                                          color: CustomTheme.appTheme,
                                        ),
                                        SizedBox(
                                          width: _mainWidth * 0.01,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (_, __) => SizedBox(
                                      width: _mainWidth * 0.025,
                                    ),
                                itemCount: getRMSFeaturesList.length),
                          ),
                          SizedBox(
                            height: _mainHeight * 0.03,
                          ),*/

                          Container(
                            width: _mainWidth,
                            padding: EdgeInsets.only(
                              left: _mainWidth * 0.035,
                              right: _mainWidth * 0.035,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${nullCheck(list: value.languageData) ? value.languageData[17].name : 'Trending'}',
                                  style: getHeaderStyle,
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        AppRoutes.propertyListingPage,
                                        arguments: {
                                          'location':
                                              'Bengaluru-Karnataka-India',
                                          'property': Property.fromLocation,
                                        });
                                  },
                                  child: Text(
                                    '${nullCheck(list: value.languageData) ? value.languageData[24].name : 'See All'}',
                                    style: TextStyle(
                                        color: CustomTheme.appThemeContrast,
                                        fontSize: getHeight(
                                            context: context, height: 14),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: _mainHeight * 0.01,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: _mainWidth * 0.035,
                              right: _mainWidth * 0.035,
                            ),
                            child: _getTrendingProperties(
                                context: context, model: value),
                          ),
                          SizedBox(
                            height: _mainHeight * 0.03,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  AppRoutes.propertyListingPage,
                                  arguments: {
                                    'location': 'Bengaluru-Karnataka-India',
                                    'property': Property.fromLocation,
                                  });
                            },
                            child: Container(
                              width: _mainWidth,
                              margin: EdgeInsets.only(
                                  left: _mainWidth * 0.035,
                                  right: _mainWidth * 0.035),
                              padding: EdgeInsets.only(
                                  left: _mainWidth * 0.035,
                                  right: _mainWidth * 0.035),
                              height: _mainHeight * 0.055,
                              decoration: BoxDecoration(
                                  color: CustomTheme.appThemeContrast,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Text(
                                    '${nullCheck(list: value.languageData) ? value.languageData[15].name : 'Book your first RentMyStay '}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: getHeight(
                                            context: context, height: 14)),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _mainHeight * 0.03,
                          ),
                          CarouselSlider(
                            items: _homeViewModel
                                .getAdsImageList()
                                .map(
                                  (imageUrl) => CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                                    BorderRadius.circular(10),
                                              ),
                                              height: _mainHeight * 0.2,
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
                                height: _mainHeight * 0.2,
                                enlargeCenterPage: true,
                                autoPlayInterval: Duration(seconds: 6),
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                viewportFraction: 0.8),
                          ),
                          SizedBox(
                            height: _mainHeight * 0.02,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: _mainWidth * 0.035,
                            ),
                            child: Text(
                              '${nullCheck(list: value.languageData) ? value.languageData[14].name : 'Explore Your Wanderlust'}',
                              style: getHeaderStyle,
                            ),
                          ),
                          SizedBox(
                            height: _mainHeight * 0.01,
                          ),
                          exploreProperties(context: context, viewModel: value),
                          SizedBox(
                            height: _mainHeight * 0.005,
                          ),
                          SizedBox(
                            height: _mainHeight * 0.02,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                            ),
                            child: Text(
                              '${nullCheck(list: value.languageData) ? value.languageData[4].name : "Refer & Earn"}',
                              style: getHeaderStyle,
                            ),
                          ),
                          SizedBox(
                            height: _mainHeight * 0.01,
                          ),
                          Container(
                            width: _mainWidth,
                            padding: EdgeInsets.only(
                                left: _mainWidth * 0.03,
                                right: _mainWidth * 0.03),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(AppRoutes.referAndEarn),
                              child: CachedNetworkImage(
                                height: _mainHeight * 0.15,
                                imageUrl:
                                    'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Screenshot%202022-06-08%20at%2010.50.43%20PM.png?alt=media&token=d0a37d0e-79ec-44ee-8e1e-97296f044d35',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                        child: Container(
                                          height: _mainHeight * 0.15,
                                          decoration: const BoxDecoration(
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
                          SizedBox(
                            height: _mainHeight * 0.03,
                          ),
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

  Widget _getTrendingProperties(
      {required BuildContext context, required HomeViewModel model}) {
    if (model.homePageModel.msg != null &&
        model.homePageModel.data != null &&
        model.homePageModel.data?.trendingProps != null &&
        model.homePageModel.data?.trendingProps!.length != 0) {
      return Container(
        height: _mainHeight * 0.26,
        decoration: BoxDecoration(
          //  color: Colors.amber,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          itemBuilder: (context, index) {
            final data = model.homePageModel.data != null &&
                    model.homePageModel.data?.trendingProps != null &&
                    model.homePageModel.data?.trendingProps!.length != 0
                ? model.homePageModel.data?.trendingProps![index]
                    as TrendingProps
                : TrendingProps();
            return InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(AppRoutes.propertyDetailsPage, arguments: {
                'propId': data.propId ?? '',
                'fromExternalLink': false,
              }),
              child: Stack(
                children: [
                  Card(
                    elevation: 2,
                    child: Container(
                        width: _mainWidth * 0.42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: data.picThumbnail ?? '',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                              errorWidget: (context, url, error) => Container(
                                  alignment: Alignment.center,
                                  height: _mainHeight * 0.125,
                                  child: const Icon(Icons.error)),
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
                                    '${data.unitType ?? ''} - ${data.propType ?? ''}',
                                    style: TextStyle(
                                        fontSize: getHeight(
                                            context: context, height: 12),
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
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.home,
                                        color: Colors.grey,
                                        size: _mainHeight * 0.015,
                                      ),
                                      SizedBox(
                                        width: _mainWidth * 0.01,
                                      ),
                                      Container(
                                        width: _mainWidth * 0.35,
                                        child: Text(
                                          data.buildingName != null
                                              ? data.buildingName.toString()
                                              : '',
                                          style: TextStyle(
                                            fontSize: getHeight(
                                                context: context, height: 12),
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: _mainWidth * 0.01,
                                      right: _mainWidth * 0.01,
                                      top: _mainHeight * 0.005),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        Images.locationIcon,
                                        height: _mainHeight * 0.01,
                                        width: _mainWidth * 0.03,
                                      ),
                                      SizedBox(
                                        width: _mainWidth * 0.01,
                                      ),
                                      Container(
                                        width: _mainWidth * 0.35,
                                        child: Text(
                                          data.area != null &&
                                                  data.area?.trim() != ''
                                              ? '${data.area}'
                                              : data.city != null &&
                                                      data.city?.trim() != ''
                                                  ? '${data.city}'
                                                  : 'Bangalore',
                                          style: TextStyle(
                                            fontSize: getHeight(
                                                context: context, height: 12),
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                data.monthlyRent != null && data.monthlyRent !='0'? Container(
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
                                            style: TextStyle(
                                              fontSize: getHeight(
                                                  context: context, height: 12),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: _mainWidth * 0.005,
                                      ),
                                      showOrgPrice(
                                              monthlyRent:
                                                  data.monthlyRent ?? '0',
                                              orgRent: data.orgMonthRent ?? '0')
                                          ? Container()
                                          : Container(
                                              width: _mainWidth * 0.1,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                  right: _mainWidth * 0.01,
                                                  top: _mainHeight * 0.003),
                                              child: FittedBox(
                                                child: Text(
                                                  data.orgMonthRent != null
                                                      ? rupee +
                                                          '${data.orgMonthRent}'
                                                      : '',
                                                  style: TextStyle(
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 10),
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
                                      /*data.monthRentOff != null &&
                                              data.monthRentOff.toString() !=
                                                  '0'
                                          ? Container(
                                              width: _mainWidth * 0.15,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                  right: _mainWidth * 0.01,
                                                  top: _mainHeight * 0.003),
                                              child: FittedBox(
                                                child: Text(
                                                  '${data.monthRentOff.toString()}% OFF',
                                                  style: TextStyle(
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 12),
                                                    color:
                                                        CustomTheme.myFavColor,
                                                    fontWeight: FontWeight.w600,

                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),*/
                                      Container(
                                        width: _mainWidth * 0.15,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                            right: _mainWidth * 0.01,
                                            top: _mainHeight * 0.003),
                                        child: FittedBox(
                                          child: Text(
                                            ' ( < 3 Month )',
                                            style: TextStyle(
                                              fontSize: getHeight(
                                                  context: context, height: 12),
                                              color: CustomTheme.myFavColor,
                                              fontWeight: FontWeight.w600,

                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ):Container(),
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
                                            data.rmsRent != null
                                                ? rupee + ' ${data.rmsRent}'
                                                : '',
                                            style: TextStyle(
                                              fontSize: getHeight(
                                                  context: context, height: 12),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: _mainWidth * 0.005,
                                      ),
                                      showOrgPrice(
                                              monthlyRent: data.rmsRent ?? '0',
                                              orgRent: data.rmsRent ?? '0')
                                          ? Container()
                                          : Container(
                                              width: _mainWidth * 0.1,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                  right: _mainWidth * 0.01,
                                                  top: _mainHeight * 0.003),
                                              child: FittedBox(
                                                child: Text(
                                                  data.orgRmsRent != null
                                                      ? rupee +
                                                          '${data.orgRmsRent}'
                                                      : '',
                                                  style: TextStyle(
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 10),
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
                                      /*data.monthRentOff != null &&
                                              data.monthRentOff.toString() !=
                                                  '0'
                                          ? Container(
                                              width: _mainWidth * 0.15,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                  right: _mainWidth * 0.01,
                                                  top: _mainHeight * 0.003),
                                              child: FittedBox(
                                                child: Text(
                                                  '${data.monthRentOff.toString()}% OFF',
                                                  style: TextStyle(
                                                    fontSize: getHeight(
                                                        context: context,
                                                        height: 12),
                                                    color:
                                                        CustomTheme.myFavColor,
                                                    fontWeight: FontWeight.w600,

                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),*/
                                      Container(
                                        width: _mainWidth * 0.15,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                            right: _mainWidth * 0.01,
                                            top: _mainHeight * 0.003),
                                        child: FittedBox(
                                          child: Text(
                                            ' ( > 3 Month )',
                                            style: TextStyle(
                                              fontSize: getHeight(
                                                  context: context, height: 12),
                                              color: CustomTheme.myFavColor,
                                              fontWeight: FontWeight.w600,

                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                /* Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(
                                      left: _mainWidth * 0.01,
                                      right: _mainWidth * 0.01,
                                    top: _mainHeight*0.01
                                      ),
                                  child: Text(
                                    nullCheck(list: _homeViewModel.languageData) ? '${_homeViewModel.languageData[23].name}' :'More Info',
                                    style: TextStyle(
                                      fontSize: getHeight(
                                          context: context, height: 12),
                                      color: CustomTheme.appThemeContrast,

                                      fontWeight: FontWeight.w600,

                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ],
                        )),
                  ),
                  Positioned(
                    right: _mainHeight * 0.015,
                    top: _mainHeight * 0.01,
                    child: GestureDetector(
                      onTap: () async {
                        if (data.wishlist != null && data.wishlist == 1) {
                          if (data.propId != null) {
                            int response = await _homeViewModel.addToWishlist(
                                propertyId: data.propId ?? '');
                            if (response == 200) {
                              setState(() {
                                data.wishlist = 0;
                              });
                              RMSWidgets.showSnackbar(
                                  context: context,
                                  message: 'Successfully Removed From Wishlist',
                                  color: CustomTheme.appTheme);
                            }
                          }
                        } else if (data.wishlist != null &&
                            data.wishlist == 0) {
                          if (data.propId != null) {
                            int response = await _homeViewModel.addToWishlist(
                                propertyId: data.propId ?? '');
                            if (response == 200) {
                              setState(() {
                                data.wishlist = 1;
                              });
                              RMSWidgets.showSnackbar(
                                  context: context,
                                  message: 'Successfully Added to Wishlist',
                                  color: CustomTheme.appTheme);
                            }
                          }
                        }
                      },
                      child: data.wishlist == 1
                          ? Icon(
                              Icons.favorite,
                              color: CustomTheme.errorColor,
                            )
                          : Icon(
                              Icons.favorite_outline_rounded,
                              color: CustomTheme.white,
                            ),
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: model.homePageModel.data?.trendingProps!.length ?? 0,
          scrollDirection: Axis.horizontal,
        ),
      );
    } else if ((model.homePageModel.msg != null &&
            model.homePageModel.data != null &&
            model.homePageModel.data?.trendingProps != null &&
            model.homePageModel.data?.trendingProps!.length == 0) ||
        (model.homePageModel.msg != null &&
            model.homePageModel.data != null &&
            model.homePageModel.data?.trendingProps == null)) {
      return Center(
          child: RMSWidgets.someError(
        context: context,
      ));
    } else {
      return Container(
        height: _mainHeight * 0.23,
        width: _mainWidth,
        //color: Colors.amber,
        child: ListView.separated(
            itemBuilder: (_, index) {
              return Shimmer.fromColors(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    height: _mainHeight * 0.22,
                    width: _mainWidth * 0.42,
                  ),
                  baseColor: Colors.grey[200] as Color,
                  highlightColor: Colors.grey[350] as Color);
            },
            itemCount: 4,
            separatorBuilder: (_, __) => SizedBox(
                  width: _mainWidth * 0.02,
                ),
            scrollDirection: Axis.horizontal),
      );
    }
  }

  bool showOrgPrice({required String monthlyRent, required String orgRent}) {
    if (orgRent == '0') {
      return true;
    }
    return orgRent != '0' &&
        monthlyRent != '0' &&
        (monthlyRent.toString() == orgRent.toString());
  }

  Widget exploreProperties(
      {required BuildContext context, required HomeViewModel viewModel}) {
    return Container(
      height: _mainHeight * 0.39,
      width: _mainWidth,
      padding:
          EdgeInsets.only(left: _mainWidth * 0.035, right: _mainWidth * 0.035),
      child: GridView.builder(
        //shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: _mainHeight * 0.005,
            crossAxisSpacing: _mainWidth * 0.035,
            mainAxisExtent: _mainHeight * 0.19
            // childAspectRatio: 1.1
            ),
        itemBuilder: (_, index) {
          final data = explorePropertiesList[index];
          return Container(
            height: _mainHeight * 0.2,
            width: _mainWidth,
            child: Column(
              children: [
                InkWell(
                  onTap: () => RMSWidgets.getToast(
                      message: 'Coming Soon...',
                      color: CustomTheme.appTheme,
                      center: true),
                  child: CachedNetworkImage(
                    height: _mainHeight * 0.15,
                    imageUrl: data.imagePath ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Shimmer.fromColors(
                        child: Container(
                          height: _mainHeight * 0.15,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            color: Colors.grey,
                          ),
                        ),
                        baseColor: Colors.grey[200] as Color,
                        highlightColor: Colors.grey[350] as Color),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.008,
                ),
                Text(
                  data.key ?? "",
                  style: TextStyle(
                      fontSize: getHeight(context: context, height: 14),
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                )
              ],
            ),
          );
        },
        itemCount: explorePropertiesList.length,
      ),
    );
  }

  void getExplorePropertiesList() {
    explorePropertiesList.add(
      UtilsModel(
          key: 'Head to the hills',
          imagePath:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Screenshot%202022-06-10%20at%201.15.48%20AM.png?alt=media&token=431d2ac6-8d80-4532-8c34-f18cf5a46e6b',
          callback: () => RMSWidgets.getToast(
              message: 'Coming Soon', color: CustomTheme.appTheme)),
    );
    explorePropertiesList.add(
      UtilsModel(
          key: 'Chill at the beach',
          imagePath:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Screenshot%202022-06-10%20at%201.16.15%20AM.png?alt=media&token=878164f1-0332-4fa5-aa54-43598af8c705',
          callback: () {}),
    );
    explorePropertiesList.add(
      UtilsModel(
          key: 'Discover your heritage',
          imagePath:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Screenshot%202022-06-10%20at%201.16.32%20AM.png?alt=media&token=23c1dda7-4243-41ff-89d9-e8eb6f278706',
          callback: () {}),
    );
    explorePropertiesList.add(
      UtilsModel(
          key: 'Travel for work',
          imagePath:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Screenshot%202022-06-10%20at%201.22.26%20AM.png?alt=media&token=b541bd17-02a8-4d6a-8d43-950edae42ddb',
          callback: () {}),
    );
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
                Icons.work_outline_outlined,
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
                  nullCheck(list: list) ? '${list[18].name}' : 'My Site Visits',
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
                      width: _mainWidth,
                      child: Text(
                          '${nullCheck(list: value.languageData) ? value.languageData[19].name : 'Owner Dashboard'}')),
                  children: [
                    getTile(
                      context: context,
                      leading: Icon(
                        Icons.view_agenda,
                        color: CustomTheme.appTheme,
                        size: 20,
                      ),
                      title: nullCheck(list: list)
                          ? '${list[20].name}'
                          : 'Property View',
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
                      title: nullCheck(list: list)
                          ? '${list[21].name}'
                          : 'Property View',
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
                      title: nullCheck(list: list)
                          ? '${list[22].name}'
                          : 'Tenants Leads',
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.tenantLeadsPage),
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
                Icons.person,
                color: CustomTheme.appTheme,
                size: 20,
              ),
              title: /*nullCheck(list: list) ? '${list[10].name}' : */'Contact Us',
              onTap: () async => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Web_View_Container(supportUrl, 'Contact Us')),
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
        height: _mainHeight * 0.12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure to exit the app ?',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: getHeight(context: context,height: 20),
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
                          fontSize: getHeight(context: context, height: 16),
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
                            CustomTheme.appThemeContrast),
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
                          fontSize: getHeight(context: context, height: 16),
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

  List<String> get getReasonsList {
    return [
      'Family and Bachelor Friendly.',
      'Free Maintenance for first 30 days of stay(T&C).',
      'Free movement across any property in first 48hrs.',
      'No Brokerage and No maintenance charged.',
      'Rent for Short term or Long term.',
    ];
  }

  List<UtilsModel> get getRMSFeaturesList {
    return [
      UtilsModel(key: 'Zero Brokerage', icon: Icons.whatshot_outlined),
      UtilsModel(
          key: 'Rent for any duration', icon: Icons.access_alarms_outlined),
      UtilsModel(key: 'Add / Host Property', icon: Icons.home_outlined),
    ];
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  Widget getLocationView(
      {required BuildContext context, required HomeViewModel value}) {
    return Container(
      padding: EdgeInsets.only(
          top: _mainHeight * 0.025,
          left: _mainWidth * 0.03,
          right: _mainWidth * 0.03),
      height: _mainHeight * 0.14,
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var data =
              _homeViewModel.getCitySuggestionList(context: context)[index];
          return InkWell(
            onTap: index == 0
                ? () async {
                    bool? granted =
                        await LocationService.checkPermission(context: context);
                    if (granted != null && granted) {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.propertyListingPage, arguments: {
                        'location': data.value,
                        'property': Property.fromCurrentLocation,
                      });
                    }
                  }
                : () => Navigator.of(context)
                        .pushNamed(AppRoutes.propertyListingPage, arguments: {
                      'location': data.value,
                      'property': Property.fromLocation,
                    }),
            child: Column(
              children: [
                Container(
                  height: _mainHeight * 0.07,
                  width: _mainWidth * 0.14,
                  child: index == 0
                      ? Container(
                          decoration: BoxDecoration(
                              color: CustomTheme.appThemeContrast,
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.my_location,
                            size: _mainHeight * 0.03,
                            color: CustomTheme.white,
                          ))
                      : CachedNetworkImage(
                          imageUrl: data.imageUrl.toString(),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Shimmer.fromColors(
                              child: Container(
                                height: _mainHeight * 0.08,
                                width: _mainWidth * 0.12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey,
                                ),
                              ),
                              baseColor: Colors.grey[200] as Color,
                              highlightColor: Colors.grey[350] as Color),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: index == 0,
                  child: Text(
                    '${nullCheck(list: value.languageData) ? value.languageData[0].name : 'Near Me'}',
                    style: TextStyle(
                        fontSize: getHeight(context: context, height: 12),
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  replacement: Text(
                    data.cityName,
                    style: TextStyle(
                        fontSize: getHeight(context: context, height: 12),
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount:
            _homeViewModel.getCitySuggestionList(context: context).length,
        separatorBuilder: (context, index) => SizedBox(
          width: _mainWidth * 0.035,
        ),
      ),
    );
  }

  TextStyle get getHeaderStyle => TextStyle(
      color: CustomTheme.appTheme,
      fontSize: getHeight(context: context, height: 18),
      fontWeight: FontWeight.w500);
}
