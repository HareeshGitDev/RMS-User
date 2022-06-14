import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/login_module/model/gmail_signin_request_model.dart';
import 'package:RentMyStay_user/login_module/model/signup_request_model.dart';
import 'package:RentMyStay_user/login_module/service/google_auth_service.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';

import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../model/gmail_registration_request_model.dart';
import '../model/login_response_model.dart';
import '../model/signup_response_model.dart';

class FirebaseRegistrationPage extends StatefulWidget {
  GoogleSignInAccount? googleData;
  String from;
  String? uid;
  String? mobile;
  final bool fromExternalLink;
  Function? onClick;

  FirebaseRegistrationPage(
      {Key? key,
      this.googleData,
      required this.from,
      this.uid,
      this.mobile,
      this.onClick,
      required this.fromExternalLink})
      : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<FirebaseRegistrationPage> {
  late LoginViewModel _loginViewModel;
  final _emailController = TextEditingController();
  late FirebaseMessaging messaging = FirebaseMessaging.instance;
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
            body: Consumer<LoginViewModel>(
              builder: (context, value, child) {
                return GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Container(
                    color: CustomTheme.appTheme,
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
                                ColorizeAnimatedText('${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[23].name :'You are Almost there'} ! ',
                                    textStyle: TextStyle(
                                      fontSize: _mainWidth*0.05,
                                    ),
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
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30))),
                            height: _mainHeight * 0.654,
                            width: _mainWidth,
                            padding: EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Visibility(
                                  visible: widget.from == 'Gmail',
                                  child: Container(
                                    height: _mainHeight * 0.2,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                widget.googleData?.photoUrl ?? " ",
                                              ),
                                              maxRadius: 30),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Text(
                                            '${widget.googleData?.email}',
                                            style: TextStyle(
                                                color: Colors.black.withGreen(70),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 22),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Hello ${widget.googleData?.displayName},Gmail Verification is done.Now Please enter few more mandatory details to complete your registration .',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: widget.from == 'OTP',
                                  child: SizedBox(
                                    height: 40,
                                  ),
                                ),
                                Visibility(
                                  visible: widget.from == 'OTP',
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                        color: Colors.white,
                                      ),
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          depth: -2,
                                          color: Colors.white,
                                        ),
                                        child: TextFormField(
                                          controller: _nameController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[12].name :"Name"}',
                                            prefixIcon: Icon(Icons.person),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Visibility(
                                    visible: widget.from == 'Gmail',
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                        color: Colors.white,
                                      ),
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          depth: -2,
                                          color: Colors.white,
                                        ),
                                        child: TextFormField(
                                          controller: _phoneNumberController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:  '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[13].name :"Phone Number"}',
                                            prefixIcon: Icon(Icons.contact_page),
                                          ),
                                        ),
                                      ),
                                    )),
                                Visibility(
                                  visible: widget.from == 'Gmail',
                                  child: SizedBox(
                                    height: 10,
                                  ),
                                ),
                                Visibility(
                                  visible: widget.from == 'OTP',
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 0),
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
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
                                          hintText:'${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[1].name :"Email"}',
                                          prefixIcon: Icon(Icons.email_outlined),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 40,
                                  width: _mainWidth,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      items: getTypeList
                                          .map((type) => DropdownMenuItem(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(10.0),
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
                                    border:
                                    Border.all(color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      items: getCityList
                                          .map((type) => DropdownMenuItem(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(10.0),
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
                                    border:
                                    Border.all(color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      items: getRMSList
                                          .map((type) => DropdownMenuItem(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(10.0),
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
                                      if (widget.from == 'Gmail') {
                                        await calledFromGmailPage();
                                      } else if (widget.from == 'OTP') {
                                        await calledFromOTPPage();
                                      }
                                    },
                                    child: Center(child:  Text('${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[15].name :"REGISTER"}')),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : RMSWidgets.networkErrorPage(context: context);
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

    await shared.setString(rms_registeredUserToken,
        (await shared.getString(rms_registeredUserToken)).toString());

    await shared.setString(
        rms_userId, (await shared.getString(rms_userId)).toString());

    await shared.setString(
        rms_gmapKey, (await shared.getString(rms_gmapKey)).toString());

    await shared.setString(
        rms_profilePicUrl, widget.googleData?.photoUrl ?? " ");
    await shared.setString(rms_phoneNumber, _phoneNumberController.text);
    await shared.setString(rms_name, widget.googleData?.displayName ?? " ");
    await shared.setString(rms_email, widget.googleData?.email ?? " ");
  }

  Future<void> setSPValuesForOTP(
      {required SignUpResponseModel response}) async {
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

  Future<void> calledFromGmailPage() async {
    if (_phoneNumberController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please Enter Your Mobile Number',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else if (typeValue.isEmpty || typeValue == 'I am') {
      Fluttertoast.showToast(
          msg: 'Please Select All Field',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else if (selectedCity.isEmpty || selectedCity == 'Select City') {
      Fluttertoast.showToast(
          msg: 'Please Select City',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else if (sourceRMS.isEmpty || sourceRMS == 'How do you Know RMS') {
      Fluttertoast.showToast(
          msg: 'Please Select Source',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else {
      RMSWidgets.showLoaderDialog(context: context, message: 'Please wait...');
      final int response = await _loginViewModel.detailsValidationAfterGmail(
          model: GmailRegistrationRequestModel(
        city: selectedCity,
        iam: typeValue,
        mobileNo: _phoneNumberController.text,
        sourceRms: sourceRMS,
      ));
      Navigator.of(context).pop();

      if (response == 200) {
        await setSPValues();
        String? fcmToken = await messaging.getToken();
        if (fcmToken != null) {
          await _loginViewModel.updateFCMToken(fcmToken: fcmToken);
        }
        if (widget.fromExternalLink && widget.onClick != null) {
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
  }

  Future<void> calledFromOTPPage() async {
    if (_emailController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please Enter E-mail Address',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else if (_nameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please Enter Your Name',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else if (typeValue.isEmpty || typeValue == 'I am') {
      Fluttertoast.showToast(
          msg: 'Please Select For Type',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else if (selectedCity.isEmpty || selectedCity == 'Select City') {
      Fluttertoast.showToast(
          msg: 'Please Select City',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else if (sourceRMS.isEmpty || sourceRMS == 'How do you Know RMS') {
      Fluttertoast.showToast(
          msg: 'Please Select Source',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else {
      RMSWidgets.showLoaderDialog(context: context, message: 'Please wait...');

      final response = await _loginViewModel.detailsValidationAfterOTP(
          model: SignUpRequestModel(
        sourceRms: sourceRMS,
        iam: typeValue,
        city: selectedCity,
        email: _emailController.text,
        fname: _nameController.text,
        phonenumber: widget.mobile,
        uid: widget.uid,
      ));
      Navigator.of(context).pop();

      if (response.msg?.toLowerCase() != 'failure') {
        log('Called For OTP Registration');
        await setSPValuesForOTP(response: response);
        String? fcmToken = await messaging.getToken();
        if (fcmToken != null) {
          await _loginViewModel.updateFCMToken(fcmToken: fcmToken);
        }
        if (widget.fromExternalLink && widget.onClick != null) {
          widget.onClick!();
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboardPage,
            (route) => false,
          );
        }
      } else {
        RMSWidgets.getToast(
            message: 'Something went wrong...',
            color: CustomTheme().colorError);
      }
    }
  }
}
