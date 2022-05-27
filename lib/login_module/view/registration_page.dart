import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/login_module/model/signup_request_model.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';

import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../theme/custom_theme.dart';
import '../../utils/color.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../model/login_response_model.dart';
import '../model/signup_response_model.dart';

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
  String sourceRMS = 'How do you Know RMS';
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
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);


  }


  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus?Scaffold(
      body: Container(

        color: CustomTheme.appTheme,
        height: _mainHeight,
        width: _mainWidth,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: SizedBox(
                  height: _mainHeight * 0.26,
                  child: Image.asset(Images.brandLogo_Transparent,
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
                            TextStyle(fontSize: 25, fontFamily: "HKGrotest-Light"),
                        colors: [
                          Colors.white,
                          CustomTheme.appTheme,
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
                height: _mainHeight * 0.705,
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
                          icon: Icons.person_outline,
                          controller: _nameController),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    _textInput(
                        hint: "Email",
                        icon: Icons.email_outlined,

                        controller: _emailController),
                    SizedBox(
                      height: 5,
                    ),
                    _textInput(
                        hint: "Phone Number",
                        icon: Icons.phone_android_outlined,
                        controller: _phoneNumberController),
                    SizedBox(
                      height: 5,
                    ),
                    _textInput(
                        hint: "Password",
                        icon: Icons.vpn_key_outlined,
                        controller: _passwordController),
                    SizedBox(
                      height: 5,
                    ),
                    _textInput(
                        hint: "Apply Referal Code (Optional)",
                        icon: Icons.ac_unit_outlined,
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

                        child:
                        DropdownButton(

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
                    Container(
                      width: _mainWidth,
                      height: 50,
                      margin: EdgeInsets.only(bottom: 15),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                CustomTheme.appTheme),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                            )),
                        onPressed: () async {

                        if (_nameController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please Enter Enter Your Name',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER);
                        }
                        else if(_emailController.text.isEmpty)
                          {
                            Fluttertoast.showToast(
                            msg: 'Please Enter E-mail Address',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER);
                          }
                        else if(_phoneNumberController.text.isEmpty)
                          {
                            Fluttertoast.showToast(
                                msg: 'Please Enter Your Mobile Number',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER);
                          }
                        else if(_passwordController.text.isEmpty)
                        {
                          Fluttertoast.showToast(
                              msg: 'Please Enter Your Password',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER);
                        }
                        else if(typeValue.isEmpty||typeValue=='I am')
                        {
                          Fluttertoast.showToast(
                              msg: 'Please Select All Field',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER);
                        }
                        else if(selectedCity.isEmpty || selectedCity =='Select City')
                        {
                          Fluttertoast.showToast(
                              msg: 'Please Select City',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER);
                        }
                        else if(sourceRMS.isEmpty || sourceRMS == 'How do you Know RMS')
                        {
                          Fluttertoast.showToast(
                              msg: 'Please Select Source',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER);
                        }
                        else {
                          RMSWidgets.showLoaderDialog(
                              context: context, message: 'Please wait...');
                          final SignUpResponseModel response =
                              await _loginViewModel.signUpUser(
                                  signUpRequestModel: SignUpRequestModel(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      phonenumber:
                                          _phoneNumberController.text,
                                      sourceRms: sourceRMS,
                                      referal: _referalController.text,
                                      iam: typeValue,
                                      city: selectedCity,
                                      fname: _nameController.text,
                                       ));
                          Navigator.of(context).pop();

                          if (response.msg?.toLowerCase() != 'failure') {
                            await setSPValues(response: response);
                            RMSWidgets.getToast(
                                message:'You have been Successfully registered',
                                color: myFavColor);
                            Navigator.pushNamedAndRemoveUntil(
                              context,AppRoutes.dashboardPage,(route) => false,);
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
    ):RMSWidgets.networkErrorPage(context: context);
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
          depth: -2,
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

  Future<void> setSPValues({required SignUpResponseModel response}) async {
    SharedPreferenceUtil shared = SharedPreferenceUtil();
    await shared.setString(
        rms_registeredUserToken, '${response.data?.appToken}');
    await shared.setString(rms_profilePicUrl, '${response.data?.pic}');
    await shared.setString(rms_phoneNumber, '${response.data?.contactNum}');
    await shared.setString(rms_name,  '${response.data?.name}');
    await shared.setString(rms_email,  '${response.data?.email}');
    await shared.setString(rms_gmapKey,  '${response.data?.gmapKey}');
    await shared.setString(rms_userId,  '${response.data?.id}');

  }
}
