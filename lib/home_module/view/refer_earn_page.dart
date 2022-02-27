import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../theme/custom_theme.dart';

class ReferAndEarn extends StatefulWidget {
  ReferAndEarn({Key? key}) : super(key: key);

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnPageState();
}

class _ReferAndEarnPageState extends State<ReferAndEarn> {
  var _mainHeight;
  var _mainWidth;
  late HomeViewModel _homeViewModel;

  @override
  void initState() {
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _homeViewModel.getInviteEarnDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;

    return Consumer<HomeViewModel>(builder: (context, value, child) {
      return Scaffold(
        appBar: _getAppBar(context: context),
        body: Container(
            color: Colors.white,
            height: _mainHeight,
            width: _mainWidth,
            child: Column(
              children: [
                Container(
                  height: _mainHeight * 0.40,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            //image: AssetImage(Images.referEarn),
                            image: NetworkImage(
                                "https://www.cardrates.com/images/themes/cr-mobile/images/home/home-hero.jpg?width=538&height=322"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: _mainHeight * 0.30,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        top: 160,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(1, 1),
                                      blurStyle: BlurStyle.outer,
                                      blurRadius: 6,
                                      color: CustomTheme.skyBlue),
                                ]),
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            height: _mainHeight * 0.30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Your Invite Code",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black45),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                            value.inviteModel.refferalCode ??
                                                " ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await Clipboard.setData(ClipboardData(
                                              text: value.inviteModel
                                                      .refferalCode ??
                                                  " "));
                                          RMSWidgets.getToast(
                                              message: 'Copied ',
                                              color: Colors.yellow);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            "COPY",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                backgroundColor: CustomTheme
                                                    .peach
                                                    .withAlpha(60)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: 15, right: 15, top: 20, bottom: 15),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Neumorphic(
                                            style: NeumorphicStyle(
                                              color: Colors.green,
                                            ),
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 15, right: 15),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        Images.google,
                                                      ),
                                                      Text(
                                                        "   Invite By Whatsapp ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  )),
                                            )),
                                        Neumorphic(
                                            style: NeumorphicStyle(
                                                color: Colors.white38),
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.share_outlined,
                                                      ),
                                                      Text("   More")
                                                    ],
                                                  ),
                                                ))),
                                      ]),
                                )
                              ],
                            )),
                      ),
                      Positioned(
                        bottom: 130,
                        left: 0,
                        right: 0,
                        top: 30,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  CustomTheme.skyBlue,
                                  CustomTheme.peach
                                ],
                                end: Alignment.topCenter,
                                begin: Alignment.bottomCenter),
                            //color: [CustomTheme.skyBlue.withAlpha(50), CustomTheme.skyBlue],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 35),
                          height: _mainHeight * 0.30,
                          child: Container(

                            margin: EdgeInsets.only(
                              left: 15,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ]),
                                    Container(
                                        margin:
                                            EdgeInsets.only(right: 15, top: 15),
                                        child: Image.asset(
                                          Images.brandLogo,
                                          height: 60,
                                          color: CustomTheme.skyBlue,
                                        ))
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 28,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(35)),
                                  child: Text(
                                      value.inviteModel.refferalMoney ?? "0"),
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
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text("Rms Money"),
                      Text(value.inviteModel.refferalMoney ?? " ")
                    ],
                  ),
                ),
              ],
            )),
      );
    });
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
      title: Text('Refer And Earn'),
    );
  }
}
