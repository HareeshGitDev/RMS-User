import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../images.dart';
import '../../utils/color.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  var _mainHeight;
  var _mainWidth;
  final _emailController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
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
                  ColorizeAnimatedText('Forgot Password ?',
                      textStyle: TextStyle(fontSize: 30, fontFamily: "Nunito"),
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
                          lightSource: LightSource.bottomLeft
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
                      height: _mainHeight*0.05,
                    ),
                    Container(
                      width: _mainWidth,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                CustomTheme.peach),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                            )),
                        onPressed: () async {},
                        child: Center(child: Text("Recover")),
                      ),
                    ),
                    SizedBox(
                      height: _mainHeight*0.05,
                    ),
                    Container(
                        color: Colors.yellow,
                        child: Image.asset(Images.resetPasswordIcon,height: _mainHeight*0.25,width: _mainWidth,)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
