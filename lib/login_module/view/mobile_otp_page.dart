import 'dart:developer';

import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/login_module/model/otp_registration_otp_model.dart';
import 'package:RentMyStay_user/login_module/service/google_auth_service.dart';
import 'package:RentMyStay_user/login_module/viewModel/login_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/sp_constants.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../service/login_api_service.dart';

class MobileOtpPage extends StatefulWidget {
  //const MobileOtpPage({Key? key}) : super(key: key);
  String number;

  MobileOtpPage({required this.number});

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<MobileOtpPage> {
  final _pinCodeController = TextEditingController();
  late LoginViewModel _loginViewModel;
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? verifyId;

  @override
  void initState() {
    initMethod();
    super.initState();
  }

  Future initMethod() async {
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    await verifyOTP(context: context, phoneNumber: widget.number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: CustomTheme.appTheme.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(Images.mobSignIn),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.number,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 28,
              ),
              PinCodeTextField(
                maxLength: 6,
                keyboardType: TextInputType.number,
                hideCharacter: false,
                defaultBorderColor: Color(0xff999999),
                pinBoxWidth: 45,
                pinBoxHeight: 45,
                pinBoxBorderWidth: 1,
                pinBoxRadius: 10,
                highlightAnimationBeginColor: Colors.grey,
                highlightAnimationEndColor: Colors.white12,
                controller: _pinCodeController,
                onTextChanged: (data) {
                  log(data.toString());
                },
              ),
              SizedBox(
                width: double.infinity,
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
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      'Verify',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
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
              ),
            ],
          ),
        ),
      ),
    );
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
          if (response.status?.toLowerCase() == 'success' &&
              response.action == 'sign-up') {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.firebaseRegistrationPage,(r)=>false,arguments: {
              'uid':userCredential.user?.uid,
              'from':'OTP',
              'mobile':phoneNumber,
            },);
          } else if (response.status?.toLowerCase() == 'success' &&
              response.action == 'sign-in') {
            await setSPValues(response: response);
            Navigator.pushNamedAndRemoveUntil(
              context,AppRoutes.dashboardPage,(route) => false,);
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
      final data = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(data);

      if (userCredential.user != null && userCredential.user?.uid != null) {
        log('UserCredentials :: ' + userCredential.toString());
        final response = await _loginViewModel.verifyOTP(
            mobileNumber: widget.number,
            uid: (userCredential.user?.uid).toString());
        if (response.status?.toLowerCase() == 'success' &&
            response.action == 'sign-up') {
          Navigator.of(context)
              .pushNamed(AppRoutes.firebaseRegistrationPage, arguments: {
            'from': 'OTP',
            'uid':userCredential.user?.uid,
            'mobile':widget.number,
          });
        } else if (response.status?.toLowerCase() == 'success' &&
            response.action == 'sign-in') {
          await setSPValues(response: response);
          Navigator.pushNamedAndRemoveUntil(
            context,AppRoutes.dashboardPage,(route) => false,);
        }
      }
    } catch (e) {
      log('Error while OTP Login :: ${e.toString()}');
    }
  }

  Future<void> setSPValues(
      {required OtpRegistrationResponseModel response}) async {
    SharedPreferenceUtil shared = SharedPreferenceUtil();
    await shared.setString(
        rms_registeredUserToken, response.appToken.toString());
    await shared.setString(rms_profilePicUrl, response.pic.toString());
    await shared.setString(rms_phoneNumber, response.contactNum.toString());
    await shared.setString(rms_name, response.name.toString());
    await shared.setString(rms_email, response.email.toString());
    await shared.setString(rms_gmapKey, response.gmapKey.toString());
    await shared.setString(rms_userId, response.id.toString());
  }
}
