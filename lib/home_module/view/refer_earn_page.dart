import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
    //WidgetsBinding.instance!.addPostFrameCallback((_) => _showDialog());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;

    return Consumer<HomeViewModel>(builder: (context, value, child) {
      return Scaffold(
        appBar: _getAppBar(context: context),
        body: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              height: _mainHeight,
              width: _mainWidth,
              child: Column(
                children: [
                  Container(
                    height: _mainHeight * 0.30,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  CustomTheme.skyBlue.withAlpha(99),
                                  CustomTheme.peach.withAlpha(20)
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
                                    CustomTheme.peach
                                  ],
                                  end: Alignment.topCenter,
                                  begin: Alignment.bottomCenter),*/
                              image: DecorationImage(
                                //image: AssetImage(Images.referEarn),
                                image: AssetImage(Images.rmscard_background),
                                fit: BoxFit.cover,
                              ),

                              //color: [CustomTheme.skyBlue.withAlpha(50), CustomTheme.skyBlue],
                              borderRadius: BorderRadius.circular(15),

                            ),
                            margin: EdgeInsets.symmetric(horizontal: 40),
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
                                            Images.rupeeSilverIcon,
                                            height: 60,
                                           // color: CustomTheme.skyBlue,
                                          )
                                      ,)
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
                                        value.inviteModel.refferalMoney ?? "₹ 0"),
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
                    height: _mainHeight * 0.52,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                          image: DecorationImage(image:
                            AssetImage(Images.referEarn),fit: BoxFit.cover),
                  ),
                          height: _mainHeight * 0.30,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          top: 220,
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
                              height: _mainHeight * 0.20,
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
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await Clipboard.setData(ClipboardData(
                                                text: value.inviteModel
                                                    .refferalCode ??
                                                    " "));
                                            RMSWidgets.getToast(
                                                message: 'Invite Code Copied ',
                                                color: Colors.black12);
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
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text("Invite You Friend and Get 1000 to your account once he/she books a flats using your Invite Code. ",textAlign: TextAlign.center,),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        left: 15, right: 15, bottom: 15),
                                    height: _mainHeight*0.08,
                                    width: MediaQuery.of(context).size.width,
                                    child: Neumorphic(
                                        style: NeumorphicStyle(
                                            color: Colors.green,),
                                        child: TextButton(
                                          onPressed: () async{
                                            await Share.share(value.inviteModel.refferalText ?? " ");
                                          },
                                          child: Row( mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.share_outlined,color: Colors.white,
                                              ),
                                              Text("   Invite Your Friends  ",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)
                                            ],
                                          ),
                                        )),
                                  )
                                ],
                              )),
                        ),

                      ],
                    ),
                  ),
                  Container(margin: EdgeInsets.only(top: 50), alignment: Alignment.center,
                    child: GestureDetector(onTap: _showDialog,
                        child: Text("Terms and Conditions",style: TextStyle(color: CustomTheme.skyBlue))),
                   ),
                ],
              )),
        ),
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
                    child: Text("Terms \& Conditions", style: TextStyle(fontSize: 18),),
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: FxText.b2(
                "• Yoo will get 1000 off on his next month rent on each booking and whoever using  your referal code he will get  ₹500 off on one month rent .",
                color: Colors.black38,
                fontWeight: 500,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: FxText.b2("• Referrer can refer as many people as he/ she wants.",
                  color: Colors.black38,
                  fontWeight: 500,
                  height: 1.25,
                  letterSpacing: 0.1),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: FxText.b2("• Referrer will get referral reward when his/ her friend uses Referrer’s code at the time of booking any house from RentMyStay App or website.",
                  color: Colors.black38,
                  fontWeight: 500,
                  height: 1.25,
                  letterSpacing: 0.1),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: FxText.b2("• Referrer can use the referral reward at the time of booking any house from RentMyStay App or website.",
                  color: Colors.black38,
                  fontWeight: 500,
                  height: 1.25,
                  letterSpacing: 0.1),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: FxText.b2("• We can update these terms at any time without prior notice.",
                  color: Colors.black38,
                  fontWeight: 500,
                  height: 1.25,
                  letterSpacing: 0.1),
            ),

          ],
        ),
      ),
    );
  }
}