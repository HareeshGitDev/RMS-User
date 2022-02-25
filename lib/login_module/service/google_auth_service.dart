import 'dart:developer';

import 'package:RentMyStay_user/login_module/service/login_api_service.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final _googleSignIn = GoogleSignIn();
  static final  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;


  static Future<GoogleSignInAccount?> loginIn() async{
    return await _googleSignIn.signIn();
  }

  static Future<GoogleSignInAccount?> logOut() async{
    return await _googleSignIn.signOut();
  }

  static Future<bool> isSignedIn() {
    return _googleSignIn.isSignedIn();
  }
  static Future<void> logoutFromFirebase() async{
    await _firebaseAuth.signOut();
  }


}
