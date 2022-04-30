import 'dart:developer';
import 'dart:ui';

import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/login_module/service/google_auth_service.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:provider/provider.dart';
import '../../Web_View_Container.dart';
import '../../utils/color.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../model/gmail_signin_request_model.dart';
import '../model/login_response_model.dart';
import '../model/signup_response_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mob_controller = TextEditingController();
  final privacy_policy =
      "https://www.rentmystay.com/info/privacy-policy/123456";
  late ThemeData theme;
  late LoginViewModel _loginViewModel;
  final _emailController = TextEditingController();
  final _resetEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _mainHeight;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _mainWidth;

  @override
  void initState() {
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    super.initState();
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            color: CustomTheme.appTheme,
            height: _mainHeight,
            width: _mainWidth,
            //padding: EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: SizedBox(
                    height: _mainHeight * 0.3,
                    child: Image.asset(
                      'assets/images/transparent_logo_rms.png',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 5,left: 15),
                  margin: EdgeInsets.only(right: 20),
                  alignment: Alignment.centerLeft,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText('Welcome Back !',
                          textStyle: TextStyle(
                              fontSize: 25, fontFamily: "HKGrotest-Light"),
                          colors: [
                            Colors.white,
                            CustomTheme.appTheme,
                          ]),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    width: _mainWidth,
                    height: _mainHeight * 0.6,
                     padding: EdgeInsets.only(left: 15,top: 25,right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          //margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              depth: -3,
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value != null && value.length < 6) {
                                  return "Enter proper email";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              depth: -3,
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value != null && value.length < 6) {
                                  return " Too Short Password";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: _mainWidth,
                          height: 45,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        CustomTheme.appTheme),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(40)),
                                )),
                            onPressed: () async {
                              FocusScope.of(context)
                                  .requestFocus(FocusNode());
                              if (_formKey.currentState != null &&
                                  !_formKey.currentState!.validate()) {}
                              if (_emailController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'Please Enter E-mail Address',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER);
                              } else {
                                if (_passwordController.text.isEmpty) {
                                  RMSWidgets.getToast(
                                      message: 'Please Enter Password',
                                      color: CustomTheme().colorError);
                                } else {
                                  RMSWidgets.showLoaderDialog(
                                      context: context,
                                      message: 'Please wait...');
                                  final LoginResponseModel response =
                                      await _loginViewModel.getLoginDetails(
                                          email: _emailController.text,
                                          password: _passwordController.text);
                                  Navigator.pop(context);
                                  if (response.msg?.toLowerCase() !=
                                          'failure' &&
                                      response.data != null) {
                                    await setSPValues(response: response);

                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.dashboardPage,
                                      (route) => false,
                                    );
                                  }
                                }
                                //
                              }
                            },
                            child: Center(child: Text("LOGIN")),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: ()=>showForgotPasswordDialog(context: context),
                              child: Text('Forgot Password',style: TextStyle(
                                fontSize: 14,
                                color: CustomTheme.appThemeContrast,
                                fontWeight: FontWeight.w600
                              ),)),
                        ),

                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Or',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: ()=>_showBottomSheet(context),
                          child: Container(
                            height: 45,
                            width: 170,
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: CustomTheme.appTheme),
                                  borderRadius: BorderRadius.circular(40)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.mobile_friendly,color: CustomTheme.appTheme,),
                                SizedBox(width: 10,),
                                Text('SignIn with OTP',style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                                ),),
                              ],
                            ),
                          ),
                        ),
                      /*  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: _mainWidth * 0.4,
                                height: 45,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              CustomTheme.appTheme),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                      )),
                                  onPressed: () async {
                                    _showBottomSheet(context);
                                    *//*  Navigator.of(context)
                                        .pushNamed(AppRoutes.mob_register_login);*//*
                                  },
                                  child: Text(
                                    'SignIn With OTP',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          *//*  Expanded(
                              child: Container(
                                width: _mainWidth * 0.4,
                                height: 35,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              CustomTheme.appTheme),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                      )),
                                  onPressed: () async {
                                    RMSWidgets.showLoaderDialog(
                                        context: context,
                                        message: 'Please wait...');
                                    final data =
                                        await GoogleAuthService.loginIn();

                                    if (data != null) {
                                      final LoginResponseModel response =
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
                                            response.data?.contactNum == '') {
                                          SharedPreferenceUtil shared =
                                              SharedPreferenceUtil();
                                          await shared.setString(
                                              rms_registeredUserToken,
                                              '${response.data?.appToken}');
                                          await shared.setString(rms_gmapKey,
                                              '${response.data?.gmapKey}');
                                          await shared.setString(rms_userId,
                                              '${response.data?.id}');
                                          Navigator.of(context).pushNamed(
                                              AppRoutes
                                                  .firebaseRegistrationPage,
                                              arguments: {
                                                'gmailData': data,
                                                'from': 'Gmail',
                                              });
                                        } else {
                                          await setSPValues(
                                              response: response);
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            AppRoutes.dashboardPage,
                                            (route) => false,
                                          );
                                        }
                                      }
                                    } else {
                                      log('Gmail SignIn Failed');
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        'SignIn With Gmail',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),*//*
                          ],
                        ),*/
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed(AppRoutes.registrationPage),
                          child: Container(
                            color: Colors.white,
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Don't have an account ? ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "HKGrotest-Light")),
                                TextSpan(
                                    text: "Register",
                                    style: TextStyle(
                                        color: orangeColors,
                                        fontFamily: "HKGrotest-Light")),
                              ]),
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () => _handleURLButtonPress(
                              context, privacy_policy, 'Privacy Policy'),
                          child: Container(
                            // color: Colors.white,
                            margin: EdgeInsets.only(bottom: 10),
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text:
                                        "By Signing in, you are agree to our ",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12)),
                                TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: CustomTheme.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  void showForgotPasswordDialog({required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'Forgot Password ?',
              style: TextStyle(
                  color: CustomTheme.appThemeContrast,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            content: Container(
              height: _mainHeight * 0.13,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text('Please Enter Email to get Password Reset Link !'),
                  SizedBox(
                    height: 10,
                  ),
                  Neumorphic(
                    style: NeumorphicStyle(
                        depth: -2,
                        color: Colors.white,
                        lightSource: LightSource.bottomLeft),
                    child: TextFormField(
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
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            elevation: 5,
            actions: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                width: _mainWidth * 0.4,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(CustomTheme.appThemeContrast),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                      )),
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
                          color: myFavColor);
                      _resetEmailController.clear();
                      Navigator.pop(context);
                    } else {
                      RMSWidgets.getToast(
                          message: 'Something Went Wrong!',
                          color: CustomTheme.appThemeContrast);
                    }
                  },
                  child: Text(
                    'Recover',
                    style: TextStyle(
                      fontSize: 14,
                    ),
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
        builder: (BuildContext buildContext) {
          return Container(
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Padding(
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
                        'Registration or Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Add your phone number. we'll send you a verification code so we know you're real",
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
                      Container(
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
                                hintText: "Mobile Number",
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
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (mob_controller.text.isNotEmpty &&
                                      mob_controller.text.length == 10) {
                                    Navigator.of(context).pushNamed(
                                        AppRoutes.otpVerifyPage,
                                        arguments: {
                                          'mobile': mob_controller.text
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
                                    'Send',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
