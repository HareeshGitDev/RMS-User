import 'dart:ui';

import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/login_module/model/gmail_signin_request_model.dart';
import 'package:RentMyStay_user/login_module/model/signup_request_model.dart';
import 'package:RentMyStay_user/login_module/service/google_auth_service.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../utils/color.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../model/gmail_registration_request_model.dart';
import '../model/login_response_model.dart';
import '../model/signup_response_model.dart';

class GmailRegistrationPage extends StatefulWidget {
  GoogleSignInAccount googleData;

  GmailRegistrationPage({Key? key, required this.googleData})
      : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<GmailRegistrationPage> {
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
  String sourceRMS = 'How do you Know RMS';
  bool fromOTP = false;

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
      body: GestureDetector(
        onTap:()=> FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          color: CustomTheme.skyBlue,
          height: _mainHeight,
          width: _mainWidth,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: SizedBox(
                    height: _mainHeight * 0.3,
                    child: Image.asset(
                      Images.brandLogo_Transparent,
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
                  height: _mainHeight * 0.654,
                  width: _mainWidth,
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),

                      Center(
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget.googleData.photoUrl.toString(),
                            ),
                            maxRadius: 30),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text('${widget.googleData.email}',style: TextStyle(
                            color: Colors.black.withGreen(70),
                            fontWeight: FontWeight.w700,
                            fontSize: 22
                        ),),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Hello ${widget.googleData.displayName},Gmail Verification is done.Now Please enter few more mandatory details to complete your registration .',style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      ),),
                      SizedBox(
                        height: 40,
                      ),
                      Visibility(
                        visible: fromOTP,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: _textInput(
                              hint: "Name",
                              icon: Icons.person,
                              controller: _nameController),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _textInput(
                          hint: "Phone Number",
                          icon: Icons.contact_page,
                          controller: _phoneNumberController),
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
                      SizedBox(height: 10),
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
                      SizedBox(height: 10),
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
                                sourceRMS = value.toString();
                              });
                            },
                            value: sourceRMS,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () async{
                            await GoogleAuthService.logOut();
                            Navigator.pop(context);
                          },
                          //child: Container(child: Text('Click me'),height: 40,color: Colors.white,)
                      ),
                      Container(
                        width: _mainWidth,
                        height: 50,
                        margin: EdgeInsets.only(bottom: 15),
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

                             /*if (_emailController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please Enter E-mail Address',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                            } else*/ if (_phoneNumberController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please Enter Your Mobile Number',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                            } else if (typeValue.isEmpty || typeValue == 'I am') {
                              Fluttertoast.showToast(
                                  msg: 'Please Select All Field',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                            } else if (selectedCity.isEmpty ||
                                selectedCity == 'Select City') {
                              Fluttertoast.showToast(
                                  msg: 'Please Select City',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                            } else if (sourceRMS.isEmpty ||
                                sourceRMS == 'How do you Know RMS') {
                              Fluttertoast.showToast(
                                  msg: 'Please Select Source',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                            } else {
                              RMSWidgets.showLoaderDialog(
                                  context: context, message: 'Please wait...');
                              SharedPreferenceUtil shared=SharedPreferenceUtil();
                              final int response =
                                  await _loginViewModel.detailsValidationAfterGmail(model:GmailRegistrationRequestModel(
                                    city: selectedCity,
                                    iam: typeValue,
                                    mobileNo: _phoneNumberController.text,
                                    sourceRms: sourceRMS,
                                    appToken: await shared.getString(rms_registeredUserToken),

                                  ) );
                              Navigator.of(context).pop();

                              if (response ==200) {
                                await setSPValues();
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.homePage);
                              } else {
                                RMSWidgets.getToast(
                                    message: 'Something went wrong...',
                                    color: CustomTheme().colorError);
                              }
                            }
                          },
                          child: Center(child: Text("REGISTER")),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
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

  Future<void> setSPValues() async {
    SharedPreferenceUtil shared = SharedPreferenceUtil();
    await shared.setString(
        rms_registeredUserToken,(await shared.getString(rms_registeredUserToken)).toString());
    await shared.setString(rms_profilePicUrl, widget.googleData.photoUrl.toString());
    await shared.setString(rms_phoneNumber, _phoneNumberController.text);
    await shared.setString(rms_name, widget.googleData.displayName.toString());
    await shared.setString(rms_email, widget.googleData.email);
    await shared.setString(rms_gmapKey, (await shared.getString(rms_gmapKey)).toString());
  }
}
