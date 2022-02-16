import 'dart:ui';

import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey();
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
      body: Form(
        key: _formKey,
        child: Container(
          color: CustomTheme.skyBlue,
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
                padding: EdgeInsets.only(bottom: 5),
                margin: EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText('Welcome Back !',
                        textStyle:
                            TextStyle(fontSize: 30, fontFamily: "Nunito"),
                        colors: [
                          Colors.white,
                          CustomTheme.skyBlue,
                        ]),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                ),
              ),
              Expanded(
                child: Container(

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30))),
                  
                  width: _mainWidth,
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 35),
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
                              prefixIcon: Icon(Icons.email),
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
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -10,
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
                              prefixIcon: Icon(Icons.password),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: _mainWidth,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  CustomTheme.skyBlue),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                              )),
                          onPressed: () async {
                            if (_formKey.currentState != null &&
                                !_formKey.currentState!.validate()) {}
                            if (_emailController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please Enter E-mail Address',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                            } else {
                              if (_passwordController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'Please Enter Password',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER);
                              } else {
                                final LoginResponseModel? response =
                                    await _loginViewModel.getLoginDetails(
                                        email: _emailController.text,
                                        password: _passwordController.text);
                                if (response != null &&
                                    response.status?.toLowerCase() ==
                                        'success') {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.homePage);
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
                      GestureDetector(

                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoutes.homePage),
                        child: Container(
                          color: Colors.white,
                          alignment: Alignment.centerLeft,
                          child: Text('Forgot Password?'),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Or Login With',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
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
                                            CustomTheme.skyBlue),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
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
                                            CustomTheme.skyBlue),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                    )),
                                onPressed: () async {},
                                child: Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
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
                                      color: Colors.black,
                                      fontFamily: "Nunito")),
                              TextSpan(
                                  text: "Register",
                                  style: TextStyle(
                                      color: orangeColors,
                                      fontFamily: "Nunito")),
                            ]),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed(AppRoutes.propertyListingPage),
                        child: Container(
                          color: Colors.white,
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
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
