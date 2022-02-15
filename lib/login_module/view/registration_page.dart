import 'dart:ui';

import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
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

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late LoginViewModel _loginViewModel;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _referalController = TextEditingController();
  var _mainHeight;
  var _mainWidth;
  String typeValue = 'I am';
  String selectedCity = 'Select City';
  String rmsWay = 'How do you Know RMS';

  @override
  void initState() {
    //_loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
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
                    ColorizeAnimatedText('You are Almost there!',
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
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: _textInput(
                          hint: "Name",
                          icon: Icons.person,
                          controller: _nameController),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    _textInput(
                        hint: "Email",
                        icon: Icons.email,
                        controller: _emailController),
                    SizedBox(
                      height: 5,
                    ),
                    _textInput(
                        hint: "Phone Number",
                        icon: Icons.contact_page,
                        controller: _phoneNumberController),
                    SizedBox(
                      height: 5,
                    ),
                    _textInput(
                        hint: "Password",
                        icon: Icons.vpn_key,
                        controller: _passwordController),
                    SizedBox(
                      height: 5,
                    ),
                    _textInput(
                        hint: "Apply Referal Code (Optional)",
                        icon: Icons.ac_unit,
                        controller: _referalController),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      width: _mainWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: getTypeList
                              .map((type) => DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(type),
                                    ),
                                    value: type,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              typeValue = value.toString();
                            });
                          },
                          value: typeValue,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 40,
                      width: _mainWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: getCityList
                              .map((type) => DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(type),
                                    ),
                                    value: type,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCity = value.toString();
                            });
                          },
                          value: selectedCity,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 40,
                      width: _mainWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: getRMSList
                              .map((type) => DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(type),
                                    ),
                                    value: type,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              rmsWay = value.toString();
                            });
                          },
                          value: rmsWay,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: _mainWidth,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                CustomTheme.skyBlue),
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
                          if (response != null && response.status == 'success') {
                            Navigator.of(context).pushNamed(AppRoutes.homePage);
                          }
                        },
                        child: Center(child: Text("REGISTER")),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
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

  List<String> get getTypeList => [
        'I am',
        'Tenants',
        'Owner',
      ];

  List<String> get getCityList => [
        'Select City',
        'Bangalore',
        'Chennai',
        'Pune',
        'Hyderabad',
        'Goa',
        'Coorg',
        'Kodikanal',
        'New Delhi',
        'Jaipur',
        'Ahmedabad',
        'Noida',
        'Gurugram',
        'Dehradun',
        'Kochi',
        'Vishakhapatan',
        'Mysore',
        'Others',
      ];

  List<String> get getRMSList => [
        'How do you Know RMS',
        'Search Engine',
        'Social Media',
        'Online Ads',
        'Referred By Friend',
        'PlayStore',
        'Rental Portals',
        'Other Realestate',
      ];
}
