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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../theme/fonts.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../model/login_response_model.dart';
import '../model/signup_response_model.dart';

class RegistrationPage extends StatefulWidget {
  final bool fromExternalLink;
  Function? onClick;

  RegistrationPage({required this.fromExternalLink,this.onClick});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late FirebaseMessaging messaging =
      FirebaseMessaging.instance;
  late LoginViewModel _loginViewModel;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _referalController = TextEditingController();
  var _mainHeight;
  bool isObscure = true;
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
getLanguageData();

  }


  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus?Scaffold(

      body:  Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.dstATop),
                image: AssetImage(
              "assets/images/loginBackground.png",
            ),
                fit: BoxFit.cover

            )
        ),
        child: Consumer<LoginViewModel>(
          builder: (context, value, child) {
            return Container(

                  margin: EdgeInsets.only(right: _mainWidth * 0.035),


                  padding: EdgeInsets.only(left: _mainWidth * 0.035,top: _mainHeight*0.08),

                  alignment: Alignment.centerLeft,
              height: _mainHeight,
              width: _mainWidth,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Center(
                        child: Image(
                          image: AssetImage("assets/images/logo.png"),
                          width: 210,

                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.loginPage,
                          arguments: {
                            'fromExternalLink':
                            widget.fromExternalLink,
                            'onClick': widget.onClick
                          }),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),

                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text:'${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[27].name : "Already have an account"} ? ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18
                                )),
                            TextSpan(
                                text: '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[26].name :'Sign In'}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  decoration: TextDecoration.underline
                                )),
                          ]),
                        ),
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Let's Get",
                    //           style: const TextStyle(
                    //               fontSize: 20,
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold
                    //           ),
                    //         ),
                    //         Text(
                    //           "Started",
                    //           //  '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[28].name : ' Back'}',
                    //           style: const TextStyle(
                    //               fontSize: 20,
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     // Container(
                    //     //   padding: EdgeInsets.all(10),
                    //     //   decoration: BoxDecoration(
                    //     //     color: Colors.white.withOpacity(0.2),
                    //     //     borderRadius: BorderRadius.only(
                    //     //       topLeft:Radius.circular(10),
                    //     //       bottomLeft:Radius.circular(10),
                    //     //
                    //     //     )
                    //     //
                    //     //   ),
                    //     //   child: Text("SignIn",
                    //     //   style: TextStyle(
                    //     //     color: Colors.white
                    //     //   ),
                    //     //   ),
                    //     // )
                    //   ],
                    // ),

                    Container(
                      decoration: BoxDecoration(

                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30))),
                      height: _mainHeight * 0.77,
                      width: _mainWidth,


                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            _textLabel(title: "Name"),
                            Padding(
                              padding: const EdgeInsets.only(top:2),
                              child: _textInput(
                                  hint: '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[12].name :"Name"}',
                                  icon: Icons.person_outline,
                                  controller: _nameController),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            _textLabel(title: "Email (OTP will be sent)"),
                            _textInput(
                                hint: '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[1].name :"Email (OTP will be sent)"}',
                                icon: Icons.email_outlined,

                                controller: _emailController),
                            SizedBox(
                              height: 5,
                            ),
                            _textLabel(title: "Phone Number (OTP will be sent)"),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),

                              ),

                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9+]")),],
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide( color: Colors.white.withOpacity(0.8),),
                                      borderRadius: BorderRadius.circular(10)),
                                  hintStyle: TextStyle(
                                    color: Color(0xff787878),
                                  ),
                                  contentPadding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),

                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide( color: Colors.white.withOpacity(0.8),),
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[13].name :"Phone Number (OTP will be sent)"}',

                                  prefixIcon: Icon(Icons.phone_android_outlined,
                                    color: Colors.white,
                                  ),


                                ),
                              ),
                            ),

                            SizedBox(
                              height: 5,
                            ),
                            _textLabel(title: "Password"),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: isObscure,
                              style: TextStyle(color: Colors.white),
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
                                    color: Color(0xff787878),
                                  ),
                                  contentPadding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),
                                hintText: '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[2].name :"Password"}',
                                prefixIcon: Icon(Icons.vpn_key_outlined,color: Colors.white,),
                                  suffix: InkWell(
                                    onTap: () => setState(() {
                                      isObscure = !isObscure;
                                    }),
                                    child: Icon(
                                      Icons.remove_red_eye_rounded,
                                      color: isObscure
                                          ? Colors.white
                                          : CustomTheme.appTheme,
                                    ),
                                  )


                              ),
                            ),

                            SizedBox(
                              height: 5,
                            ),
                            _textLabel(title: "Referal Code (Optional)"),

                            _textInput(
                                hint: '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[14].name :"Apply Referal Code (Optional)"}',
                                icon: Icons.ac_unit_outlined,
                                controller: _referalController),
                            SizedBox(
                              height: 6,
                            ),
                            _textLabel(title: "I am"),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              height: 40,
                              width: _mainWidth,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButtonHideUnderline(

                                child:
                                DropdownButton(

                                  items: getTypeList
                                      .map((type) => DropdownMenuItem(

                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(type,
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                      ),
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

                            SizedBox(
                              height: 6,
                            ),
                            _textLabel(title: "City"),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              height: 40,
                              width: _mainWidth,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: getCityList
                                      .map((type) => DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(type,
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                      ),
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

                            SizedBox(
                              height: 6,
                            ),
                            _textLabel(title: "How Do You Know RMS?"),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              height: 40,
                              width: _mainWidth,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: getRMSList
                                      .map((type) => DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(type,
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                      ),
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
                            SizedBox(height: 20,),

                            Container(
                              width: _mainWidth,
                              height: 50,
                              margin: EdgeInsets.only(bottom: 15),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.white  ),
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
                                      String? fcmToken =
                                      await messaging.getToken();
                                      if (fcmToken != null) {
                                        await _loginViewModel.updateFCMToken(
                                            fcmToken: fcmToken);
                                      }
                                      RMSWidgets.getToast(
                                          message:'You have been Successfully registered',
                                          color: CustomTheme.myFavColor);
                                      if(widget.fromExternalLink && widget.onClick != null){
                                        widget.onClick!();
                                      }else{
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          AppRoutes.dashboardPage,
                                              (route) => false,
                                        );
                                      }

                                    }
                                  }
                                },
                                child: Center(child: Text('${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[15].name :"Sign Up"}',
                                style: TextStyle(
                                  color: CustomTheme.appThemeContrast
                                ),
                                )),
                              ),
                            ),
                            SizedBox(height: 50,),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ):RMSWidgets.networkErrorPage(context: context);
  }
  Widget _textLabel(
  {required String title}
      ){
    return   Text("$title",
      style: TextStyle(
        color:  Colors.white,
        fontWeight: FontWeight.w600,

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

      ),

      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide( color: Colors.white.withOpacity(0.8),),
              borderRadius: BorderRadius.circular(10)),
          hintStyle: TextStyle(
            color: Color(0xff787878),
          ),
          contentPadding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),

          focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide( color: Colors.white.withOpacity(0.8),),
              borderRadius: BorderRadius.circular(10)),
          hintText: hint,
          prefixIcon: Icon(icon,
          color: Colors.white,
          ),


        ),
      ),
    );
  }

  List<String> get getTypeList => [
        'I am',
        'Tenant',
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
