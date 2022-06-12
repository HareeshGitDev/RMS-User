import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/login_module/model/otp_registration_otp_model.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';

import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';

class MobileOtpPage extends StatefulWidget {
  //const MobileOtpPage({Key? key}) : super(key: key);
  String number;
  final bool fromExternalLink;
  Function? onClick;

  MobileOtpPage({required this.number,required this.fromExternalLink,this.onClick});

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<MobileOtpPage> {
  final _pinCodeController = TextEditingController();
  late LoginViewModel _loginViewModel;
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? verifyId;
  var _mainHeight;
  var _mainWidth;
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
    initMethod();

  }
  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }
  Future initMethod() async {
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    getLanguageData();
    WidgetsBinding.instance?.addPostFrameCallback(
            (_) => verifyOTP(context: context, phoneNumber: widget.number));
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight=MediaQuery.of(context).size.height;
    _mainWidth=MediaQuery.of(context).size.width;
    return _connectionStatus?Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        title:  Text(
          nullCheck(
              list: context.watch<LoginViewModel>().loginLang)
              ? '${context.watch<LoginViewModel>().loginLang[19].name}'
              :'OTP Verification',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<LoginViewModel>(
        builder:  (context, value, child) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: _mainHeight*0.03, horizontal: _mainWidth*0.04),
            child: Column(
              children: [
                Container(
                  width: _mainWidth*0.5,
                  height: _mainHeight*0.2,
                  decoration: BoxDecoration(
                    color: CustomTheme.appTheme.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(Images.mobSignIn),
                ),

                SizedBox(
                  height: _mainHeight*0.05,
                ),
                Row(
                  children: [
                    Text(
                      '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[20].name : 'OTP has been sent to'} :  ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.number,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[21].name :"Enter your OTP code number"}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15,
                ),
                PinCodeTextField(
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  hideCharacter: false,
                  defaultBorderColor: CustomTheme.appTheme,
                  pinBoxWidth: 45,
                  pinBoxHeight: 45,
                  pinBoxBorderWidth: 1,
                  pinBoxRadius: 10,
                  highlightAnimationBeginColor: Colors.grey,
                  highlightAnimationEndColor: Colors.white12,
                  controller: _pinCodeController,
                  onTextChanged: (data) {

                  },
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  width: _mainWidth,
                  //height: _mainHeight*0.05,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_pinCodeController.text.length != 6) {
                        log('Invalid Otp Code');
                        return;
                      }
                      await loginWithOTP(
                          verificationId: verifyId.toString(),
                          smsCode: _pinCodeController.text,
                          context: context);
                    },
                    style: ButtonStyle(
                      foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(CustomTheme.appTheme),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        '${nullCheck(list: _loginViewModel.loginLang) ? _loginViewModel.loginLang[22].name :'Verify OTP'}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                /*  const Text(
              "Didn't you receive any code?",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              "Resend New Code",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomTheme.appTheme,
              ),
              textAlign: TextAlign.center,
            ),*/
              ],
            ),
          );
        },
      ),
    ):RMSWidgets.networkErrorPage(context: context);
  }

  Future verifyOTP(
      {required String phoneNumber, required BuildContext context}) async {
    //only for web_based_platforms
    //_firebaseAuth.signInWithPhoneNumber(phoneNumber);

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91" + phoneNumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        log('Verification Completed :: ' + phoneAuthCredential.toString());

        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        if (userCredential.user != null && userCredential.user?.uid != null) {
          log('UserCredentials :: ' + userCredential.toString());
          final response = await _loginViewModel.verifyOTP(
              mobileNumber: phoneNumber,
              uid: (userCredential.user?.uid).toString());
          if (response.msg?.toLowerCase() != 'failure' &&
              response.data?.action?.toLowerCase() == 'sign-up') {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.firebaseRegistrationPage,(r)=>false,arguments: {
              'uid':userCredential.user?.uid,
              'from':'OTP',
              'mobile':phoneNumber,
              'fromExternalLink':
              widget.fromExternalLink,
              'onClick': widget.onClick
            },);
          } else if (response.msg?.toLowerCase() != 'failure' &&
              response.data?.action?.toLowerCase() == 'sign-in') {
            await setSPValues(response: response);
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
        } else {
          log('Error From Firebase OTP ');
        }
      },
      verificationFailed: (FirebaseAuthException authException) {
        log('Verification Failed :: ' + authException.toString());
      },
      codeSent: (
        String verificationId,
        int? forceResendingToken,
      ) {
        log('Code Sent :: VerificationId $verificationId -- $forceResendingToken');
        setState(() {
          verifyId = verificationId;
        });
      },timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        log('Code Auto Retrieval Timeout :: VerificationId :: $verificationId');
        setState(() {
          verifyId = verificationId;
        },);
      },
    );
  }

  Future<void> loginWithOTP(
      {required String verificationId,
      required String smsCode,
      required BuildContext context}) async {
    try {
      RMSWidgets.showLoaderDialog(context: context,message: 'Loading');
      final data = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(data);

      if (userCredential.user != null && userCredential.user?.uid != null) {
        log('UserCredentials :: ' + userCredential.toString());
        final response = await _loginViewModel.verifyOTP(
            mobileNumber: widget.number,
            uid: (userCredential.user?.uid).toString());
        if (response.msg?.toLowerCase() != 'failure' &&
            response.data?.action?.toLowerCase() == 'sign-up') {
          Navigator.pop(context);
          Navigator.of(context)
              .pushNamed(AppRoutes.firebaseRegistrationPage, arguments: {
            'from': 'OTP',
            'uid':userCredential.user?.uid,
            'mobile':widget.number,
            'fromExternalLink':
            widget.fromExternalLink,
            'onClick': widget.onClick


          });
        } else if (response.msg?.toLowerCase() != 'failure' &&
            response.data?.action?.toLowerCase() == 'sign-in') {
          await setSPValues(response: response);
          Navigator.pop(context);

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
      }else{
        Navigator.pop(context);
      }
    } catch (e) {
      log('Error while OTP Login :: ${e.toString()}');
    }
  }

  Future<void> setSPValues(
      {required OtpRegistrationResponseModel response}) async {
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
