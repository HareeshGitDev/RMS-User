import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/login_module/service/google_auth_service.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/theme/fonts.dart';

import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/view/webView_page.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../model/gmail_signin_request_model.dart';
import '../model/login_response_model.dart';
import '../model/signup_response_model.dart';

class LoginPage extends StatefulWidget {
  final bool fromExternalLink;
  Function? onClick;

  LoginPage({required this.fromExternalLink, this.onClick});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FirebaseMessaging messaging = FirebaseMessaging.instance;
  TextEditingController mob_controller = TextEditingController();
  final privacy_policy =
      "https://www.rentmystay.com/info/privacy-policy/123456";

  late LoginViewModel _loginViewModel;
  final _emailController = TextEditingController();
  final _resetEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _mainHeight;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _mainWidth;
  bool isObscure = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;

  SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();

  getLanguageData() async {
    await _loginViewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'loginPage');
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

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
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    getLanguageData();
  }

  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus
        ? Scaffold(

      backgroundColor:   Colors.white,

            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(
                    "assets/images/loginBackground.png",
                  ),
                      fit: BoxFit.cover

                  )
              ),
              child: Consumer<LoginViewModel>(
                builder: (context, value, child) {
                  return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Container(
                        //color: CustomTheme.appTheme,
                        height: _mainHeight,
                        width: _mainWidth,

                        //padding: EdgeInsets.only(left: 25, right: 25),
                        child: Column(
                          children: <Widget>[
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 25, right: 25),
                            //   child: SizedBox(
                            //     height: _mainHeight * 0.3,
                            //     child: Image.asset(
                            //       'assets/images/transparent_logo_rms.png',
                            //     ),
                            //   ),
                            // ),
                            Container(
                              padding: EdgeInsets.only(left: _mainWidth * 0.035,top: _mainHeight*0.12),
                              margin: EdgeInsets.only(right: _mainWidth * 0.035),
                              alignment: Alignment.centerLeft,

                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 40),
                                    child: Center(
                                      child: Image(
                                        image: AssetImage("assets/images/logo.png"),
                                        width: 130,

                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[0].name : 'Welcome'}',
                                              style: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold
                                              ),
                                  ),
                                  Text(
                                    '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[28].name : ' Back'}',
                                              style: const TextStyle(
                                                fontSize: 30,
                                                  color: Colors.white,
                                                fontWeight: FontWeight.bold
                                              ),
                                  ),
                                ],
                              ),

                              // child: AnimatedTextKit(
                              //   animatedTexts: [
                              //     ColorizeAnimatedText(
                              //         '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[0].name : 'Welcome Back'} ! ',
                              //         textStyle: TextStyle(
                              //           fontSize: _mainWidth * 0.05,
                              //         ),
                              //         colors: [
                              //           Colors.white,
                              //           CustomTheme.appTheme,
                              //         ]),
                              //   ],
                              //   isRepeatingAnimation: true,
                              //   repeatForever: true,
                              // ),
                            ),
                            SizedBox(
                              height: _mainHeight * 0.025,
                            ),
                            Expanded(
                              child: Container(
                                width: _mainWidth,
                                height: _mainHeight * 0.6,
                                padding: EdgeInsets.only(
                                    left: _mainWidth * 0.04,
                                    top: _mainHeight * 0.03,
                                    right: _mainWidth * 0.04),
                                decoration: const BoxDecoration(

                                  // borderRadius: BorderRadius.only(
                                  //     topLeft: Radius.circular(25.0),
                                  //     topRight: Radius.circular(25.0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text("Email",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,

                                    ),
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),
                                    TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      validator: (value) {
                                        String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                            "\\@" +
                                            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                            "(" +
                                            "\\." +
                                            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                            ")+";
                                        RegExp regExp = RegExp(p);
                                        if (value != null &&
                                            value.isNotEmpty &&
                                            regExp.hasMatch(value)) {
                                          return null;
                                        } else {
                                          return "Enter Valid email";
                                        }
                                      },
                                      keyboardType:
                                          TextInputType.emailAddress,
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide( color: Colors.white.withOpacity(0.8),),
                                            borderRadius: BorderRadius.circular(10)),

                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide( color: Colors.white.withOpacity(0.8),),
                                            borderRadius: BorderRadius.circular(10)),
                                        hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                        contentPadding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),
                                        hintText:
                                            '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[1].name : 'Enter your email'}',
                                        // prefixIcon:
                                        //     Icon(Icons.email_outlined),

                                      ),
                                    ),

                                    SizedBox(
                                      height:9,
                                    ),
                                    Text("Password",
                                      style: TextStyle(
                                      color:  Colors.white,
                                        fontWeight: FontWeight.w600,

                                      ),
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),
                                    TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      validator: (value) {
                                        if (value != null &&
                                            value.length < 6) {
                                          return " Too Short Password";
                                        }
                                        return null;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: _passwordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: isObscure,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide( color: Colors.white.withOpacity(0.8),),
                                            borderRadius: BorderRadius.circular(10)),

                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide( color: Colors.white.withOpacity(0.8),),
                                            borderRadius: BorderRadius.circular(10)),
                                        hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                        ),

                                        suffix: InkWell(
                                          onTap: () => setState(() {
                                            isObscure = !isObscure;
                                          }),
                                          child: Icon(
                                            Icons.remove_red_eye_rounded,
                                            color: isObscure
                                                ? Colors.grey
                                                : CustomTheme.appTheme,
                                          ),
                                        ),
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(color: Colors.grey)),
                                        contentPadding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),
                                        hintText:
                                            '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[2].name : "Password"}',
                                        // prefixIcon: Icon(Icons.lock_outline),
                                      ),
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.045,
                                    ),
                                    Container(
                                      width: _mainWidth,
                                      height: _mainHeight * 0.05,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                            )),
                                        onPressed: () async {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          if (_formKey.currentState != null &&
                                              _formKey.currentState!.validate()) {
                                            RMSWidgets.showLoaderDialog(
                                                context: context,
                                                message: 'Please wait');
                                            final LoginResponseModel response =
                                                await _loginViewModel
                                                    .getLoginDetails(
                                                        email:
                                                            _emailController.text,
                                                        password:
                                                            _passwordController
                                                                .text);
                                            Navigator.pop(context);
                                            if (response.msg?.toLowerCase() !=
                                                    'failure' &&
                                                response.data != null) {
                                              await setSPValues(
                                                  response: response);

                                              String? fcmToken =
                                                  await messaging.getToken();
                                              if (fcmToken != null) {
                                                await _loginViewModel
                                                    .updateFCMToken(
                                                        fcmToken: fcmToken);
                                              }
                                              if (widget.fromExternalLink &&
                                                  widget.onClick != null) {
                                                widget.onClick!();
                                              } else {
                                                Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  AppRoutes.dashboardPage,
                                                  (route) => false,
                                                );
                                              }
                                            }
                                          }
                                          //
                                        },
                                        child: Center(
                                            child: Text(
                                                '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[3].name : "LOGIN"}',
                                              style: TextStyle(
                                                color: CustomTheme.appThemeContrast,
                                                fontWeight: FontWeight.bold
                                              ),

                                            ),

                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.015,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                          onTap: () => showForgotPasswordDialog(
                                              context: context, value: value),
                                          child: Text(
                                            '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[4].name : 'Forgot Password'} ?',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.045,
                                    ),

                                    Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            //flex:2,
                                            child: Divider(
                                              color: Colors.white.withOpacity(0.7),
                                              thickness: 1.6,
                                            )),
                                        SizedBox(width: 10,),
                                      Text(
                                            '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[5].name : 'Or'}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white.withOpacity(0.7),

                                                fontWeight: FontWeight.w400),
                                          ),

                                        SizedBox(width: 10,),
                                        Expanded(
                                            // flex:2,
                                            child: Divider(
                                              color: Colors.white.withOpacity(0.7),

                                              thickness: 1.6,
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        GestureDetector(
                                          onTap: () => _showBottomSheet(context),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10,
                                                top: 10,bottom: 10
                                            ),
                                            decoration: BoxDecoration(
                                                color:
                                                Colors.white.withOpacity(0.1),
                                                border: Border.all(
                                                    color:
                                                    Colors.white.withOpacity(0.1),),
                                                borderRadius:
                                                BorderRadius.circular(7)),
                                            child: Icon(
                                              Icons.mobile_friendly,
                                              color: CustomTheme.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 30,),
                                        Visibility(
                                          visible: Platform.isAndroid,
                                          child: GestureDetector(
                                            onTap: () async {
                                              RMSWidgets.showLoaderDialog(
                                                  context: context,
                                                  message: 'Please wait...');
                                              final data = await GoogleAuthService
                                                  .loginIn();

                                              if (data != null) {
                                                final LoginResponseModel
                                                    response =
                                                    await _loginViewModel
                                                        .registerUserAfterGmail(
                                                            model:
                                                                GmailSignInRequestModel(
                                                  name: data.displayName,
                                                  email: data.email,
                                                  id: data.id,
                                                  picture: data.photoUrl,
                                                ));

                                                Navigator.of(context).pop();
                                                if (response.msg?.toLowerCase() !=
                                                    'failure') {
                                                  if (response.data != null &&
                                                      response.data?.contactNum !=
                                                          null &&
                                                      response.data?.contactNum ==
                                                          '') {
                                                    SharedPreferenceUtil shared =
                                                        SharedPreferenceUtil();
                                                    await shared.setString(
                                                        rms_registeredUserToken,
                                                        '${response.data?.appToken}');
                                                    await shared.setString(
                                                        rms_gmapKey,
                                                        '${response.data?.gmapKey}');
                                                    await shared.setString(
                                                        rms_userId,
                                                        '${response.data?.id}');

                                                    Navigator.of(context).pushNamed(
                                                        AppRoutes
                                                            .firebaseRegistrationPage,
                                                        arguments: {
                                                          'gmailData': data,
                                                          'from': 'Gmail',
                                                          'fromExternalLink': widget
                                                              .fromExternalLink,
                                                          'onClick':
                                                              widget.onClick
                                                        });
                                                  } else {
                                                    await setSPValues(
                                                        response: response);
                                                    String? fcmToken =
                                                        await messaging
                                                            .getToken();
                                                    if (fcmToken != null) {
                                                      await _loginViewModel
                                                          .updateFCMToken(
                                                              fcmToken: fcmToken);
                                                    }
                                                    if (widget.fromExternalLink &&
                                                        widget.onClick != null) {
                                                      widget.onClick!();
                                                    } else {
                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                        context,
                                                        AppRoutes.dashboardPage,
                                                        (route) => false,
                                                      );
                                                    }
                                                  }
                                                }
                                              } else {
                                                log('Gmail SignIn Failed');
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Container(
                                              // height: 40,
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10,
                                              top: 10,bottom: 10
                                              ),
                                              decoration: BoxDecoration(
                                                  color:
                                                  Colors.white.withOpacity(0.1),
                                                  border: Border.all(
                                                      color:
                                                      Colors.white.withOpacity(0.1),),
                                                  borderRadius:
                                                      BorderRadius.circular(7)),

                                              child: Icon(
                                                Icons.mail,
                                                color: CustomTheme.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(AppRoutes.registrationPage,
                                              arguments: {
                                            'fromExternalLink':
                                                widget.fromExternalLink,
                                            'onClick': widget.onClick
                                          }),
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 35),


                                        child: Center(
                                          child: RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[8].name : "Don't have an account"} ? ',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400
                                                  )),
                                              TextSpan(
                                                  text:
                                                      '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[9].name : 'Sign Up'}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,

                                                    color: CustomTheme
                                                        .white,
                                                  )),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Spacer(),
                                    // GestureDetector(
                                    //   onTap: () => _handleURLButtonPress(context,
                                    //       privacy_policy, 'Privacy Policy'),
                                    //   child: Container(
                                    //     // color: Colors.white,
                                    //     margin: EdgeInsets.only(bottom: 10),
                                    //     alignment: Alignment.bottomLeft,
                                    //     child: RichText(
                                    //       text: TextSpan(children: [
                                    //         TextSpan(
                                    //             text:
                                    //                 '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[10].name : "By Signing in, you are agree to our "} ',
                                    //             style: TextStyle(
                                    //                 color: Colors.black,
                                    //                 fontSize: 12)),
                                    //         TextSpan(
                                    //             text:
                                    //                 '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[11].name : "Privacy Policy"}',
                                    //             style: TextStyle(
                                    //               fontSize: 16,
                                    //               color: CustomTheme.appTheme,
                                    //               fontStyle: FontStyle.italic,
                                    //               fontWeight: FontWeight.w600,
                                    //             )),
                                    //       ]),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : RMSWidgets.networkErrorPage(context: context);
  }

  Future<void> setSPValues({required LoginResponseModel response}) async {
    SharedPreferenceUtil shared = SharedPreferenceUtil();
    await shared.setString(
        rms_registeredUserToken, '${response.data?.appToken}');
    await shared.setString(rms_profilePicUrl, '${response.data?.pic}');
    await shared.setString(rms_phoneNumber, '${response.data?.contactNum}');
    await shared.setString(rms_name, '${response.data?.name}');
    await shared.setString(rms_email, '${response.data?.email}');
    await shared.setString(rms_gmapKey, '${response.data?.gmapKey}');
    await shared.setString(rms_userId, '${response.data?.id}');
  }

  void showForgotPasswordDialog(
      {required BuildContext context, required LoginViewModel value}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              '${nullCheck(list: value.loginLang) ? value.loginLang[4].name : 'Forgot Password'} ?',
              style: TextStyle(
                  color: CustomTheme.appThemeContrast,
                  fontWeight: FontWeight.w600,
                  fontSize: getHeight(context: context, height: 20)),
            ),
            content: Container(
              height: _mainHeight * 0.13,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
                      '${nullCheck(list: value.loginLang) ? value.loginLang[24].name : 'Please enter your Email ID to get Password Link'} !'),
                  SizedBox(
                    height: _mainHeight * 0.035,
                  ),
                  Neumorphic(
                    style: NeumorphicStyle(
                        depth: -2,
                        color: Colors.white,
                        lightSource: LightSource.bottomLeft),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value != null && value.length < 6) {
                          return "Enter proper email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: _resetEmailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            '${nullCheck(list: value.loginLang) ? value.loginLang[1].name : 'Enter your email address'}',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          size: _mainHeight * 0.02,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            elevation: 5,
            actions: [
              Container(
                padding: EdgeInsets.only(bottom: _mainHeight * 0.015),
                width: _mainWidth * 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    side: BorderSide(
                      width: 1.0,
                      color: CustomTheme.appThemeContrast,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    RMSWidgets.showLoaderDialog(
                        context: context, message: 'Please wait...');
                    final int response = await _loginViewModel.resetPassword(
                        email: _resetEmailController.text);
                    Navigator.pop(context);

                    if (response == 200) {
                      RMSWidgets.getToast(
                          message:
                              'An Email with instructions for resetting the password is sent to your email id.',
                          color: CustomTheme.myFavColor);
                      _resetEmailController.clear();
                      Navigator.pop(context);
                    } else {
                      RMSWidgets.getToast(
                          message: 'Something Went Wrong!',
                          color: CustomTheme.appThemeContrast);
                    }
                  },
                  child: Text(
                    '${nullCheck(list: value.loginLang) ? value.loginLang[25].name : 'Recover'}',
                    style: TextStyle(
                        fontSize: getHeight(context: context, height: 14),
                        color: CustomTheme.black),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: CustomTheme.appTheme.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(Images.mobSignIn),
                    ),
                    Text(
                      '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[16].name : 'Registration or Login'}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[17].name : "Add your phone number. we'll send you a verification code so we know you're real"}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: CustomTheme.appTheme.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              controller: mob_controller,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[13].name : "Enter your password"}',
                                hintStyle:
                                    TextStyle(color: Colors.blueGrey.shade200),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10)),
                                prefix: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '(+91)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 22,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (mob_controller.text.isNotEmpty &&
                                    mob_controller.text.length == 10) {
                                  Navigator.of(context).pushNamed(
                                      AppRoutes.otpVerifyPage,
                                      arguments: {
                                        'mobile': mob_controller.text,
                                        'fromExternalLink':
                                            widget.fromExternalLink,
                                        'onClick': widget.onClick
                                      });
                                } else {
                                  RMSWidgets.getToast(
                                      message:
                                          "Please Enter valid Mobile Number",
                                      color: CustomTheme().colorError);
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        CustomTheme.appTheme),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'Send OTP',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

void _handleURLButtonPress(BuildContext context, String url, String title) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Web_View_Container(url, title)),
  );
}
