import 'dart:ui';

import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../utils/color.dart';
import '../model/login_response_model.dart';
import 'btn_widget.dart';
import 'herder_container.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginViewModel _loginViewModel;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _mainHeight;
  var _mainWidth;

  @override
  void initState() {
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: loginPageThemeColors,
        height: _mainHeight,
        width: _mainWidth,
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              height: _mainHeight * 0.7,
              width: _mainWidth,
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText('Welcome Back !',
                          textStyle:
                              TextStyle(fontSize: 40, fontFamily: "Nunito"),
                          colors: [
                            Colors.black,
                            Color(0xff7AB02A),
                            Colors.black,
                            Color(0xff7AB02A)
                          ]),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: _textInput(
                        hint: "Email",
                        icon: Icons.email,
                        controller: _emailController),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _textInput(
                      hint: "Password",
                      icon: Icons.vpn_key,
                      controller: _passwordController),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: _mainWidth,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              loginPageThemeColors),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                          )),
                      onPressed: () async {
                        final LoginResponseModel? response =
                            await _loginViewModel.getLoginDetails(
                                email: _emailController.text,
                                password: _passwordController.text);
                        if (response != null &&
                            response.status?.toLowerCase() == 'success') {
                          Navigator.of(context).pushNamed(AppRoutes.homePage);
                        }
                      },
                      child: Center(child: Text("LOGIN")),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: NeumorphicButton(
                      onPressed: () {},
                      curve: Neumorphic.DEFAULT_CURVE,
                      style: NeumorphicStyle(
                        border: NeumorphicBorder.none(),
                        lightSource: LightSource.bottom,
                        color: Colors.white,
                      ),
                      child: Text(
                        "Forgot Password?",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Or Login With',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: _mainWidth * 0.4,
                          height: 40,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        loginPageThemeColors),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                )),
                            onPressed: () async {},
                            child: Text(
                              'SignIn With OTP',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          width: _mainWidth * 0.4,
                          height: 40,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        loginPageThemeColors),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                )),
                            onPressed: () async {},
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/google-plus.svg',
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      'SignIn',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                                  color: Colors.black, fontFamily: "Nunito")),
                          TextSpan(
                              text: "Register",
                              style: TextStyle(
                                  color: orangeColors, fontFamily: "Nunito")),
                        ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 65,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "By Signing in, you are agree to our ",
                            style: TextStyle(
                                color: Colors.black, fontFamily: "Nunito")),
                        TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                                color: myFavColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Nunito")),
                      ]),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textInput(
      {required TextEditingController controller,
      required String hint,
      required IconData icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: -10,
          color: Colors.white,
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: Icon(icon),
          ),
        ),
      ),
    );
  }
}
