import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<GoogleSignInAccount?> loginIn() {
    return _googleSignIn.signIn();
  }

  static Future<GoogleSignInAccount?> logOut() {
    return _googleSignIn.signOut();
  }

  static Future<bool> isSignedIn() {
    return _googleSignIn.isSignedIn();
  }

  static Future verifyOTP(
      {required String phoneNumber, required BuildContext context}) async {
    //only for web_based_platforms
    //_firebaseAuth.signInWithPhoneNumber(phoneNumber);
    String? verifyId;
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        log('Verification Completed :: ' + phoneAuthCredential.toString());
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);

        log('UserCredentials :: ' + userCredential.toString());
      },
      verificationFailed: (FirebaseAuthException authException) {
        log('Verification Failed :: ' + authException.toString());
      },
      codeSent: (
        String verificationId,
        int? forceResendingToken,
      ) {
        log('Code Sent :: $verificationId -- $forceResendingToken');
        verifyId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('Code Auto Retrieval Timeout  :: $verificationId');
      },
    );
    return verifyId;
  }

  static Future loginWithOTP(
      {required String verificationId,
      required String smsCode,
      required BuildContext context}) async {
    final data = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(data);
    log('UserCredentials :: ' + userCredential.toString());
  }
}
