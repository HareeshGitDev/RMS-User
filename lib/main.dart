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
        StreamProvider<ConnectivityResult>(
          initialData: ConnectivityResult.none,
          create: (context) => Connectivity().onConnectivityChanged,
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
  50: Color.fromRGBO(37,150,190, .1),
  100: Color.fromRGBO(37,150,190, .2),
  200: Color.fromRGBO(37,150,190, .3),
  300: Color.fromRGBO(37,150,190, .4),
  400: Color.fromRGBO(37,150,190, .5),
  500: Color.fromRGBO(37,150,190, .6),
  600: Color.fromRGBO(37,150,190, .7),
  700: Color.fromRGBO(37,150,190, .8),
  800: Color.fromRGBO(37,150,190, .9),
  900: Color.fromRGBO(37,150,190, 1),
};
// Green color code: 93cd48 and first two characters (FF) are alpha values (transparency)
MaterialColor customColor = MaterialColor(0xff2596be, colorMap);
void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
