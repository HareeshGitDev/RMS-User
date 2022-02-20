import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> loginIn() {
    return _googleSignIn.signIn();
  }

  static Future<GoogleSignInAccount?> logOut() {
    return _googleSignIn.signOut();
  }

  static Future<bool> isSignedIn() {
    return _googleSignIn.isSignedIn();
  }
}
