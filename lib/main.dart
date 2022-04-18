import 'dart:developer';
import 'dart:io' show Platform;
import 'package:RentMyStay_user/theme/custom_theme.dart';
import 'package:RentMyStay_user/utils/service/bottom_navigation_provider.dart';
import 'package:RentMyStay_user/utils/service/location_service.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'login_module/view/splash_page.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );
  // final FirebaseApp firebaseApp = await Firebase.initializeApp(
  //     name: 'rentmystay_user',
  //     options: Platform.isMacOS || Platform.isIOS
  //         ? const FirebaseOptions(
  //             appId: 'IOS KEY',
  //             apiKey: 'AIzaSyCE-KLe5oa_Gcou-WQHiTeqHpw1RV1-Ouo',
  //             projectId: 'rentmystay-new-1539065190327',
  //             messagingSenderId: '172037116875',
  //             databaseURL:
  //                 'https://rentmystay-new-1539065190327.firebaseio.com')
  //         : const FirebaseOptions(
  //             appId: '1:172037116875:android:87e0896da0f7cb1434dc4e',
  //             apiKey: 'AIzaSyCE-KLe5oa_Gcou-WQHiTeqHpw1RV1-Ouo',
  //             projectId: 'rentmystay-new-1539065190327',
  //             messagingSenderId: '172037116875',
  //             databaseURL:
  //                 'https://rentmystay-new-1539065190327.firebaseio.com'));
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BottomNavigationProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RentMyStay ',
        theme: ThemeData(
          primarySwatch: customColor,
          fontFamily: 'hk-grotest',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
        onGenerateRoute: NavigationService.generateRoute,
      ),
    );
  }
}
Map<int, Color> colorMap = {
  50: Color.fromRGBO(0, 54, 111, .1),
  100: Color.fromRGBO(0, 54, 111, .2),
  200: Color.fromRGBO(0, 54, 111, .3),
  300: Color.fromRGBO(0, 54, 111, .4),
  400: Color.fromRGBO(0, 54, 111, .5),
  500: Color.fromRGBO(0, 54, 111, .6),
  600: Color.fromRGBO(0, 54, 111, .7),
  700: Color.fromRGBO(0, 54, 111, .8),
  800: Color.fromRGBO(0, 54, 111, .9),
  900: Color.fromRGBO(0, 54, 111, 1),
};
// Green color code: 93cd48 and first two characters (FF) are alpha values (transparency)
MaterialColor customColor = MaterialColor(0xff00366F, colorMap);
void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
