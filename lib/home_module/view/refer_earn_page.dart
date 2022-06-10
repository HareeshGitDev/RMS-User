import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/theme/fonts.dart';
import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';

class ReferAndEarn extends StatefulWidget {
  ReferAndEarn({Key? key}) : super(key: key);

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnPageState();
}

class _ReferAndEarnPageState extends State<ReferAndEarn> {
  var _mainHeight;
  var _mainWidth;
  late HomeViewModel _homeViewModel;
  late SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
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
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _homeViewModel.getInviteEarnDetails();

    getLanguageData();
  }

  getLanguageData() async {
    await _homeViewModel.getReferAndEarnLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'refer&earn');
  }

  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;

    return _connectionStatus?Consumer<HomeViewModel>(builder: (context, value, child) {
      return Scaffold(
        appBar: _getAppBar(context: context),
        body: value.referAndEarnModel != null &&
                value.referAndEarnModel?.msg != null &&
                value.referAndEarnModel?.data != null
            ? Container(
                color: Colors.white,
                height: _mainHeight,
                width: _mainWidth,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        height: _mainHeight * 0.31,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      CustomTheme.appTheme.withAlpha(99),
                                      CustomTheme.appThemeContrast.withAlpha(20)
                                    ],
                                    end: Alignment.topCenter,
                                    begin: Alignment.bottomCenter),
                                /* image: DecorationImage(

                              //image: AssetImage(Images.referEarn),
                              image: NetworkImage(
                                  "https://www.cardrates.com/images/themes/cr-mobile/images/home/home-hero.jpg?width=538&height=322"),
                              fit: BoxFit.cover,
                            ), */
                              ),
                              height: _mainHeight * 0.30,
                            ),
                            Positioned(
                              bottom: 50,
                              left: 0,
                              right: 0,
                              top: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                  /*   gradient: LinearGradient(
                                  colors: [
                                    CustomTheme.skyBlue,

                                  ],
                                  end: Alignment.topCenter,
                                  begin: Alignment.bottomCenter),*/
                                  image: DecorationImage(
                                    //image: AssetImage(Images.referEarn),
                                    image: AssetImage(
                                      Images.rmscard_background,
                                    ),
                                    colorFilter: ColorFilter.mode(
                                        CustomTheme.appTheme,
                                        BlendMode.colorBurn),
                                    fit: BoxFit.cover,
                                  ),

                                  //color: [CustomTheme.skyBlue.withAlpha(50), CustomTheme.skyBlue],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 40),
                                height: _mainHeight * 0.3,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: 15,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(children: [
                                            Image.asset(
                                              Images.brandLogo_Transparent,
                                              height: 70,
                                            ),
                                            Text(
                                              "Monies",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ]),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 15, top: 15),
                                            child: Image.asset(
                                              Images.rupeeSilverIcon,
                                              height: 60,
                                              // color: CustomTheme.skyBlue,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: _mainHeight*0.032,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        margin: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(35)),
                                        child: Text(
                                            '$rupee ${value.referAndEarnModel?.data?.refferalMoney ?? " 0 "}',style: TextStyle(
                                          fontSize: getHeight(context: context, height: 12)
                                        ),),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: _mainWidth,
                        padding: EdgeInsets.only(
                            left: _mainWidth * 0.03,
                            right: _mainWidth * 0.03),
                        child: CachedNetworkImage(
                          height: _mainHeight * 0.22,
                          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Screenshot%202022-06-08%20at%2010.50.43%20PM.png?alt=media&token=d0a37d0e-79ec-44ee-8e1e-97296f044d35',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Shimmer.fromColors(
                              child: Container(
                                height: _mainHeight * 0.22,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                              ),
                              baseColor: Colors.grey[200] as Color,
                              highlightColor: Colors.grey[350] as Color),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(1, 1),
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 6,
                                    color: CustomTheme.appTheme),
                              ]),
                         margin: EdgeInsets.symmetric(horizontal: _mainWidth*0.035),
                          height: _mainHeight * 0.28,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: _mainHeight*0.02),
                                  child: Text(
                                    '${nullCheck(list: value.referAndEarnLang) ? value.referAndEarnLang[0].name : 'Your Invite Code'}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: getHeight(context: context, height: 12),
                                        color: Colors.black45),
                                  )),
                              Container(
                                margin: EdgeInsets.only(top: _mainHeight*0.01),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        value.referAndEarnModel?.data
                                            ?.refferalCode ??
                                            " ",
                                        textAlign: TextAlign.center,
                                        style:
                                        TextStyle(fontSize: getHeight(context: context, height: 20))),
                                    value.referAndEarnModel?.data
                                        ?.refferalCode !=
                                        null
                                        ? GestureDetector(
                                      onTap: () async {
                                        await Clipboard.setData(
                                            ClipboardData(
                                                text: value
                                                    .referAndEarnModel
                                                    ?.data
                                                    ?.refferalCode ??
                                                    " "));
                                        RMSWidgets.getToast(
                                            message:
                                            'Invite Code Copied ',
                                            color:
                                            Colors.black12);
                                      },
                                      child: Container(
                                       
                                        decoration: BoxDecoration(
                                          color: CustomTheme.myFavColor,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        padding: EdgeInsets.only(left: _mainWidth*0.01,right: _mainWidth*0.01,top: _mainHeight*0.0025,bottom: _mainHeight*0.0025),
                                        margin: EdgeInsets.only(left: _mainWidth*0.02),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "COPY",
                                          textAlign:
                                          TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: getHeight(context: context, height:12)

                                          ),
                                        ),
                                      ),
                                    )
                                        : Container(),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: _mainWidth*0.04,
                                  right: _mainWidth*0.04,
                                  top: _mainHeight*0.02,
                                  bottom: _mainHeight*0.02,
                                ),
                                child: Text(
                                  '${nullCheck(list: value.referAndEarnLang) ? value.referAndEarnLang[1].name : 'Invite Your Friend and Get 1000 to your account once he/she books a flats using your Invite Code.'}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Spacer(),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                  left: _mainWidth*0.04,
                                  right: _mainWidth*0.04,
                                ),
                                height: _mainHeight * 0.08,
                                width:
                                MediaQuery.of(context).size.width,
                                child: Neumorphic(
                                    style: NeumorphicStyle(
                                      color: CustomTheme.myFavColor,
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        await Share.share(value
                                            .referAndEarnModel
                                            ?.data
                                            ?.refferalText ??
                                            " ");
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.share_outlined,
                                            color: Colors.white,
                                            size: _mainWidth*0.05,
                                          ),
                                          SizedBox(
                                            width: _mainWidth*0.02,
                                          ),
                                          Text(
                                            '${nullCheck(list: value.referAndEarnLang) ? value.referAndEarnLang[2].name : 'Invite Your Friends'}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                            fontSize: getHeight(context: context, height: 16)
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              )
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        child: GestureDetector(
                            onTap: _showDialog,
                            child: Text('${nullCheck(list: value.referAndEarnLang) ? value.referAndEarnLang[4].name : 'Terms & Conditions'}',
                                style: TextStyle(color: CustomTheme.appTheme))),
                      ),
                    ],
                  ),
                ))
            : value.referAndEarnModel != null &&
                    value.referAndEarnModel?.msg != null &&
                    value.referAndEarnModel?.data == null
                ? Center(
                    child: RMSWidgets.someError(
                    context: context,
                  ))
                : Center(
                    child: RMSWidgets.getLoader(color: CustomTheme.appTheme)),
      );
    }):RMSWidgets.networkErrorPage(context: context);
  }

  AppBar _getAppBar({required BuildContext context}) {
    return AppBar(
      leading: BackButton(
        color: Colors.white,
      ),
      centerTitle: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      titleSpacing: 0,
      backgroundColor: CustomTheme.appTheme,
      title: Text(
          nullCheck(list: context.watch<HomeViewModel>().referAndEarnLang)
              ? '${context.watch<HomeViewModel>().referAndEarnLang[3].name}'
              : 'Refer & Earn'),
    );
  }

  void _showDialog() {
    showDialog(
        context: context, builder: (BuildContext context) => TermsDialog());
  }
}

class TermsDialog extends StatefulWidget {
  @override
  _TermsDialogState createState() => _TermsDialogState();
}

class _TermsDialogState extends State<TermsDialog> {
  bool? isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      "Terms \& Conditions",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                "• Yoo will get 1000 off on his next month rent on each booking and whoever using  your referal code he will get  ₹500 off on one month rent .",
                style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                "• Referrer can refer as many people as he/ she wants.",
                style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                "• Referrer will get referral reward when his/ her friend uses Referrer’s code at the time of booking any house from RentMyStay App or website.",
                style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                "• Referrer can use the referral reward at the time of booking any house from RentMyStay App or website.",
                style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                "• We can update these terms at any time without prior notice.",
                style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
