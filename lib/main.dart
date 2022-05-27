import 'dart:developer';
import 'dart:io' show Platform;
import 'package:RentMyStay_user/theme/custom_theme.dart';
import 'package:RentMyStay_user/utils/service/bottom_navigation_provider.dart';
import 'package:RentMyStay_user/utils/service/location_service.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'login_module/view/splash_page.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
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
Map<int, Color> colorMap =const {
  50: Color.fromRGBO(51,101,138, .1),
  100: Color.fromRGBO(51,101,138, .2),
  200: Color.fromRGBO(51,101,138, .3),
  300: Color.fromRGBO(51,101,138, .4),
  400: Color.fromRGBO(51,101,138, .5),
  500: Color.fromRGBO(51,101,138, .6),
  600: Color.fromRGBO(51,101,138, .7),
  700: Color.fromRGBO(51,101,138, .8),
  800: Color.fromRGBO(51,101,138, .9),
  900: Color.fromRGBO(51,101,138, 1),
};
// Green color code: 93cd48 and first two characters (FF) are alpha values (transparency)
MaterialColor customColor = MaterialColor(0xff33658a, colorMap);
void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
